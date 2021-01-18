Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FC72FA79C
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407099AbhARRdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:33:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:39838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407088AbhARRcd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 12:32:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2E1122C9E;
        Mon, 18 Jan 2021 17:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610991113;
        bh=q0hWOqF7poaJYBJscAU0AyCeQqxvsdTRi98uqRDqeRk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gX71eR/Nc9DZ0nji29DleO4HJbVP3GcsK5qsSqhU11ENuPgSq5mPRr2fI8BDwTzxg
         LZgmIVs6l2HDYhdBFmOC8aprU6VJglC2NeclXt/U5Hi70/WpDctzAojjUVev+Vdu0L
         /WE3beilLpuWjYdWlO/jqMpr8VYep356znV1bQZ34osrHRanQfzVvyOkVBuVtzs1Wv
         GPH+SNs8ykxTv8M7dijhTobHMqbSEwHz8bAkrO7f6BCawZsIFieNn6jJfWF0mYyAks
         Q57Zwb5ENh6D6yTMJQ79iAUKsWKjq1Uk5RfoxpCXVdTlogh4ertSdidOfUZ7H2CD/X
         9uwyS5is1RIHQ==
Date:   Mon, 18 Jan 2021 09:31:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
Subject: Re: [RFC PATCH 0/1] net: arcnet: Fix RESET sequence
Message-ID: <20210118093152.3644bf5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YAVm2OW1PZ5tYDn5@lx-t490>
References: <20201222090338.186503-1-a.darwish@linutronix.de>
        <X/xYfVi3mQrnjth+@lx-t490>
        <YAVm2OW1PZ5tYDn5@lx-t490>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 11:45:44 +0100 Ahmed S. Darwish wrote:
> On Mon, Jan 11, 2021 at 02:54:06PM +0100, Ahmed S. Darwish wrote:
> > Hi,
> >
> > On Tue, Dec 22, 2020 at 10:03:37AM +0100, Ahmed S. Darwish wrote:
> > ...  
> > >
> > > Included is an RFC patch to fix the points above: if the RESET flag is
> > > encountered, a workqueue is scheduled to run the generic reset sequence.
> > >  
> > ...
> >
> > Kind reminder.  
> 
> Ping. Will anyone look at this?

Clearly not, if you think the fix is correct please repost as non-RFC.
