Return-Path: <netdev+bounces-4108-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D1C470AE6D
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 17:09:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FE751C2091E
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 15:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F23146AC;
	Sun, 21 May 2023 15:09:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5049823AF
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 15:09:54 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C12139
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 08:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=6oQwhyFO6ZPD5B2+AN7jA4VexfiZGlSl9R0zLnl7lSg=; b=ruOKtjSq3aDj6Tm/FQyqPGbP8u
	KEQv8uZ3Jle4MV9FudDFQU3kswFoJPzqOi9aIHZqYqrfXpEXKHM0YOkfAj7e9mOwrOtWH7eocpZoM
	UjeX4CgFnG8xVxBEogNkfwKnb9e+B99kembkO0GWuLCyjOwZMqJZxg59jjlregcHVXPM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q0kgk-00DShI-Cx; Sun, 21 May 2023 17:09:38 +0200
Date: Sun, 21 May 2023 17:09:38 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: add helpers for comparing phy IDs
Message-ID: <6ec0e9c7-5394-40f7-9f89-384ea978a6d7@lunn.ch>
References: <E1pzzm3-006BZJ-Bi@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pzzm3-006BZJ-Bi@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 02:03:59PM +0100, Russell King wrote:
> There are several places which open code comparing PHY IDs. Provide a
> couple of helpers to assist with this, using a slightly simpler test
> than the original:
> 
> - phy_id_compare() compares two arbitary PHY IDs and a mask of the
>   significant bits in the ID.
> - phydev_id_compare() compares the bound phydev with the specified
>   PHY ID, using the bound driver's mask.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

