Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 508EEE7978
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfJ1T5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:57:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38956 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfJ1T5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 15:57:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=U8MlV+u9EHu4/f01PhfC67QG1AgicdnCjdNkTx/kGVE=; b=zAYacyTuqZMgQdTwqMGLKB2Brp
        MQ2VYJpjs3u8ED7HvIG3mW3EX6zhj+flrm4EYduy4XNyfzYFuGvC+KQlPXjvn2wETHVwqiIa0a5Rt
        CsdVA8xNXV8RsQrxv7/09kNuOo0xCONGFk5tZ3TQTgnT1d9tMC+133p3NdeHg+nJGt44=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iPB98-0008JF-JY; Mon, 28 Oct 2019 20:57:46 +0100
Date:   Mon, 28 Oct 2019 20:57:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>
Subject: Re: [PATCH net-next 2/4] net: phy: marvell: fix downshift function
 naming
Message-ID: <20191028195746.GG17625@lunn.ch>
References: <4ae7d05a-4d1d-024f-ebdf-c92798f1a770@gmail.com>
 <2cf44878-02e5-3f0f-6eec-cc9d51a18127@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cf44878-02e5-3f0f-6eec-cc9d51a18127@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 28, 2019 at 08:52:55PM +0100, Heiner Kallweit wrote:
> I got access to the M88E1111 datasheet, and this PHY version uses
> another register for downshift configuration. Therefore change prefix
> to m88e1011, aligned with constants like MII_M1011_PHY_SCR.
> 
> Fixes: a3bdfce7bf9c ("net: phy: marvell: support downshift as PHY tunable")
> Reported-by: Chris Healy <Chris.Healy@zii.aero>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
