Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F18B4966E7
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 18:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730487AbfHTQ5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 12:57:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45810 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbfHTQ5e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 12:57:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lPZlDP5gA+MWnoXz3gebdeb4kigYnFHrwvSUjg8QqGc=; b=nrExVr8U6g7kB0uJvGXk9qc6ZV
        4u8J9jg4KL6T3pCGe8Hu6R5Mv0ltF47KSPsyHckUcMF0DGY3zvnUR49JYsowEAqiyhO3vm69+qU9C
        XeYjhVg7qR+f5mO/aobZOgPnRDrb+Hqk2k0jLRIWsDAIQFeCzlZmYJBQ5T0Z9V7fRsM8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i07Rp-0007Jd-Jw; Tue, 20 Aug 2019 18:57:29 +0200
Date:   Tue, 20 Aug 2019 18:57:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Hubert Feurstein <h.feurstein@gmail.com>, mlichvar@redhat.com,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH spi for-5.4 0/5] Deterministic SPI latency with NXP DSPI
 driver
Message-ID: <20190820165729.GQ29991@lunn.ch>
References: <20190818182600.3047-1-olteanv@gmail.com>
 <CA+h21hr4UcoJK7upNJjG0ibtX7CkF=akxVdrb--1AJn6-z=sUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hr4UcoJK7upNJjG0ibtX7CkF=akxVdrb--1AJn6-z=sUQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> - Ethernet has support for hardware timestamping

True, but not all drivers support it.

Marvell switches are often combined with Marvell MACs. None of the
Marvell MAC drivers, mv643xx, mvneta, mvpp2 or octeontx2 support
hardware timestamping. My guess is, the hardware probably supports it,
but nobody has taken the time to writing the driver code. FEC does
have PTP support, but what does it look like in general? Are Marvell
drives the exception, or the norm?

What we have been talking about in this thread, adding timestamp calls
at various places, is simple, compared to adding driver code to a
number of MAC drivers. We can get a lot of 'bang for our buck' with
time stamps, it is easy to copy to other drivers, you don't need a
good knowledge of the hardware, datasheet, etc.

So if we can get this accepted, we should try to do it. You can always
come back later and add your full hardware solution.

   Andrew
