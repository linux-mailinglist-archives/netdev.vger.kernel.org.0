Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA0220B0D1
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgFZLrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726972AbgFZLrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:47:41 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D975C08C5DB;
        Fri, 26 Jun 2020 04:47:41 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d66so4545795pfd.6;
        Fri, 26 Jun 2020 04:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qQNGW1ubfzePDn/nTOZGpiUilVnPMC5Ou6eBIhQTrzs=;
        b=ODOylG7bpS1L8pej1mt62biajx9xwQFo0p9iDxsI/oGwkmPvMJ/0GXIWzTv6TN0P6+
         CHLJtwm0Ry5loEGOYSS5DJuEz6ybKhjiqHa8FFY+bcoC8O0ohxSAFeWMSl5jLCp8cqgk
         ayPh9Rhgrirl2xGv1L5KQu3VK8uLBB108tHDqEJuX8ZlMjUgpA4wNXA8tUelglqkPChg
         RnWCHye7vZsA4kVvVyWl/8fLU0fTgmje3cvLpPyYfHIyy/rWNWQQs+MIfdmGAuUUT4Er
         UqGjTOTC1pUntLCWjCu81H4pt1y4JspScJCcYnB2DzxNGeb1qv6JC7H/yQ2mmB+4gmL/
         q3Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qQNGW1ubfzePDn/nTOZGpiUilVnPMC5Ou6eBIhQTrzs=;
        b=mIHxUSBM4Z1c8ZprZie5SMA7vCgoykzIltsa6TUVvLOh62xFaK7KYnCfsdnltWwufn
         3QURB+nscq0UpDuDmgpOpTECHEdZ4W2zRTXhGV0R2qp0tMZtBZv7byaCcXpwijBR8gZq
         Me0ad1mQpoacnli8jqzNUFQ2QNPDz8GjlCYv2eupj6yM/wQ6pxxrXUvkjs0zP9Xurl7F
         6R2FhoauzYZSEA4O4uKNXiFKIYbsFFgYswcpdC1RFxIdsdK3Yc7CoNPpdnusWX4oxpwO
         nXt0yxal7SJQXqpEJedsYIv+Yd4kTn0ZShuTn2ZSGKXbhTayOUpcyem3ikQInE72tdPq
         Gf0A==
X-Gm-Message-State: AOAM531FfEvvda8Z4GK0WziuR2lSOkERgkHLB7NU9nc7ZArLsdKvHSsW
        vEvHTlJmc50KrwhuEmBnYHg=
X-Google-Smtp-Source: ABdhPJyNQB41X8+JmdMeQ2PuQfgsiTxZvhldBnutus1649bWIwUSZJPdWiPXZL9wKFWrHZzkJEZ0fw==
X-Received: by 2002:aa7:98c6:: with SMTP id e6mr2460572pfm.17.1593172060828;
        Fri, 26 Jun 2020 04:47:40 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id o1sm11077238pjp.37.2020.06.26.04.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 04:47:40 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Fri, 26 Jun 2020 19:47:33 +0800
To:     Joe Perches <joe@perches.com>
Cc:     devel@driverdev.osuosl.org, Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: qlge: fix else after return or break
Message-ID: <20200626114733.ffjbwy7uooz2i73x@Rk>
References: <20200625215755.70329-1-coiby.xu@gmail.com>
 <20200625215755.70329-3-coiby.xu@gmail.com>
 <049f51497b84e55e61aca989025b64493287cbab.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <049f51497b84e55e61aca989025b64493287cbab.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 03:13:14PM -0700, Joe Perches wrote:
>On Fri, 2020-06-26 at 05:57 +0800, Coiby Xu wrote:
>> Remove unnecessary elses after return or break.
>
>unrelated trivia:
>
>> diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
>[]
>> @@ -1391,12 +1391,11 @@ static void ql_dump_cam_entries(struct ql_adapter *qdev)
>>  			pr_err("%s: Failed read of mac index register\n",
>>  			       __func__);
>>  			return;
>> -		} else {
>> -			if (value[0])
>> -				pr_err("%s: CAM index %d CAM Lookup Lower = 0x%.08x:%.08x, Output = 0x%.08x\n",
>> -				       qdev->ndev->name, i, value[1], value[0],
>> -				       value[2]);
>
>looks like all of these could use netdev_err
>
>				netdev_err(qdev, "etc...",
>					   i, value[1], value[0], value[2]);
>
>etc...
>
Interestingly, scripts/checkpatch.pl couldn't detect this problem.
I once used printk(KERN_ALERT...) and the script would properly warn me
that,

     WARNING: Prefer [subsystem eg: netdev]_alert([subsystem]dev, ... then dev_alert(dev, ... then pr_alert(...  to printk(KERN_ALERT .

I'll fix this issue when sending another version of the patches. Thank
you for the reminding!

--
Best regards,
Coiby
