Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9774167CBA
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 12:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgBULvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 06:51:32 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45950 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728330AbgBULvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 06:51:31 -0500
Received: by mail-pf1-f193.google.com with SMTP id 2so1070586pfg.12;
        Fri, 21 Feb 2020 03:51:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WnHYv3vr0Vwr6SMzoPca2DWynWDX4pzqXsyYD0aAcdw=;
        b=tlMLwZAeuQrDyJX8AZNoeIo2YfboK9p4SE46ZRQpG4+pfzDSpdE1ISp8jEXZI4v5za
         4RyDc8e880iVMBjW49x5i6ae1xaMKsbZOAQSUoq/UIVQShyl6gPunQlONAITjCSwAyjs
         qwWkxxOpKOO0nc5lwsVJ0o2ZztkmBdUEVBvsuhJUpKmFtKLK34snMz1rUqk3ZX06/aZA
         Pqc+WHWyuWmWru3hH/VqGNUq/H6HjSg5CC9iMj6yE4/9QZDmmZuaOa0Hkiwcq3z6OSQf
         A9q6Z+ir2W2yZd4dt0i2MORgk+uMxDh8XFlqTqb1qYnNJI00HcrMXoxAheoD3tsXA/EK
         gW+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WnHYv3vr0Vwr6SMzoPca2DWynWDX4pzqXsyYD0aAcdw=;
        b=QKWSajq5QLrXRwhcJc1LR6kut6zTIglfuy8W9cp6GvafsTyqdMHuRCRHFcdq5rYmHg
         fskhUd1IBZwMYX/vMeC5Dw/NTD/g3ddmBomjW4B+9hzo8UmFu39k8DEKq84ibUn7wdw/
         ntD9KQ/YmVQbfmM7hTTlk6N7yLN6w4onh6E1GTd/87IsCJ2i2qONzlEBt2doh9KOwY6O
         +JJPnGGbiiy83rQgmxldTNtUZyckD0kBWYqToJBR0aJA5+7fneliy9uu14IG2pkTZlRt
         OqHhLte5E+RJw5HHFarbzDDNXdTVwfdwz/IILpFdKQ/GL8LMoBza/ofbmUnf6MwLNLQR
         PBYg==
X-Gm-Message-State: APjAAAUAyOzVFtzhqL844eEeeQQCWiAwNdaIW6TI6XkWmLgg3z49wYym
        dnkD0IiWw6rU2EM6fkjRbGaf0Ufw
X-Google-Smtp-Source: APXvYqzBmSYxsK4Bi3JUNs8UL8dCVaqVjKL77TmqJ5dRRRq9CNPBnKKjLJyvdlzQsGr09gwcowROyg==
X-Received: by 2002:a63:e50a:: with SMTP id r10mr27377086pgh.27.1582285890946;
        Fri, 21 Feb 2020 03:51:30 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 196sm2706469pfy.86.2020.02.21.03.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 03:51:30 -0800 (PST)
Date:   Fri, 21 Feb 2020 03:51:28 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     min.li.xe@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/2] ptp: Add a ptp clock driver for IDT
 82P33 SMU.
Message-ID: <20200221115128.GA1692@localhost>
References: <1582234109-6296-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582234109-6296-1-git-send-email-min.li.xe@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 04:28:29PM -0500, min.li.xe@renesas.com wrote:

> +module_param(phase_snap_threshold, uint, 0);
> +MODULE_PARM_DESC(phase_snap_threshold,
> +"threshold in nanosecond below which adjtime would ignore and do nothing");

If it is important not to snap small offsets, can't the driver
calculate the threshold itself?  It will be difficult for users to
guess this value.

> +/* static function declaration for ptp_clock_info*/
> +
> +static int idt82p33_enable(struct ptp_clock_info *ptp,
> +			   struct ptp_clock_request *rq, int on);
> +
> +static int idt82p33_adjfreq(struct ptp_clock_info *ptp, s32 ppb);
> +
> +static int idt82p33_settime(struct ptp_clock_info *ptp,
> +			    const struct timespec64 *ts);
> +
> +static int idt82p33_adjtime(struct ptp_clock_info *ptp, s64 delta_ns);
> +
> +static int idt82p33_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts);
> +
> +static void idt82p33_sync_tod_work_handler(struct work_struct *work);

As a matter of coding style, forward declarations are to be avoided in
network drivers.  You can avoid these by moving the functions,
idt82p33_channel_init() and idt82p33_caps_init() further down.

> +static void idt82p33_byte_array_to_timespec(struct timespec64 *ts,
> +static void idt82p33_timespec_to_byte_array(struct timespec64 const *ts,
> +static int idt82p33_xfer(struct idt82p33 *idt82p33,

These three are identical to the functions in ptp_clockmatrix.c.  Why
not introduce a common, shared source file to refactor this code?

> +static int idt82p33_page_offset(struct idt82p33 *idt82p33, unsigned char val)
> +static int idt82p33_rdwr(struct idt82p33 *idt82p33, unsigned int regaddr,
> +static int idt82p33_read(struct idt82p33 *idt82p33, unsigned int regaddr,
> +static int idt82p33_write(struct idt82p33 *idt82p33, unsigned int regaddr,

If I am not wrong, these are identical as well.

> +static int idt82p33_enable_channel(struct idt82p33 *idt82p33, u32 index)
> +{
> +	struct idt82p33_channel *channel;
> +	int err;
> +
> +	if (!(index < MAX_PHC_PLL))
> +		return -EINVAL;
> +
> +	channel = &idt82p33->channel[index];
> +
> +	err = idt82p33_channel_init(channel, index);
> +	if (err)
> +		return err;
> +
> +	channel->idt82p33 = idt82p33;
> +
> +	idt82p33_caps_init(&channel->caps);
> +	snprintf(channel->caps.name, sizeof(channel->caps.name),
> +		 "IDT 82P33 PLL%u", index);
> +	channel->caps.n_per_out = hweight8(channel->output_mask);
> +
> +	err = idt82p33_dpll_set_mode(channel, PLL_MODE_DCO);
> +	if (err)
> +		return err;
> +
> +	err = idt82p33_enable_tod(channel);
> +	if (err)
> +		return err;
> +
> +	channel->ptp_clock = ptp_clock_register(&channel->caps, NULL);
> +
> +	if (IS_ERR(channel->ptp_clock)) {
> +		err = PTR_ERR(channel->ptp_clock);
> +		channel->ptp_clock = NULL;
> +		return err;
> +	}

The function, ptp_clock_register(), can also return NULL.  Please
handle that case as well.

> +
> +	if (!channel->ptp_clock)
> +		return -ENOTSUPP;
> +
> +	dev_info(&idt82p33->client->dev, "PLL%d registered as ptp%d\n",
> +		 index, channel->ptp_clock->index);
> +
> +	return 0;
> +}


> +static int idt82p33_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
> +{

Please implement the .adjfine() method instead.  It offers better
resolution.

(The .adjfreq() method is deprecated.)

> +	struct idt82p33_channel *channel =
> +			container_of(ptp, struct idt82p33_channel, caps);
> +	struct idt82p33 *idt82p33 = channel->idt82p33;
> +	int err;
> +
> +	mutex_lock(&idt82p33->reg_lock);
> +	err = _idt82p33_adjfreq(channel, ppb);
> +	mutex_unlock(&idt82p33->reg_lock);
> +
> +	return err;
> +}

Thanks,
Richard
