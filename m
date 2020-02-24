Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F5B169DCB
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 06:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgBXFce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 00:32:34 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34665 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgBXFcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 00:32:33 -0500
Received: by mail-pg1-f195.google.com with SMTP id j4so4530887pgi.1;
        Sun, 23 Feb 2020 21:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gmAc8ivr/C7d+QzZGVBXrbDmIH8je8z/sIj0mHBkKGA=;
        b=ZWrpZPkwcspILxRqZCPH6tehznrkWPgVYfNG0SD2upeoyUXb2JLfL7V8pdTjmALv0S
         +JADJ8tHoCASKaF0JZPZDYLtP+dyWdjrRL9md1pi6U2CvIaiBRLL2/oulbtKziwqEpEX
         jfDoCmYscWwSCtgfxTLf0hfKSbWa0RlcjEFt9n5ZZ89ECzhLBm6S97D5Q3hGtHH3mbi7
         q2lLJCeowTs88oR0wkYSShUwFfqhe8HymVHK+F1khjwVYT+fdB6q7ZLc5dLEnMw+RCIb
         pWLlzM2EP5kESxosnQWxBnEcv1ESO7Ld7CkPd6VltMfOI0r77iMlOrXSMsIhaqzR84CJ
         zE8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gmAc8ivr/C7d+QzZGVBXrbDmIH8je8z/sIj0mHBkKGA=;
        b=h9OmwCGixfXUVNbS1LvSazBcPhb0hL2GwK5Vkp2wz2VGRL7BNMrGIJ/ZUSo3qncVFB
         AFMA0V/AqEcC8RWUMT5ctEYSu+m4pIOrj5wAMCOiq4v4qbsv/VbaHT3mDhAAYpGbMSrF
         TbKDnFPQ4APmta9U8Ma1SBodKKEdTJUCjgACe/NKUTyCihhTr4OijBHdASTlZ3ITjq1T
         fwf2tfEiU9QBYoLUmdT215cMA8z2GdmuEHn5BBzzZtr+xdggG+oMFllIGuEH5dOitZE3
         uSxpHFis+opBhsI6seMu/gx4vAUq5mqghuS/CY72Yt6AbHA2b6jz6wJNMlZWG44x4SdR
         I/5Q==
X-Gm-Message-State: APjAAAWq2BhN76jEyMtd9BTltn5U2DnqKQQ7TtYoT8MD4hR89gusQXYK
        jrd+nuk5vm+LdlDhq3K7cAs=
X-Google-Smtp-Source: APXvYqw2+OoNUwC+DHYLkIWINIDRLfS6iaF7yKwT/NrQkJuKpO0+htrhpSkg4MTKvnr4RSsOJ2K1Xg==
X-Received: by 2002:aa7:8804:: with SMTP id c4mr50981283pfo.214.1582522352952;
        Sun, 23 Feb 2020 21:32:32 -0800 (PST)
Received: from f3 (ag119225.dynamic.ppp.asahi-net.or.jp. [157.107.119.225])
        by smtp.gmail.com with ESMTPSA id z10sm10489746pgf.35.2020.02.23.21.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 21:32:31 -0800 (PST)
Date:   Mon, 24 Feb 2020 14:32:25 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Kaaira Gupta <kgupta@es.iitr.ac.in>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: add braces around macro arguments
Message-ID: <20200224053225.GB312634@f3>
References: <20200221195649.GA18450@kaaira-HP-Pavilion-Notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221195649.GA18450@kaaira-HP-Pavilion-Notebook>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/02/22 01:26 +0530, Kaaira Gupta wrote:
> Fix checkpatch.pl warnings of adding braces around macro arguments to
> prevent precedence issues by adding braces in qlge_dbg.c
> 
> Signed-off-by: Kaaira Gupta <kgupta@es.iitr.ac.in>
> ---
>  drivers/staging/qlge/qlge_dbg.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
> index 8cf39615c520..c7af2548d119 100644
> --- a/drivers/staging/qlge/qlge_dbg.c
> +++ b/drivers/staging/qlge/qlge_dbg.c
> @@ -1525,7 +1525,7 @@ void ql_dump_regs(struct ql_adapter *qdev)
>  #ifdef QL_STAT_DUMP
>  
>  #define DUMP_STAT(qdev, stat)	\
> -	pr_err("%s = %ld\n", #stat, (unsigned long)qdev->nic_stats.stat)
> +	pr_err("%s = %ld\n", #stat, (unsigned long)(qdev)->nic_stats.stat)
>  
>  void ql_dump_stat(struct ql_adapter *qdev)
>  {
> @@ -1578,12 +1578,12 @@ void ql_dump_stat(struct ql_adapter *qdev)
>  #ifdef QL_DEV_DUMP
>  
>  #define DUMP_QDEV_FIELD(qdev, type, field)		\
> -	pr_err("qdev->%-24s = " type "\n", #field, qdev->field)
> +	pr_err("qdev->%-24s = " type "\n", #field, (qdev)->(field))
>  #define DUMP_QDEV_DMA_FIELD(qdev, field)		\
>  	pr_err("qdev->%-24s = %llx\n", #field, (unsigned long long)qdev->field)
                                                                   ^^^^
You missed one.
