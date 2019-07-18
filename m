Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B5D6D22D
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 18:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390295AbfGRQlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 12:41:25 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37785 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389858AbfGRQlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 12:41:25 -0400
Received: by mail-pf1-f193.google.com with SMTP id 19so12883112pfa.4;
        Thu, 18 Jul 2019 09:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6rXfAOSyMwNydp+7fmtGTEr8JM70VS1PI32cRhPTo2c=;
        b=Nn2uvpW25U33GY3F7gF4xsSBi/LCRa96KOW4alT4IeiDuZDJOuOvQp/chZwhmPwhCY
         XrVmyAGC/rkyXbpLWxooQrHdOA7n+UHwGGCeCSdUwUsZl2mzQ7KcdN/n0SfDrKiKlaXM
         4D2dcW11mg5cwSm23/B5QDL7t2fnsbc67TOV5eM5PIcPEhZ+XZUGMl0J/XT6Hac9DaXR
         yZ60uH8W4oRybCQ9TIkeLetVZqE5tXqMIjNU8VwegHg8Uqq42mO3BRNz14CM5nXytN+V
         ZVbubU3cMDpWPThDt3Qa7W3ihsR9ByaLKDRuFz1HEJaOFHSgPQWK3GtvBgjj7Q4aDrZS
         Ln4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6rXfAOSyMwNydp+7fmtGTEr8JM70VS1PI32cRhPTo2c=;
        b=LIrioA03Qip7GHwLCCyCusDgrwrCiHnDQj+3LU3ZAG0dnL6ENvJF8qRcSBmJORIArq
         A3+OgFcIWJKL6EJYtQW4Qkn0OtsnbE9dDCICpWfwl5DWzXlA8/kE8dUCizZ+m8t1nbXt
         LIjAGyezbN7Wcx2XpGV2+C22XTpf8KU6MMMlLxxbc0BrfFxw49wBfx6BakXPUEVnuxOg
         TZN/7qSDGibGHCAo2mJg9t/6pdgEk4wURWMNL8tr4YpOGi/ji3bC7BCBiuKOSVibYo04
         Hr+fitjiZafKrqM7evaHGWHNjqjnMNcxQsz8Y7eCxWXSbUDECLslrkJ11L9bPe0uFJVL
         Df+Q==
X-Gm-Message-State: APjAAAUEJBaVGuJKhjc1XqOkiUqYiQDyVD/GTvA1zfysE4nii4ZqiFwz
        mOLXCri+5tHuwV7IEgPhulI=
X-Google-Smtp-Source: APXvYqwKz2mpCqXvBYtJLAKEvoXIkVXorTIADsH/2NMAdWM6vDdkXoBav4Yde8I7/FZed4NJVJyYOw==
X-Received: by 2002:a63:2606:: with SMTP id m6mr48408098pgm.436.1563468084713;
        Thu, 18 Jul 2019 09:41:24 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id f15sm28866625pje.17.2019.07.18.09.41.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 09:41:23 -0700 (PDT)
Date:   Thu, 18 Jul 2019 09:41:21 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 4/5] PTP: Add flag for non-periodic output
Message-ID: <20190718164121.GB1533@localhost>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
 <20190716072038.8408-5-felipe.balbi@linux.intel.com>
 <20190716163927.GA2125@localhost>
 <87k1ch2m1i.fsf@linux.intel.com>
 <20190717173645.GD1464@localhost>
 <87ftn3iuqp.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ftn3iuqp.fsf@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 11:59:10AM +0300, Felipe Balbi wrote:
> no problem, anything in particular in mind? Just create new versions of
> all the IOCTLs so we can actually use the reserved fields in the future?

Yes, please!

Thanks,
Richard
