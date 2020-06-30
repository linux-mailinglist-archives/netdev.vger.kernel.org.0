Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4EB20F087
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 10:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731522AbgF3IaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 04:30:21 -0400
Received: from esa6.hc3370-68.iphmx.com ([216.71.155.175]:19703 "EHLO
        esa6.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbgF3IaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 04:30:20 -0400
Authentication-Results: esa6.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: vJWCbZ24qNBCnRa1jeMfzFihapPAEXWOb/MH/cTYYQUyip68MUIwSFss/OBbvXPJYIxsyk1cMP
 fykjYjWPPolzXUfAKEKbi8v5e6uTYPGHa6se6prvblrrjZ315fDhXE1Ldp+PwYlfxKFSuTxQzJ
 fPz8b/Ptrkeq2wV7Rn+c0mEizLc08zRTfpE0PDc/3s/85ulln/xVa/ZpKNcjFMEisNHCGoh3Sk
 yQnP6MGeMNavHGNxNXThtwWpJyX4Yohpdvq55ZlG0FcG1zCwqQ5tX3XMLY0i4aQJXKK1yVMij0
 oLM=
X-SBRS: 2.7
X-MesageID: 21593289
X-Ironport-Server: esa6.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.75,296,1589256000"; 
   d="scan'208";a="21593289"
Date:   Tue, 30 Jun 2020 10:30:06 +0200
From:   Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To:     Anchal Agarwal <anchalag@amazon.com>
CC:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Subject: Re: [PATCH 06/12] xen-blkfront: add callbacks for PM suspend and
 hibernation]
Message-ID: <20200630083006.GJ735@Air-de-Roger>
References: <20200604070548.GH1195@Air-de-Roger>
 <20200616214925.GA21684@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200617083528.GW735@Air-de-Roger>
 <20200619234312.GA24846@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200622083846.GF735@Air-de-Roger>
 <20200623004314.GA28586@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200623081903.GP735@Air-de-Roger>
 <20200625183659.GA26586@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200626091239.GA735@Air-de-Roger>
 <20200629192035.GA13195@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200629192035.GA13195@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
X-ClientProxiedBy: AMSPEX02CAS02.citrite.net (10.69.22.113) To
 AMSPEX02CL02.citrite.net (10.69.22.126)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 07:20:35PM +0000, Anchal Agarwal wrote:
> On Fri, Jun 26, 2020 at 11:12:39AM +0200, Roger Pau Monné wrote:
> > So the frontend should do:
> > 
> > - Switch to Closed state (and cleanup everything required).
> > - Wait for backend to switch to Closed state (must be done
> >   asynchronously, handled in blkback_changed).
> > - Switch frontend to XenbusStateInitialising, that will in turn force
> >   the backend to switch to XenbusStateInitWait.
> > - After that it should just follow the normal connection procedure.
> > 
> > I think the part that's missing is the frontend doing the state change
> > to XenbusStateInitialising when the backend switches to the Closed
> > state.
> > 
> > > I was of the view we may just want to mark frontend closed which should do
> > > the job of freeing resources and then following the same flow as
> > > blkfront_restore. That does not seems to work correctly 100% of the time.
> > 
> > I think the missing part is that you must wait for the backend to
> > switch to the Closed state, or else the switch to
> > XenbusStateInitialising won't be picked up correctly by the backend
> > (because it's still doing it's cleanup).
> > 
> > Using blkfront_restore might be an option, but you need to assert the
> > backend is in the initial state before using that path.
> >
> Yes, I agree and I make sure that XenbusStateInitialising only triggers
> on frontend once backend is disconnected. msleep in a loop not that graceful but
> works.
> Frontend only switches to XenbusStateInitialising once it sees backend
> as Closed. The issue here is and may require more debugging is:
> 1. Hibernate instance->Closing failed, artificially created situation by not
> marking frontend Closed in the first place during freezing.
> 2. System comes back up fine restored to 'backend connected'.

I'm not sure I'm following what is happening here, what should happen
IMO is that the backend will eventually reach the Closed state? Ie:
the frontend has initiated the disconnection from the backend by
setting the Closing state, and the backend will have to eventually
reach the Closed state.

At that point the frontend can initiate a reconnection by switching to
the Initialising state.

> 3. Re-run (1) again without reboot
> 4. (4) fails to recover basically freezing does not fail at all which is weird
>    because it should timeout as it passes through same path. It hits a BUG in
>    talk_to_blkback() and instance crashes.

It's hard to tell exactly. I guess you would have to figure what makes
the frontend not get stuck at the same place as the first attempt.

Roger.
