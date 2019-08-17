Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F18B911DE
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 18:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfHQQDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 12:03:46 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38794 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfHQQDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 12:03:46 -0400
Received: by mail-pg1-f195.google.com with SMTP id e11so4465243pga.5;
        Sat, 17 Aug 2019 09:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VX9SuN022Zgb1Vaem7TDWo/v6LonzdjcvnS8iGmSoyI=;
        b=nGeNWyM9NauOz00Dd0d3rDDL4kpZN6/LIgEVPapNO4Sd/KGnMxRPQXMVarArOOoVIy
         R3JkBPHYSpVglbK1InK7bEc6ClXdGbK7R/5ymakF2pmAd7AeoU3lr2kIXDngkOXDV0w7
         VIbcyHbQK9CtiCuTYe2JzMD5ja6MASNZK3ihzvq9Np91iMdKphp8MT3DXNda2Cg6I11G
         /JtTFD39yeHfOELTwcRYgUXjFKSJWWGHest4yBUp2oAvQ49JmBjBxgSkADEu3hUI2Oz7
         zGD4O2Gb3L+9/MMBXt8ywcwDhpS00Az2Ttu25VZ0lKTysQ7l3HUKmUGVl288I6xB/S+c
         pIxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VX9SuN022Zgb1Vaem7TDWo/v6LonzdjcvnS8iGmSoyI=;
        b=Mpe+SIxvqV6FJIaF2vVlLkwE1hjcLMPo42r0wa0RrbtC01F3UfgHaP+vrGIRo99TQL
         S1oHZ9MeGxSJGQatPKzyIMeUzG10SFCpSUTYIt8KFi2jAxfX+gI9caIM4NqH6eOlY/5c
         foZP6aum3hEJSVAsmR8iei8L49GsAQse1rC4UII9+n7eW+R0tIa9UHHaW872srOqANU5
         hwrOE9PdyTuOk71yZTXDdHqbtQw/7KfGbbK2dBz+ABlttgm6dWyxZ99Z3AmJpYyE5+2m
         eLU71v3bXaBTFH2QRU0uxUJ2OIBYXTx6jfjJBPvH7vQzb/vAr59NMTM6umqCzh0ceV6W
         eJ0A==
X-Gm-Message-State: APjAAAXEovOE+/f7d4xZN0ajtsnHdsxyvLc1YgP5EEk221t0pNTSGgVL
        bDCKB0iUUE8ofhosndjh+RQ=
X-Google-Smtp-Source: APXvYqzV2LlHDU2zsYA3MncwrJG/FqdniLTR9RztJFkT4pUxIEg/t4O9IHHu/jHXqgjmx8MXWntwhA==
X-Received: by 2002:a17:90a:d792:: with SMTP id z18mr12534888pju.36.1566057825781;
        Sat, 17 Aug 2019 09:03:45 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id b6sm8568436pgq.26.2019.08.17.09.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Aug 2019 09:03:44 -0700 (PDT)
Date:   Sat, 17 Aug 2019 09:03:42 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] PTP: add support for one-shot output
Message-ID: <20190817160342.GB1540@localhost>
References: <20190814074712.10684-1-felipe.balbi@linux.intel.com>
 <20190814074712.10684-2-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814074712.10684-2-felipe.balbi@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 10:47:12AM +0300, Felipe Balbi wrote:
> diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
> index 039cd62ec706..9412b16cc8ed 100644
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

The .flags field doesn't need this comment.  The individual BIT macro
names should be clear enough, and if not, then comment the macros.

>  	unsigned int rsv[4];          /* Reserved for future use. */
>  };
>  
> -- 
> 2.22.0
> 

Reviewed-by: Richard Cochran <richardcochran@gmail.com>
