Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6249F192014
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 05:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgCYERX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Mar 2020 00:17:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37009 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgCYERX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 00:17:23 -0400
Received: from mail-pf1-f200.google.com ([209.85.210.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jGxTl-0006Sk-3X
        for netdev@vger.kernel.org; Wed, 25 Mar 2020 04:17:21 +0000
Received: by mail-pf1-f200.google.com with SMTP id t19so1063796pfq.21
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 21:17:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=vVoJdtTocGUlP29HjnLch4GTGfFRHYMMlLvLUSfKJds=;
        b=G2zC1tjzxlR6ZWJAmL90qyt0U0kvGtyhNvqQ9pA4ufPTkHQfQzqt1eMyJ3JPj3B4s4
         sGR7MQxXF1E2LlZOe0QHVQzhDqob87sI+jzgQLvsJSqTCpzE/eukpJe6uuP6CC+qnLh8
         Iwdl6V+7lTcTQ18dzorCIC9NWRyCTynFkbxoN9gZx3Mnx6AiMpuoH+84ym/WEFJ0RzRW
         XQvt5EQDPqE0idmyaLOq5IZbBbW/t3Mrjwyd86lY2zg/8jA4D6OXQx9UbjiERTKpS7SR
         BRcnXGGIPWL+x+76pmfvc4J4bXBdPFVtI0pKXEGE4h0OHU0LJAAmbX+4+DIl8BkbEYcv
         odCg==
X-Gm-Message-State: ANhLgQ0NvBBxFzFGL7bI+eJzW1samxNEY4X+heR801fjvxXNN21NyviI
        B69dSTnOQ1RRwEk+uNFT0fnGctVfWsAMqypUh7Wfqhz9ZJjbJR3tKfYP0jZwWQ/vSrOwRlviFdX
        NWbnOIWUiR7L64UwnsZOaHxYY8pijq2zA4g==
X-Received: by 2002:aa7:947d:: with SMTP id t29mr1294537pfq.184.1585109839585;
        Tue, 24 Mar 2020 21:17:19 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvQpxqBo4YHRa+qrNZnbKcUGaBxApWGqCw9RRRFcwLQK05ook0U0OCinknPd7UlfBZiO4AOKQ==
X-Received: by 2002:aa7:947d:: with SMTP id t29mr1294515pfq.184.1585109839226;
        Tue, 24 Mar 2020 21:17:19 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id q19sm6720989pgn.93.2020.03.24.21.17.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Mar 2020 21:17:18 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH] e1000e: bump up timeout to wait when ME un-configure ULP
 mode
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <20200323191639.48826-1-aaron.ma@canonical.com>
Date:   Wed, 25 Mar 2020 12:17:15 +0800
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <EC4F7F0B-90F8-4325-B170-84C65D8BBBB8@canonical.com>
References: <20200323191639.48826-1-aaron.ma@canonical.com>
To:     Aaron Ma <aaron.ma@canonical.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Aaron,

> On Mar 24, 2020, at 03:16, Aaron Ma <aaron.ma@canonical.com> wrote:
> 
> ME takes 2+ seconds to un-configure ULP mode done after resume
> from s2idle on some ThinkPad laptops.
> Without enough wait, reset and re-init will fail with error.

Thanks, this patch solves the issue. We can drop the DMI quirk in favor of this patch.

> 
> Fixes: f15bb6dde738cc8fa0 ("e1000e: Add support for S0ix")
> BugLink: https://bugs.launchpad.net/bugs/1865570
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---
> drivers/net/ethernet/intel/e1000e/ich8lan.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
> index b4135c50e905..147b15a2f8b3 100644
> --- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
> +++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
> @@ -1240,9 +1240,9 @@ static s32 e1000_disable_ulp_lpt_lp(struct e1000_hw *hw, bool force)
> 			ew32(H2ME, mac_reg);
> 		}
> 
> -		/* Poll up to 300msec for ME to clear ULP_CFG_DONE. */
> +		/* Poll up to 2.5sec for ME to clear ULP_CFG_DONE. */
> 		while (er32(FWSM) & E1000_FWSM_ULP_CFG_DONE) {
> -			if (i++ == 30) {
> +			if (i++ == 250) {
> 				ret_val = -E1000_ERR_PHY;
> 				goto out;
> 			}

The return value was not caught by the caller, so the error ends up unnoticed.
Maybe let the caller check the return value of e1000_disable_ulp_lpt_lp()?

Kai-Heng

> -- 
> 2.17.1
> 

