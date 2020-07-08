Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5424C218DD2
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730655AbgGHRDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729897AbgGHRDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 13:03:16 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C8FC061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 09:55:17 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id p3so21946346pgh.3
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 09:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=IeE44RqauS6Zj6kYhwfpieJRLlC4OJTY0VSWQeGYTts=;
        b=XOv5nD+vj9+5Wdqg6E+NaFP+wTBiuecIdKLSL5HWg75dN3EWOaLPmqU3jSbnjiJeZo
         UheHpbX4I1G2JFFaaOoyi/dB/uzHzjbVDw/L4IJx5N2jTQaPuhQNzkGSsLMV//CWv8Pp
         HsdaPMfnR+BMbAJELy2f2P6BFbYgvV8TCMUUgFTZqN6R2KRzMI82IuBq5inJJm8RwbH/
         I4pH79LC0Nq8fNFn/CGEjq0YAfB8T9fED03A2WvlIoVP209NMlzCseZxeInRYHB0qITM
         xQio+CsVy0mIhr0+wZg3yegvaYLFhu/k9Un7yVXnIjsQpnrQMCWz7xYAUoEYsicqcxQ/
         7o3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IeE44RqauS6Zj6kYhwfpieJRLlC4OJTY0VSWQeGYTts=;
        b=KJMDhtg1f1aMNLS3rwJiJ5CRDc7VvJFnvKu4DmoxZAqSN5eFRjiHU7H7RWRJwJUOcR
         t5DTyTZU9R9yaet8U67kISfuH6ULjAHTbuSX1UJocdz0o/92efdVU7wjjFb0cKemnVoG
         1Z97qOPV3Bv2kW7g9m9wsWs2XM0/IdwPcwBSY2Ld/hTuPSI6NCdo0NMiJIpIxeuXyxXP
         FNTFSO7KZkSglyBsy+sk8QHFSV11QZ7+UVSS8fO606+WiaKiZhqjKYYBCQSjDDqAu+rT
         GQuoKFSw4TYzaxWIBBJQUdhLbi2PvblT+cHQE4r8ZpOgorrdAfjPR4X3HXZJTra8Gc86
         9RDQ==
X-Gm-Message-State: AOAM530KqtsfEEzEB4LEqNqwTNoBBG6EDlAIbIS4xVD+kk3A1LKwkite
        EUU+DlRVDgBdXOynOETAmfpAEfy/
X-Google-Smtp-Source: ABdhPJzLez5W+xDspDf4FhEs0HbEFC7eD0MNRw1Jhp6jF3eoU+AansoZgN80AwOUypnVuQ+PnPa0zQ==
X-Received: by 2002:a62:3207:: with SMTP id y7mr2484088pfy.95.1594227316548;
        Wed, 08 Jul 2020 09:55:16 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id l9sm160719pjy.2.2020.07.08.09.55.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 09:55:15 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/2] irq_work: Export symbol
 "irq_work_queue_on"
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <12188783-aa3c-9a83-1e9f-c92e37485445@alibaba-inc.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e71cfd58-f639-24a7-ffb8-ebe3d74422a2@gmail.com>
Date:   Wed, 8 Jul 2020 09:55:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <12188783-aa3c-9a83-1e9f-c92e37485445@alibaba-inc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/20 9:38 AM, YU, Xiangning wrote:
> Unlike other irq APIs, irq_work_queue_on is not exported. It makes sense to
> export it so other modules could use it.
> 
> Signed-off-by: Xiangning Yu <xiangning.yu@alibaba-inc.com>
> ---
>  kernel/irq_work.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> index eca83965b631..e0ed16db660c 100644
> --- a/kernel/irq_work.c
> +++ b/kernel/irq_work.c
> @@ -111,7 +111,7 @@ bool irq_work_queue_on(struct irq_work *work, int cpu)
>  	return true;
>  #endif /* CONFIG_SMP */
>  }
> -
> +EXPORT_SYMBOL_GPL(irq_work_queue_on);
>  
>  bool irq_work_needs_cpu(void)
>  {
> 


??? You no longer need this change, right ???

