Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57AE54C4CCF
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243963AbiBYRn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243961AbiBYRnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:43:24 -0500
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6C34FC4B;
        Fri, 25 Feb 2022 09:42:48 -0800 (PST)
Received: by mail-oo1-f53.google.com with SMTP id x6-20020a4a4106000000b003193022319cso7223207ooa.4;
        Fri, 25 Feb 2022 09:42:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zHQ0Pr3ifNQPSPFr8KGHQ/qHkoEyzMsgPR4CglaYpXU=;
        b=0bLOIaEnlhdOIdh5OUtHD7NbLvvs9tc0qXnjzV7pjjf5niZV6+3xwOmuz39ov9XW/F
         RryJx6uzW1+r4eRxTnDheqBwyZDfC/4jFCh9hFfPHjqGbUX2+Mhi5QPTwd4gtc945xJz
         GinO3mpPkLeOKd+w6eDUjawbvVCmG2QcVI36Wg7Q5U6w1IT7JgaI+GkhvyHWE5Y1Ntsg
         VAK8ePNTetR/qIUvP/xyXFMABqCAlZVAgUjN5QXykdf9NYSRaHaUIK0pxU3PxqFLpqAv
         3NVpJyFBDBNNm88o11QOJ9c1cD1osmSJ8KRhY1E2NQSDskVWoN0ptYanW5G0xTnzNkMJ
         C1ig==
X-Gm-Message-State: AOAM530YYk8qqdPJzmLojgRMNTJtZ9xDt+cS4HBQF/XubMWcnHnf9Sgw
        0S/vbSgbjXS25Yk55oca6w==
X-Google-Smtp-Source: ABdhPJxcxi7bzi6JWztEBIq03YPFnl9xa7CKDKpnb04VO1SXCHU9g6PQWVwcn1U+65MvBQ29q/k5zQ==
X-Received: by 2002:a05:6870:b69a:b0:d6:d137:2734 with SMTP id cy26-20020a056870b69a00b000d6d1372734mr1735368oab.199.1645810967932;
        Fri, 25 Feb 2022 09:42:47 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id dy16-20020a056870c79000b000d273fb9e95sm1466344oab.7.2022.02.25.09.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 09:42:47 -0800 (PST)
Received: (nullmailer pid 1144497 invoked by uid 1000);
        Fri, 25 Feb 2022 17:42:45 -0000
Date:   Fri, 25 Feb 2022 11:42:45 -0600
From:   Rob Herring <robh@kernel.org>
To:     EVS Hardware Dpt <hardware.evs@gmail.com>
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] net/fsl: fman: Allow fm_max_frame_sz &
 rx_extra_headroom config from devicetree.
Message-ID: <YhkVFdTMcX4+TOiQ@robh.at.kernel.org>
References: <20220217160528.2662513-1-hardware.evs@gmail.com>
 <AM6PR04MB39761CAFB51985AFC203C535EC379@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <CAEDiaShTrWgA75e8x2deHMHF-53LFiusrVHTxP_Jy4gvaLg_9A@mail.gmail.com>
 <AM6PR04MB397692A930803C5CB6B1D568EC379@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <CAEDiaSg8SZWyoiX6jJYCX4HncZks5O8dyyVLOchYD4idGf4rCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEDiaSg8SZWyoiX6jJYCX4HncZks5O8dyyVLOchYD4idGf4rCg@mail.gmail.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 01:28:00PM +0100, EVS Hardware Dpt wrote:
> Hi Madalin, Guys,

Please don't top post on maillists.

> 
> I didn't have that historical part in mind. So, even if I still think there
> are a lot of examples super close to what I'm proposing everywhere in
> dts files, devicetree is out of equation.
> 
> Could I change the patchset to allow configuration of those two parameters
> from config ? I won't remove configuration using module parameters,
> just adding (what I think to be) an easier way of configuration.
> 
> What do you think?

Config in DT is okay, but it depends on the type of config, who is 
doing the config, and when. Think of DT config like BIOS configuration, 
but without a UI to change it.

MTU configuration has been around forever and is common to lots of h/w. 
If we wanted to configure that in DT, it would already be a standard 
property.

Rob

> 
> Regards,
> Fred.
> 
> Le ven. 18 févr. 2022 à 12:33, Madalin Bucur <madalin.bucur@nxp.com> a écrit :
> >
> > > -----Original Message-----
> > > From: EVS Hardware Dpt <hardware.evs@gmail.com>
> > > Subject: Re: [PATCH 1/2] net/fsl: fman: Allow fm_max_frame_sz &
> > > rx_extra_headroom config from devicetree.
> > >
> > > Hi Madalin, Guys
> > >
> > > I know, but it's somewhat difficult to use those parameters on kernel's
> > > command line.
> > > I don't think it's wrong to also add that in devicetree.
> > > No removal, just an added feature.
> > >
> > > For ethernet node in devicetree, there are a lot of configuration stuff
> > > like
> > > max-frame-size to allow configuration of MTU
> > > (and so potentially enable jumbo) and it's regarded as fine.
> > >
> > > It's also the goal of this patch. Allow an easy configuration of
> > > fsl_fm_max_frm from a dts. I added rx_extra_headroom for the sake of
> > > completeness.
> > >
> > > So I plead for this addition because I don't think it's wrong to do that
> > > and
> > > I consider it's nicer to add an optional devicetree property rather than
> > > adding a lot of obscure stuff on kernel's command line.
> > >
> > > Hope you'll share my point of view.
> > >
> > > Have a nice weekend Madalin, Guys,
> > > Fred.
> >
> > Hi, Fred,
> >
> > I understand your concerns in regards to usability but the device trees, as
> > explained earlier by Jakub, have a different role - they describe the HW,
> > rather than configure the SW on it. Removal of such config entries from the
> > device tree was one item on a long list to get the DPAA drivers upstreamed.
> >
> > > Le ven. 18 févr. 2022 à 08:23, Madalin Bucur <madalin.bucur@nxp.com> a
> > > écrit :
> > > >
> > > > > -----Original Message-----
> > > > > From: Fred Lefranc <hardware.evs@gmail.com>
> > > > > Subject: [PATCH 1/2] net/fsl: fman: Allow fm_max_frame_sz &
> > > > > rx_extra_headroom config from devicetree.
> > > > >
> > > > > Allow modification of two additional Frame Manager parameters :
> > > > > - FM Max Frame Size : Can be changed to a value other than 1522
> > > > >   (ie support Jumbo Frames)
> > > > > - RX Extra Headroom
> > > > >
> > > > > Signed-off-by: Fred Lefranc <hardware.evs@gmail.com>
> > > >
> > > > Hi, Fred,
> > > >
> > > > there are module params already for both, look into
> > > >
> > > > drivers/net/ethernet/freescale/fman/fman.c
> > > >
> > > > for fsl_fm_rx_extra_headroom and fsl_fm_max_frm.
> > > >
> > > > Regards,
> > > > Madalin
> 
