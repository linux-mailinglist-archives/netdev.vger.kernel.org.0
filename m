Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C419551E0A
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 00:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfFXWP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 18:15:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55338 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbfFXWP6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 18:15:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HKfIgzi+9Iy7ZgzS5BLDPp4IacOM2N7OgAWeS03VyZI=; b=IQLfVrGcJM3TSXNBM8dGF1Ayl2
        qt04VGSfk0zFIKyHrlDGymQTaj6hjxi7GxzGHNGpeyeShn3pYec2PIXEgHtI/6eGP64YEUyIyIRME
        2OnXl1QKbG0M+O7nhTZu8u47Ih7Ji+d2qNljiZqzUyZI2rN/cIC/2U9JsidjS1Bw3xro=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hfXFi-00010K-Be; Tue, 25 Jun 2019 00:15:54 +0200
Date:   Tue, 25 Jun 2019 00:15:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/8] net: aquantia: add documentation for the
 atlantic driver
Message-ID: <20190624221554.GE31306@lunn.ch>
References: <cover.1561388549.git.igor.russkikh@aquantia.com>
 <438b6899b5c2d82474a0dcee543b2ae6c4ee7b1f.1561388549.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <438b6899b5c2d82474a0dcee543b2ae6c4ee7b1f.1561388549.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 03:10:47PM +0000, Igor Russkikh wrote:
> Document contains configuration options description,
> details and examples of driver various settings.
> 
> Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
> ---
>  .../device_drivers/aquantia/atlantic.txt      | 437 ++++++++++++++++++
>  1 file changed, 437 insertions(+)
>  create mode 100644 Documentation/networking/device_drivers/aquantia/atlantic.txt
> 
> diff --git a/Documentation/networking/device_drivers/aquantia/atlantic.txt b/Documentation/networking/device_drivers/aquantia/atlantic.txt
> new file mode 100644
> index 000000000000..45b93f8143b4
> --- /dev/null
> +++ b/Documentation/networking/device_drivers/aquantia/atlantic.txt
> @@ -0,0 +1,437 @@
> +aQuantia AQtion Driver for the aQuantia Multi-Gigabit PCI Express Family of
> +Ethernet Adapters
> +=============================================================================
> +
> +Contents
> +========
> +
> +- Important Note
> +- Identifying Your Adapter
> +- Command Line Parameters
> +- Additional Configurations
> +- Support

Hi Igor

This TOC is now out of date. You don't have an Important Note section,
Command line parameters are near the end etc.

> +
> +Identifying Your Adapter
> +========================
> +
> +The driver in this release is compatible with AQC-100, AQC-107, AQC-108 based ethernet adapters.
> +
> +
> +SFP+ Devices (for AQC-100 based adapters)
> +----------------------------------
> +
> +This release tested with passive Direct Attach Cables (DAC) and SFP+/LC Optical Transceiver.
> +
> +Config file parameters
> +=======================
> +For some fine tuning and performance optimizations,
> +some parameters can be changed in the {source_dir}/aq_cfg.h file.

To me, these seems like the least likely option, so should come last
for those who are very desperate. Start with ethtool, then command
line parameters, and if all else fails, hack the code to change
settings.

	    Andrew
