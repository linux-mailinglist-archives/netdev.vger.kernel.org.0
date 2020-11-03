Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8202F2A4C4E
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbgKCRHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:07:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:32954 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728046AbgKCRHd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 12:07:33 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kZzmI-0053nr-L0; Tue, 03 Nov 2020 18:07:26 +0100
Date:   Tue, 3 Nov 2020 18:07:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        robh@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/4] dt-bindings: net: Add Rx/Tx output
 configuration for 10base T1L
Message-ID: <20201103170726.GM1042051@lunn.ch>
References: <20201030172950.12767-1-dmurphy@ti.com>
 <20201030172950.12767-3-dmurphy@ti.com>
 <20201030195655.GD1042051@lunn.ch>
 <a50fe8f3-2ca1-8969-08ac-013704a5a617@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a50fe8f3-2ca1-8969-08ac-013704a5a617@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Do you have any issue with the property being in the ethernet-phy.yaml?

It seems generic enough. Increasing the voltage increases the power
requirements, and maybe not all boards are capable of that.

	Andrew
