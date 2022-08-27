Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF2E5A377A
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 13:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345336AbiH0Lpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 07:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234485AbiH0Lpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 07:45:33 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A658C5F239
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 04:45:31 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id p16so4295803ejb.9
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 04:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Uiwsx18+PIfPz8cnyidyt6nJqQWpgQBOhncDXGNdZ44=;
        b=uz5I1OOQSl1cIngBs/kpcpdH2jOhD7IdT1UDm7nhq5x8FOC57Kw2AJN/mWYmaX1tvI
         3i+AdZL2snZ9AbQJpDScXctDkNQlRewjh5KwJliaEQZDn4EXDnaQMVVR5n7iHm3MQoEX
         yCqLTR1ok+FT0EKcKoGREOsUdw1Now6JZEOkByPNUwcm6GLB5SwNB3jjOQIrTay5DJ3M
         /0qshNwOF/YKQuxuCuaQaddGjkOtfqBjbs1xtrAX4XF48eRsrL+wxmtF6QN93SfC1wIF
         BzdezYt4Kic+Hy3vgk4FcgcIGuxEeg/X+EWJ2JChd7VwawolAKOb2N5P2ejiydrmyDlF
         +WWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Uiwsx18+PIfPz8cnyidyt6nJqQWpgQBOhncDXGNdZ44=;
        b=UZ8AruoziBJqIh4KOWyb0TZN0Q9M3n44vUgxdQSA+eKxU9VPvggNq1UcJ+dlVNS2eU
         svBErwV8WZfVmJv33/tKz2KSTSpHlenZSYHZGBp8AXxSFmjbTDuTLmCiUTHtvZrE4Z82
         Xr4ovaNvX/BLslbyIA3npUAakZ6SuTaQChwYWNqgUcaqqcbpnDE7RNhA5zScG8nZ3U4t
         wBXB7C1TohpuZH5QY2E7iFVbvmwX+0V/ztUN5Rsd8sM/GK5J405Sro1rNVaarc+kN7bV
         yHFi4UNC+iwl29ZfyEyVLiosxFSpSrHZFCNMrkpryydedWIE/wIThB4Hogt3v1OZEfg/
         Sfug==
X-Gm-Message-State: ACgBeo2HMknXeTbM3tpEbtqsBm5zOIS9yVijOZesHB8K0hx9z/TlHglP
        dyQaI7Gsg++A1yVzIUAYIucoug==
X-Google-Smtp-Source: AA6agR58mXo/pcOpmfdDlH8zVf13b1q3vXakLSsyWmrsOPVAeF04JfEdvTXohaJhnyAy2TdJ9ZEDkw==
X-Received: by 2002:a17:907:1c1f:b0:73d:6883:9869 with SMTP id nc31-20020a1709071c1f00b0073d68839869mr7965199ejc.241.1661600730126;
        Sat, 27 Aug 2022 04:45:30 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id v12-20020a1709061dcc00b0073dc8d0eabesm2054379ejh.15.2022.08.27.04.45.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Aug 2022 04:45:29 -0700 (PDT)
Message-ID: <0b6143d1-d4d4-7765-3e27-c686abda25d5@blackwall.org>
Date:   Sat, 27 Aug 2022 14:45:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH ipsec-next,v4 3/3] xfrm: lwtunnel: add lwtunnel support
 for xfrm interfaces in collect_md mode
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        dsahern@kernel.org, contact@proelbtn.com, pablo@netfilter.org,
        nicolas.dichtel@6wind.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220826114700.2272645-1-eyal.birger@gmail.com>
 <20220826114700.2272645-4-eyal.birger@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220826114700.2272645-4-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/08/2022 14:47, Eyal Birger wrote:
> Allow specifying the xfrm interface if_id and link as part of a route
> metadata using the lwtunnel infrastructure.
> 
> This allows for example using a single xfrm interface in collect_md
> mode as the target of multiple routes each specifying a different if_id.
> 
> With the appropriate changes to iproute2, considering an xfrm device
> ipsec1 in collect_md mode one can for example add a route specifying
> an if_id like so:
> 
> ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1
> 
> In which case traffic routed to the device via this route would use
> if_id in the xfrm interface policy lookup.
> 
> Or in the context of vrf, one can also specify the "link" property:
> 
> ip route add <SUBNET> dev ipsec1 encap xfrm if_id 1 link_dev eth15
> 
> Note: LWT_XFRM_LINK uses NLA_U32 similar to IFLA_XFRM_LINK even though
> internally "link" is signed. This is consistent with other _LINK
> attributes in other devices as well as in bpf and should not have an
> effect as device indexes can't be negative.
> 
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> 
> ----
> 
> v4: use NLA_U32 for LWT_XFRM_LINK as suggested by Nicolas Dichtel
> 
> v3: netlink improvements as suggested by Nikolay Aleksandrov and
>     Nicolas Dichtel
> 
> v2:
>   - move lwt_xfrm_info() helper to dst_metadata.h
>   - add "link" property as suggested by Nicolas Dichtel
> ---
>  include/net/dst_metadata.h    | 11 +++++
>  include/uapi/linux/lwtunnel.h | 10 +++++
>  net/core/lwtunnel.c           |  1 +
>  net/xfrm/xfrm_interface.c     | 85 +++++++++++++++++++++++++++++++++++
>  4 files changed, 107 insertions(+)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

