Return-Path: <netdev+bounces-11817-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FAF473482E
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 22:32:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BAA928100F
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 20:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B91279D6;
	Sun, 18 Jun 2023 20:32:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806617477
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 20:32:07 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608F4126
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 13:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=nEoALmKSUjgYyGln4hiQyWkMt1z6cYhPTszyOelXpbs=; b=6Qw9buzL3sZG79Ay6WmfJV4Z1x
	CXvwIHWP9uvs9lBKbgA533YZ0aqQYesuTHgNaV9MU0ygCRk7bQjzGbVYnW5o67AaflkWIWEK2Iq6C
	kPI9GVV+p+dJ7YQdpmmvfCbmm6eTEyLdDYHnARW8jbzoMgjIW4bUKWQY0KB7aQGysYQk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAz48-00Grb9-RK; Sun, 18 Jun 2023 22:32:04 +0200
Date: Sun, 18 Jun 2023 22:32:04 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: netdev <netdev@vger.kernel.org>
Cc: Russell King <rmk+kernel@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v0] net: phy-c45: Fix genphy_c45_ethtool_set_eee
 description
Message-ID: <d8aaf7e8-d74d-41d6-81b0-e5ccd940073f@lunn.ch>
References: <20230618180130.4016802-1-andrew@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230618180130.4016802-1-andrew@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 18, 2023 at 08:01:30PM +0200, Andrew Lunn wrote:
> The text has been cut/paste from  genphy_c45_ethtool_get_eee but not
> changed to reflect it performs set.
> 
> Additionally, extend the comment. This function implements the logic
> that eee_enabled has global control over EEE. When eee_enabled is
> false, no link modes will be advertised, and as a result, the MAC
> should not transmit LPI.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Russell has suggested some changes in another thread.

    Andrew

---
pw-bot: cr

