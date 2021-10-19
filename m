Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A244335F2
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhJSMbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:31:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46496 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhJSMbW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 08:31:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4KPabGMaD3wPi9aIZhTTDGiCmqEZZ5KOQzX/xnMFK5c=; b=VhBMmqOHyvEmQuDl3D8SGZQPPM
        xFEqu3sRwnKlaXlypIFyzG7eMiNc7mf/R7H1crPxPT3+xkgRzZDm8Y9TZTShnxLDhChIp56acq1Xg
        ghzKcxNFng2fA/V4bjy06voGS4M6yyfDzg689NC8nnmS/s64dFXhIjClXmAVOKCIwkOg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcoEn-00B4gv-5L; Tue, 19 Oct 2021 14:29:01 +0200
Date:   Tue, 19 Oct 2021 14:29:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jie Luo <quic_luoj@quicinc.com>
Cc:     Luo Jie <luoj@codeaurora.org>, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org
Subject: Re: [PATCH v3 03/13] net: phy: at803x: improve the WOL feature
Message-ID: <YW66DXOIt8GrR2IQ@lunn.ch>
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-4-luoj@codeaurora.org>
 <YW2/wck2NPhgwjuL@lunn.ch>
 <0ba3022d-9879-bf85-251d-3f48b9cff93b@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ba3022d-9879-bf85-251d-3f48b9cff93b@quicinc.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> 
> when this register AT803X_INTR_STATUS bits are cleared after read, we can't
> clear only WOL interrupt here.

O.K. But you do have the value of the interrupt status register. So
you could call phy_trigger_machine(phydev) if there are any other
interrupt pending. They won't get lost that way.

	  Andrew
