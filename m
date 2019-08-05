Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20F6481FF7
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 17:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbfHEPTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 11:19:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34400 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728801AbfHEPTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 11:19:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=X0Omz7wEn8g6XyOTfvnwde5UwQVppDYfudC2QbH8ejc=; b=XaFmMJNqhOirvXm88Hyt1j9N4l
        aF3CNbG3kQoDjq7L2AeLC1RK0xi8Ay9RjYISZAoKIFGSyYMbYr8jkqZ7DTZBzxWU9l/N6WAN6fspB
        6Ddrt8nSP8eezDJ8IeJBbRdGqvi3T0l6nf66WcpASwM5zxBX5kLclBgPK3NdBkNvJeFw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1huelR-0007qg-JH; Mon, 05 Aug 2019 17:19:09 +0200
Date:   Mon, 5 Aug 2019 17:19:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH 12/16] net: phy: adin: read EEE setting from device-tree
Message-ID: <20190805151909.GR24275@lunn.ch>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-13-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805165453.3989-13-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 07:54:49PM +0300, Alexandru Ardelean wrote:
> By default, EEE is not advertised on system init. This change allows the
> user to specify a device property to enable EEE advertisements when the PHY
> initializes.
 
This patch is not required. If EEE is not being advertised when it
should, it means there is a MAC driver bug.

	Andrew
