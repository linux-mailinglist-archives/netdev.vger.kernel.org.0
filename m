Return-Path: <netdev+bounces-4961-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FAC170F5FA
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:14:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB3581C20C0E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:14:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07AD217FF7;
	Wed, 24 May 2023 12:14:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F9617ABE
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:14:00 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3C9130;
	Wed, 24 May 2023 05:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=8qeTXxkupCWLmc+up1atUtzykwHapMbu+cqMpe+hUp4=; b=oBA3CWu5kRoYDXR6FVmp+1YbuU
	LZKtQ5clrbZJgoVvU9ueAZitoEjwSSrZr+y3odd+SHd/ph8KAL6hWkl23+Fb/zhbGz6JimBRQg5q3
	wZmWLG8JCQk8iDT6/MWR96/aLAGl9QhpLzGnh8EiC6PbwTZsePc/7OIQOZFtS/j9Ai2s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q1nNG-00Dmij-8x; Wed, 24 May 2023 14:13:50 +0200
Date: Wed, 24 May 2023 14:13:50 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Francesco Dolcini <francesco@dolcini.it>,
	Praneeth Bajjuri <praneeth@ti.com>
Cc: Praneeth Bajjuri <praneeth@ti.com>, Geet Modi <geet.modi@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Grygorii Strashko <grygorii.strashko@ti.com>,
	Dan Murphy <dmurphy@ti.com>
Subject: Re: DP83867 ethernet PHY regression
Message-ID: <c2c75e43-eb7e-41c7-902e-726db764acb5@lunn.ch>
References: <ZGuDJos8D7N0J6Z2@francesco-nb.int.toradex.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGuDJos8D7N0J6Z2@francesco-nb.int.toradex.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 04:58:46PM +0200, Francesco Dolcini wrote:
> Hello all,
> commit da9ef50f545f ("net: phy: dp83867: perform soft reset and retain
> established link") introduces a regression on my TI AM62 based board.
> 
> I have a working DTS with Linux TI 5.10 downstream kernel branch, while
> testing the DTS with v6.4-rc in preparation of sending it to the mailing
> list I noticed that ethernet is working only on a cold poweron.
> 
> With da9ef50f545f reverted it always works.

Hi Praneeth

Do you have any suggestions? It was your patched which introduced the
regression. Before we revert it, i want to give you an opportunity to
fix the problem it introduced.

Thanks
	Andrew

