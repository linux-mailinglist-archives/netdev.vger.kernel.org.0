Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5EB62B34
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 23:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732710AbfGHVrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 17:47:12 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38609 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730589AbfGHVrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 17:47:12 -0400
Received: by mail-qt1-f194.google.com with SMTP id n11so19589617qtl.5
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 14:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=gWr/D+5oyDrWHtBMH3oyotq+QixFWAAPaOacnO7XOrM=;
        b=UlAuKPoUL2qI52YDbODzhuqSNJTCZBT6/IZMh77v6hEtYbEu0nhxuRTktLZ/rgd1gJ
         YqQsEXUkzKbhSL1zZQ5Ka7LOV7FWBlM+zR/Jt+LS3OVY6FWvEcm6wLq2K08QHwn8qSbr
         mM1/i4xdaFyzKapVIbUfnK72TL+n+PiSVf0ju7kMwtw1EoAqcmteqO2W3aWRAJaSDNh6
         F/Nd31qTSy2FvasixuIrOgbrUkUNXwk9D4yaRHRD8mIu80lCBZLv1Aj60nHc2B1iPpSZ
         NrDEqQ6gY9Bx3KXHDYPDKZNkztUb5AiShouoO3YwiNqOR7wRiOMPLussCWpXCcbePoaE
         4gQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=gWr/D+5oyDrWHtBMH3oyotq+QixFWAAPaOacnO7XOrM=;
        b=udE92vt9jT1b/mUbtr9xhdKBgkE9nV8NTbXoPWoCCUZOjn5Cz308n90dawGsWNoHOH
         +8QR1e4Yso/x1e9ROAEfcX7OA2puAzGKgnBn+8jaj1S2LrxmU+PPzt7sBcPRcHHQKD2s
         rRU3IwUz/OoqNii25D8wmlpCmVKEQzLkCikZ0c15y+1k7SWiLbxDczc+7J0tUkbnga++
         YhpsLNaX+nbSKbMWqVKKsj5/Md18d6XNqbhrITy2fBBFI+s1xFJiMDbwBheue8EOpzhC
         CGUtfPeF5pIrjYauAeBB4SjZDta2auAV8SzMW3CEUpbCmv20dC667rWSY6Czg+8XRwWR
         hxIA==
X-Gm-Message-State: APjAAAW54dLm6tGZ5we42yAD2s8ay4xW6YWWwtcJjtWLsvYXkZOzTQwZ
        rAXrNCX+XpnX6CpWCowgldO3hw==
X-Google-Smtp-Source: APXvYqyLQszLOY0niaJl8UxjHHQYJhnPnOGwrS+YdVh+SXBIRc1X6stQqzn+K4l+jyZ/GHy0wQTxdw==
X-Received: by 2002:a0c:e908:: with SMTP id a8mr16540771qvo.214.1562622431087;
        Mon, 08 Jul 2019 14:47:11 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x1sm7683655qkj.22.2019.07.08.14.47.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 14:47:11 -0700 (PDT)
Date:   Mon, 8 Jul 2019 14:47:06 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [EXT] Re: [PATCH net-next v2 4/4] qed*: Add devlink support for
 configuration attributes.
Message-ID: <20190708144706.46ad7a50@cakuba.netronome.com>
In-Reply-To: <MN2PR18MB25280224F5DDDFE8D86B234CD3F60@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190704132011.13600-1-skalluru@marvell.com>
        <20190704132011.13600-5-skalluru@marvell.com>
        <20190704150747.05fd63f4@cakuba.netronome.com>
        <DM6PR18MB25242BC08136A2C528C1A695D3F50@DM6PR18MB2524.namprd18.prod.outlook.com>
        <20190705123907.1918581f@cakuba.netronome.com>
        <MN2PR18MB25280224F5DDDFE8D86B234CD3F60@MN2PR18MB2528.namprd18.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Jul 2019 02:31:15 +0000, Sudarsana Reddy Kalluru wrote:
> > > > > +			Type: u8
> > > > > +			Configuration mode: Permanent
> > > > > +
> > > > > +dcbx_mode		[PORT, DRIVER-SPECIFIC]
> > > > > +			Configure DCBX mode for the device.
> > > > > +			Supported dcbx modes are,
> > > > > +			    Disabled(0), IEEE(1), CEE(2) and
> > > > > Dynamic(3)
> > > > > +			Type: u8
> > > > > +			Configuration mode: Permanent  
> > > >
> > > > Why is this a permanent parameter?
> > > >  
> > > This specifies the dcbx_mode to be configured in non-volatile memory.
> > > The value is persistent and is used in the next load of OS or the mfw.  
> > 
> > And it can't be changed at runtime?  
>
> Run time dcbx params are not affected via this interface, it only
> updates config on permanent storage of the port.

IOW it affects the defaults after boot?  It'd be preferable to have 
the DCB uAPI handle "persistent"/default settings if that's the case.
