Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20864E3BBC
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 10:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbiCVJaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 05:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiCVJaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 05:30:16 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75A15C84A
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 02:28:46 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id p15so34878109ejc.7
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 02:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nGP7T+3R7WN+ulhjM07ea7s3j7YrM3fNEMYdMssnmac=;
        b=8L2HaVvswXmRhB8WkT4g0ew6KX7uxdFqJny48ufaoRP3qfMsnyA6dHuurPSkO5b/RG
         8tNHmHjwKHIWabG2t2oELviyLsH5qCxQR7FwTpiXSwMkaUPQ96xGi83taXDBb5GRIIE5
         pQSqZJXngaU+qlX69uTmGoH/5R4oGNcQ76ttKCYEPBdf3YVMY58lXOnpawFdXkRDeY3D
         cHlWrqPs/cbCCc52tCqGwH70q+nXM2qLRh0l7IAqXTw1DSAFz9STI75iYYYk+OO3AU5X
         HmR66R4xzfw8fxtS9YQJ9cVW7UApe2UB/nmN0p1T6XoL+/+5EHSRF4JyDm/q1NLoWDhq
         TLvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nGP7T+3R7WN+ulhjM07ea7s3j7YrM3fNEMYdMssnmac=;
        b=buOwjfTVTbObD/HvCXMq01/oc3AZouKQxLvgzMfywRyVtd9Gq7eNWrISLAr1THQr7q
         t35m1kTOXvI4Ga8f0Bz+FyZE+dY4LkEJJ+BM1rSGNMl5r3x197VK6nrHxI0H1p19Wqnz
         SEjkzdC6H3aRrkm3o3yjgdB44LhP2BjEwGjtJ59MY66/ZxgyagFB+zbmWVSQzbhl+rWt
         oCza6/3JipMm1/wPPmq71f617N1fui5RJZahQllkCn1zBqSHoZ8vDnd3c+jLOUhwiKML
         nV3lSgvfZcuthdIe0229dnY9su2ezp1KrP3DAwQw+Y7w71cGPEJvnsmmipBeLoR70ra0
         rl2Q==
X-Gm-Message-State: AOAM533bawrEglViOZJ6fPTnxf2c0V2ypHowvnhmtPwZb54+1JEGiX1U
        fEUCaLWAF5DgpXCszkcqqqG7XP8/k07a+RZAbaotFg==
X-Google-Smtp-Source: ABdhPJwWkwIP7iT9bsluV3IlsIG3A3Tv/3IMzAmfwYbWmv9+9vZR23pZE94fXAXtvWFhmASqIKxZvw==
X-Received: by 2002:a17:907:2ce3:b0:6df:d2cf:4d98 with SMTP id hz3-20020a1709072ce300b006dfd2cf4d98mr15243840ejc.139.1647941325192;
        Tue, 22 Mar 2022 02:28:45 -0700 (PDT)
Received: from [192.168.100.202] (212-147-51-13.fix.access.vtx.ch. [212.147.51.13])
        by smtp.gmail.com with ESMTPSA id y17-20020a056402359100b0041926ea1e12sm4266155edc.53.2022.03.22.02.28.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 02:28:44 -0700 (PDT)
Message-ID: <657a1095-67c7-c262-d05f-39d95d433b54@blackwall.org>
Date:   Tue, 22 Mar 2022 11:28:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net-next] net: bridge: mst: prevent NULL deref in
 br_mst_info_size()
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220322012314.795187-1-eric.dumazet@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220322012314.795187-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/22 03:23, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Call br_mst_info_size() only if vg pointer is not NULL.
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000058: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x00000000000002c0-0x00000000000002c7]
[snip]
> Fixes: 122c29486e1f ("net: bridge: mst: Support setting and reporting MST port states")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Tobias Waldekranz <tobias@waldekranz.com>
> Cc: Nikolay Aleksandrov <razor@blackwall.org>
> ---
>   net/bridge/br_netlink.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index a8d90fa8621e2dd7b74b16ce527984f40b563ea0..204472449ec9323cedc19326ff600a61d8f510f5 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -119,7 +119,7 @@ static size_t br_get_link_af_size_filtered(const struct net_device *dev,
>   	/* Each VLAN is returned in bridge_vlan_info along with flags */
>   	vinfo_sz += num_vlan_infos * nla_total_size(sizeof(struct bridge_vlan_info));
>   
> -	if (filter_mask & RTEXT_FILTER_MST)
> +	if (vg && (filter_mask & RTEXT_FILTER_MST))
>   		vinfo_sz += br_mst_info_size(vg);
>   
>   	if (!(filter_mask & RTEXT_FILTER_CFM_STATUS))

Thanks,
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
