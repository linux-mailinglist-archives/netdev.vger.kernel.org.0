Return-Path: <netdev+bounces-6946-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E786E718EF0
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 01:11:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A325228165B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 23:11:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C323240777;
	Wed, 31 May 2023 23:11:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B682E18C3B
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 23:11:12 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB8197
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=zX01+283jaD3QYt414vq6GCz0rlBZDuRU9fDAQQp5uI=; b=Gm8UmV74nUluDTomTOiGooiYXh
	wzKlg3gwUUrV4H3r9Ys8d5JQ+1waWrp5mJg1GFJLAj6rpIq0BRn0D9wNCqngkatY02AHQoPkV2UEQ
	S8zx0q2F29ki6oLzI8TOR9t0DB8qUS4AgIxhhY6W0E+dEx5rVW6sHs9oFsl0FPMtXKcA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q4Uy0-00EW9T-HQ; Thu, 01 Jun 2023 01:10:56 +0200
Date: Thu, 1 Jun 2023 01:10:56 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Tristram.Ha@microchip.com
Cc: davem@davemloft.net, f.fainelli@gmail.com, netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next] net: phy: smsc: add WoL support to
 LAN8740/LAN8742 PHYs.
Message-ID: <f6c99c27-7674-4b5c-942a-2698fe35643a@lunn.ch>
References: <1685151574-2752-1-git-send-email-Tristram.Ha@microchip.com>
 <cd313489-603e-4d8e-a09d-22a0c492a3cd@lunn.ch>
 <BYAPR11MB35583CCCF0C908763B5BA5E3EC489@BYAPR11MB3558.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR11MB35583CCCF0C908763B5BA5E3EC489@BYAPR11MB3558.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> > From an architecture point of view, i don't think a PHY driver should
> > be access these data structure directly. See if ipv6_get_lladdr() does
> > what you need?
> 
> ipv6_get_lladdr() is not exported so cannot be used when building the
> PHY driver as a module.

Well that is easy to change. You can propose changes to anything in
Linux, anywhere. And if it makes sense, it will get accepted.

       Andrew

