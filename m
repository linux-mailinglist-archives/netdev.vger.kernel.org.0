Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6655FF8B52
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 10:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfKLJEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 04:04:49 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53204 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727180AbfKLJEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 04:04:48 -0500
Received: by mail-wm1-f65.google.com with SMTP id l1so2195282wme.2
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 01:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y+xqaA+PPE83+8NKlD/ArjFhQQS4KR3/VLoI8CbMHTQ=;
        b=OrhbC81KkHxApm8Cyz6wofLkMe30UUYrZ7SAIxLPpbWOQjNRJ+9i1INbWFIyA56cLo
         +BPL+Bu+q910hA2jR8t+LHkEUJg2RtT1luLd+cTyw1q6vBbZW+00jX28LiDUftYcJcNz
         pr7RWL8NXHx8ktgGMGhfU5ikoMwf2CapBm6n8L8DxBPB/Km+TB9z7aLDt2FfNr+yauBM
         QnSiiLl9ZxWQ0RT6f/bEBdg/14II3kFpNt7QQ9dJFZRnddNZqxa4EcFIdKdtAIriqmKY
         FF/bK5CEC1RZK71LX2MpRDEw7FcfVrB+k27pH+ptjJ3xINLTCK/2TbYmctl9G565MNs4
         7rQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Y+xqaA+PPE83+8NKlD/ArjFhQQS4KR3/VLoI8CbMHTQ=;
        b=ASGUAxxZPxEsKU0Cn4+wsNKqpjl6zlJxuL6qxwjAZyTkfYcmNIqJo/ipbW/V7Bg9lF
         gK+IBzT3iW83nNSnVod8ym+cfuInF4Q5cqHK6TlyRADEaelhUkjkr9y9J2xdES5EUXH/
         vyY7fOrMTWfb9XQKLDdUWeYfYFmHbLKyLbcEPymxg2buDwJ8O/HUUE3L7hTCEpAM8x8l
         z3LmCYDlyFqnMwuMY6co5ahtpFpWp6Ij297XPw40gBtIiC2SnMFb39Un0wW+iVIDrNPS
         KpjC5Mr4XaItzWi3+0eYi6VIjp15NpUoBmTYi5q7PfzsxgsoByCF9OWyn5i+CX/aZPvY
         0kKA==
X-Gm-Message-State: APjAAAX5LnlNlXmXPM0VlAoH+mmQpmhihIY3weJlkDUPJQKFwRdVg7Sw
        HbJfmxX/8T0vA6amV7YkQu7mTA==
X-Google-Smtp-Source: APXvYqzAugh1NnuNK1H/GCm69vuRvJ84ZPDmwfNcjCKH7OcWchiOigPgyE3JxWJgXjnInQMy6zlEMg==
X-Received: by 2002:a7b:cb4a:: with SMTP id v10mr2715803wmj.106.1573549486843;
        Tue, 12 Nov 2019 01:04:46 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id b17sm20011773wru.36.2019.11.12.01.04.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Nov 2019 01:04:46 -0800 (PST)
Date:   Tue, 12 Nov 2019 10:04:45 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath10k: Handle "invalid" BDFs for msm8998 devices
Message-ID: <20191112090444.ak2xu67eawfgpdgb@netronome.com>
References: <20191106234712.2380-1-jeffrey.l.hugo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106234712.2380-1-jeffrey.l.hugo@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 06, 2019 at 03:47:12PM -0800, Jeffrey Hugo wrote:
> When the BDF download QMI message has the end field set to 1, it signals
> the end of the transfer, and triggers the firmware to do a CRC check.  The
> BDFs for msm8998 devices fail this check, yet the firmware is happy to
> still use the BDF.  It appears that this error is not caught by the
> downstream drive by concidence, therefore there are production devices
> in the field where this issue needs to be handled otherwise we cannot
> support wifi on them.  So, attempt to detect this scenario as best we can
> and treat it as non-fatal.
> 
> Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
> ---
>  drivers/net/wireless/ath/ath10k/qmi.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
> index eb618a2652db..5ff8cfc93778 100644
> --- a/drivers/net/wireless/ath/ath10k/qmi.c
> +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> @@ -265,10 +265,13 @@ static int ath10k_qmi_bdf_dnld_send_sync(struct ath10k_qmi *qmi)
>  			goto out;
>  
>  		if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
> -			ath10k_err(ar, "failed to download board data file: %d\n",
> -				   resp.resp.error);
> -			ret = -EINVAL;
> -			goto out;
> +			if (!(req->end == 1 &&
> +			      resp.resp.result == QMI_ERR_MALFORMED_MSG_V01)) {

Would it make sense to combine the inner and outer condition,
something like this (completely untested) ?

		if (resp.resp.result != QMI_RESULT_SUCCESS_V01 &&
		    !(req->end == 1 &&
		      resp.resp.result == QMI_ERR_MALFORMED_MSG_V01)) {

> +				ath10k_err(ar, "failed to download board data file: %d\n",
> +					   resp.resp.error);
> +				ret = -EINVAL;
> +				goto out;
> +			}
>  		}
>  
>  		remaining -= req->data_len;
> -- 
> 2.17.1
> 
