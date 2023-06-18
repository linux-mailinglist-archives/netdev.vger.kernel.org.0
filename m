Return-Path: <netdev+bounces-11789-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F71C734760
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 19:50:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B6AB281095
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 17:50:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7786E6FC1;
	Sun, 18 Jun 2023 17:50:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2AB6FA2
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 17:50:07 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E629E4C
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 10:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=d4hyVLLxq8QtWiPzLkwShP7brvhOf2EpRO5V0W3stkI=; b=Iz4dft3hBYsVwG9gyUsmUwVhAj
	72SIP/khPloWBS7vMGYGZTwQN7uOSw1bAPyp7Gh9gj2xo/01u5RaFYpvXql4kO2fzTHsDtaiKJrQC
	NI1bK2RricXkUA//6R54r0yfRTM875OuIpabFUIsPJAVxfwiRtAzf3ZVEyU1YZqh3ZlI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAwXM-00GquP-8V; Sun, 18 Jun 2023 19:50:04 +0200
Date: Sun, 18 Jun 2023 19:50:04 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: netdev <netdev@vger.kernel.org>
Cc: ansuelsmth@gmail.com, Russell King <rmk+kernel@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v0 1/3] led: trig: netdev: Fix requesting
 offload device
Message-ID: <5d17f2ac-bc50-40ab-ab30-9594fc99fa18@lunn.ch>
References: <20230618173937.4016322-1-andrew@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230618173937.4016322-1-andrew@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

-EMORECOFFEE

Forget the cover note, which would be something like:

Extend the PHY subsystem to allow PHY drivers to offload basic LED
blinking. Provide the needed plumbing in phylib and extend the Marvell
PHY driver to offload RX activity, TX activity and link.

I will wait the usual 24 hours and then repost with a cover note.

  Andrew

