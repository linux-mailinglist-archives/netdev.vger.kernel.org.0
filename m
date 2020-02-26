Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5349816F5C7
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 03:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbgBZCrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 21:47:11 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32996 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728989AbgBZCrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 21:47:11 -0500
Received: by mail-pg1-f193.google.com with SMTP id 6so551358pgk.0;
        Tue, 25 Feb 2020 18:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1Y1UZOFfTZ0N6C6Za7AR6jiLifnSzYiC7Rf6ZLlfNiw=;
        b=P42MrSbUt/jDRdsuYTv73WxSBQYHL2ixhS9t3NbKGd9SNMfPqqbEfc8/ME9OkMgfdy
         UxJQ2v//q3H1K9dDHdH/s0rmT2NorypFnBFmO/S1opc7MQSbVfW5A0dOjZIV6kMvT7uP
         Kn47dTNifgZMlU2/BSTpjqfJgnP07NjdYPlS6Cm8Lj3vDSoERQSq+7P7OGgqKcNIc2gN
         XxOCv1xsrSlmosu2wNYEUk1Hx/i5vAHgViV8ZB8zlBwZdaQRXuTJjmfJ3coEWzo+LSGc
         x7etNWvB6gXGWXw21vWq/kmp6WONGtzPvkJWXBNYmBSelX5il7YJHlaZClzFl7hZ6jBD
         20jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1Y1UZOFfTZ0N6C6Za7AR6jiLifnSzYiC7Rf6ZLlfNiw=;
        b=YK2kJ0rd4V1U4oN5eE5cGZrg0+n097BxHEHuZgkI6nLgXgfTesUcsdqsS7honxOonP
         zsK75+Y1HY2xWxjGO8Yp5SeZhzRYa7wYa+kqRGShA5v8MX65OQGM/amCxDXKlCNVNJ70
         0Igq8/COktnuuU0bNBsAYqhz17yKf7xBnShqqvcqKYl0SpEERMYmRmUmHkaTrYM1N8Wd
         RAPwAMkYSNjOFerSjvXgoNB5XYidzcIxX1NLLsLIxk+EwhHqR8HaWq7vMJIdJlAI1792
         4shLy5QUoPMIqApMfEdplAxLX2XBKG/vIFiHUYHIhSgVjgbTagoEkq5lcpLlraXHQyc9
         REsQ==
X-Gm-Message-State: APjAAAWjzJy00t7wju1S21wQB5tjdE21PY9+JvbjuM4MySVY4CgI3S1/
        l3ZzEuWusz9upm2VPyC+JTI=
X-Google-Smtp-Source: APXvYqwAGBfDW1W1JoMhxUQofiKL5jbdmw6iHpPOI4qgkIdGrY+7eME4F8Iv+SLzWvp2tiziCUkfiA==
X-Received: by 2002:aa7:8597:: with SMTP id w23mr1993190pfn.38.1582685229908;
        Tue, 25 Feb 2020 18:47:09 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id z30sm451033pfq.154.2020.02.25.18.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 18:47:09 -0800 (PST)
Date:   Tue, 25 Feb 2020 18:47:07 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Christopher S. Hall" <christopher.s.hall@intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        x86@kernel.org, jacob.e.keller@intel.com, davem@davemloft.net,
        sean.v.kelley@intel.com
Subject: Re: [Intel PMC TGPIO Driver 0/5] Add support for Intel PMC Time GPIO
 Driver with PHC interface changes to support additional H/W Features
Message-ID: <20200226024707.GA10271@localhost>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
 <20200203040838.GA5851@localhost>
 <20200225233707.GA32079@skl-build>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225233707.GA32079@skl-build>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 03:37:07PM -0800, Christopher S. Hall wrote:
> On Sun, Feb 02, 2020 at 08:08:38PM -0800, Richard Cochran wrote:
> > The TGPIO input clock, the ART, is a free running counter, but you
> > want to support frequency adjustments.  Use a timecounter cyclecounter
> > pair.
> 
> I'm concerned about the complexity that the timecounter adds to
> the driver. Specifically, the complexity of dealing with any rate mismatches
> between the timecounter and the periodic output signal. The phase
> error between the output and timecounter needs to be zero.

If I understood correctly, the device's outputs are generated from a
non-adjustable counter.  So, no matter what, you will have the problem
of changing the pulse period in concert with the user changing the
desired frequency.

> My counter-proposal would be to use the real-time clock as the basis of the
> device clock. This is fairly simple because the relation between ART and the
> realtime clock is known. When output is enabled any phase error between
> the realtime clock and the periodic output signal is accumulated in the
> SYS_OFFSET result.

I don't understand how you intend to do this...
 
> This leaves the PHC API behavior as it is currently and uses the frequency
> adjust API to adjust the output rate.
> 
> > Let the user dial a periodic output signal in the normal way.
> > 
> > Let the user change the frequency in the normal way, and during this
> > call, adjust the counter values accordingly.
> 
> Yes to both of the above.

So, why then do you need this?

+#define PTP_EVENT_COUNT_TSTAMP2 \
+       _IOWR(PTP_CLK_MAGIC, 19, struct ptp_event_count_tstamp)

If you can make the device work with the existing user space API,

	ioctl(fd, PTP_PEROUT_REQUEST2, ...);
	while (1) {
		clock_adjtimex(FD_TO_CLOCKID(fd), ...);
	}

that would be ideal.  But I will push back on anything like the
following.

	ioctl(fd, PTP_PEROUT_REQUEST2, ...);
	while (1) {
		clock_adjtimex(FD_TO_CLOCKID(fd), ...);
		ioctl(fd, PTP_EVENT_COUNT_TSTAMP, ...);
	}

But maybe I misunderstood?

Thanks,
Richard
