Return-Path: <netdev+bounces-2983-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0066C704D9D
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:18:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 997B72815D3
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0783261C9;
	Tue, 16 May 2023 12:18:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36E024EA6
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 12:18:38 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8EA49E4;
	Tue, 16 May 2023 05:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=iXg6k8lAqcLNkjmM+3EjJ6NUCTSstzc0OitScDh3o0Y=; b=Hh1LTdZpP+lxGRRpTjM2Yajuf5
	VaUDIdDYUn3NSEyIRl1DkNqo39Y8bAjZEC/npHZD9LoG4f7ZJA12gctKXgyIC3y0y6RZsryeFTN3c
	HV4P0KBKqbDL8fbtKpHq3lEbTtly0EmXbLfuRttcDwjwr/XyX1l4k3WZEugdb1+0+xH8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pytdF-00D0uj-8p; Tue, 16 May 2023 14:18:21 +0200
Date: Tue, 16 May 2023 14:18:21 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Marco Migliore <m.migliore@tiesse.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Ashkan Boldaji <ashkan.boldaji@digi.com>,
	Pavana Sharma <pavana.sharma@digi.com>,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Fix mv88e6393x EPC write
 command offset
Message-ID: <7a51da03-30b9-41d0-ac14-ec29573afd61@lunn.ch>
References: <20230516073854.91742-1-m.migliore@tiesse.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516073854.91742-1-m.migliore@tiesse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 09:38:54AM +0200, Marco Migliore wrote:
> According to datasheet, the command opcode must be specified
> into bits [14:12] of the Extended Port Control register (EPC).
> 
> Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
> Signed-off-by: Marco Migliore <m.migliore@tiesse.com>

Hi Marco

Thanks for the respin.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

For the next time you submit a patch, it is normal to put a version in the Subject line:

[PATCH net v2] net: dsa: mv88e6xxx: Fix mv88e6393x EPC write command offset

That helps us keep track of the versions, and makes it clear which is
the latest version.

    Andrew

