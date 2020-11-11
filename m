Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36982AE4A9
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 01:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731746AbgKKAJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 19:09:10 -0500
Received: from smtp7.emailarray.com ([65.39.216.66]:36922 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgKKAJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 19:09:09 -0500
Received: (qmail 17175 invoked by uid 89); 11 Nov 2020 00:09:04 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 11 Nov 2020 00:09:04 -0000
Date:   Tue, 10 Nov 2020 16:09:02 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Victor Stewart <v@nametag.social>
Cc:     netdev@vger.kernel.org
Subject: Re: MSG_ZEROCOPY_FIXED
Message-ID: <20201111000902.zs4zcxlq5ija7swe@bsd-mbp.dhcp.thefacebook.com>
References: <CAM1kxwjkJndycnWWbzBFyAap9=y13DynF=SMijL1=3SPpHbvdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM1kxwjkJndycnWWbzBFyAap9=y13DynF=SMijL1=3SPpHbvdw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 08, 2020 at 05:04:41PM +0000, Victor Stewart wrote:
> hi all,
> 
> i'm seeking input / comment on the idea of implementing full fledged
> zerocopy UDP networking that uses persistent buffers allocated in
> userspace... before I go off on a solo tangent with my first patches
> lol.
> 
> i'm sure there's been lots of thought/discussion on this before. of
> course Willem added MSG_ZEROCOPY on the send path (pin buffers on
> demand / per send). and something similar to what I speak of exists
> with TCP_ZEROCOPY_RECEIVE.
> 
> i envision something like a new flag like MSG_ZEROCOPY_FIXED that
> "does the right thing" in the send vs recv paths.

See the netgpu patches that I posted earlier; these will handle
protocol independent zerocopy sends/receives.  I do have a working
UDP receive implementation which will be posted with an updated
patchset.
--
Jonathan
