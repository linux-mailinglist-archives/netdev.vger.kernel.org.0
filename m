Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3293615FDA
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 10:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiKBJd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 05:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiKBJdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 05:33:25 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A5265F6
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 02:33:22 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id y14so43707544ejd.9
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 02:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xekgv7hlWx7bzbvREmX1x3qWnu+QmgOoSi/q6Y1y2mA=;
        b=fAn8eG5WBN7wK9mr0LYPFXoqIyfUQoqX5WHIdz6HuJj807wPj0Qa52ujHHMvBGLMKe
         8QLBa9FaPt5vQUmps8N/Zd9xPuJnjWSTNdU+mz79uSrrLsPCItn3WIpCqTxXE4SmuE0x
         2DqJD8UmLyK0x4bE9cfFTOdn8muowio5RNFbLACimzwpsUiLffj9fBt+1oDMEbGFVKrw
         NyWwbXbgBxWQ839rPKUWEfnjddrVoPBplxQvoE/aZmQd6+8PZPOlOW4DVYPTFTtGHtee
         nyAT9cU0ikNdKvhLAZBRMym9D5HI3lN73Ss71QUzaBoA1Zgf4m2/d/ckjcQr7ciavENv
         4NmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xekgv7hlWx7bzbvREmX1x3qWnu+QmgOoSi/q6Y1y2mA=;
        b=blqyQLKIORHGGgTCrB0Iuqnen2SHgfGsG3NkW1K98ngdXk7Hz+pRv/gPylBDwF//ku
         KmcnA5OpGFrMmEFotW4sfqcrpyjwu8hHpSIdHbVxjm/RD37KsVEgIvQh+vbQBsjVop3U
         yQUCz3oF8p8OEJmV9suz3g2voINfR7n3Ym01WNARArbKw3no4KFqhoDZWrc55phBLGVK
         lcT0IO/dfiKQABMxPN7e9mu/vnAjmEwsgQscEl3+DhWFpwsGG3zg6tr9GLJY0CgIEZKr
         qbUnlfSNAmd5R5GmeXAFa43sTZMkHOZuD61UnroWXSY/Difxksr7p/RLS3nukSKHXOZW
         k2Mw==
X-Gm-Message-State: ACrzQf1jXY5GAeCFKj09XyBhF9VsWpcek5bPccweLP/X9CWM3O+IBu/p
        T5bHwuhij3gwMSr0gHl83orGeg==
X-Google-Smtp-Source: AMsMyM47VZ+b2yTjH/WGB3LoMpOnr8cV7ZmnAnuW1lcWjM3AfzJjkPVT6t3jFH7vUn1ODbOMYfIwWQ==
X-Received: by 2002:a17:907:80a:b0:783:2585:5d73 with SMTP id wv10-20020a170907080a00b0078325855d73mr22356782ejb.642.1667381601076;
        Wed, 02 Nov 2022 02:33:21 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o17-20020aa7dd51000000b004637489cf08sm3092370edw.88.2022.11.02.02.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 02:33:20 -0700 (PDT)
Date:   Wed, 2 Nov 2022 10:33:19 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: Re: [patch net-next v3 00/13] net: fix netdev to devlink_port
 linkage and expose to user
Message-ID: <Y2I5X4eMnisedAE5@nanopsycho>
References: <20221031124248.484405-1-jiri@resnulli.us>
 <20221101102915.3eccdb09@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101102915.3eccdb09@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 01, 2022 at 06:29:15PM CET, kuba@kernel.org wrote:
>On Mon, 31 Oct 2022 13:42:35 +0100 Jiri Pirko wrote:
>> Currently, the info about linkage from netdev to the related
>> devlink_port instance is done using ndo_get_devlink_port().
>> This is not sufficient, as it is up to the driver to implement it and
>> some of them don't do that. Also it leads to a lot of unnecessary
>> boilerplate code in all the drivers.
>
>Sorry about the late nit picks, the other patches look good.

Nevermind, will fix those.

>Nice cleanup!

Thx!
