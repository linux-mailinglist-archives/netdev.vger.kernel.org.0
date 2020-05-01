Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF161C0CE0
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgEAD4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728092AbgEAD4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:56:05 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A0FC035494;
        Thu, 30 Apr 2020 20:56:04 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 145so1057298pfw.13;
        Thu, 30 Apr 2020 20:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7J8Rkq3kYamrLU5CPRwhylDWDhZyVC12eTil7FMDdLc=;
        b=lj0sGg4qE2YogN1HNVwe+jZC/FZ4AY178ESS1kDK1+0/AXF//gPfAny/Mv3qqx1w19
         wwOiQF7uYOQ+AXl0AQZICSvwxNPWz1BfWzBuWbHTsr/WyEAh48Jkp4R4/dEm9xatVvn7
         9uEvMMfikcOyW59WgJGivv7BKL4WSHIpBEA9ZhFgNwQwI9TrZ3KwiRluQxVQrThEyoAo
         0vivxxkJ74t2Nie8zt9b63wuN6xnkyC5hZ1G/Mfz0od7AHzFR2VBwXArChbYg4DFQygu
         ewM2YITIN4+/tTa42yHJUdVozqYSnw+fnDu58igHZ9k/QBK2UjMIoYSyxe5Gaf8s7KW4
         V2RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7J8Rkq3kYamrLU5CPRwhylDWDhZyVC12eTil7FMDdLc=;
        b=sb0wb3lfR2zqsQCwm5VLH4q1CGfE7CcvndE3nZxRy54dRU+SQiaugN/DwmgRvGXES3
         LTwCnX77MM/s+ZeklMStiEVticipAE+P5LS96d7DNuhhwVAOdy/UQu12RyG5H0vqSune
         5Lcbx9cihQS48D8dWTZ9LVGB8PfGvJysZXz/bVQI7v9eOwblF1yKqxE5qGSFdyZMgq/Z
         X9q4W//NcI8mIbWDXt0v9frtMnnnpiyWxnEjoC9aBf1GvBoSkgmvEhVqjno4zAc+FyqW
         ZTGaBeqKswkI2OuptOQyUFhMT9HiHPMyFGoNibHlsPhpqvXv1vW3S5LWt6kJvJr9aC2z
         awgA==
X-Gm-Message-State: AGi0PuaIfL2uHWkavnSZGoWPw6pbM26a8JRvDR0t8OdT/IaFdB25EGgG
        UyXwM8uQ6KI3Xr2ACaTEWsc=
X-Google-Smtp-Source: APiQypKvHkDUk/bS81AnDzEZUMik1BVyvYXTTbvzp837MWVDpDOoL2Ma4AiRsmUcb4XdbWhFBYDpng==
X-Received: by 2002:aa7:8b12:: with SMTP id f18mr2213441pfd.81.1588305363471;
        Thu, 30 Apr 2020 20:56:03 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id m19sm953427pjv.30.2020.04.30.20.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 20:56:03 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:56:01 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     vincent.cheng.xh@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] ptp: ptp_clockmatrix: Add adjphase() to
 support PHC write phase mode.
Message-ID: <20200501035601.GC31749@localhost>
References: <1588206505-21773-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1588206505-21773-4-git-send-email-vincent.cheng.xh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1588206505-21773-4-git-send-email-vincent.cheng.xh@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 08:28:25PM -0400, vincent.cheng.xh@renesas.com wrote:
> @@ -871,6 +880,69 @@ static int idtcm_set_pll_mode(struct idtcm_channel *channel,
>  
>  /* PTP Hardware Clock interface */
>  
> +/**
> + * @brief Maximum absolute value for write phase offset in picoseconds
> + *
> + * Destination signed register is 32-bit register in resolution of 50ps
> + *
> + * 0x7fffffff * 50 =  2147483647 * 50 = 107374182350
> + */
> +static int _idtcm_adjphase(struct idtcm_channel *channel, s32 deltaNs)
> +{
> +	struct idtcm *idtcm = channel->idtcm;
> +
> +	int err;
> +	u8 i;
> +	u8 buf[4] = {0};
> +	s32 phaseIn50Picoseconds;
> +	s64 phaseOffsetInPs;

Kernel coding style uses lower_case_underscores rather than lowerCamelCase.

> +
> +	if (channel->pll_mode != PLL_MODE_WRITE_PHASE) {
> +
> +		kthread_cancel_delayed_work_sync(
> +			&channel->write_phase_ready_work);
> +
> +		err = idtcm_set_pll_mode(channel, PLL_MODE_WRITE_PHASE);
> +
> +		if (err)
> +			return err;
> +
> +		channel->write_phase_ready = 0;
> +
> +		kthread_queue_delayed_work(channel->kworker,
> +					   &channel->write_phase_ready_work,
> +					   msecs_to_jiffies(WR_PHASE_SETUP_MS));

Each PHC driver automatically has a kworker provided by the class
layer.  In order to use it, set ptp_clock_info.do_aux_work to your
callback function and then call ptp_schedule_worker() when needed.

See drivers/net/ethernet/ti/cpts.c for example.

Thanks,
Richard

