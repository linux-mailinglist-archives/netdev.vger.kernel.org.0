Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDBCBD51DE
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 20:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729761AbfJLStl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 14:49:41 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33366 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728688AbfJLStk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 14:49:40 -0400
Received: by mail-pg1-f196.google.com with SMTP id i76so7690916pgc.0
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 11:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zAqOelK247hlqNTSOFbZ9NllexXJUbarTtqLjlWH6Fc=;
        b=CEOff1nUbZOxkJdQV0D5msWFY/4wjAzuAHY0mPNhT38BmqGt1nndT18imGeN9/0uz2
         fl9qcC0OyJaOZbHPw0C81KxIt1UHRD54bmAIm+mqJgxY+jyRGBqgDDi/uT1JzCpNHz+l
         N45+EIge0iNSWw+J+XdwahYOGPhlMRoVKUYfqCZjZ9vtAxNBotaNgh7O6iIU5KcCo8R+
         UCD3gW7a+qgxvtA0g+j3Mj7It75A0YuuRpYybGWa58e2Y8uBPhPm6Qh+SrXXCBw46FkK
         FC2L+QoQOBR6uQA6ZdL5KAPTVlnRzBaEstrMAA6urv1sGOiHZuANobtqYD2wBxX7l6G9
         t/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zAqOelK247hlqNTSOFbZ9NllexXJUbarTtqLjlWH6Fc=;
        b=gMuY5V5OLfv/WPNkNNZqofPw3oRs2oIiiyyYtHHaCradF/XjhHXfyWo8xml8Sbw55/
         tXcENdixueD/AiV/birA+4kR6EPV4v3xSYqsMwef/EwlTFJm8W5fGsSERQjneLAIP5kk
         Mqe3Vz5AqQrPyYhMXcPKB9yNZxCMmqMEXTpzy2FFvJ290MIYf8sh5jAySyUpQQgkcp0l
         LH5sxhn6ZZPw3VrQR/nIe0joH1c1qi6avvMhFCCclQGUFnPNdysIa3/dH74rGJ2SIpNz
         nr0lxm5nHZduBX3lspO8zRe9mbfsTOh91qCDWZGhR8f6xN1NdxdTC4ez26q+IXyqBEe4
         HBsA==
X-Gm-Message-State: APjAAAU66IEjUwqqHmFzx/ASR1R9wXsKUSsdxy7Ka6ltJa8yZoyYzsBP
        Ug+aJD6aEcxH7q6Y4WyH9yaxtB4S
X-Google-Smtp-Source: APXvYqyi4Tm/QXXw56QVNkFZEjgJfEfj1esOAO2Iaebfbnm8stHnxu2aG7dcLuDRm6j5NAl0aZZKeQ==
X-Received: by 2002:a63:4756:: with SMTP id w22mr11880939pgk.106.1570906178993;
        Sat, 12 Oct 2019 11:49:38 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id v43sm18134735pjb.1.2019.10.12.11.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 11:49:38 -0700 (PDT)
Date:   Sat, 12 Oct 2019 11:49:35 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: Re: [PATCH v2 net-next 01/12] net: aquantia: PTP skeleton
 declarations and callbacks
Message-ID: <20191012184935.GI3165@localhost>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
 <91d1e1181a01005ef04610241bffb9032f4669b8.1570531332.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91d1e1181a01005ef04610241bffb9032f4669b8.1570531332.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 10:56:36AM +0000, Igor Russkikh wrote:

> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
> new file mode 100644
> index 000000000000..d5a28904f708
> --- /dev/null
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
> @@ -0,0 +1,93 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Aquantia Corporation Network Driver
> + * Copyright (C) 2014-2019 Aquantia Corporation. All rights reserved
> + */
> +
> +/* File aq_ptp.c:
> + * Definition of functions for Linux PTP support.
> + */
> +
> +#include <linux/ptp_clock_kernel.h>
> +#include <linux/clocksource.h>
> +
> +#include "aq_nic.h"
> +#include "aq_ptp.h"
> +
> +struct aq_ptp_s {
> +	struct aq_nic_s *aq_nic;
> +

Nit: no blank line here.

> +	struct ptp_clock *ptp_clock;
> +	struct ptp_clock_info ptp_info;
> +};
> +
> +static struct ptp_clock_info aq_ptp_clock = {
> +	.owner		= THIS_MODULE,
> +	.name		= "atlantic ptp",
> +	.n_ext_ts	= 0,
> +	.pps		= 0,
> +	.n_per_out     = 0,
> +	.n_pins        = 0,
> +	.pin_config    = NULL,

Nit: use tabs to align columns (here some are spaces).

> +};
> +
> +int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec)
> +{
> +	struct hw_atl_utils_mbox mbox;
> +	struct ptp_clock *clock;
> +	struct aq_ptp_s *aq_ptp;
> +	int err = 0;
> +
> +	hw_atl_utils_mpi_read_stats(aq_nic->aq_hw, &mbox);
> +
> +	if (!(mbox.info.caps_ex & BIT(CAPS_EX_PHY_PTP_EN))) {
> +		aq_nic->aq_ptp = NULL;
> +		return 0;
> +	}
> +
> +	aq_ptp = kzalloc(sizeof(*aq_ptp), GFP_KERNEL);
> +	if (!aq_ptp) {
> +		err = -ENOMEM;
> +		goto err_exit;
> +	}
> +
> +	aq_ptp->aq_nic = aq_nic;
> +
> +	aq_ptp->ptp_info = aq_ptp_clock;
> +	clock = ptp_clock_register(&aq_ptp->ptp_info, &aq_nic->ndev->dev);
> +	if (!clock) {
> +		netdev_err(aq_nic->ndev, "ptp_clock_register failed\n");
> +		err = 0;
> +		goto err_exit;
> +	}

You need to test for PTR_ERR and NULL:

 * ptp_clock_register() - register a PTP hardware clock driver
 *
 * @info:   Structure describing the new clock.
 * @parent: Pointer to the parent device of the new clock.
 *
 * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
 * support is missing at the configuration level, this function
 * returns NULL, and drivers are expected to gracefully handle that
 * case separately.

> +	aq_ptp->ptp_clock = clock;
> +
> +	aq_nic->aq_ptp = aq_ptp;
> +
> +	return 0;
> +
> +err_exit:
> +	kfree(aq_ptp);
> +	aq_nic->aq_ptp = NULL;
> +	return err;
> +}

Thanks,
Richard
