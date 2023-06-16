Return-Path: <netdev+bounces-11615-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEFD7733B1A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:43:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE4881C20F93
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CC01613D;
	Fri, 16 Jun 2023 20:43:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E5AECB
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:43:01 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AA83AA3;
	Fri, 16 Jun 2023 13:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=SjGeG/Asq80tJKRYYzdJI4qDQRsSpZV+gFFdzpK1g0s=; b=PpkZYdnk5hkg+VheE1FMkc3EE4
	kXtXJE/Yw+ptoAALI0cjlgA0UfEF/qAaTxU22zZmt230iXsb1wO/+qV4FWVaHLAJl95+eM5mlsw1B
	xcPSyWtDKrRo5PnnhW5Cd1R9IM4c0OsBpU6/8wYyiF154/AhQqQwIAgJCnfBNZu2NcwI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAGHU-00Gl3l-0O; Fri, 16 Jun 2023 22:42:52 +0200
Date: Fri, 16 Jun 2023 22:42:51 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc: hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	richardcochran@gmail.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, sebastian.tobuschat@nxp.com
Subject: Re: [PATCH net-next v1 04/14] net: phy: nxp-c45-tja11xx: add
 *_reg_field functions
Message-ID: <ff1999c4-f80d-480f-a26e-6951d36c9f8b@lunn.ch>
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
 <20230616135323.98215-5-radu-nicolae.pirea@oss.nxp.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616135323.98215-5-radu-nicolae.pirea@oss.nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> +static int nxp_c45_read_reg_field(struct phy_device *phydev,
> +				  const struct nxp_c45_reg_field *reg_field)
> +{
> +	u16 mask;
> +	int ret;
> +
> +	if (reg_field->size == 0) {
> +		phydev_warn(phydev, "Trying to read a reg field of size 0.");

I would actually use phydev_err(). 

> +	if (reg_field->size == 0) {
> +		phydev_warn(phydev, "Trying to write a reg field of size 0.");

Here as well.


    Andrew

---
pw-bot: cr

