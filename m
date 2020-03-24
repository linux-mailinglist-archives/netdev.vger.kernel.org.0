Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4BD190E5B
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgCXNHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:07:37 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36079 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbgCXNHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 09:07:37 -0400
Received: by mail-pg1-f193.google.com with SMTP id j29so2117052pgl.3;
        Tue, 24 Mar 2020 06:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sTwltg2N6YMOLJ87lW3KLzzpZfAMS4VGR4PUGWKJtjs=;
        b=Wb7Zbg7UGrRrgZFPdlYC1ch4BgkPYpVGF/M0Xt87ToqiueJqMJ69TOFRvg+bOpv870
         dCauePH0HhQTW0u0DGu9c5cOL2o3NF9EiyHn/oBzkIoM1lS5EXAVp4dMPtyrCHHeIu/9
         nIH6z2w74Td39D+aDrCF2oNk6P3O2U9FuV3fUqhx0lgcCMw7RUyjOtdUntbJLGR3xK/a
         7M3W3ihhnJ9/ZbiPb/Zj9p2fqAhLjATgwGuXtyX7vsaX4NH/xNkeJv+eg58O6Pwh2NG0
         W+Gz91NTdDOoBgMc0IPOzJtsnyPlpAs3Kd5bx44xK3EvvfnuvdLauYmX8yx8oIarO0d8
         TRoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sTwltg2N6YMOLJ87lW3KLzzpZfAMS4VGR4PUGWKJtjs=;
        b=XJWQNFnoeoyns3G3wkVlNeOtCVpHLzMzvBIPNl2D5yUg5xyZ8cVN1a0W734b1oo4Dj
         nA0WruJpdtRyqwpkCoj1plynHLAvj3You9+/qfI6xc99v7YN/I+CWFiqZPozwsipQHy4
         UlhbRibLoG8+IrwN+q+c4Z5PZMUaTs6Qz2mx9yMbEcYoi2fV6JN2RIkmkvXLehmijYjH
         GK0vaZ6Yk4+ly/kldD5QqRfaDjyQDUG9ho+c1ah3NLQ/wyzfi8D9Jrtv+kbchRDjmGhv
         DUQ0HtgDoWlnN//s8prbFdVkGScVeY9/dH1BIGeJEGiK83ilubmDZKGQS22/DBy42BCa
         vPwQ==
X-Gm-Message-State: ANhLgQ10VupJQIShjwPuAos6wFiaavzDIH5E+mNDp/UsS1pbNTk2eosj
        UlfIy7q9JYRBjFENy2q7XYE=
X-Google-Smtp-Source: ADFU+vv91w7BtZdoyOUeLQX9gDkdPoNU/CR9SW0F1k3K0pOU9dp3ovg/gTTmoxkf3QB5u7b+1o+H2A==
X-Received: by 2002:a63:9043:: with SMTP id a64mr27708163pge.308.1585055256115;
        Tue, 24 Mar 2020 06:07:36 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id x3sm15570734pfp.167.2020.03.24.06.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 06:07:35 -0700 (PDT)
Date:   Tue, 24 Mar 2020 06:07:33 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH 6/6] ptp_ocelot: support 4 programmable pins
Message-ID: <20200324130733.GA18149@localhost>
References: <20200320103726.32559-1-yangbo.lu@nxp.com>
 <20200320103726.32559-7-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320103726.32559-7-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 06:37:26PM +0800, Yangbo Lu wrote:
> +static int ocelot_ptp_enable(struct ptp_clock_info *ptp,
> +			     struct ptp_clock_request *rq, int on)
> +{
> +	struct ocelot *ocelot = container_of(ptp, struct ocelot, ptp_info);
> +	enum ocelot_ptp_pins ptp_pin;
> +	struct timespec64 ts;
> +	unsigned long flags;
> +	int pin = -1;
> +	u32 val;
> +	s64 ns;
> +
> +	switch (rq->type) {
> +	case PTP_CLK_REQ_PEROUT:
> +		/* Reject requests with unsupported flags */
> +		if (rq->perout.flags)
> +			return -EOPNOTSUPP;
> +
> +		/*
> +		 * TODO: support disabling function
> +		 * When ptp_disable_pinfunc() is to disable function,
> +		 * it has already held pincfg_mux.
> +		 * However ptp_find_pin() in .enable() called also needs
> +		 * to hold pincfg_mux.
> +		 * This causes dead lock. So, just return for function
> +		 * disabling, and this needs fix-up.

What dead lock?

When enable(PTP_CLK_REQ_PEROUT, on=0) is called, you don't need to
call ptp_disable_pinfunc().  Just stop the periodic waveform
generator.  The assignment of function to pin remains unchanged.

> +		 */
> +		if (!on)
> +			break;
> +
> +		pin = ptp_find_pin(ocelot->ptp_clock, PTP_PF_PEROUT,
> +				   rq->perout.index);
> +		if (pin == 0)
> +			ptp_pin = PTP_PIN_0;
> +		else if (pin == 1)
> +			ptp_pin = PTP_PIN_1;
> +		else if (pin == 2)
> +			ptp_pin = PTP_PIN_2;
> +		else if (pin == 3)
> +			ptp_pin = PTP_PIN_3;
> +		else
> +			return -EINVAL;

Return -EBUSY here instead.

Thanks,
Richard
