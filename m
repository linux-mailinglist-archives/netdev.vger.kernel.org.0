Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C182CFFD6
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 00:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgLEXue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 18:50:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbgLEXud (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 18:50:33 -0500
Date:   Sat, 5 Dec 2020 15:49:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607212193;
        bh=h0vaEYwFre3MPf6MHPuQ2v8JOABc6Vx+THCYEJwqZEg=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=CoulufPecNt5be0Hh33etS3OzTQxlnBJ7VBB2umi3YSs3TT6bAL3EyUHBgEj678S1
         D4e7VYqm5pc2agH2C6uCN5zPOwbkvVwlH+Y2LwcMt4wYPnBdw1fXV95sYKffViOi82
         y0gL1xUtGL6JHZ55vqfkxTlEJvulAsxDRMKJIl+uZORsFppIruc0DSGKJvS1xuNNnV
         arPEnpc1N7a7vSPwk9IxxpxwYLSRgD4a85MqeoZCZRlLf4Z+nzhwxkq4qHnj2Dp0Ve
         nMp1Nrg6/xjUA+Dj7oA/ei8fl0jd7Qlt8cw+URHJlwZLH8KqybD0pcvvwEZagDn2XM
         VXYVuq9MeuQVQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     "Limonciello, Mario" <Mario.Limonciello@dell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>,
        David Arcari <darcari@redhat.com>,
        "Shen, Yijun" <Yijun.Shen@dell.com>,
        "Yuan, Perry" <Perry.Yuan@dell.com>,
        "anthony.wong@canonical.com" <anthony.wong@canonical.com>
Subject: Re: [PATCH v3 0/7] Improve s0ix flows for systems i219LM
Message-ID: <20201205154951.4dd92194@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <CAKgT0UfuyrbzpDNySMmnAkqKnw9cYuEM1LhgG0QvmrY=smR-uw@mail.gmail.com>
References: <20201204200920.133780-1-mario.limonciello@dell.com>
        <CAKgT0Uc=OxcuHbZihY3zxsxzPprJ_8vGHr=reBJFMrf=V9A5kg@mail.gmail.com>
        <DM6PR19MB2636B200D618A5546E7BBB57FAF10@DM6PR19MB2636.namprd19.prod.outlook.com>
        <CAKgT0UfuyrbzpDNySMmnAkqKnw9cYuEM1LhgG0QvmrY=smR-uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 14:38:03 -0800 Alexander Duyck wrote:
> > > The patches look good to me. Just need to address the minor issue that
> > > seems to have been present prior to the introduction of this patch
> > > set.
> > >
> > > Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>  
> >
> > Thanks for your review.  Just some operational questions - since this previously
> > existed do you want me to re-spin the series to a v4 for this, or should it be
> > a follow up after the series?
> >
> > If I respin it, would you prefer that change to occur at the start or end
> > of the series?  
> 
> I don't need a respin, but if you are going to fix it you should
> probably put out the patch as something like a 8/7. If you respin it
> should happen near the start of the series as it is a bug you are
> addressing.

Don't we need that patch to be before this series so it can be
back ported easily? Or is it not really a bug?
