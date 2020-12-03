Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596322CCD6A
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 04:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgLCDmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 22:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgLCDmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 22:42:45 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162CCC061A4D
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 19:41:59 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id f11so792543oij.6
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 19:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i/eobEHX219bnaFxWAsmav+2uvT51fnL/qvUipy6+Y4=;
        b=F2F3cidYL0JM3VoisCSqQUMY8bdtLm00RMk9k8MRPNfikQZBQc7DuGeYC3pWZwpNd0
         rlG4/0o2U3NeI460ksPambBh5mEp0CpRzfKg8Y4trnJJypw6ijNi87darmw1s2ZmMQhd
         WnlrbJ+a2I34ejCb/FUq3DoM/eieNKpI9cdKi49x/v46WB6Ci/k4lXJhv1BV8Rwj9rpv
         kY4RpsR9DAjZ++cQ8MIEQhCxIKOSGba1sxonKyNzfxHTDc3C8vtKQRqX5WVhRdR35FRw
         4fCIW7wEdgwXWV60k9t00Yv0+OAgvBeHk0QSbsA7pOj65aFvuj1M08XC9KloQ7q5TfPh
         e9wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i/eobEHX219bnaFxWAsmav+2uvT51fnL/qvUipy6+Y4=;
        b=Rw38lzkOw74sMfnVVFBUc/tbapsSwgTN0GNTst60Pfa5kX3x/jreILIaqJ8+aPwQm5
         juIz1xbbyce53XC18E8gjA/LpV0O+JMFuUX0rWEZk2pRlo9Nj9Xjnq4/j3jE97I8EB5h
         ZuQfy6x6Mr6IN7OOan7h7H8gCRpYuUxc7Qa0apGpzMuSbSDzfH58fIqGcrHax8kmYd/E
         eV6haAAiqIWZBB8ryEIkRyFC3u9pbqXk2Cc63hu2JxeVVyl28/WfvZoLQQhtMg7E4yR+
         GpyKEwV7/t99Br0xP97fQxU3WPS708sYg6oba72Tylfm/rMJZOm+62o9ZkCCjpqFoH5z
         XAGg==
X-Gm-Message-State: AOAM530MoEcthllhfTJVIXqRpqySGfimNBg8iVJdmmYyoJLESZV61Pi2
        jU7NbfIxgJwfTYiXYZ6J9YQ=
X-Google-Smtp-Source: ABdhPJxag7aCLUMCusSkG7uOd1hc6iT0kuX5y6gFOo3Q6a66lDkKxbEG/k6NQksdD2Zhcy6yxDD1uQ==
X-Received: by 2002:aca:61c5:: with SMTP id v188mr696880oib.66.1606966918515;
        Wed, 02 Dec 2020 19:41:58 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id i6sm36054oik.36.2020.12.02.19.41.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 19:41:57 -0800 (PST)
Subject: Re: [PATCH iproute2-next] devlink: Extend man page for port function
 set command
To:     Parav Pandit <parav@nvidia.com>, netdev@vger.kernel.org,
        stephen@networkplumber.org, dsahern@kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20201130164712.571540-1-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dcabfc2d-d376-ca0f-55e9-983380636298@gmail.com>
Date:   Wed, 2 Dec 2020 20:41:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201130164712.571540-1-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/20 9:47 AM, Parav Pandit wrote:
> Extended devlink-port man page for synopsis, description and
> example for setting devlink port function attribute.
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  man/man8/devlink-port.8 | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
> index 966faae6..7e2dc110 100644
> --- a/man/man8/devlink-port.8
> +++ b/man/man8/devlink-port.8
> @@ -46,6 +46,12 @@ devlink-port \- devlink port configuration
>  .ti -8
>  .B devlink port help
>  
> +.ti -8
> +.BR "devlink port function set "

The command exists in iproute2 main branch correct?

