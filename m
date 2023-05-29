Return-Path: <netdev+bounces-6092-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1EE6714CDF
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:18:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 195811C208E5
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E2428C14;
	Mon, 29 May 2023 15:18:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642453FD4
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 15:18:15 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13129C4
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 08:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=c2+f+7J+mDfeYFlAyp5fSh2wOqkJ7+k9dm64i55AjKU=; b=niuoF68I3k+voIasScIgVUluW0
	ePzTuZk8s1ywjC8NcpmZkKnM4+7EsLAYipIr5zUH65hRhhnCQdY6V2ULVLfOxHWBWbxQthPz14a/t
	udkK9BCvS8SvamSt0bAiPNyXIpHTkE27Nr5qKvfKYKJKUYRwOgv3mUQy5VdmmlR4nYWU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q3edH-00EEpy-CM; Mon, 29 May 2023 17:18:03 +0200
Date: Mon, 29 May 2023 17:18:03 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/6] net: mdio: add mdio_device_get() and
 mdio_device_put()
Message-ID: <c54edc01-109f-40f3-a798-4533b03dfa26@lunn.ch>
References: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
 <E1q2USm-008PAO-Gx@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q2USm-008PAO-Gx@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 11:14:24AM +0100, Russell King (Oracle) wrote:
> Add two new operations for a mdio device to manage the refcount on the
> underlying struct device. This will be used by mdio PCS drivers to
> simplify the creation and destruction handling, making it easier for
> users to get it correct.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

