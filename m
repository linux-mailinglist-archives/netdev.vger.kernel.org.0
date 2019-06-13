Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D72446CD
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393049AbfFMQyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:54:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730045AbfFMCf3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 22:35:29 -0400
Received: from dragon (li1322-146.members.linode.com [45.79.223.146])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC58420B7C;
        Thu, 13 Jun 2019 02:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560393329;
        bh=vPst04mhCl3KIJo/LpaMenWyVwtqXqolMhGHFBGokHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h3dX+Ct9uOVCm6ikypOSf56jJ0R6OqUWb3PzVg+C5Z5emu7tcZLbFmLlrPknQhoDS
         xSzdLAw8clUVDiesy1W6VFdoWHLhVM8+gOtoFzyFNJRBOGE88NWgqwNJMI5XYp12TS
         WpIbalQ91kg3+LqIFJV2Wq/PjiGHbfsTncngghCE=
Date:   Thu, 13 Jun 2019 10:34:53 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     leoyang.li@nxp.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4] ARM: dts: Introduce the NXP LS1021A-TSN board
Message-ID: <20190613023452.GF20747@dragon>
References: <20190606222817.14223-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606222817.14223-1-olteanv@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 07, 2019 at 01:28:17AM +0300, Vladimir Oltean wrote:
> The LS1021A-TSN is a development board built by VVDN/Argonboards in
> partnership with NXP.
> 
> It features the LS1021A SoC and the first-generation SJA1105T Ethernet
> switch for prototyping implementations of a subset of IEEE 802.1 TSN
> standards.
> 
> It has two regular Ethernet ports and four switched, TSN-capable ports.
> 
> It also features:
> - One Arduino header
> - One expansion header
> - Two USB 3.0 ports
> - One mini PCIe slot
> - One SATA interface
> - Accelerometer, gyroscope, temperature sensors
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied, thanks.
