Return-Path: <netdev+bounces-1162-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 884166FC635
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:24:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52659281206
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4313182BE;
	Tue,  9 May 2023 12:24:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CE8DDB7
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 12:24:46 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E09C19A9
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 05:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=OnEdAnCYlQoFZyQ4+L/hcmZe2LkZfR4S/2ju7kjndkE=; b=WThj0kO8GRHf2vk1Z0itbjSVnN
	QQmtIhCr9ENruq9E87GHcldNSAhXF6emOjJxkLHcThPNUzaSk6YqzcL0RfTeC+MCLKTpL+AC7QoUf
	DCXXf2lKccr4Bk+ZLYpGo1V6I+7GzRENlkGZbqqkNxvJxdoTHOGScUb46s6eGzOtNDAQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pwMOO-00CIZj-Rg; Tue, 09 May 2023 14:24:32 +0200
Date: Tue, 9 May 2023 14:24:32 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
	Voon Weifeng <weifeng.voon@intel.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: pcs: xpcs: fix incorrect number of interfaces
Message-ID: <74082216-205e-4bcb-8613-2b8c23c06911@lunn.ch>
References: <E1pwLr2-001Ms2-3d@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pwLr2-001Ms2-3d@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 12:50:04PM +0100, Russell King (Oracle) wrote:
> In synopsys_xpcs_compat[], the DW_XPCS_2500BASEX entry was setting
> the number of interfaces using the xpcs_2500basex_features array
> rather than xpcs_2500basex_interfaces. This causes us to overflow
> the array of interfaces. Fix this.
> 
> Fixes: f27abde3042a ("net: pcs: add 2500BASEX support for Intel mGbE controller")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

