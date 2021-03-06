Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B7A32FB3D
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 15:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhCFOsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 09:48:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43384 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230439AbhCFOsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Mar 2021 09:48:16 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lIYDz-009X8t-KM; Sat, 06 Mar 2021 15:48:11 +0100
Date:   Sat, 6 Mar 2021 15:48:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, saeedm@nvidia.com,
        andrew.gospodarek@broadcom.com, jacob.e.keller@intel.com,
        guglielmo.morandin@broadcom.com, eugenem@fb.com,
        eranbe@mellanox.com
Subject: Re: [RFC] devlink: health: add remediation type
Message-ID: <YEOWK7HtiRz09XZm@lunn.ch>
References: <20210306024220.251721-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210306024220.251721-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+/**
> + * enum devlink_health_reporter_remedy - severity of remediation procedure
> + * @DLH_REMEDY_NONE: transient error, no remediation required
> + * @DLH_REMEDY_COMP_RESET: associated device component (e.g. device queue)
> + *			will be reset
> + * @DLH_REMEDY_RESET: full device reset, will result in temporary unavailability
> + *			of the device, device configuration should not be lost
> + * @DLH_REMEDY_REINIT: device will be reinitialized and configuration lost
> + * @DLH_REMEDY_POWER_CYCLE: device requires a power cycle to recover
> + * @DLH_REMEDY_REIMAGE: device needs to be reflashed
> + * @DLH_REMEDY_BAD_PART: indication of failing hardware, device needs to be
> + *			replaced
> + *
> + * Used in %DEVLINK_ATTR_HEALTH_REPORTER_REMEDY, categorizes the health reporter
> + * by the severity of the required remediation, and indicates the remediation
> + * type to the user if it can't be applied automatically (e.g. "reimage").
> + */
> +enum devlink_health_reporter_remedy {
> +	DLH_REMEDY_NONE = 1,
> +	DLH_REMEDY_COMP_RESET,
> +	DLH_REMEDY_RESET,
> +	DLH_REMEDY_REINIT,
> +	DLH_REMEDY_POWER_CYCLE,
> +	DLH_REMEDY_REIMAGE,
> +	DLH_REMEDY_BAD_PART,
> +};

Hi Jakub

Are there any cases where the host is the problem, not the device? The
host driver needs to be unloaded and reloaded? The host needs a
reboot?

	Andrew
