Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E41C42A8C2
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237417AbhJLPvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 11:51:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234892AbhJLPvH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 11:51:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 338F460EBB;
        Tue, 12 Oct 2021 15:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634053745;
        bh=zoZx7D+jVfVpUZgonLblO2ILaXws8fuJx8irfTgPUsg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VRzwZHDuFimrSi+dAarv8oRhe79bCqTv1O65B0WkrcC9JB9VDn/AwIrv8eCqLfIpZ
         GRgQfzmhZrG58sa5Yu8gFPe7btNdZ/wpulu+ukQXY/GMK5p4mv2eKYyelrZrN9y0XN
         Ujbt6W9gsE7T+3LwQDLktyUSGUXGOxg8V5h+G/q5q/MWb6aBpHbM2TI/DY1IMa6OGv
         TC8gQXlMa3Qz+KCfkpVIcj8ak/Ze77zsgdngAz8P7roC8Df03KhDrpWPynbb18egqI
         0ok/38gDY01AJevorgBR6yLDKx8Tc0tNyTCeM6b3GeHB4l7HoFBrWSkRKegHeUylF9
         vnLvGtj96ZK1A==
Date:   Tue, 12 Oct 2021 08:49:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     Ruud Bos <kernel.hbk@gmail.com>, netdev@vger.kernel.org,
        richardcochran@gmail.com, davem@davemloft.net
Subject: Re: [PATCH net-next 0/4] igb: support PEROUT and EXTTS PTP pin
 functions on 82580/i354/i350
Message-ID: <20211012084904.73c8453a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAA0z7By8Rz+3dqMF8_WXRZuvG7K_Mrgm209Zpsk6C0urG1cOnA@mail.gmail.com>
References: <20211006125825.1383-1-kernel.hbk@gmail.com>
        <YV2f7F/WmuJq/A79@bullseye>
        <CAA0z7By8Rz+3dqMF8_WXRZuvG7K_Mrgm209Zpsk6C0urG1cOnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Oct 2021 17:43:52 +0200 Ruud Bos wrote:
> On Wed, Oct 6, 2021 at 3:09 PM Ruud Bos <kernel.hbk@gmail.com> wrote:
> > My apologies for the huge delay in resending this patch set.
> >
> > I tried  setting up my corporate e-mail to work on Linux to be able to use
> > git send-email and getting rid of the automatically appended
> > confidentiality claim. Eventually I gave up on getting this sorted, hence
> > the different e-mail address.
> >
> > Anyway, I have re-spun the patch series atop net-next.
> > Feedback is welcome.
>
> Ping?
> I did not receive any response to my patches yet.
> Does that mean I did something wrong?

These are supposed to go via Intel's trees. 
Let's point To: at Intel's maintainers.
