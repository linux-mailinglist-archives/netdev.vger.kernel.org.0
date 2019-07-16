Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69AD16ACEA
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 18:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbfGPQjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 12:39:31 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38249 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfGPQjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 12:39:31 -0400
Received: by mail-pl1-f195.google.com with SMTP id az7so10389196plb.5;
        Tue, 16 Jul 2019 09:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eh3K6XRA6WufDmkE5JaSlW3TwpIe3cmqxYTGyNYioEE=;
        b=YLtmR67XmuYZj2OiXKDBRsAFqlIMaPbmOTs3SahTnDigrncU8/MtxPMn5+0Q5hlXRE
         kxImrFZp/UnBQym84YtUc/ee/reaZ/0leUMfYPKowlzgHF7i7rgTPhob52y2+YZQj2ET
         V1ov5BkonwjyZ42E/qCmZ77o6LJDT7A3mGdHvg7Ca7wvHbEaoZH51ECqyC+uDRXJUxUo
         h0ATuO6zopu+7FJ0Cr4Vnkwe6UQqXK+F1fv+lSKXSD6FG+OoQiyx6bZIIhRuAxrZ+gZF
         v9lip/pX0IYr7guDOPJPqcx0KXsFWtM9Nx5Pur6OmqsMrmFMLj1NLMsvU+JvTj4YtaQw
         DzyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eh3K6XRA6WufDmkE5JaSlW3TwpIe3cmqxYTGyNYioEE=;
        b=aAMBq8WuMWmsXXk1a4z6xvIzbqX2E2nAWsx+8pNF3/E0SnMnvhovVavi4N0Q9agyci
         Ru3AgDXfYdG4G6htQL5tW16zVhA9xuvXl1V0vuEUS9jObiF1OGaKqih4l5nPtKqMZkwq
         8vY5TDewG1t6KCSCT8L08qswd1lVoqyu0SzMe5GLZHtY3eVbU5GfzWP3He1Yos5gr3SE
         A9D4GG7aqZf+kyAhmuUHd+kZ1HKc8ySyH7s1U1oT63AbRcoulY51+E3RbYB0uC8RAenM
         /TQCxr0i4XeGl12NYLNgMSB0j6v0PJ0o3eqnOSoG7oi01UxIL5vJphE/gfpJ3dkEuYmS
         0ahg==
X-Gm-Message-State: APjAAAWZF/A3raQoBZZ/KmYxPQ/gNkxMklF01NyS4xyyNVu+etXqKwvG
        5anpYhA4O95cl2Tr55ot54BTPhR/
X-Google-Smtp-Source: APXvYqw7014vqzLIZT3xw5eCSHaFAh1/PAq9IDU3t8K7iVAGQuIo6zBkmC021Ffkd4b76fSVJ2Wbjg==
X-Received: by 2002:a17:902:968d:: with SMTP id n13mr37325139plp.257.1563295170321;
        Tue, 16 Jul 2019 09:39:30 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id f20sm6764584pgg.56.2019.07.16.09.39.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 09:39:29 -0700 (PDT)
Date:   Tue, 16 Jul 2019 09:39:27 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 4/5] PTP: Add flag for non-periodic output
Message-ID: <20190716163927.GA2125@localhost>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
 <20190716072038.8408-5-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716072038.8408-5-felipe.balbi@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 10:20:37AM +0300, Felipe Balbi wrote:
> When this new flag is set, we can use single-shot output.
> 
> Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
> ---
>  include/uapi/linux/ptp_clock.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
> index 674db7de64f3..439cbdfc3d9b 100644
> --- a/include/uapi/linux/ptp_clock.h
> +++ b/include/uapi/linux/ptp_clock.h
> @@ -67,7 +67,9 @@ struct ptp_perout_request {
>  	struct ptp_clock_time start;  /* Absolute start time. */
>  	struct ptp_clock_time period; /* Desired period, zero means disable. */
>  	unsigned int index;           /* Which channel to configure. */
> -	unsigned int flags;           /* Reserved for future use. */
> +
> +#define PTP_PEROUT_ONE_SHOT BIT(0)
> +	unsigned int flags;           /* Bit 0 -> oneshot output. */
>  	unsigned int rsv[4];          /* Reserved for future use. */

Unfortunately, the code never checked that .flags and .rsv are zero,
and so the de-facto ABI makes extending these fields impossible.  That
was my mistake from the beginning.

In order to actually support extensions, you will first have to
introduce a new ioctl.

Sorry,
Richard

>  };
>  
> -- 
> 2.22.0
> 
