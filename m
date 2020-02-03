Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D43A150089
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 03:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgBCCOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 21:14:33 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36806 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgBCCOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 21:14:33 -0500
Received: by mail-pl1-f196.google.com with SMTP id a6so5214001plm.3;
        Sun, 02 Feb 2020 18:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MlSvnr7alRWcchcXEUNjydXzi0TvlR+UkqP05vumdnk=;
        b=uJdSikLpqA68ZLjCn6j2afQv/5XuLG5V9o7dalAZskZBLiXM+eUCHaP0+R2rNQSErm
         eZg1fjoW8Vok1Wy2HXh+KRq+f+SNb1TmGHOn1ghvDELdNWQYNtBPxm82LffZSOr6mLcE
         67DE6Mnck8/dvVQjVFBqlrHcFBN6nUE/zet9T58SFiwhDEAZ2tmy58eqaqeTEgHueuCJ
         4zXo4XooSE+09e0K6bx7/MiYKFouz0L50ZSN1Z1DPdvAaKMdXKlyNMDpE0ED7Wmiy2al
         2VJZBuIabXzM3ThhG0iGPYsxTAEnD2CEhOawy8QbhfDHEWimZThnsH/fRox0Q1TbAuIl
         8wdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MlSvnr7alRWcchcXEUNjydXzi0TvlR+UkqP05vumdnk=;
        b=IkAerlVOe3Q/b7ns//n9CcQ0Zw5Jk6Voz3AqDOlqHXYKNDpJJJTcTLf9qCPGb0knxB
         x3E7SFkctZ2M9Hf6nEuxLyz08ZVL5KY0K6YMshUJYI5GSiyNzyfp4sgOPwPkET3Ye961
         kzj90VLQt3cA1y9phss43CXvWME0FM5myt/ZF7JSil/Ak8IU4xPvW39MXnNKiZE/OF4j
         r4Lyv6Er7Marge8wawmR+8nb0U1CyyinW8Z7V2cuK9iKgiWKZSoCCMP4ScyronOPCbqJ
         OH5kC22Ks7BOtPrWEqkdy0xotJKP2Z6LK0QSH3ehqGeftz1qcTOwW1CUDXxLXTN4unfU
         7hmQ==
X-Gm-Message-State: APjAAAVoj2Ue7hfViAex+j5kRfI2ned5je4Tq6mcTOfL1SORl2u+RiNE
        ZhIlyNKCL/FFxM/9kSgO9Hg=
X-Google-Smtp-Source: APXvYqyRd4ugExzcI6oAdObJ297nZlP4Jw7YnILUQHEnmxCoxJSsPmezCUQ38MPkfbE9BGg5TtZVyw==
X-Received: by 2002:a17:90a:d205:: with SMTP id o5mr26932323pju.46.1580696072872;
        Sun, 02 Feb 2020 18:14:32 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id g21sm18831802pfb.126.2020.02.02.18.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Feb 2020 18:14:32 -0800 (PST)
Date:   Sun, 2 Feb 2020 18:14:29 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     christopher.s.hall@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        x86@kernel.org, jacob.e.keller@intel.com, davem@davemloft.net,
        sean.v.kelley@intel.com
Subject: Re: [Intel PMC TGPIO Driver 2/5] drivers/ptp: Add PEROUT2 ioctl
 frequency adjustment interface
Message-ID: <20200203021429.GB3516@localhost>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
 <20191211214852.26317-3-christopher.s.hall@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211214852.26317-3-christopher.s.hall@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 01:48:49PM -0800, christopher.s.hall@intel.com wrote:
> diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
> index 93cc4f1d444a..8223f6f656dd 100644
> --- a/include/linux/ptp_clock_kernel.h
> +++ b/include/linux/ptp_clock_kernel.h
> @@ -134,6 +134,8 @@ struct ptp_clock_info {
>  			  struct ptp_system_timestamp *sts);
>  	int (*getcrosststamp)(struct ptp_clock_info *ptp,
>  			      struct system_device_crosststamp *cts);
> +	int (*counttstamp)(struct ptp_clock_info *ptp,
> +			   struct ptp_event_count_tstamp *count);

KernelDoc missing.

As tglx said, it is hard to guess what this will be used for.  I would
appreciate a fuller explanation of the new callback in the commit log
message.

In general, please introduce a specific new API with an example of how
it is used.  In this series you have three new APIs,

   [Intel PMC TGPIO Driver 2/5] drivers/ptp: Add PEROUT2 ioctl frequency adjustment interface
   [Intel PMC TGPIO Driver 3/5] drivers/ptp: Add user-space input polling interface
   [Intel PMC TGPIO Driver 4/5] x86/tsc: Add TSC support functions to support ART driven Time-Aware GPIO

and then a largish driver using them all.

   [Intel PMC TGPIO Driver 5/5] drivers/ptp: Add PMC Time-Aware GPIO Driver

May I suggest an ordering more like:

[1/5] x86/tsc: Add TSC support functions to support ART...	(with forward explanation of the use case)
[2/5] drivers/ptp: Add PMC Time-Aware GPIO Driver		(without new bits)
[3/5] drivers/ptp: Add Enhanced handling of reserve fields	(okay as is)
[4/5] drivers/ptp: Add PEROUT2 ioctl frequency adjustment interface
[5/5] implement ^^^ in the driver
[6/5] drivers/ptp: Add user-space input polling interface
[7/5] implement ^^^ in the driver

> +/*
> + * Bits of the ptp_pin_desc.flags field:
> + */
> +#define PTP_PINDESC_EVTCNTVALID	(1<<0)

Is this somehow connected to ...

>  #define PTP_PEROUT_ONE_SHOT (1<<0)
> +#define PTP_PEROUT_FREQ_ADJ (1<<1)

... this?  If not, then they each deserve their own patch.

> @@ -164,10 +179,14 @@ struct ptp_pin_desc {
>  	 * PTP_EXTTS_REQUEST and PTP_PEROUT_REQUEST ioctls.
>  	 */
>  	unsigned int chan;
> +	/*
> +	 * Per pin capability flag
> +	 */
> +	unsigned int flags;

Please use 'capabilities' instead of 'flags'.

> +#define PTP_EVENT_COUNT_TSTAMP2 \
> +	_IOWR(PTP_CLK_MAGIC, 19, struct ptp_event_count_tstamp)

What is the connection between this, PTP_PINDESC_EVTCNTVALID, and
PTP_PEROUT_FREQ?

Thanks,
Richard
