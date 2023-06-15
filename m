Return-Path: <netdev+bounces-11231-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DD2D732110
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 22:46:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 721B1280A9A
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 20:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E21EAF3;
	Thu, 15 Jun 2023 20:46:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2DD7E3
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 20:46:34 +0000 (UTC)
Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539E826AA;
	Thu, 15 Jun 2023 13:46:31 -0700 (PDT)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 022F0207D3;
	Thu, 15 Jun 2023 22:46:28 +0200 (CEST)
Date: Thu, 15 Jun 2023 22:46:24 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: "Bajjuri, Praneeth" <praneeth@ti.com>,
	Siddharth Vadapalli <s-vadapalli@ti.com>, vikram.sharma@ti.com
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Pointner <h4nn35.work@gmail.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: DP83867 ethernet PHY regression
Message-ID: <ZIt4oNn5eDqfsDVy@francesco-nb.int.toradex.com>
References: <ZGuDJos8D7N0J6Z2@francesco-nb.int.toradex.com>
 <ZG4ISE3WXlTM3H54@debian.me>
 <CAHvQdo0gucr-GcWc9YFxsP4WwPUdK9GQ6w-5t9CuqqvPTv+VcA@mail.gmail.com>
 <ZG8PS/CSpHXIA6wt@francesco-nb.int.toradex.com>
 <827377ae-091b-8888-18b9-bb574d7ff3ca@ti.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <827377ae-091b-8888-18b9-bb574d7ff3ca@ti.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Bajjuri, Siddharth and Vikram

On Thu, May 25, 2023 at 03:18:34AM -0500, Bajjuri, Praneeth wrote:
> On 5/25/2023 2:33 AM, Francesco Dolcini wrote:
> > On Thu, May 25, 2023 at 08:31:00AM +0200, Johannes Pointner wrote:
> > > On Wed, May 24, 2023 at 3:22 PM Bagas Sanjaya <bagasdotme@gmail.com> wrote:
> > > > 
> > > > On Mon, May 22, 2023 at 04:58:46PM +0200, Francesco Dolcini wrote:
> > > > > Hello all,
> > > > > commit da9ef50f545f ("net: phy: dp83867: perform soft reset and retain
> > > > > established link") introduces a regression on my TI AM62 based board.
> > > > > 
> > > > > I have a working DTS with Linux TI 5.10 downstream kernel branch, while
> > > > > testing the DTS with v6.4-rc in preparation of sending it to the mailing
> > > > > list I noticed that ethernet is working only on a cold poweron.
> > > > > 
> > > > > With da9ef50f545f reverted it always works.
> 
> Thank you for bringing this issue to attention.
> I have looped Siddharth and vikram to further investigate and provide input.

Were you able to make any progress? If we are not getting anywhere in
the coming days I would be inclined to send a revert, what do you think?

Francesco



