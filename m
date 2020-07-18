Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F3F224AB2
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 12:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgGRKkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 06:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgGRKkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 06:40:32 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F221FC0619D2;
        Sat, 18 Jul 2020 03:40:31 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id f12so13436594eja.9;
        Sat, 18 Jul 2020 03:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JR+BY/byYWea4NrHdYia2JzvxtdkhExHpRY4Xivah28=;
        b=mNOH7PXwc+0A2Y89g0uPhS+iOIwsPAMOkozru8G0WznaNRPmo96DSaKbJhvDAgq5vS
         pIUMQ8jSpDB+ZfawNOGk6oir/6lqr9+tWXnMZMh+tffIgDK3JxCJxwA2mlY37L4LpURx
         OC6M7qF5ZgrLHsRexYQDzNoPHUXW02Gjjis1ve+HPVNN526jN1HcZuc/8irNaFqI1shZ
         AR/ipQhQluQJojqPdqDYwXPaqAg3z5og3quAd+fBOt2l+XuGYGWL45RghPRo0RtFg1hg
         meBBkVCd3VQbhUATFtJcXkbflyPKGMtbzR8DcJN7d92Pskf1MxwDwoe+NdwIns88UAjd
         UeaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JR+BY/byYWea4NrHdYia2JzvxtdkhExHpRY4Xivah28=;
        b=Nf9MGjHOVaiaVZo6lM4njFbVxIJ8jbf6oMg2am6knL2C5zMMx+B3yRbp2WXYKoczFz
         kwKb/LG1o3ro2LUMpURujr+CXxEy1FqMCku6+uVgo2MmsyCBeqV0VoCKQnIiibftPzpK
         r/7IEOh2d2um51G37ykl9kq6N9cSZzzxq89Q2e4ivVbvgWqqrZ2lG+DhfGOV/kWIpyjo
         kkbcX86PQWgwPwErouQZ9nV3wKOJGBNbntW8/wlKl7EslFmyqOgeBAVZJ/EJeBcEizsC
         72M5ELBlfeN6fQ+KRfXaBzAZzZjDmEWMAE+GZIrRzq5Ay+wD0SVCdLPVyYsVDl7rTfu+
         42EA==
X-Gm-Message-State: AOAM5333bWxs5zMDFNo5wqfvRF24A99cDKcyvS2lupVjA9j+CduJp6XB
        vOIwEHeoFy5NOljXUyuEr0g=
X-Google-Smtp-Source: ABdhPJxPAP6dXZx3IG4z+cDI7YABPJaauEgH8uB5hbbMK3WuFJYHDacU677yldVzt9JCObd0tv//+Q==
X-Received: by 2002:a17:906:b2c8:: with SMTP id cf8mr12619102ejb.132.1595068830639;
        Sat, 18 Jul 2020 03:40:30 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id x10sm10538498ejc.46.2020.07.18.03.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 03:40:30 -0700 (PDT)
Date:   Sat, 18 Jul 2020 13:40:27 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     UNGLinuxDriver@microchip.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: felix: Make some symbols static
Message-ID: <20200718104027.ugsdw42jfcpewfl6@skbuf>
References: <20200718100158.31878-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200718100158.31878-1-wanghai38@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 06:01:58PM +0800, Wang Hai wrote:
> Fix sparse build warning:
> 
> drivers/net/dsa/ocelot/felix_vsc9959.c:560:19: warning:
>  symbol 'vsc9959_vcap_is2_keys' was not declared. Should it be static?
> drivers/net/dsa/ocelot/felix_vsc9959.c:640:19: warning:
>  symbol 'vsc9959_vcap_is2_actions' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---

Please update your tree.

commit 3ab4ceb6e9639e4e42d473e46ae7976c24187876
Author: Vladimir Oltean <vladimir.oltean@nxp.com>
Date:   Sat Jun 20 18:43:36 2020 +0300

    net: dsa: felix: make vcap is2 keys and actions static

    Get rid of some sparse warnings.

    Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

>  drivers/net/dsa/ocelot/felix_vsc9959.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index 1dd9e348152d..2067776773f7 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -557,7 +557,7 @@ static const struct ocelot_stat_layout vsc9959_stats_layout[] = {
>  	{ .offset = 0x111,	.name = "drop_green_prio_7", },
>  };
>  
> -struct vcap_field vsc9959_vcap_is2_keys[] = {
> +static struct vcap_field vsc9959_vcap_is2_keys[] = {
>  	/* Common: 41 bits */
>  	[VCAP_IS2_TYPE]				= {  0,   4},
>  	[VCAP_IS2_HK_FIRST]			= {  4,   1},
> @@ -637,7 +637,7 @@ struct vcap_field vsc9959_vcap_is2_keys[] = {
>  	[VCAP_IS2_HK_OAM_IS_Y1731]		= {182,   1},
>  };
>  
> -struct vcap_field vsc9959_vcap_is2_actions[] = {
> +static struct vcap_field vsc9959_vcap_is2_actions[] = {
>  	[VCAP_IS2_ACT_HIT_ME_ONCE]		= {  0,  1},
>  	[VCAP_IS2_ACT_CPU_COPY_ENA]		= {  1,  1},
>  	[VCAP_IS2_ACT_CPU_QU_NUM]		= {  2,  3},
> -- 
> 2.17.1
> 

Thanks,
-Vladimir
