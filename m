Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B585911CE
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 18:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfHQP7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 11:59:31 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46143 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbfHQP7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 11:59:31 -0400
Received: by mail-pg1-f195.google.com with SMTP id m3so3864463pgv.13;
        Sat, 17 Aug 2019 08:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xIlhVyHBmb3rcCp+KzrwcLo7a20Ei5NLFLjc/pDseU0=;
        b=cbCTvjIBVb+wS7VLXUoKpVlN88AtzcWy+XNBk1e3ABUE1OyesQ6KdJ8vfYqmtMnIPC
         BLSK0/1+8k7+BLIHnS8oP6QYJ8UUTzAdilvpCb3MGsDYO18De6mJ/AWTvtGIolUiABY/
         6azsDVWEoSfqXRdCCiMjaoT1az8eRdMuBk8qt3/SS+TiHIkUO7HXWheQo6tVbRrwBCJf
         jUSE/AvYDrDIIfnhYZZX/3cxvrf99p1VQZ7GVhV/euYQcWqI8OQE5InvtGbR7l9uF8/6
         +x9a5dzFh4TZZx9iEugr/QJMMmcgOuYAwrrPHTC863JGtn10RloPL0tex6eoAqgWeP9s
         HdoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xIlhVyHBmb3rcCp+KzrwcLo7a20Ei5NLFLjc/pDseU0=;
        b=hiEaxg47gVMef+mM60i/A1iU1pUJHQ+M4UR95TGibRpTVDtSY2zFBlsD2pDCrFQkkw
         hiTALTHlxawM8jI4BX/IbsBmRFQhqqsWIKzD8PEdyTnQFsHZz3N4/hwCAITQ+3I94T5k
         3bU2omhCkQlIAQA0GGSY2O0KmdoAD4JY75p7clYBCUQ/Qz8uwKmjGFX/Cj5lj9S10+Vl
         kgggmOiKx3ipl2/4KJztoorrT/SeGlkRuW3MvmDbPZKehTbAm6R5K3xLG1lwa+AkaQTR
         PGKoAKWYAHBnlTpeBTtcJ/nAo8yRfJge739KLF/owX7JAUruTaPhqBFWkCtoiUlZyeSZ
         hItg==
X-Gm-Message-State: APjAAAXIAT0jh5GjK1FTdPyV+V7C86MFgVkSA0a7NXWkcGuaWEXKeY4M
        wFA1UDYQ40MQE6Y/jpEEifs=
X-Google-Smtp-Source: APXvYqx729u4HAZJtk7rY2vqxpnYL8YoY7lKPmX9QdvNVhy7BLwnYGYevQ3WBAFQhnIpcAwTBs+glQ==
X-Received: by 2002:a62:e806:: with SMTP id c6mr16431028pfi.132.1566057570572;
        Sat, 17 Aug 2019 08:59:30 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id n128sm9486232pfn.46.2019.08.17.08.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Aug 2019 08:59:29 -0700 (PDT)
Date:   Sat, 17 Aug 2019 08:59:27 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] PTP: introduce new versions of IOCTLs
Message-ID: <20190817155927.GA1540@localhost>
References: <20190814074712.10684-1-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814074712.10684-1-felipe.balbi@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 10:47:11AM +0300, Felipe Balbi wrote:
> The current version of the IOCTL have a small problem which prevents us
> from extending the API by making use of reserved fields. In these new
> IOCTLs, we are now making sure that flags and rsv fields are zero which
> will allow us to extend the API in the future.
> 
> Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
> ---
>  drivers/ptp/ptp_chardev.c      | 58 ++++++++++++++++++++++++++++++++--
>  include/uapi/linux/ptp_clock.h | 12 +++++++
>  2 files changed, 68 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> index 18ffe449efdf..204212fc3f8c 100644
> --- a/drivers/ptp/ptp_chardev.c
> +++ b/drivers/ptp/ptp_chardev.c
> @@ -123,9 +123,11 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  	struct timespec64 ts;
>  	int enable, err = 0;
>  
> +	memset(&req, 0, sizeof(req));

Nit: please leave a blank line between memset() and switch/case.

>  	switch (cmd) {
>  
>  	case PTP_CLOCK_GETCAPS:
> +	case PTP_CLOCK_GETCAPS2:
>  		memset(&caps, 0, sizeof(caps));
>  		caps.max_adj = ptp->info->max_adj;
>  		caps.n_alarm = ptp->info->n_alarm;

Reviewed-by: Richard Cochran <richardcochran@gmail.com>

