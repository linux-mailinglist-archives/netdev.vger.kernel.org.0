Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D1031829E
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 01:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbhBKA0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 19:26:30 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33892 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229756AbhBKA01 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 19:26:27 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9znj-005Qv6-5v; Thu, 11 Feb 2021 01:25:43 +0100
Date:   Thu, 11 Feb 2021 01:25:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH v2 net-next 1/4] dt-bindings: net: Add QCA807x PHY
Message-ID: <YCR5h73bASurqt5A@lunn.ch>
References: <20210210125523.2146352-1-robert.marko@sartura.hr>
 <20210210125523.2146352-2-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210210125523.2146352-2-robert.marko@sartura.hr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 01:55:20PM +0100, Robert Marko wrote:
> Add DT bindings for Qualcomm QCA807x PHY series.
> 
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> Cc: Luka Perkov <luka.perkov@sartura.hr>
> ---
> Changes in v2:
> * Drop PSGMII/QSGMII TX driver defines
> 
>  include/dt-bindings/net/qcom-qca807x.h | 30 ++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>  create mode 100644 include/dt-bindings/net/qcom-qca807x.h
> 
> diff --git a/include/dt-bindings/net/qcom-qca807x.h b/include/dt-bindings/net/qcom-qca807x.h
> new file mode 100644
> index 000000000000..a5ac12777c2b
> --- /dev/null
> +++ b/include/dt-bindings/net/qcom-qca807x.h
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Device Tree constants for the Qualcomm QCA807X PHYs
> + */
> +
> +#ifndef _DT_BINDINGS_QCOM_QCA807X_H
> +#define _DT_BINDINGS_QCOM_QCA807X_H
> +
> +/* Full amplitude, full bias current */
> +#define QCA807X_CONTROL_DAC_FULL_VOLT_BIAS		0
> +/* Amplitude follow DSP (amplitude is adjusted based on cable length), half bias current */
> +#define QCA807X_CONTROL_DAC_DSP_VOLT_HALF_BIAS		1
> +/* Full amplitude, bias current follow DSP (bias current is adjusted based on cable length) */
> +#define QCA807X_CONTROL_DAC_FULL_VOLT_DSP_BIAS		2
> +/* Both amplitude and bias current follow DSP */
> +#define QCA807X_CONTROL_DAC_DSP_VOLT_BIAS		3
> +/* Full amplitude, half bias current */
> +#define QCA807X_CONTROL_DAC_FULL_VOLT_HALF_BIAS		4
> +/* Amplitude follow DSP setting; 1/4 bias current when cable<10m,
> + * otherwise half bias current
> + */
> +#define QCA807X_CONTROL_DAC_DSP_VOLT_QUARTER_BIAS	5
> +/* Full amplitude; same bias current setting with “010” and “011”,
> + * but half more bias is reduced when cable <10m
> + */
> +#define QCA807X_CONTROL_DAC_FULL_VOLT_HALF_BIAS_SHORT	6
> +/* Amplitude follow DSP; same bias current setting with “110”, default value */
> +#define QCA807X_CONTROL_DAC_DSP_VOLT_HALF_BIAS_SHORT	7

Are these really properties of the board? That is what device tree is
supposed to be about. These seem like configuration options. Which
suggests they should actually be a PHY tunable.

	 Andrew
