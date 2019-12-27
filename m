Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08B9812B580
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 16:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfL0PMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 10:12:34 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39359 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfL0PMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 10:12:34 -0500
Received: by mail-pf1-f193.google.com with SMTP id q10so14859617pfs.6
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 07:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kJuS7Ky41VzVE0Zb7pmqs3jq/+kEH2lbY7CjT1+LT7k=;
        b=hKZK/duv/czowF2sOP5O64cbU3fIX9NYzeC17R9nTtLb8ynZRJWjiMODts6KgsZR9C
         LjFELmNzFlZTB589FamuDAdSN45bfzr8F9Rm7//ntkc9fu7mHvjYuo9q5qTUxgVIRpJw
         ShElqYUmy5He9VZyP3vj+J/KXn0iUWLVj9gtygFzOjWVarjoCKCzQOaYAr/MgFPRB0Eb
         Ru3SG/ylJvr9wuxjCx3O4+kljQ44COEBWx7ZsMqCC0lwI36YAB8wIMEQ57jY6BWo2Wdh
         4VRM9zA4lMXULoNvEZV+WlLZEcD1x7eEj8d2IV/VrzLqk5XnjRp58jq0QuJmBIAKaQjD
         lnzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kJuS7Ky41VzVE0Zb7pmqs3jq/+kEH2lbY7CjT1+LT7k=;
        b=UoagGmxlZ0DcXd2sMoZXOl0/TDgGib20qcYt18d71hKMLLroFmiUafUkF769LPlP0N
         gw7WYiWc+8A6jjrc8UP9CJ1nUGMPjjIwSTWP4aoexKEuuI1woZ2iGnNzSobbGy+z43md
         JJA2is+KTl6iKxEbwlY5QPeAVJ1OSl0yGTScH6Pf9Oma/bg/SDVH+jsfmR8brl5eQZkU
         HRPuU/V4PK8QdIr/ulSJRHGnA5RVyZgH0Rgp8YkY9RI8zLxzFwipJnuZZws82Md7+jlr
         8Od9+StO9Jy5fm0n4bvbiKtwljXqpEZX3Yw3d6/DVYBv3EgBbK02IEnKSULgp1mr+MBY
         fKeA==
X-Gm-Message-State: APjAAAX14frA2Cdstx9d26Cd1v7GBZIhFLsV5A0uPF5MZQ/YnQdoYBec
        rPyvv0gggDX3XlPBlrRx65o=
X-Google-Smtp-Source: APXvYqzaBVkbQpCCquGOQf3prHqG1C/jOQDFYu7j4zkxpgVMuMhTdB+0/4fAp2a7wjYHsYYylvz3Wg==
X-Received: by 2002:a63:4a1c:: with SMTP id x28mr51431417pga.7.1577459553704;
        Fri, 27 Dec 2019 07:12:33 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id 13sm40281257pfi.78.2019.12.27.07.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 07:12:32 -0800 (PST)
Date:   Fri, 27 Dec 2019 07:12:30 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH] net: mscc: ocelot: support PPS signal generation
Message-ID: <20191227151230.GB1435@localhost>
References: <20191226095851.24325-1-yangbo.lu@nxp.com>
 <CA+h21hojJ=UU2i1kucYoD4G9VQgpz1XytSOp_MT9pjRYFnkc4A@mail.gmail.com>
 <AM7PR04MB68858970C5BA46FE33C01F48F82B0@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <20191227020820.GA6970@localhost>
 <AM7PR04MB68858E4814EB85A8860FA48FF82A0@AM7PR04MB6885.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM7PR04MB68858E4814EB85A8860FA48FF82A0@AM7PR04MB6885.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 27, 2019 at 03:51:08AM +0000, Y.b. Lu wrote:
> I'm a little confused.
> It seems PTP_CLK_REQ_PEROUT method needs req.perout.start and req.perout.period to generate periodical *clock* signal, while PPS is *pulse* signal every second.
> For the two cases (1Hz clock signal and 1 pulse very second), how to configure with PTP_CLK_REQ_PEROUT method?

If your HW can generate other periods, then implement them!

If your HW can only do exactly one pps, then you can check that the
nanoseconds fields are zero, returning -ERANGE when they are non-zero.

> For some hardware, each pin has fixed function. And some hardware, each pin could be programable for function.
> The Ocelot PTP pin is programable, but initially the software author may plan to set fixed function for each pin.
> Do you suggest we make all pins function programable?

Yes.  You should implement the ptp_clock_info.verify method:

 * @verify:   Confirm that a pin can perform a given function. The PTP
 *            Hardware Clock subsystem maintains the 'pin_config'
 *            array on behalf of the drivers, but the PHC subsystem
 *            assumes that every pin can perform every function. This
 *            hook gives drivers a way of telling the core about
 *            limitations on specific pins. This function must return
 *            zero if the function can be assigned to this pin, and
 *            nonzero otherwise.

If the pin cannot be changed on a particular SoC, then the .verify
should simply make sure user space chose the correct setting.

> BTW, current ptp clock code is embedded in ocelot.c.
> More and more functions will be added in the future, and the interrupt implementation in SoC is different between Ocelot and VSC9959.
> Do you think it's proper to separate common code as a single PTP driver?

If you get a lot of code re-use, then sure.

Thanks,
Richard
