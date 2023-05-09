Return-Path: <netdev+bounces-1011-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AE696FBD11
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 04:21:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25AF6281145
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 02:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13209395;
	Tue,  9 May 2023 02:21:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073547C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:21:36 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91D3E60;
	Mon,  8 May 2023 19:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=g+O5x00tplesv+G8v13jy0sAUVQJ7tkYtzclxRqNG7Q=; b=vVQNgELPGEDx3HjUySODw/JSTt
	vbbTCTA3o1NY6bU0L7MKCRKQ1ikzURZcuqLd1gC/EE3yynw7+EH5VN7WJRm6AW3mdEVrk9TnoKVWe
	xSFIWEn7hHdqI1ZpChb5iVQx508vefsKvS1REY9DqnPghSgA0NiZtm4U/O5V+xSTrqhA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pwCya-00CFuP-M7; Tue, 09 May 2023 04:21:16 +0200
Date: Tue, 9 May 2023 04:21:16 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Siddharth Vadapalli <s-vadapalli@ti.com>
Cc: hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, srk@ti.com
Subject: Re: [PATCH net-next] net: phy: dp83869: support mii mode when rgmii
 strap cfg is used
Message-ID: <2550fd50-3caf-4155-b6fd-bbdd6c9c1b72@lunn.ch>
References: <20230508070359.357474-1-s-vadapalli@ti.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508070359.357474-1-s-vadapalli@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 12:33:59PM +0530, Siddharth Vadapalli wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> The DP83869 PHY on TI's k3-am642-evm supports both MII and RGMII
> interfaces and is configured by default to use RGMII interface (strap).
> However, the board design allows switching dynamically to MII interface
> for testing purposes by applying different set of pinmuxes.
> 
> To support switching to MII interface, update the DP83869 PHY driver to
> configure OP_MODE_DECODE.RGMII_MII_SEL(bit 5) properly when MII PHY
> interface mode is requested.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

