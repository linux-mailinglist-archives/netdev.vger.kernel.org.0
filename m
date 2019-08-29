Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4291A223D
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 19:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfH2R2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 13:28:52 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41823 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727173AbfH2R2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 13:28:52 -0400
Received: by mail-pf1-f194.google.com with SMTP id 196so2514392pfz.8;
        Thu, 29 Aug 2019 10:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=h3l+cnwgLiAnxdbo1DA0QAVgE8Ahk9WZSlg+KJsywhg=;
        b=LzVRRjQVaNl26Q1HWhVNlp4y3i6RrjP4ioKujdqMcYLxuWJAyounwHpRRXYbS4a+3I
         9MBKvFW5dU6A6f6dfiN0meLYZqHzy09lk0Vrrj8OlQLumZh7QeYy8yDmdRY5gh9Jq6TF
         a3pmCnZ9idbMg9bvifOaRNB/3X+X+gy2+CJ4KD46cpM/cLYQvs33UQcEAkHqup33yWI5
         J8OuzXHGFKDeZmj2H4FvytpzVwGJA5a/BliZf2y/pIhzRU5UpX6NsmPF+saALZ2ThLn7
         GqkLp6Wvy8uhJ6zZERLaUGZdasJMqrYHVqYvkrwS/FJAQ30LmXrOYDDN4pAnBxaSnn0W
         1kqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=h3l+cnwgLiAnxdbo1DA0QAVgE8Ahk9WZSlg+KJsywhg=;
        b=q5JzvQyL7W0ZlvKaS3+8FiNq8h4+9i7ZcU6T3ampeFT4NDiJXJZaCqX8PQS/FtjaP8
         4BQZFtIGAKrVMul0m6XnU8pLtGdaz0l5amQjIeSFvUdiYHk3yE6CkGgWOc8KB7Eo1flq
         9X8uUNxxBWVYv7TjK9r13Pp4zp6xsRVPo74aOpAxZTgQ02U9KdslELpFZjbmTj1Us2M0
         kSciIe0YgkZNlXyZ221Es2IknzsOMQIv71G7M9IupbOziNPETGcO290FWmDLmm10WbHc
         6IQgvepMuQx0Jn7UVmsbOkLiC1Juf7fej2xEdBfNCfZPHLngo8WHRMZ3GsrlcKfhacMm
         duOQ==
X-Gm-Message-State: APjAAAXNQw+hRWP/yqGIUApOstDzpkAIL89hHJO0y3N+9vs9ULQ0rUAS
        N82YPSrr1yxh0lmscilMfEk=
X-Google-Smtp-Source: APXvYqw7CbFzyCtt3jbkWG8reMnAoR7kVbwpZwqnxbz7M4tUSwU+i/XccvSM/taww6ip18AttI2NGA==
X-Received: by 2002:a17:90a:c503:: with SMTP id k3mr11205835pjt.134.1567099731651;
        Thu, 29 Aug 2019 10:28:51 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id 203sm3881871pfz.107.2019.08.29.10.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 10:28:50 -0700 (PDT)
Date:   Thu, 29 Aug 2019 10:28:48 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH v2 2/2] PTP: add support for one-shot output
Message-ID: <20190829172848.GC2166@localhost>
References: <20190829095825.2108-1-felipe.balbi@linux.intel.com>
 <20190829095825.2108-2-felipe.balbi@linux.intel.com>
 <20190829172509.GB2166@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829172509.GB2166@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Adding davem onto CC...

On Thu, Aug 29, 2019 at 12:58:25PM +0300, Felipe Balbi wrote:
> diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> index 98ec1395544e..a407e5f76e2d 100644
> --- a/drivers/ptp/ptp_chardev.c
> +++ b/drivers/ptp/ptp_chardev.c
> @@ -177,9 +177,8 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  			err = -EFAULT;
>  			break;
>  		}
> -		if ((req.perout.flags || req.perout.rsv[0] || req.perout.rsv[1]
> -				|| req.perout.rsv[2] || req.perout.rsv[3])
> -			&& cmd == PTP_PEROUT_REQUEST2) {
> +		if ((req.perout.rsv[0] || req.perout.rsv[1] || req.perout.rsv[2]
> +			|| req.perout.rsv[3]) && cmd == PTP_PEROUT_REQUEST2) {

Please check that the reserved bits of req.perout.flags, namely
~PTP_PEROUT_ONE_SHOT, are clear.

>  			err = -EINVAL;
>  			break;
>  		} else if (cmd == PTP_PEROUT_REQUEST) {
> diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
> index 039cd62ec706..95840e5f5c53 100644
> --- a/include/uapi/linux/ptp_clock.h
> +++ b/include/uapi/linux/ptp_clock.h
> @@ -67,7 +67,9 @@ struct ptp_perout_request {
>  	struct ptp_clock_time start;  /* Absolute start time. */
>  	struct ptp_clock_time period; /* Desired period, zero means disable. */
>  	unsigned int index;           /* Which channel to configure. */
> -	unsigned int flags;           /* Reserved for future use. */
> +
> +#define PTP_PEROUT_ONE_SHOT BIT(0)
> +	unsigned int flags;

@davem  Any CodingStyle policy on #define within a struct?  (Some
maintainers won't allow it.)

>  	unsigned int rsv[4];          /* Reserved for future use. */
>  };
>  
> -- 
> 2.23.0
> 

Thanks,
Richard
