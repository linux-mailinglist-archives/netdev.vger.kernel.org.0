Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C8C60572D
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 08:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiJTGMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 02:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiJTGM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 02:12:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FAD16CA6C
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 23:12:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 584D361A0C
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 06:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51157C433C1;
        Thu, 20 Oct 2022 06:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666246343;
        bh=ucvxZNg3IC/FP+E5eeSOj0LMxf8dCMzFkoPemIUDlOA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vIap0gJE0pWHQQCPhmmump1CFk3H/cQ0gxxjWPfuX5cY8lw58u0bRAtkV2m4WBmor
         px29m5FuavbdLoWP7Cue9sopzHeLPIwDM+HYBGDsGltOY34f2BFy62S5ai3e3EDaqG
         K9v5ihQGxoIZApuYKL7TFoB+1IEK2+VItsORJz4tUPt+oaN5tn22/F0uI9/fvXxNY2
         RtKf0KlZFzPuSnOM/ez8mTkoxDK/6JL/uxprQahui44pieDRHpWqMe+c13ezgF5XpT
         mRcBWE7DNwqQyyUumZgyG/yGue2aGczzFQh8ll4poCIMQIGk2I5ESkzR6MAJjRou6w
         Vy5gcF4hilXsg==
Date:   Thu, 20 Oct 2022 09:12:20 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com
Subject: Re: [PATCH net] MAINTAINERS: add keyword match on PTP
Message-ID: <Y1DmxBUCOYpWn5GY@unreal>
References: <20221020021913.1203867-1-kuba@kernel.org>
 <Y1Dh8kFNicjxzNHn@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y1Dh8kFNicjxzNHn@unreal>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 08:51:46AM +0300, Leon Romanovsky wrote:
> On Wed, Oct 19, 2022 at 07:19:13PM -0700, Jakub Kicinski wrote:
> > Most of PTP drivers live under ethernet and we have to keep
> > telling people to CC the PTP maintainers. Let's try a keyword
> > match, we can refine as we go if it causes false positives.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  MAINTAINERS | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 5c6ce094e55e..ba8ed738494f 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16673,6 +16673,7 @@ F:	Documentation/driver-api/ptp.rst
> >  F:	drivers/net/phy/dp83640*
> >  F:	drivers/ptp/*
> >  F:	include/linux/ptp_cl*
> > +K:	(?:\b|_)ptp(?:\b|_)
> 
> I tried it with grep (maybe it is wrong) and it finds only files with
> underscores.
> 
> ➜  kernel git:(m/xfrm-latest) tree | grep -E "(?:\b|_)ptp(?:\b|_)"
> │   │   │   │   │   ├── ice_ptp_consts.h
> │   │   │   │   │   ├── ice_ptp_hw.c
> │   │   │   │   │   ├── ice_ptp_hw.h
> 
> And this is as it is written in MAINTAINERS without "_".
> 
> ➜  kernel git:(m/xfrm-latest) tree | grep -E "\bptp\b"
> │   │       ├── sysfs-ptp
> │   │   │   │   ├── intel,ixp46x-ptp-timer.yaml
> │   │   │   ├── ptp
> │   │   │   │   ├── brcm,ptp-dte.txt
> │   │   │   │   ├── ptp-idt82p33.yaml
> │   │   │   │   ├── ptp-idtcm.yaml
> │   │   │   │   ├── ptp-ines.txt
> │   │   │   │   ├── ptp-qoriq.txt
> │   │   ├── ptp.rst
> │   │   │   │   ├── ptp.c
> │   │   │   │   ├── ptp.h
> │   │   │   │       └── xgbe-ptp.c
> │   │   │   │   │   ├── dpaa2-ptp.c
> │   │   │   │   │   ├── dpaa2-ptp.h
> │   │   │   │   │   ├── ptp.c
> │   │   │   │   │   │   ├── ptp.c
> │   │   │   │   │   │   ├── ptp.h
> │   │   │   │   │       │   ├── ptp.c
> │   │   │   │   │       │   ├── ptp.h
> │   │   │   │   ├── ptp.c
> │   │   │   │   ├── ptp.h
> │   │   │   │   │   ├── ptp.c
> │   │   │   │   │   ├── ptp.h
> │   │   │   ├── bcm-phy-ptp.c
> 
> Should I try it differently?

And maybe "K: ptp" will be even better.

> 
> Thanks
> 
> >  
> >  PTP VIRTUAL CLOCK SUPPORT
> >  M:	Yangbo Lu <yangbo.lu@nxp.com>
> > -- 
> > 2.37.3
> > 
