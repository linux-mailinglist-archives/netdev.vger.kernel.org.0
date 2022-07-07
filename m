Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7B156975E
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 03:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbiGGBY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 21:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234644AbiGGBYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 21:24:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3025E2E9C9;
        Wed,  6 Jul 2022 18:24:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5BE78CE21A8;
        Thu,  7 Jul 2022 01:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F51EC3411C;
        Thu,  7 Jul 2022 01:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657157087;
        bh=YYAxmusy0ct4ZG1Il9AiODxjUliPdi0KcxWfM7ZIj9A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rKkIfyY2nmywCAejQPjJWLtkESEdus9zb2+gkl0u5I5FfHYXf+PUyrHhFeb1XysbQ
         /m88UnyyuUbHdiEonql8LrsoiIZPYNbWGsyJqzQ0l+EYkFf4z9zmMF1QC2jIfzWYxb
         QaZJnmKscHKs5n023MiBPlJpu/exjc6VrmsNsf4Rk6Arzf22NQr0AGllAWwlAm4xKc
         BUR6vC513L9k01PWZ3oZySiydOpNHUxsC/MhXhVascuKWvC3wWlMywsoFY7EPjJl5v
         Ae0IC1y54yBniuyYF/eUd3HsMHRnxogreSlYF6YEiQurARxIY/tp2i5ImHcxsXAGmH
         JXXH0p/7X6wsg==
Date:   Wed, 6 Jul 2022 18:24:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <kbuild-all@lists.01.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] octeontx2-af: Fix compiler warnings.
Message-ID: <20220706182446.2fb0e78d@kernel.org>
In-Reply-To: <20220706130241.2452196-1-rkannoth@marvell.com>
References: <20220706130241.2452196-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jul 2022 18:32:41 +0530 Ratheesh Kannoth wrote:
> drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:388:5: warning: =
no previous prototype for 'rvu_exact_calculate_hash' [-Wmissing-prototypes]
> 388 | u32 rvu_exact_calculate_hash(struct rvu *rvu, u16 chan, u16 ctype, =
u8 *mac,
> |     ^~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: In function 'rv=
u_npc_exact_get_drop_rule_info':
> >> drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1080:14: warn=
ing: variable 'rc' set but not used [-Wunused-but-set-variable] =20
> 1080 |         bool rc;
> |              ^~
> drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: At top level:
> drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1248:5: warning:=
 no previous prototype for 'rvu_npc_exact_add_table_entry' [-Wmissing-proto=
types]
> 1248 | int rvu_npc_exact_add_table_entry(struct rvu *rvu, u8 cgx_id, u8 l=
mac_id, u8 *mac,
> |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: In function 'rv=
u_npc_exact_add_table_entry':
> drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1254:33: warning=
: variable 'table' set but not used [-Wunused-but-set-variable]
> 1254 |         struct npc_exact_table *table;
> |                                 ^~~~~
> drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: At top level:
> drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1320:5: warning:=
 no previous prototype for 'rvu_npc_exact_update_table_entry' [-Wmissing-pr=
ototypes]
> 1320 | int rvu_npc_exact_update_table_entry(struct rvu *rvu, u8 cgx_id, u=
8 lmac_id,
> |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There are also these warnings not fixed by the follow up:

In file included from ../drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_=
fs.c:14:
../drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h:15120:28: error:=
 =E2=80=98npc_mkex_default=E2=80=99 defined but not used [-Werror=3Dunused-=
variable]
15120 | static struct npc_mcam_kex npc_mkex_default =3D {
      |                            ^~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h:15000:30: error:=
 =E2=80=98npc_lt_defaults=E2=80=99 defined but not used [-Werror=3Dunused-v=
ariable]
15000 | static struct npc_lt_def_cfg npc_lt_defaults =3D {
      |                              ^~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h:14901:31: error:=
 =E2=80=98npc_kpu_profiles=E2=80=99 defined but not used [-Werror=3Dunused-=
variable]
14901 | static struct npc_kpu_profile npc_kpu_profiles[] =3D {
      |                               ^~~~~~~~~~~~~~~~
../drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h:483:38: error: =
=E2=80=98ikpu_action_entries=E2=80=99 defined but not used [-Werror=3Dunuse=
d-variable]
  483 | static struct npc_kpu_profile_action ikpu_action_entries[] =3D {
      |                                      ^~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

Annoyingly kernel defaults to -Werror now so they break the build for
me, and I'm not immediately sure how to fix those for you. So I think
I'll revert the v2 and you can repost v3 as if v2 wasn't applied. SG?
