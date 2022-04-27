Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27703511794
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 14:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234356AbiD0MiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 08:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbiD0MiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 08:38:15 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77CF50E3A;
        Wed, 27 Apr 2022 05:35:03 -0700 (PDT)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1njgse-000Bll-3T; Wed, 27 Apr 2022 14:34:52 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1njgsd-000Gt8-Hj; Wed, 27 Apr 2022 14:34:51 +0200
Subject: Re: [PATCH v5 1/3] selftests: bpf: add test for bpf_skb_change_proto
To:     Lina.Wang@mediatek.com, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, Maciej enczykowski <maze@google.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <9dc51533-92d2-1c82-2a6e-96e1ac747bb7@iogearbox.net>
 <20220418015230.4481-1-Lina.Wang@mediatek.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f8b9437c-3f54-3d15-d21b-cbac6e4d6911@iogearbox.net>
Date:   Wed, 27 Apr 2022 14:34:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220418015230.4481-1-Lina.Wang@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26525/Wed Apr 27 10:19:41 2022)
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/18/22 3:52 AM, Lina.Wang@mediatek.com wrote:
[...]
>> OT: In Cilium we run similar NAT46/64 translation for XDP and tc/BPF
>> for our LB services [4] (that is,
>> v4 VIP with v6 backends, and v6 VIP with v4 backends).
>>
>>     [4]
>> https://github.com/cilium/cilium/blob/master/bpf/lib/nat_46x64.h
>>         
>> https://github.com/cilium/cilium/blob/master/test/nat46x64/test.sh
> 
> It is complicated for me, my case doesnot use XDP driver.I use xdp_dummy
> just to enable veth NAPI GRO, not real XDP driver code. My test case is
> simple and enough for my patch, I think. I have covered tcp and udp,
> normal and SO_SEGMENT.

Ok, fair enough, then lets resend with the minor fixups as discussed
earlier and worst case we can do the test_progs integration at a later
point to avoid blocking the fix. At least there is something runnable
under net/bpf selftests.. even if not yet in BPF CI but we can follow-up
on it later. Thanks Lina!
