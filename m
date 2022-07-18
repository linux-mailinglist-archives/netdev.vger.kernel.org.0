Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDFB0578B21
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 21:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbiGRTot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 15:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234128AbiGRTor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 15:44:47 -0400
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3870C6445;
        Mon, 18 Jul 2022 12:44:47 -0700 (PDT)
Received: by mail-il1-f169.google.com with SMTP id h16so6584218ila.2;
        Mon, 18 Jul 2022 12:44:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v1mTrcXvswvV41WDcTPk/HMuVmCDknQU5gd5C2gfzQ8=;
        b=QiLipj//hUSOs1SmLU7LT0beMbZ91pJvnhinxymF/Y2omOcv+Y41SFPtbz8L9J6ySd
         Kt5UyHpPKkn9hQ7MpIEblCMH16DyhXD9r05TblyKmYOg+mm5gNOXUnSEO3vB5s8lKSvE
         VVVhk+CdNFSAM7Uolrs5XOY3XW/vy7HtdLiL1R4Zpk6ih9dgE9sjK5hi98i/dsVR65iy
         1a1inAmQGyllMHjGB7iDS8CZ4AChALFUw7AxiwUaO14SZLsoZMjy+erwQrGbHmYUbGTs
         AGuDuaZ8lNVF0onH6lTjaAMzKTFbFRCl1AabukURMEyi/1iZXSQmalWiXbGAZtnYGZcU
         jjhg==
X-Gm-Message-State: AJIora9HO2fWZyffG/D3+ahboOvU30Eexefv7cStWKXEU4VwQ1UaR6gD
        G897fS4mWhfUrOExDhbxbQudSXWyig==
X-Google-Smtp-Source: AGRyM1thdOCUCm3a5Arpfp2n9tlXe8iJFisYAFCILX2dspZF1A5XRi7ojWRrgF50rGbfnoIyJr1SPQ==
X-Received: by 2002:a05:6e02:12c3:b0:2dc:6c36:5cc2 with SMTP id i3-20020a056e0212c300b002dc6c365cc2mr15044171ilm.278.1658173486480;
        Mon, 18 Jul 2022 12:44:46 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id m3-20020a92d703000000b002dc0d2f7c7bsm5115783iln.4.2022.07.18.12.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 12:44:46 -0700 (PDT)
Received: (nullmailer pid 3423082 invoked by uid 1000);
        Mon, 18 Jul 2022 19:44:44 -0000
Date:   Mon, 18 Jul 2022 13:44:44 -0600
From:   Rob Herring <robh@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [RFC PATCH net-next 9/9] net: pcs: lynx: Remove remaining users
 of lynx_pcs_create
Message-ID: <20220718194444.GA3377770-robh@kernel.org>
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220711160519.741990-10-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711160519.741990-10-sean.anderson@seco.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 12:05:19PM -0400, Sean Anderson wrote:
> Now that PCS devices have a compatible string, we no longer have to bind
> the driver manually in lynx_pcs_create. Remove it, and convert the
> remaining users to pcs_get_by_fwnode.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> This requires that all PCSs have a compatible string. For a reasonable
> window of compatibility, this should be applied one major release after
> all compatible strings are added.

These platforms are pretty stable. I don't think a 1 release window is 
sufficient. Maybe a 1 LTS release.

> 
>  .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 27 ++-----------------
>  drivers/net/pcs/pcs-lynx.c                    | 19 -------------
>  include/linux/pcs-lynx.h                      |  1 -
>  3 files changed, 2 insertions(+), 45 deletions(-)
