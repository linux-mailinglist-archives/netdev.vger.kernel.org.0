Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAAFC66B233
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 16:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbjAOPps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 10:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbjAOPpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 10:45:46 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BB293E5
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 07:45:44 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id p189so628050iod.0
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 07:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rTWRn8XcuqXZaD7jdWYPjP6512PMGRzIpIIJu65X6nk=;
        b=B1iu5kc/92ilKy57HVVKRgeznpAMfeQ75g/lUCFF0IGrqlN5KurPHhXPf0OGOBT9og
         OT8kIJTDn/u1Ww3Y234oHTljqTW8DcPnr0NI9gN92kfUkUiQmRFp5so+fN3y35bzEmwA
         pQB36wCNQayNgRYI7XkIgyYz3LcCFiNv4UiP7255U/KCMe+TwM5oP3ubis7fUaKu4n8w
         shVEYWfcZSaOM03IxOCNvBTkt9b2iQaXb29emxyYhXZDSydGVgYOetdMJD2TrrATCT6u
         vaZyrlU4uJW1m7+FIHVg67OUFixExJbs+q30v24mFjaUk42E6cPk3PMnGDNafxRCAC3V
         NqkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rTWRn8XcuqXZaD7jdWYPjP6512PMGRzIpIIJu65X6nk=;
        b=Iz88p7r5jugdJkoSIPNmmLVOI2fIATLF2bVGx9Qk32XJ6vkaiQUQJuqSGY2W69cZVw
         wwZzVhOOZ3u7iVCSvCu0nU0BUY3vcpYyF3DAdbxfRLoapPPXzkXbgLXke3uJhKXZLGQ9
         fjsqbo3Kxpq0Toc+X3LydScvs0xUIMIpOs7ipPcvyy9m96RI96mJpgephjrqK+kNRH+0
         qh2bGjOH6gSplyaMIu5THGLoiJFyv3RLQHVBn0Slw4MXmPUxtgHdVcrbQn5DsMKWuFhF
         wK63nYOeUdPm/1T/tGOiB4E+dGik+dmawUZBHAnGXOoh6swTEdH42WJQpA9+RY3cj3dS
         Ik7Q==
X-Gm-Message-State: AFqh2kr9VkLuFIH0yV3UlRosWIo2H0FZO+FSbhnRGn37SuVsqOJiVP2R
        FyQh70u8JOD+0l+D5r0hhvY=
X-Google-Smtp-Source: AMrXdXvw5rQ0wHf9k6MWrwc2mlGa8Zych8cNCA2Fzfi577kFUyfnlBvMJDQHbYT6l+DvTAdNWRYySg==
X-Received: by 2002:a6b:dc08:0:b0:704:7ab3:8795 with SMTP id s8-20020a6bdc08000000b007047ab38795mr9014994ioc.17.1673797543790;
        Sun, 15 Jan 2023 07:45:43 -0800 (PST)
Received: from ?IPV6:2601:284:8200:b700:7de9:438a:dc6b:e300? ([2601:284:8200:b700:7de9:438a:dc6b:e300])
        by smtp.googlemail.com with ESMTPSA id b23-20020a05663805b700b003a470e29d03sm461209jar.109.2023.01.15.07.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Jan 2023 07:45:43 -0800 (PST)
Message-ID: <568848da-a702-04ba-4071-2d8a14ac779a@gmail.com>
Date:   Sun, 15 Jan 2023 08:45:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 00/10] net: support ipv4 big tcp
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
References: <cover.1673666803.git.lucien.xin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <cover.1673666803.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/13/23 8:31 PM, Xin Long wrote:
> This is similar to the BIG TCP patchset added by Eric for IPv6:
> 
>   https://lwn.net/Articles/895398/
> 
> Different from IPv6, IPv4 tot_len is 16-bit long only, and IPv4 header
> doesn't have exthdrs(options) for the BIG TCP packets' length. To make
> it simple, as David and Paolo suggested, we set IPv4 tot_len to 0 to
> indicate this might be a BIG TCP packet and use skb->len as the real
> IPv4 total length.
> 
> This will work safely, as all BIG TCP packets are GSO/GRO packets and
> processed on the same host as they were created; There is no padding
> in GSO/GRO packets, and skb->len - network_offset is exactly the IPv4
> packet total length; Also, before implementing the feature, all those
> places that may get iph tot_len from BIG TCP packets are taken care
> with some new APIs:
> 
> Patch 1 adds some APIs for iph tot_len setting and getting, which are
> used in all these places where IPv4 BIG TCP packets may reach in Patch
> 2-7, and Patch 8 implements this feature and Patch 10 adds a selftest
> for it. Patch 9 is a fix in netfilter length_mt6 so that the selftest
> can also cover IPv6 BIG TCP.
> 
> Note that the similar change as in Patch 2-7 are also needed for IPv6
> BIG TCP packets, and will be addressed in another patchset.
> 
> The similar performance test is done for IPv4 BIG TCP with 25Gbit NIC
> and 1.5K MTU:
> 
> No BIG TCP:
> for i in {1..10}; do netperf -t TCP_RR -H 192.168.100.1 -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
> 168          322          337          3776.49
> 143          236          277          4654.67
> 128          258          288          4772.83
> 171          229          278          4645.77
> 175          228          243          4678.93
> 149          239          279          4599.86
> 164          234          268          4606.94
> 155          276          289          4235.82
> 180          255          268          4418.95
> 168          241          249          4417.82
> 
> Enable BIG TCP:
> ip link set dev ens1f0np0 gro_max_size 128000 gso_max_size 128000
> for i in {1..10}; do netperf -t TCP_RR -H 192.168.100.1 -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
> 161          241          252          4821.73
> 174          205          217          5098.28
> 167          208          220          5001.43
> 164          228          249          4883.98
> 150          233          249          4914.90
> 180          233          244          4819.66
> 154          208          219          5004.92
> 157          209          247          4999.78
> 160          218          246          4842.31
> 174          206          217          5080.99
> 
> Xin Long (10):
>   net: add a couple of helpers for iph tot_len
>   bridge: use skb_ip_totlen in br netfilter
>   openvswitch: use skb_ip_totlen in conntrack
>   net: sched: use skb_ip_totlen and iph_totlen
>   netfilter: use skb_ip_totlen and iph_totlen
>   cipso_ipv4: use iph_set_totlen in skbuff_setattr
>   ipvlan: use skb_ip_totlen in ipvlan_get_L3_hdr
>   net: add support for ipv4 big tcp
>   netfilter: get ipv6 pktlen properly in length_mt6
>   selftests: add a selftest for big tcp
> 
>  drivers/net/ipvlan/ipvlan_core.c           |   2 +-
>  include/linux/ip.h                         |  20 +++
>  include/linux/ipv6.h                       |   9 ++
>  include/net/netfilter/nf_tables_ipv4.h     |   4 +-
>  include/net/route.h                        |   3 -
>  net/bridge/br_netfilter_hooks.c            |   2 +-
>  net/bridge/netfilter/nf_conntrack_bridge.c |   4 +-
>  net/core/gro.c                             |   6 +-
>  net/core/sock.c                            |  11 +-
>  net/ipv4/af_inet.c                         |   7 +-
>  net/ipv4/cipso_ipv4.c                      |   2 +-
>  net/ipv4/ip_input.c                        |   2 +-
>  net/ipv4/ip_output.c                       |   2 +-
>  net/netfilter/ipvs/ip_vs_xmit.c            |   2 +-
>  net/netfilter/nf_log_syslog.c              |   2 +-
>  net/netfilter/xt_length.c                  |   5 +-
>  net/openvswitch/conntrack.c                |   2 +-
>  net/sched/act_ct.c                         |   2 +-
>  net/sched/sch_cake.c                       |   2 +-
>  tools/testing/selftests/net/Makefile       |   1 +
>  tools/testing/selftests/net/big_tcp.sh     | 157 +++++++++++++++++++++
>  21 files changed, 212 insertions(+), 35 deletions(-)
>  create mode 100755 tools/testing/selftests/net/big_tcp.sh
> 

Thanks for working on this and writing the selftests.

A couple of years ago I was experimenting with a simpler version of this
change (only changed what I needed to run tests). tcpdump (as an example
of packet socket app) was confused about the packet length and reported
truncated packet errors. As I recall that is the only really tricky part
to getting large packets for IPv4.
