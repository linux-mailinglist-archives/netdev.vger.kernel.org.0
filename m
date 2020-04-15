Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954FD1AB46F
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 01:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389989AbgDOXvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 19:51:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40536 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389935AbgDOXvo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 19:51:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7Zcs90M+OFK9KaugCflcZNqAOXkYGYgCjgQdJ2e+gEc=; b=TwqZfeT/RfcbheeHUgBMtv6qdP
        LkJT7fw9bWjHmWr7VOzqUZoq1Wer3UY1wD6mBDSJ0BiN3mpK9+ZLww3WmdIkv6t/FiJHCogOWzt3V
        F5/kD5s4cobHdb1Rv+UHqKS1bwQs8150GfjolvAeg5FUrRCm3zzYz7JmLV9qdYzRL3Vo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jOroh-002yT8-Hj; Thu, 16 Apr 2020 01:51:39 +0200
Date:   Thu, 16 Apr 2020 01:51:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org,
        Christian Lamparter <chunkeey@gmail.com>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH v3 3/3] ARM: dts: qcom: ipq4019: add MDIO node
Message-ID: <20200415235139.GJ611399@lunn.ch>
References: <20200415150244.2737206-1-robert.marko@sartura.hr>
 <20200415150244.2737206-3-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415150244.2737206-3-robert.marko@sartura.hr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 05:02:48PM +0200, Robert Marko wrote:
> This patch adds the necessary MDIO interface node
> to the Qualcomm IPQ4019 DTSI.
> 
> Built-in QCA8337N switch is managed using it,
> and since we have a driver for it lets add it.
> 
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> Cc: Luka Perkov <luka.perkov@sartura.hr>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
