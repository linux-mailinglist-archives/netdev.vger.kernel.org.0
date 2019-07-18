Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75CF36D2DE
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 19:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfGRRgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 13:36:44 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45661 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727921AbfGRRgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 13:36:43 -0400
Received: by mail-io1-f68.google.com with SMTP id g20so52723672ioc.12
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 10:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6026YBUvM6hh4udYGhgJaVU8cAU22IkZO2YG1K39CTM=;
        b=etQCqticQTkSHk2OrgScvV7z5AE7EPkqFLHcftsA14gxoa9Ojprm2vUV4xycUMSp8o
         eNXK0ycQApE5yTBhQssqSXkgJgIhLw2HJeAudqBpjMu9LcyyOL31XHircBcBbpLOLOa5
         Tz3swG9bvXnelgAMLEcBDuZVdpdsILwyxYzd4qlNDywng7LPvhXoy5o4X5rJpG0pfMwu
         U1XQ089UliFHBLwRkZd6ln4Ph5GQ/Ek8BD3DBeSc5TLuFL9lAtJYw6wJ/Vc0QSm/r3eF
         9NhfQRywCoyPU2w1/34F6BAmSoZqA3vZog8AGwR7j8mrXWJKdE6lr/CaayQiY4+KQq4U
         XP0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6026YBUvM6hh4udYGhgJaVU8cAU22IkZO2YG1K39CTM=;
        b=ZJDaVyHM8oTKAl+mE5g1OTwPaj4mudOIcmm7TgDa/XoFxxw6BSyOnkvh9NhyxSWSVW
         UMicBstbSotf+Tz3QAoP40Em02D3NME5Ot0BSiuekWX42QnNdbSCsy+ug+VH/oyYKPF/
         KTtsI9ZQzWFVDU8cSYNVa2+NHqKqPUw1fVL4VYw+YjaeWWBdxtsVcKlV7pjiR7wp5KBP
         HCq7PuZUYrDbXrSH4DbJ3ftihjvi2G75HUkHFbC+urQwE5wS1gSsF/F3Gm9K4K1Vmunj
         hTU7vetYHOwiODgYUdakninUNdBVj+Mzksp/KSedKFYFH3b8TMirhyu0xgQ79XrTtN3c
         LRSA==
X-Gm-Message-State: APjAAAVDwRlTNtZuSAsc/xzCchz+G/R5Ia/2CNUPLm37jGFDlFRc7HKa
        dfGFycPyHt/LZCVFGy2Q5C56XD4m
X-Google-Smtp-Source: APXvYqzgGb1havCb1mlJUOr2qI7GCkBN3BLgov2QLJ/s2ByV+fWF9Jzei3Vd9L+U1KLXVcbPdAvXOg==
X-Received: by 2002:a6b:ea0f:: with SMTP id m15mr46203487ioc.300.1563471402890;
        Thu, 18 Jul 2019 10:36:42 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:d57e:4df9:f3b0:1b7c? ([2601:282:800:fd80:d57e:4df9:f3b0:1b7c])
        by smtp.googlemail.com with ESMTPSA id z19sm33071019ioh.12.2019.07.18.10.36.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 10:36:42 -0700 (PDT)
Subject: Re: [PATCH iproute2 net-next v4 5/6] tc: etf: Add documentation for
 skip-skb-check.
To:     Vedang Patel <vedang.patel@intel.com>, netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        stephen@networkplumber.org, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com, jakub.kicinski@netronome.com,
        m-karicheri2@ti.com
References: <1563306789-2908-1-git-send-email-vedang.patel@intel.com>
 <1563306789-2908-5-git-send-email-vedang.patel@intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <32e4deac-aaab-c437-1b76-529c16731877@gmail.com>
Date:   Thu, 18 Jul 2019 11:36:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1563306789-2908-5-git-send-email-vedang.patel@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/19 1:53 PM, Vedang Patel wrote:
> Document the newly added option (skip-skb-check) on the etf man-page.
> 
> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
> ---
>  man/man8/tc-etf.8 | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/man/man8/tc-etf.8 b/man/man8/tc-etf.8
> index 30a12de7d2c7..2e01a591dbaa 100644
> --- a/man/man8/tc-etf.8
> +++ b/man/man8/tc-etf.8
> @@ -106,6 +106,16 @@ referred to as "Launch Time" or "Time-Based Scheduling" by the
>  documentation of network interface controllers.
>  The default is for this option to be disabled.
>  
> +.TP
> +skip_skb_check

patch 1 adds skip_sock_check.

> +.br
> +.BR etf(8)
> +currently drops any packet which does not have a socket associated with it or
> +if the socket does not have SO_TXTIME socket option set. But, this will not
> +work if the launchtime is set by another entity inside the kernel (e.g. some
> +other Qdisc). Setting the skip_skb_check will skip checking for a socket
> +associated with the packet.
> +
>  .SH EXAMPLES
>  
>  ETF is used to enforce a Quality of Service. It controls when each
> 

