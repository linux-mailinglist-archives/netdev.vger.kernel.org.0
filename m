Return-Path: <netdev+bounces-7597-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7A28720C7D
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 02:04:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 007E1281A65
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 00:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42CDB17D5;
	Sat,  3 Jun 2023 00:04:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35FB417CE
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 00:04:38 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9138E1BB;
	Fri,  2 Jun 2023 17:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=Ro1LXCStrI6TbGKslKmZNBVJP09Dt9bV0yfODP3l5bs=; b=wfOgDpl9rBPF8igkxzJOS/6PRM
	p6LwkmJaomuUbiksDD6ffMST0d/6Mx+FdKVqoyFnd9QUvebTPphoeFChTW65yp0O4YeB4aESjhfQW
	a6mw/Bjtt9wmFZAXSGokbaCqz4XRXlR1OzVgYQYQ3Bopr0QTp721vBLYxznzMxMzF0gI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q5Ekd-00EimJ-RI; Sat, 03 Jun 2023 02:04:11 +0200
Date: Sat, 3 Jun 2023 02:04:11 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Robert Hancock <robert.hancock@calian.com>
Cc: Woojung Huh <woojung.huh@microchip.com>, UNGLinuxDriver@microchip.com,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Move KSZ9477 errata handling to PHY driver
Message-ID: <1faa28be-7881-482d-9b47-c407d8159f47@lunn.ch>
References: <20230602234019.436513-1-robert.hancock@calian.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602234019.436513-1-robert.hancock@calian.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 05:40:17PM -0600, Robert Hancock wrote:
> Patches to move handling for KSZ9477 PHY errata register fixes from
> the DSA switch driver into the corresponding PHY driver, for more
> proper layering and ordering.


Hi Robert

Is it an issue when it is performed twice, both in the PHY and the DSA
driver? This could happen if somebody was doing a git bisect and
landed in the middle of these two.

       Andrew

