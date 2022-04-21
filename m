Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B37B509D7E
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 12:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388389AbiDUKVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 06:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388405AbiDUKV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 06:21:26 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC382F39A
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 03:17:55 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id t25so5872563edt.9
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 03:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=J8Pn8rUD1/67P2tIwIl9jn0IKf5NiUvBQMzixzEqf/Q=;
        b=B+CHHscwnn2+GacbCaiG+xNaVwl86dTG9X33TRd5Haj/UzFu/OV15iRoZllAENs/fn
         5XstadFRJB3u1VfDeP+s3zylVwkFvGzVU3svaIoI/BMK831NIwb+J4/jvC2EnJgtYjuE
         u3RJnmV6ZgpYlM3CDwblSTZnb31nQSo+Zc4t1lb7/h+mWIHZaaY7ICn8yJRS2PuiGcG4
         tBjaxKYkOyhllGC+0Do+fYZuG0jXcZxdQQUuRl6hQvVKeNdY0rVejVCNvpW1PFpyrvuX
         CNylqIrGqgLLsfAIdw4NI898sqFykbiuymAcEhsfEYtnf1AgsTVfSyQysnsa7tZhz4Bi
         4T3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=J8Pn8rUD1/67P2tIwIl9jn0IKf5NiUvBQMzixzEqf/Q=;
        b=ZIaQ4dX7Ur5fNBwAqlbKML/5tgmsQBqsaVo31izjqogb3QsRk96vKPZxNFClEdqEOD
         HuT3gq/DR43flebQY+QjOucmSKltg03uWXweDKRlnDK7MFtivspSXHvc3oUFzLRNWYad
         pRutBFLSKZp02ULB9wGFhhtehoTq06lxU8P8divwf825dYHzgE2LgmC2211sjmLNKCse
         5VaK/NILKujxJBho7Ca1U6fLS4Yj1cyHW6mAT3U/bW92ZnaH4pG0tD6dwGzmN3no0lDy
         gQkiCu2xCzfOANOprG/wPE72WG+e1z8cZKi0VSFSP9FcC9wWVu6zJco0zxVpCxTvEcCR
         HJaQ==
X-Gm-Message-State: AOAM533n/IJyf/cn8J57i2czYiTXOVx4azXb3pG5jDQphoxcuNUVyO6e
        fgph/uV8ed4aJTZRkxVS7WlT3Q==
X-Google-Smtp-Source: ABdhPJxYj9pp3y6xMvUGAE9H+e7IXXi/Z76cQeSVwqvG2gC/kdL6xiYyU7QpLXbffYAK3KRvQEpSTQ==
X-Received: by 2002:a05:6402:26d1:b0:423:fc04:8e78 with SMTP id x17-20020a05640226d100b00423fc048e78mr14943798edd.133.1650536274027;
        Thu, 21 Apr 2022 03:17:54 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id s1-20020a056402036100b004240a3fc6b4sm2805757edw.82.2022.04.21.03.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 03:17:53 -0700 (PDT)
Message-ID: <c945ebff-02fe-f2d5-656f-6bdfc46416f1@blackwall.org>
Date:   Thu, 21 Apr 2022 13:17:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next] net: bridge: switchdev: check br_vlan_group()
 return value
Content-Language: en-US
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220421101247.121896-1-clement.leger@bootlin.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220421101247.121896-1-clement.leger@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/04/2022 13:12, Clément Léger wrote:
> br_vlan_group() can return NULL and thus return value must be checked
> to avoid dereferencing a NULL pointer.
> 
> Fixes: 6284c723d9b9 ("net: bridge: mst: Notify switchdev drivers of VLAN MSTI migrations")
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  net/bridge/br_switchdev.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index 81400e0b26ac..8f3d76c751dd 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -354,6 +354,8 @@ static int br_switchdev_vlan_attr_replay(struct net_device *br_dev,
>  	attr.orig_dev = br_dev;
>  
>  	vg = br_vlan_group(br);
> +	if (!vg)
> +		return 0;
>  
>  	list_for_each_entry(v, &vg->vlan_list, vlist) {
>  		if (v->msti) {


Good catch.
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
