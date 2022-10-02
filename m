Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20AD5F2446
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 19:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiJBRYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 13:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiJBRYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 13:24:32 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F217826566;
        Sun,  2 Oct 2022 10:24:30 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id lx7so8156605pjb.0;
        Sun, 02 Oct 2022 10:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=ddUbrVfslldcDQxxyn6u5sOEq16bk7soH0LIUHhOqM0=;
        b=Cic4Cl+qWUkaPWdDhfVLdWZzetX7cAmz5Se7BxBFadgx9LkatRoTCJP8RvphfY4lzf
         tG01VRjjNOMuMnkGbJJWUBNUfVdib4b6brdgZjOjqzkFwGYwfmIrEMRGWw1Dk33lMTrq
         ohMzdhn2Bzthbn0LKqw2aLHkRRBQdXCNFfaK2H2aC4IDQWwt4LHB11NPpWuCNAIbjt6h
         op8BnmPNFhem2qtocBQAjqbA46dq/RBnRQgwjIeSMD2GYRE13FJh5vK6ugB+T5mis5H4
         lh0oPdu1VKyv8shBIan9Vkv6MBu2mxE9fkHG9UzgCFJXfxMX8vfOgRvpS1yJEpzhSVy6
         UqVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ddUbrVfslldcDQxxyn6u5sOEq16bk7soH0LIUHhOqM0=;
        b=jPMUq5BXaYYccuWp1cDUgb27crsFVeCkIdafv29zsUs7y1uI9u6VEkOx3nqBbqXqoc
         L2ZeAH4OvIHAxQAnraIGmp6qBc0lnULgLzUsBad2xV4CLv5a8maVsggjQZDdj8KfZwKt
         Qx9wg+mcOtw4r+Sd/gLmFl7YFJXRUhWl/btYwPueAbtEsyH4U8Z89YdKdYuSRf61koiA
         /BPy60LcU/6nyNTu5vztsYjYJCDe9Dh2iounXbRSYxCLzEsDmqJit1YwaWRsKa330S38
         PQgOqq8f7yFChu+3uFeTEYKi0OkCWjT4k5+lwsJhPI+eOvSmDMYHp6Yt7PIZ1WQRW+TG
         RaSw==
X-Gm-Message-State: ACrzQf2HuLIGDhkD1c7IKGGsFIr98I1ZpNrbYE4oUGwQBx2yI86pt0Hj
        oBY0jW8vT82JvIjv32dfc7c=
X-Google-Smtp-Source: AMsMyM5TsMKwHWs9ivkII+6uBTlUl8+rfRrLIzh8tQDALFEC+fI5Ra0iNVK7c6A4FDElUUgLk5Yl0w==
X-Received: by 2002:a17:903:1c4:b0:17f:5b7b:657 with SMTP id e4-20020a17090301c400b0017f5b7b0657mr1481056plh.125.1664731470478;
        Sun, 02 Oct 2022 10:24:30 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w190-20020a6262c7000000b00537b1aa9191sm5785163pfb.178.2022.10.02.10.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Oct 2022 10:24:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sun, 2 Oct 2022 10:24:27 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, kvalo@kernel.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org
Subject: Re: [PATCH net-next] net: drop the weight argument from
 netif_napi_add
Message-ID: <20221002172427.GA3027039@roeck-us.net>
References: <20220927132753.750069-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927132753.750069-1-kuba@kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 06:27:53AM -0700, Jakub Kicinski wrote:
> We tell driver developers to always pass NAPI_POLL_WEIGHT
> as the weight to netif_napi_add(). This may be confusing
> to newcomers, drop the weight argument, those who really
> need to tweak the weight can use netif_napi_add_weight().
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

That seems to have missed some (or at least one) file(s).

Building mips:cavium_octeon_defconfig ... failed
--------------
Error log:
drivers/net/ethernet/cavium/octeon/octeon_mgmt.c: In function 'octeon_mgmt_probe':
drivers/net/ethernet/cavium/octeon/octeon_mgmt.c:1399:9: error: too many arguments to function 'netif_napi_add'
 1399 |         netif_napi_add(netdev, &p->napi, octeon_mgmt_napi_poll,
      |         ^~~~~~~~~~~~~~
In file included from include/linux/etherdevice.h:21,
                 from drivers/net/ethernet/cavium/octeon/octeon_mgmt.c:11:
include/linux/netdevice.h:2562:1: note: declared here
 2562 | netif_napi_add(struct net_device *dev, struct napi_struct *napi,

Guenter
