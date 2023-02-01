Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C385686A75
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjBAPgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 10:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjBAPgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 10:36:12 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9E36A49
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 07:36:10 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id x6so900943ilv.7
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 07:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K5xmdVZqd62DfBFxOOqbDZOJ26Mz+O+u8yxwL0j/ML0=;
        b=B83ErGNAF0qUvfgHuoFmhfudY+GyQCs/6jvDrM/d0DH3TXWjDh5ExBDTRcF0FjStse
         rIVljlYuiutdnNUaBK8dBdDlxDMr4TQnJDWph/CMPG5IvTS952ubSvf/uF/38GkMp5vj
         mMQ3mYNmGdY7A/wmEFayzG0PCjwKKmzG7rRE52PzFOGrhn2zba1ek+PapYFWDGCicmzi
         o2snbzUSGtMCEq6W0ZPlCfryyWqGDCX0NMSQqSgzUc//bUgr7e8JfXJWR9ArKFTNTIrZ
         E17HCOdsUZdAhG4sXnFSXIu1WMwnFwmVZRgFe21Xrpaeac+TZElNt1FftW5py2qt3t8k
         sjrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K5xmdVZqd62DfBFxOOqbDZOJ26Mz+O+u8yxwL0j/ML0=;
        b=s6LyTfJ+67ei8+J9Y68gOL/JBY/3zAAxLtiGMJ3pavbxttwYSePzD0d7r64QPP6IaR
         R29KQl3VSA2mDdduWbfjPyK4zEM3dGgS3J7ZTM1S0gFfa1laP3vxOdNzVbd1tojsBIWg
         52tsl4ZFaYsjuGofILTYIAATtqBqJjXwdPCn+OCTuxCFJshxo0cE47sp64mD2x4mj3fy
         QDQ4DZyvw/dR5XVbNS99mj7r6sQ0jILX7qWd9LqmbW1OjowjNX0SNnoZnmdQhLog2por
         nXKfTRImbo9IEy7RcusKbYhsBOMCcs2C7yWpZpfTNHljCStOCi4R29Mjz+UbG0Eb02W7
         v0nQ==
X-Gm-Message-State: AO0yUKWaBjzXHAWd9weqr5cjk6vBTHwbqkeDjoUD3FyA7h4lucwlhhQw
        hYbDf61hghf8cq9nvdBVEp8=
X-Google-Smtp-Source: AK7set/X9khBpOSqFSknIBKBqgKOZi/t5jxcIycI65rtNEcQ+7+VcbLHpiqiJtteytJ2wn0CaKfLiA==
X-Received: by 2002:a05:6e02:1807:b0:310:9bad:89a7 with SMTP id a7-20020a056e02180700b003109bad89a7mr2634186ilv.14.1675265770298;
        Wed, 01 Feb 2023 07:36:10 -0800 (PST)
Received: from ?IPV6:2601:282:800:7ed0:1dfd:95ca:34d0:dedb? ([2601:282:800:7ed0:1dfd:95ca:34d0:dedb])
        by smtp.googlemail.com with ESMTPSA id e26-20020a056638021a00b003a96425c4c5sm6317220jaq.157.2023.02.01.07.36.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 07:36:09 -0800 (PST)
Message-ID: <d8ddc04e-205a-e57b-22b9-61973dad67cf@gmail.com>
Date:   Wed, 1 Feb 2023 08:36:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCHv4 net-next 09/10] net: add gso_ipv4_max_size and
 gro_ipv4_max_size per device
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
References: <cover.1674921359.git.lucien.xin@gmail.com>
 <7e1f733cc96c7f7658fbf3276a90281b2f37acd1.1674921359.git.lucien.xin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <7e1f733cc96c7f7658fbf3276a90281b2f37acd1.1674921359.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/23 8:58 AM, Xin Long wrote:
> This patch introduces gso_ipv4_max_size and gro_ipv4_max_size
> per device and adds netlink attributes for them, so that IPV4
> BIG TCP can be guarded by a separate tunable in the next patch.
> 
> To not break the old application using "gso/gro_max_size" for
> IPv4 GSO packets, this patch updates "gso/gro_ipv4_max_size"
> in netif_set_gso/gro_max_size() if the new size isn't greater
> than GSO_LEGACY_MAX_SIZE, so that nothing will change even if
> userspace doesn't realize the new netlink attributes.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/linux/netdevice.h    |  6 ++++++
>  include/uapi/linux/if_link.h |  3 +++
>  net/core/dev.c               |  4 ++++
>  net/core/dev.h               | 18 ++++++++++++++++++
>  net/core/rtnetlink.c         | 33 +++++++++++++++++++++++++++++++++
>  5 files changed, 64 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


