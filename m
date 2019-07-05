Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1586160D69
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 23:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfGEV6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 17:58:47 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40149 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfGEV6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 17:58:47 -0400
Received: by mail-pl1-f193.google.com with SMTP id a93so5163087pla.7;
        Fri, 05 Jul 2019 14:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RawdHlmHGrqtF0TAtNn3rZDOX8J8ZLc09OxC8vLfhCI=;
        b=TbBw3AxOG7dgy2QZhRt7WIzMidEbf6oU/MAyOQ7/plG9wnkYJ/6DoIHVeXBF04IZDL
         5bNHoSwgs5T677/WIEvmxMOZTNvoZhpfc1Dn8XflRrc+LNOFlziw6/kXJRAkrw4nXmWX
         b0cAPQeP7BTtvjUBihlqIb2JkeELzYK29M7AuOHomKFpSTxMi/5Y12eKV/Wtz6GSawPC
         eRt3i5qIVUG2aPVZdJRqgca+j8ao4BwOp2ZH61n4kMzWMoMx1QHAHFw8EdbhNW8fOO5V
         2u9YFs4/Ey9nWmmM91BvF7mL1XhmmtkRlzlzTPGaa4LlRNzqPPuE29y7piahkkfESpVa
         4Z4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RawdHlmHGrqtF0TAtNn3rZDOX8J8ZLc09OxC8vLfhCI=;
        b=VdERc912UlnMrbUo/MGLliVh7NZkGA6QSHiNIJypP2Dd5D1EKo3b23mDPnmG+ZeIBe
         Q0HcOJ7q2QsPdSHe8EzrwHmLCRCjjul3ayiGyemcDAcC3oM7V0dmYA8W5xwVPNY619dJ
         AEjjWJmhsZqDBppnbbOQ/0VF0UaWq4t8Wfe8Pfxiyh25sSxOH81zajlj+mk/4YWFy8ss
         GFqW8guGH8EUHP3Z4KSqQKRkZUkDTO6rQf478WDsu9CKU9bF0ipWHbnpKuvFeWFjU8rY
         +/9h6W+jt3l07Az+Q4tSDN6N0N5dSLu9NWjM2cgy/2CIBUnu0DHvNxJnY5I6+yIoSKlE
         abnw==
X-Gm-Message-State: APjAAAUUxOapUXKzeSlmTVkyukxUo5wRw9aP8cknjyaDMGIU32+I5zvu
        /FAUDOE5Yo5fVuCH4yIQnOOmOSAa
X-Google-Smtp-Source: APXvYqxU6fZAaC3JnKZiY0nANxvDspFgu7iiedGqsbBKD3qFKWnEwswkzambum7r7vGWPys1D5kVpA==
X-Received: by 2002:a17:902:694a:: with SMTP id k10mr7947139plt.255.1562363926562;
        Fri, 05 Jul 2019 14:58:46 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id q144sm14737513pfc.103.2019.07.05.14.58.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Jul 2019 14:58:45 -0700 (PDT)
Date:   Fri, 5 Jul 2019 14:58:43 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, ralf@linux-mips.org,
        paul.burton@mips.com, jhogan@kernel.org, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: Re: [PATCH net-next 8/8] net: mscc: PTP Hardware Clock (PHC) support
Message-ID: <20190705215843.ncku546l3lktpwni@localhost>
References: <20190701100327.6425-1-antoine.tenart@bootlin.com>
 <20190701100327.6425-9-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701100327.6425-9-antoine.tenart@bootlin.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 12:03:27PM +0200, Antoine Tenart wrote:

> +static irqreturn_t ocelot_ptp_rdy_irq_handler(int irq, void *arg)
> +{
> +	struct ocelot *ocelot = arg;
> +
> +	do {
> +		struct skb_shared_hwtstamps shhwtstamps;
> +		struct list_head *pos, *tmp;
> +		struct ocelot_skb *entry;
> +		struct ocelot_port *port;
> +		struct timespec64 ts;
> +		struct sk_buff *skb = NULL;
> +		u32 val, id, txport;
> +
> +		val = ocelot_read(ocelot, SYS_PTP_STATUS);
> +
> +		/* Check if a timestamp can be retrieved */
> +		if (!(val & SYS_PTP_STATUS_PTP_MESS_VLD))
> +			break;

Instead of an infinite do/while loop, I suggest a for loop bounded by
number of iterations or by execution time.  That would avoid getting
stuck here forever.  After all, this code is an ISR.

Thanks,
Richard

> +		WARN_ON(val & SYS_PTP_STATUS_PTP_OVFL);
> +
> +		/* Retrieve the ts ID and Tx port */
> +		id = SYS_PTP_STATUS_PTP_MESS_ID_X(val);
> +		txport = SYS_PTP_STATUS_PTP_MESS_TXPORT_X(val);
> +
> +		/* Retrieve its associated skb */
> +		port = ocelot->ports[txport];
> +
> +		list_for_each_safe(pos, tmp, &port->skbs) {
> +			entry = list_entry(pos, struct ocelot_skb, head);
> +			if (entry->id != id)
> +				continue;
> +
> +			skb = entry->skb;
> +
> +			list_del(pos);
> +			kfree(entry);
> +		}
> +
> +		/* Next ts */
> +		ocelot_write(ocelot, SYS_PTP_NXT_PTP_NXT, SYS_PTP_NXT);
> +
> +		if (unlikely(!skb))
> +			continue;
> +
> +		/* Get the h/w timestamp */
> +		ocelot_get_hwtimestamp(ocelot, &ts);
> +
> +		/* Set the timestamp into the skb */
> +		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
> +		shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
> +		skb_tstamp_tx(skb, &shhwtstamps);
> +
> +		dev_kfree_skb_any(skb);
> +	} while (true);
> +
> +	return IRQ_HANDLED;
> +}
