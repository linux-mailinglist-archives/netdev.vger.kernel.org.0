Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1B664D90E
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 10:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiLOJwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 04:52:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiLOJvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 04:51:49 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149542E9C5
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 01:51:47 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id f18so2457425wrj.5
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 01:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r9maO8/cKmeRVsXSB+a9eypvmWTbPlcfzeGJMFNn9GI=;
        b=WGUYZPu1BC2/WvnsnjJeQersEKVBeT7qgr3qzhj33BdvH+6T6IDlVQyDdfT4HHKw3J
         cNqZCyt4P1vn2IaB5TbqPrKkzrpftcv7fu584wXWcyZzZiXwVVlvUrwX+u5f+XTStR8Z
         KYr3OsHBILkxmYmQ6WST7v3tTait6mSyKZmkPwBeeKe2UVo+9g8RIWGCnUWDha1F6Nbe
         7bGILGc5wr5sypol4SmFjbiUl6N/0UUCyAzND99eyTM2bUK/IF3/q4XIzMqycrovAlYw
         UK+N4OrwV4k28gRr2vr1NccUbiJ9HX9jMXKoAMdZbofCrauBwSV368c2nbn43DcU1b52
         nHfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r9maO8/cKmeRVsXSB+a9eypvmWTbPlcfzeGJMFNn9GI=;
        b=tmpZsaRBc9i7uaqjk59FdjUbtUZXFCdeDPOYDvmGn/2gA8S1sA7YH4PcCYGd8Kmj72
         2AaD7LNDCDoQ9UNoH3jaO53qRgpIsKBu9fGoiqnrOYsN8ARE80X6FFgU98FY7kwETipU
         4zu9a0m/50KrKKSAJCbZlV6nLk/pASjkWCfTA2VAEVVBi9ML76L1TAWmEZ231hCOj2ex
         DYNlXMpN6zohZNiO3Zo6ux5rmWcbbxtHiowQKXYh4bJLi1loLAh0EjSCrPCTF7lagny1
         kOGPJJNKPmoRPhne9qpFHTWZ3wO0BVpoxEC/ZLmi3RsRPrzBPEGBw0p5XqBQxChQ9fFF
         unLQ==
X-Gm-Message-State: ANoB5ploIgwRhBEIg1uUs3ksTraoxBCLy8g5FTi4OBAnx9P4eVp+Afkw
        YIQDEHEnjXz3A5ScFJotTnrAwA==
X-Google-Smtp-Source: AA0mqf7Hbv6ASKnISuMZ2nHwZGPCjH9t4GNjuwNTDV2Mt6kqhZ0MDCCHy6co7Aay3ulXo6iMnWYFdw==
X-Received: by 2002:adf:dbc4:0:b0:242:bef:80a7 with SMTP id e4-20020adfdbc4000000b002420bef80a7mr18930875wrj.49.1671097905524;
        Thu, 15 Dec 2022 01:51:45 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id j23-20020adfa557000000b00241ce5d605dsm5790445wrb.110.2022.12.15.01.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 01:51:44 -0800 (PST)
Date:   Thu, 15 Dec 2022 10:51:43 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, leon@kernel.org
Subject: Re: [RFC net-next 01/15] devlink: move code to a dedicated directory
Message-ID: <Y5ruLxvHdlhhY+kU@nanopsycho>
References: <20221215020155.1619839-1-kuba@kernel.org>
 <20221215020155.1619839-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215020155.1619839-2-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 15, 2022 at 03:01:41AM CET, kuba@kernel.org wrote:
>The devlink code is hard to navigate with 13kLoC in one file.
>I really like the way Michal split the ethtool into per-command
>files and core. It'd probably be too much to split it all up,

Why not? While you are at it, I think that we should split it right
away.


>but we can at least separate the core parts out of the per-cmd
>implementations and put it in a directory so that new commands
>can be separate files.
>
>Move the code, subsequent commit will do a partial split.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>---
> net/Makefile                            | 1 +
> net/core/Makefile                       | 1 -
> net/devlink/Makefile                    | 3 +++
> net/{core/devlink.c => devlink/basic.c} | 0

What's "basic" about it? It sounds a bit misleading.


> 4 files changed, 4 insertions(+), 1 deletion(-)
> create mode 100644 net/devlink/Makefile
> rename net/{core/devlink.c => devlink/basic.c} (100%)
>
>diff --git a/net/Makefile b/net/Makefile
>index 6a62e5b27378..0914bea9c335 100644
>--- a/net/Makefile
>+++ b/net/Makefile
>@@ -23,6 +23,7 @@ obj-$(CONFIG_BPFILTER)		+= bpfilter/
> obj-$(CONFIG_PACKET)		+= packet/
> obj-$(CONFIG_NET_KEY)		+= key/
> obj-$(CONFIG_BRIDGE)		+= bridge/
>+obj-$(CONFIG_NET_DEVLINK)	+= devlink/

Hmm, as devlink is not really designed to be only networking thing,
perhaps this is good opportunity to move out of net/ and change the
config name to "CONFIG_DEVLINK" ?


> obj-$(CONFIG_NET_DSA)		+= dsa/
> obj-$(CONFIG_ATALK)		+= appletalk/
> obj-$(CONFIG_X25)		+= x25/
>diff --git a/net/core/Makefile b/net/core/Makefile
>index 5857cec87b83..10edd66a8a37 100644
>--- a/net/core/Makefile
>+++ b/net/core/Makefile
>@@ -33,7 +33,6 @@ obj-$(CONFIG_LWTUNNEL) += lwtunnel.o
> obj-$(CONFIG_LWTUNNEL_BPF) += lwt_bpf.o
> obj-$(CONFIG_DST_CACHE) += dst_cache.o
> obj-$(CONFIG_HWBM) += hwbm.o
>-obj-$(CONFIG_NET_DEVLINK) += devlink.o
> obj-$(CONFIG_GRO_CELLS) += gro_cells.o
> obj-$(CONFIG_FAILOVER) += failover.o
> obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
>diff --git a/net/devlink/Makefile b/net/devlink/Makefile
>new file mode 100644
>index 000000000000..ba54922128ab
>--- /dev/null
>+++ b/net/devlink/Makefile
>@@ -0,0 +1,3 @@
>+# SPDX-License-Identifier: GPL-2.0
>+
>+obj-y := basic.o
>diff --git a/net/core/devlink.c b/net/devlink/basic.c
>similarity index 100%
>rename from net/core/devlink.c
>rename to net/devlink/basic.c




>-- 
>2.38.1
>
