Return-Path: <netdev+bounces-11531-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A68077337CB
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:59:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 905B31C20E23
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 17:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8771E1DCA5;
	Fri, 16 Jun 2023 17:59:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D33E19E69
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 17:59:12 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB03510D8;
	Fri, 16 Jun 2023 10:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=m5UFA98bQm/tJLd03h/z+t8dvv9ZMgDrIaMa7EZgg24=; b=vrX6KGYOS0XtMD/X1//v4ifnNb
	2pk1gLoXOnuUSxy1ChwxtVJ4lECbZ7AVSbHaKmKj1fZ2tbjB3A2MeutMKXEDDDczt2SD8jbrdskMF
	d+mR2F5tBIpy5wA03awqfsPHSuKTfdQbDMAu7sryolk3wFWMN3oN/0XKI8WwbPBIpWsI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qADj1-00Gk7S-VZ; Fri, 16 Jun 2023 19:59:07 +0200
Date: Fri, 16 Jun 2023 19:59:07 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>, netdev@vger.kernel.org,
	rust-for-linux@vger.kernel.org, aliceryhl@google.com,
	miguel.ojeda.sandonis@gmail.com
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
Message-ID: <34531d5f-0804-4c8b-94c0-ce12ff8047dc@lunn.ch>
References: <20230613045326.3938283-1-fujita.tomonori@gmail.com>
 <20230614230128.199724bd@kernel.org>
 <8e9e2908-c0da-49ec-86ef-b20fb3bd71c3@lunn.ch>
 <20230615190252.4e010230@kernel.org>
 <ZIvbX+edJo3Rh9W6@hoboy.vegasvil.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIvbX+edJo3Rh9W6@hoboy.vegasvil.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 08:47:43PM -0700, Richard Cochran wrote:
> On Thu, Jun 15, 2023 at 07:02:52PM -0700, Jakub Kicinski wrote:
> 
> > IMO we have too much useless playground stuff in C already, don't get me
> > started. Let's get a real device prove that this thing can actually work
> > :( We can waste years implementing imaginary device drivers that nobody
> > ends up using.
> 
> Yes, the long standing policy seems to be not to merge "dummy"
> drivers.  The original PTP patch set had one, but at the time the
> reviews said firmly "No" to that.

Hi Richard

I think in the modern day, you could probably add code to netdevsim to
aid testing PTP. It should however by accompanied with selftests which
actually make use of what you add.

	Andrew

