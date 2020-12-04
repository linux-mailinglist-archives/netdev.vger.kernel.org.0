Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE472CE4A3
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 01:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgLDA5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 19:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgLDA5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 19:57:14 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEB9C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 16:56:28 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id l23so2176530pjg.1
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 16:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DB7PizKs3qTj51m7Z+CghMsxmHB0NC3bOPAXDwBhCRA=;
        b=TTsajPDdd1Z3NJZQ6hgcCkUVDSud7Cp0Bv1LsU0zFmzXuEq8CROxE2ua7SGm2IXb9M
         AERftci/3X8A74fZsj+iBl78MpGofteheEPJX9JEXjCXlgl6peh3Lls4R7AKTvMwyfTO
         eo2pRNj3Gj4n9UjQBg2B8gg5v1tjv4XgOS2qVUuhGBSclxY7XUeSoHMgtrSBdLDYrSLj
         OMltNZudmWX5A31dBqaP2MU7Uvx2RfgOv+z40Qbeenrt1vgrstdVFvvvf/VC/DUbFI/S
         fwIBbKnTwcMPJ+QiEMvVN3OFIjyPjqQ+TGoLuV5onswKKxRtS3dQ85ITkyqP48jZ36B9
         a+bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DB7PizKs3qTj51m7Z+CghMsxmHB0NC3bOPAXDwBhCRA=;
        b=PLglzk0Uoo/uxrm1Z+qp8ekBtRa9iXXwgrCFBPv5kXVgPtN8ys2yb7w44Z3sbdS83l
         SDzq10kHMQVmqGkOIHrk8il8r8H2BMvUkCaUpdyoYJuMV4aCFu+0MekraLesh2szcitn
         5TBwJMgJO8c0Bnfd9RUwuXmrCZYP6Q0LrARRTnHkzAXC6rt3CiieRYK7eYoqi7I+kMZ+
         sXouv52qNSAg0DOZ8RubI31WAMCyn8wRAcP1YaBDtEiWyWEH4QtQ7F8uoKoURYTAkfcM
         Rsqc7CACfn7/rid6OPgaPJPC+RCZkb10nclZdbFlHNiaK4PZeaiS96Cjjc38OzS528Pz
         KsLA==
X-Gm-Message-State: AOAM531eCmSZuff+7Q5yUQVizCJPaaJLY2KUETRR3vi8O2ftoZWCFlc9
        +2wyZwL8IxAjTGgTB7sD0+E=
X-Google-Smtp-Source: ABdhPJxDNBfmEk4pXHgb8dUtW0S/B5W1hvNN8njPmaF34iQQ1hHxLwqxpjVDul3Wp/Cfu9JI7a5TEg==
X-Received: by 2002:a17:902:bf44:b029:da:d0ee:cef with SMTP id u4-20020a170902bf44b02900dad0ee0cefmr1151131pls.12.1607043387762;
        Thu, 03 Dec 2020 16:56:27 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id d3sm441451pji.26.2020.12.03.16.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 16:56:27 -0800 (PST)
Date:   Thu, 3 Dec 2020 16:56:24 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 net-next] ptp: Add clock driver for the OpenCompute
 TimeCard.
Message-ID: <20201204005624.GC18560@hoboy.vegasvil.org>
References: <20201203182925.4059875-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203182925.4059875-1-jonathan.lemon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 10:29:25AM -0800, Jonathan Lemon wrote:
> The OpenCompute time card is an atomic clock along with
> a GPS receiver that provides a Grandmaster clock source
> for a PTP enabled network.
> 
> More information is available at http://www.timingcard.com/
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

What changed in v2?

(please include a change log for future patches)

> +static int
> +ptp_ocp_gettimex(struct ptp_clock_info *ptp_info, struct timespec64 *ts,
> +		 struct ptp_system_timestamp *sts)
> +{

The name here is a bit confusing since "timex" has a special meaning
in the NTP/PTP API.

Suggest plain old ptp_ocp_gettime();

> +	struct ptp_ocp *bp = container_of(ptp_info, struct ptp_ocp, ptp_info);
> +	unsigned long flags;
> +	int err;
> +
> +	spin_lock_irqsave(&bp->lock, flags);
> +	err = __ptp_ocp_gettime_locked(bp, ts, sts);
> +	spin_unlock_irqrestore(&bp->lock, flags);
> +
> +	return err;
> +}
> +
> +static void
> +__ptp_ocp_settime_locked(struct ptp_ocp *bp, const struct timespec64 *ts)
> +{
> +	u32 ctrl, time_sec, time_ns;
> +	u32 select;
> +
> +	time_ns = ts->tv_nsec;
> +	time_sec = ts->tv_sec;
> +
> +	select = ioread32(&bp->reg->select);
> +	iowrite32(OCP_SELECT_CLK_REG, &bp->reg->select);
> +
> +	iowrite32(time_ns, &bp->reg->adjust_ns);
> +	iowrite32(time_sec, &bp->reg->adjust_sec);
> +
> +	ctrl = ioread32(&bp->reg->ctrl);
> +	ctrl |= OCP_CTRL_ADJUST_TIME;
> +	iowrite32(ctrl, &bp->reg->ctrl);
> +
> +	/* restore clock selection */
> +	iowrite32(select >> 16, &bp->reg->select);
> +}
> +
> +static int
> +ptp_ocp_settime(struct ptp_clock_info *ptp_info, const struct timespec64 *ts)
> +{
> +	struct ptp_ocp *bp = container_of(ptp_info, struct ptp_ocp, ptp_info);
> +	unsigned long flags;
> +
> +	if (ioread32(&bp->reg->status) & OCP_STATUS_IN_SYNC)
> +		return 0;
> +
> +	dev_info(&bp->pdev->dev, "settime to: %lld.%ld\n",
> +		 ts->tv_sec, ts->tv_nsec);

No need for this dmesg spam.   Change to _debug if you really want to
keep it.

> +	spin_lock_irqsave(&bp->lock, flags);
> +	__ptp_ocp_settime_locked(bp, ts);
> +	spin_unlock_irqrestore(&bp->lock, flags);
> +
> +	return 0;
> +}

> +static int
> +ptp_ocp_null_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
> +{
> +	struct ptp_ocp *bp = container_of(ptp_info, struct ptp_ocp, ptp_info);
> +
> +	if (scaled_ppm == 0)
> +		return 0;
> +
> +	dev_info(&bp->pdev->dev, "adjfine, scaled by: %ld\n", scaled_ppm);

No need for this either.

> +	return -EOPNOTSUPP;

You can set the offset but not the frequency adjustment.  Makes sense
for an atomic clock.

> +}

This driver looks fine, but I'm curious how you will use it.  Can it
provide time stamping for network frames or other IO?

If not, then that seems unfortunate.  Still you can regulate the Linux
system clock in software, but that of course introduces time error.

Thanks,
Richard
