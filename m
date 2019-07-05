Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82E5260D99
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 00:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbfGEWC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 18:02:28 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36146 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbfGEWC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 18:02:28 -0400
Received: by mail-pf1-f194.google.com with SMTP id r7so4825699pfl.3;
        Fri, 05 Jul 2019 15:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JPGHjXzOzA8Mn6MfMz2VhzS4WY9ljzhFEFEy4KRIlT8=;
        b=Ke4j3oeXgqHum3eb0P6cxYRVE1ad4vvvnYm+USdf/WUVDhYzKvHDxYzsH2gzMGgqV+
         FyU0sMiNa4jw4lnh0sj8MPTAk9Zeyrgaaguok/pNaDzmbjgokD9rBEwpgOcrcZrh2mai
         dXPhWwUcqV4mhgL2GKjWea84NySL7GsjHxo16eR8baT0XfTPfN7SZUeixHA6CaV4b5Kb
         EdNgnFrfnPzckp3nPBXNcOjvh3WFBgGwXk7xsvqL/M/trpxIREcwqqyl6yjn6eZhrubQ
         z17w8xon13qQjrkZFWGYVurf94xOtEdgFNTeUlAyrASJ6I2MBhFjxsMcb0+NV86WKTMu
         cnuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JPGHjXzOzA8Mn6MfMz2VhzS4WY9ljzhFEFEy4KRIlT8=;
        b=ZcNUVHA4TSaFfBn8bDLIa1NqV6cOX20XPltXXGBaCNg0xVwYPnqktT3BgWHD8t27C/
         ZsRE+yAm0JVTFJhdKm588lfQ24ZwtLXk2Bs4H8MUhOJycohTbnUMyaOIR2z+IGzP4hWs
         l3yTyVgdf/VIwgZwNfSGRxoPMrSNIqHglejejTSbmJrQv5P2M4r85Q5RohtzZPN97Sr0
         cYYwPcoSmKCGrPIVAbhWcYEiXrvstEhA089YyIse+I4RJk+CGNKnHN1fpLsN01nGWjiY
         LM4i3X9F6rKk3ZrX3ZautcIuRahQ1BBNVWP14nQxVNZVoMpy3pkFKoqE1MM4QsFJbuMP
         qRqw==
X-Gm-Message-State: APjAAAXXhIhOf4X6RVZtAtcJBcr4keumZGsI0KxCDc7hG7lpqDfxqF9/
        MSJEdfuB/bCrhjepXQvuWtY=
X-Google-Smtp-Source: APXvYqxWvAhpl7XgddojsH+t04dPfeWuVJbEfkYpQ+kXcUT3LzX88oc4lQHDVjjufIPIhjoAL4SfHQ==
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr7898375pjb.138.1562364147638;
        Fri, 05 Jul 2019 15:02:27 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id 2sm9351917pff.174.2019.07.05.15.02.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Jul 2019 15:02:27 -0700 (PDT)
Date:   Fri, 5 Jul 2019 15:02:24 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, ralf@linux-mips.org,
        paul.burton@mips.com, jhogan@kernel.org, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: Re: [PATCH net-next v2 8/8] net: mscc: PTP Hardware Clock (PHC)
 support
Message-ID: <20190705220224.5i2uy4uxx5o4raaw@localhost>
References: <20190705195213.22041-1-antoine.tenart@bootlin.com>
 <20190705195213.22041-9-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705195213.22041-9-antoine.tenart@bootlin.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 05, 2019 at 09:52:13PM +0200, Antoine Tenart wrote:
> +static irqreturn_t ocelot_ptp_rdy_irq_handler(int irq, void *arg)
> +{
> +	struct ocelot *ocelot = arg;
> +
> +	do {

> +		/* Check if a timestamp can be retrieved */
> +		if (!(val & SYS_PTP_STATUS_PTP_MESS_VLD))
> +			break;

As in my reply on v1, I suggest adding a sanity check on this ISR's
infinite loop.

> +	} while (true);
> +
> +	return IRQ_HANDLED;
> +}

Thanks,
Richard
