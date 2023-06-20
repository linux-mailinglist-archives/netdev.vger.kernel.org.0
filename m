Return-Path: <netdev+bounces-12255-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A89A736E38
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 16:02:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13C2B1C20D73
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C749168B3;
	Tue, 20 Jun 2023 14:00:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FADB168B2
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 14:00:12 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203E5A4;
	Tue, 20 Jun 2023 07:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=naZEnvmVHGGLbfZLbhTkxbQ/pztHxoOXvvXSluXZFDw=; b=LdJKPnMTXGQVxOZ/CtT3rXX9j4
	+YyN7FGFydfu6UAbEqTYj3Tndqk/ckJNjknA4XHautgzDcpT81xOJZ4Rmm2IxboqHU20FnaQfsA8B
	uBjgzGMNBOrFccaK+IILeqPWfKl/XeC8h4GLA1E1D2qTsSa0+DTix8aeW6CPSnrmaNB0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qBbPs-00H018-Ad; Tue, 20 Jun 2023 15:29:04 +0200
Date: Tue, 20 Jun 2023 15:29:04 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Guo Samin <samin.guo@starfivetech.com>
Cc: Conor Dooley <conor@kernel.org>, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, netdev@vger.kernel.org,
	Peter Geis <pgwipeout@gmail.com>, Frank <Frank.Sae@motor-comm.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: net: motorcomm: Add pad driver
 strength cfg
Message-ID: <b0a61cf4-adb1-4261-b6a5-aeb1e3c1b1aa@lunn.ch>
References: <20230526090502.29835-1-samin.guo@starfivetech.com>
 <20230526090502.29835-2-samin.guo@starfivetech.com>
 <20230526-glutinous-pristine-fed571235b80@spud>
 <1dbf113c-7592-68bd-6aaf-05ff1d8c538c@starfivetech.com>
 <15eb4ffe-ea12-9a2c-ae9d-c34860384b60@starfivetech.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15eb4ffe-ea12-9a2c-ae9d-c34860384b60@starfivetech.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> I just got the detailed data of Driver Strength(DS) from Motorcomm ,
> which applies to both rx_clk and rx_data.
> 
> |----------------------|
> |     ds map table     |
> |----------------------|
> | DS(3b) | Current (mA)|
> |--------|-------------|
> |   000  |     1.20    |
> |   001  |     2.10    |
> |   010  |     2.70    |
> |   011  |     2.91    |
> |   100  |     3.11    |
> |   101  |     3.60    |
> |   110  |     3.97    |
> |   111  |     4.35    |
> |--------|-------------|
>
> Since these currents are not integer values

Integers is not a problem. Simply use uA.

> and have no regularity, it is not very good to use in the drive/dts
> in my opinion.

I think they are fine to use. Add a lookup table, microamps to
register value. Return -EINVAL if the requested value is not in the
table. List the valid values in the schema, so the checker tool might
point out problems.

      Andrew

