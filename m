Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13294155CD8
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 18:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbgBGR2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 12:28:51 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38454 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbgBGR2v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Feb 2020 12:28:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UEBTS0XrdoJSJQl95vSpuczU7JlSfYzUjvPMMXXJ5c4=; b=nZPxdgD/cUEFic5JI75m8v0Xr7
        CzOliGBTSnBDBIgGpIokFggKL4yrT8Bccvx0sDAVG0BcwajXoK9KPtsWyzptxfB3FBdxfIx8Ofc6/
        75s/hj9xZVa9oGxqU0yOIiT/04ftNIyXOmS9EE6zR/V1CQgvKi6M/zCYiY5bqEtEPJas=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j07Qq-0004lY-If; Fri, 07 Feb 2020 18:28:44 +0100
Date:   Fri, 7 Feb 2020 18:28:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     christopher.s.hall@intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        jacob.e.keller@intel.com,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, sean.v.kelley@intel.com
Subject: Re: [Intel PMC TGPIO Driver 5/5] drivers/ptp: Add PMC Time-Aware
 GPIO Driver
Message-ID: <20200207172844.GC19213@lunn.ch>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
 <20191211214852.26317-6-christopher.s.hall@intel.com>
 <CACRpkdbi7q5Vr2Lt12eirs3Z8GLL2AuLLrAARCHkYEYgKbYkHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbi7q5Vr2Lt12eirs3Z8GLL2AuLLrAARCHkYEYgKbYkHg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 07, 2020 at 06:10:46PM +0100, Linus Walleij wrote:
> OK this looks like some GPIO registers...
> 
> Then there is a bunch of PTP stuff I don't understand I suppose
> related to the precision time protocol.

Hi Linus

I understand your confusion. The first time this was posted to netdev,
i asked it to be renamed because it has very little to do with GPIO

https://lore.kernel.org/netdev/20190719132021.GC24930@lunn.ch/

	Andrew
