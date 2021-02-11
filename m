Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF313174FC
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 01:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbhBKAGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 19:06:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33848 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232920AbhBKAGE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 19:06:04 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9zTx-005QiM-1r; Thu, 11 Feb 2021 01:05:17 +0100
Date:   Thu, 11 Feb 2021 01:05:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH v2 net-next 3/4] net: phy: Add Qualcomm QCA807x driver
Message-ID: <YCR0vdiph/l6qs04@lunn.ch>
References: <20210210125523.2146352-1-robert.marko@sartura.hr>
 <20210210125523.2146352-4-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210125523.2146352-4-robert.marko@sartura.hr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 01:55:22PM +0100, Robert Marko wrote:

Hi Robert

Could you move the GPIO driver into a patch of its own, and Cc: the
GPIO maintainer and list for that patch please.

     Andrew
