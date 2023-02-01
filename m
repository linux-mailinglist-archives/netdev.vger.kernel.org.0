Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECDA1686EF3
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 20:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbjBATaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 14:30:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjBATaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 14:30:00 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FFD7BBCA;
        Wed,  1 Feb 2023 11:29:59 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pNIno-00027L-0u;
        Wed, 01 Feb 2023 20:29:52 +0100
Date:   Wed, 1 Feb 2023 19:28:11 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Alexander Couzens <lynxis@fe80.eu>,
        Simon Horman <simon.horman@corigine.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 net 0/3] fixes for mtk_eth_soc
Message-ID: <Y9q9S9AxdsYMti3P@makrotopia.org>
References: <20230201182331.943411-1-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230201182331.943411-1-bjorn@mork.no>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 07:23:28PM +0100, Bjørn Mork wrote:
> Changes since v4:
>  - use same field order for kernel-doc and code in patch 1
>  - cc'ing full maintainer list from get_maintainer.pl
> 
> Changes since v3:
>  - fill hole in struct mtk_pcs with new interface field
>  - improved patch 2 commit message
>  - added fixes tags
>  - updated review tags
>  
> Changes since v2:
>  - use "true" for boolean
>  - fix SoB typo
>  - updated tags
> 
> Changes since v1:
>  - only power down on changes, fix from Russel
>  - dropped bogus uncondional in-band patch
>  - added pcs poll patch from Alexander
>  - updated tags
> 
> 
> Fix mtk_eth_soc sgmii configuration.
> 
> This has been tested on a MT7986 with a Maxlinear GPY211C phy
> permanently attached to the second SoC mac.

for the whole series:
Acked-by: Daniel Golle <daniel@makrotopia.org>
Tested-by: Daniel Golle <daniel@makrotopia.org>

> 
> 
> Alexander Couzens (2):
>   net: mediatek: sgmii: ensure the SGMII PHY is powered down on
>     configuration
>   mtk_sgmii: enable PCS polling to allow SFP work
> 
> Bjørn Mork (1):
>   net: mediatek: sgmii: fix duplex configuration
> 
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h |  4 +-
>  drivers/net/ethernet/mediatek/mtk_sgmii.c   | 46 ++++++++++++++-------
>  2 files changed, 35 insertions(+), 15 deletions(-)
> 
> -- 
> 2.30.2
> 
