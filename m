Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7111B2F9DDC
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 12:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389981AbhARLSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 06:18:00 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55540 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388841AbhARKq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 05:46:28 -0500
Date:   Mon, 18 Jan 2021 11:45:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610966746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GoNJIEid/fflBhSldAhfI5RCh95JfZzJIiYzBPtsCM8=;
        b=JF1dB0yr4AZDbDINkXF8HsjdOZbTC7yETeEScBqmXq2jjcIKW9hiJHFgIaXfCGur+K32jO
        EU7wcM/jm+iojzI4izwbkAm8fVWywax9o6gbv5pdjmVuCU8d0aZpQ7RwsTY3MkgAljrQ8E
        MzRJUtdN69X5v0ENTwQ+IuaiIfHxg2tVJainMMxQoAdPOMcwTk4ReemhG7b96YhbPAXQX9
        dBiLZEXxeVq5KR7WupikoIytieAnzDJjvFmESciOSvQjs4ZiKjbSfAGkaQulbMTkA20QmF
        FIfI8LHWDa+14yIsXHNs/xog1Dpr2fOPHTna3+qIunVmTfiBo655VgNTCTuaqQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610966746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GoNJIEid/fflBhSldAhfI5RCh95JfZzJIiYzBPtsCM8=;
        b=06v9uGcP61ic/HsZAJ+DICguRMMIOXGU3bnQGgY06X9RL2vrcraUmZ636tPNa46AZ3BLxj
        6uilUmvKTniQf7Cw==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
Subject: Re: [RFC PATCH 0/1] net: arcnet: Fix RESET sequence
Message-ID: <YAVm2OW1PZ5tYDn5@lx-t490>
References: <20201222090338.186503-1-a.darwish@linutronix.de>
 <X/xYfVi3mQrnjth+@lx-t490>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/xYfVi3mQrnjth+@lx-t490>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 02:54:06PM +0100, Ahmed S. Darwish wrote:
> Hi,
>
> On Tue, Dec 22, 2020 at 10:03:37AM +0100, Ahmed S. Darwish wrote:
> ...
> >
> > Included is an RFC patch to fix the points above: if the RESET flag is
> > encountered, a workqueue is scheduled to run the generic reset sequence.
> >
> ...
>
> Kind reminder.

Ping. Will anyone look at this?

Thanks,

--
Ahmed S. Darwish
