Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C171B4F6266
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 16:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235309AbiDFO6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 10:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbiDFO5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 10:57:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CC0171EE1;
        Wed,  6 Apr 2022 04:41:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8F7FB82271;
        Wed,  6 Apr 2022 11:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE74DC385A1;
        Wed,  6 Apr 2022 11:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649245112;
        bh=stsNdSojHjSqUsxRCEnzCoQQOj4ykG3g24XypssIwhk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=l6WWivFLBTsnPc43D+ytoS6R8Mmupmj+cDQmguVUL3XtaXFo0M9yVEICcGCzy8bRD
         5/VfMu7vSXQjCiI06UyoaFepIDFtrWyK4LiyuixTohH0d+jToRQ7EEcE4WEdnPJsoQ
         CFeM+ppC/vx5AounPBFKa/OEwWmngK/+L9eK0wwjNEaTtShztpOnrHqlaN5a6JjwOM
         iJULDuiGZgCGuFBVfa5VXrETOltEq6v29blckAqLszRou91ppXFJyfxdGShYv6PEBH
         v5lRBnp3YdAYtQEunfsIa6ZocijIeq8ajcCE/nw8Y550OhiAjPAEG7DXs2YinvGmuS
         90t9fRg/U7Cxw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] iwlegacy: 4965-rs: remove three unused variables
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220318030025.12890-1-alexander.vorwerk@stud.uni-goettingen.de>
References: <20220318030025.12890-1-alexander.vorwerk@stud.uni-goettingen.de>
To:     Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>
Cc:     <davem@davemloft.net>, <stf_xl@wp.pl>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164924510641.19026.5950929335774086462.kvalo@kernel.org>
Date:   Wed,  6 Apr 2022 11:38:30 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de> wrote:

> The following warnings showed up when compiling with W=1.
> 
> drivers/net/wireless/intel/iwlegacy/4965-rs.c: In function ‘il4965_rs_stay_in_table’:
> drivers/net/wireless/intel/iwlegacy/4965-rs.c:1636:18: warning: variable ‘il’ set but not used [-Wunused-but-set-variable]
>   struct il_priv *il;
>                   ^~
> drivers/net/wireless/intel/iwlegacy/4965-rs.c: In function ‘il4965_rs_alloc_sta’:
> drivers/net/wireless/intel/iwlegacy/4965-rs.c:2257:18: warning: variable ‘il’ set but not used [-Wunused-but-set-variable]
>   struct il_priv *il;
>                   ^~
> drivers/net/wireless/intel/iwlegacy/4965-rs.c: In function ‘il4965_rs_sta_dbgfs_scale_table_write’:
> drivers/net/wireless/intel/iwlegacy/4965-rs.c:2535:18: warning: variable ‘il’ set but not used [-Wunused-but-set-variable]
>   struct il_priv *il;
>                   ^~
> 
> Fixing by removing the variables.
> 
> Signed-off-by: Alexander Vorwerk <alexander.vorwerk@stud.uni-goettingen.de>

Please compile test your patches:

In file included from drivers/net/wireless/intel/iwlegacy/4965-rs.c:22:
drivers/net/wireless/intel/iwlegacy/4965-rs.c: In function 'il4965_rs_stay_in_table':
drivers/net/wireless/intel/iwlegacy/common.h:2927:32: error: 'il' undeclared (first use in this function); did you mean 'i'?
 2927 |         if (il_get_debug_level(il) & level)                             \
      |                                ^~
drivers/net/wireless/intel/iwlegacy/common.h:3043:33: note: in expansion of macro 'IL_DBG'
 3043 | #define D_RATE(f, a...)         IL_DBG(IL_DL_RATE, f, ## a)
      |                                 ^~~~~~
drivers/net/wireless/intel/iwlegacy/4965-rs.c:1664:25: note: in expansion of macro 'D_RATE'
 1664 |                         D_RATE("LQ: stay is expired %d %d %d\n",
      |                         ^~~~~~
drivers/net/wireless/intel/iwlegacy/common.h:2927:32: note: each undeclared identifier is reported only once for each function it appears in
 2927 |         if (il_get_debug_level(il) & level)                             \
      |                                ^~
drivers/net/wireless/intel/iwlegacy/common.h:3043:33: note: in expansion of macro 'IL_DBG'
 3043 | #define D_RATE(f, a...)         IL_DBG(IL_DL_RATE, f, ## a)
      |                                 ^~~~~~
drivers/net/wireless/intel/iwlegacy/4965-rs.c:1664:25: note: in expansion of macro 'D_RATE'
 1664 |                         D_RATE("LQ: stay is expired %d %d %d\n",
      |                         ^~~~~~
drivers/net/wireless/intel/iwlegacy/4965-rs.c: In function 'il4965_rs_alloc_sta':
drivers/net/wireless/intel/iwlegacy/common.h:2927:32: error: 'il' undeclared (first use in this function); did you mean 'inl'?
 2927 |         if (il_get_debug_level(il) & level)                             \
      |                                ^~
drivers/net/wireless/intel/iwlegacy/common.h:3043:33: note: in expansion of macro 'IL_DBG'
 3043 | #define D_RATE(f, a...)         IL_DBG(IL_DL_RATE, f, ## a)
      |                                 ^~~~~~
drivers/net/wireless/intel/iwlegacy/4965-rs.c:2256:9: note: in expansion of macro 'D_RATE'
 2256 |         D_RATE("create station rate scale win\n");
      |         ^~~~~~
drivers/net/wireless/intel/iwlegacy/4965-rs.c: In function 'il4965_rs_sta_dbgfs_scale_table_write':
drivers/net/wireless/intel/iwlegacy/common.h:2927:32: error: 'il' undeclared (first use in this function); did you mean 'inl'?
 2927 |         if (il_get_debug_level(il) & level)                             \
      |                                ^~
drivers/net/wireless/intel/iwlegacy/common.h:3043:33: note: in expansion of macro 'IL_DBG'
 3043 | #define D_RATE(f, a...)         IL_DBG(IL_DL_RATE, f, ## a)
      |                                 ^~~~~~
drivers/net/wireless/intel/iwlegacy/4965-rs.c:2549:9: note: in expansion of macro 'D_RATE'
 2549 |         D_RATE("sta_id %d rate 0x%X\n", lq_sta->lq.sta_id,
      |         ^~~~~~
make[5]: *** [scripts/Makefile.build:288: drivers/net/wireless/intel/iwlegacy/4965-rs.o] Error 1
make[4]: *** [scripts/Makefile.build:550: drivers/net/wireless/intel/iwlegacy] Error 2
make[3]: *** [scripts/Makefile.build:550: drivers/net/wireless/intel] Error 2
make[2]: *** [scripts/Makefile.build:550: drivers/net/wireless] Error 2
make[1]: *** [scripts/Makefile.build:550: drivers/net] Error 2
make: *** [Makefile:1834: drivers] Error 2

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220318030025.12890-1-alexander.vorwerk@stud.uni-goettingen.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

