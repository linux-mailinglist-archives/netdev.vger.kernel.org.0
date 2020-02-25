Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3B7E16B6B7
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 01:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgBYAaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 19:30:23 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42662 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbgBYAaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 19:30:23 -0500
Received: by mail-pf1-f194.google.com with SMTP id 4so6230444pfz.9;
        Mon, 24 Feb 2020 16:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l/HYeO0SZpS2mVUEBc8APQcdfzEO6/5KedHOJbsf1+0=;
        b=d+skt2sBbLEVjHlgxNGLIubTJBeEodN4PlxOzAs5oAvGHhQqltucdP6v5tOf6XcYMX
         cRz6VpU8Q2zwK8I/YGoCcvi2U8KE6bVvbziI5ANX7sDgjF5OCQugJ/0MUpMlvShH3mvr
         +Rhyagz/9IKvIMjzA/UDGl/8uCo79t8W2QIeuDZM6m3u8Rmb7/Rz4UdPG/y1yQuHePZf
         iKxR+9gGm2tepBJIw9wJjT4/OBOO13/XPzB7vsspr6WqM8jZ5PilKldvGJi/7DQxKlj/
         KejvBoO03k0GXlqOD0ip8YO01dxBuBwlvnnbHz4gvCTA7rdrzpfSrSfCc6/K76/bi15e
         i36g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l/HYeO0SZpS2mVUEBc8APQcdfzEO6/5KedHOJbsf1+0=;
        b=dMcKhX1Zm7fCLqB2ZJOrfvclRpu2inM4ih9GxTrRZ+JGUOZwOWE6XFXfA7uYS7XtA+
         FOxx+cLMC1XWi10kAGDz+PZMbkXdDwJlOgbvzBnszZY8SNWkCdkLrHaCGj5c4NXqrz7U
         dlymXGsOIxNamGValoBTtXYYY1CM2XjmCQY+ZbbFvwKVhEr6Q5o+wWDzlCCFo2hysGr8
         QPmmxNLQNSSsHjB3O7i50q/7ekoARU1juSdnQBYgoWApZWEL8fr8q0QePwmoq1VMIFzW
         KyHh6IMFzvkX+y+pRDa7DJ+u6wI/npaqGpoWrOx/w2YRVt4IQUtOxel3GPF146x0Jgkr
         jdcw==
X-Gm-Message-State: APjAAAXiXxfFiVm5zNg1FInQ7YoMPd9EnlTIVdByz3vbPmnMLKwGBH66
        WJwFJlBMVUTbzWTeTDyq5m1dSudojz8=
X-Google-Smtp-Source: APXvYqx/y0zhrSvkI4rUBOZfz0EjA3mPwVjbL5QtqAqm8B32FetJzyy3bYZGWGpfGrC3ye4Nc8uDsA==
X-Received: by 2002:a63:1044:: with SMTP id 4mr57319701pgq.412.1582590622846;
        Mon, 24 Feb 2020 16:30:22 -0800 (PST)
Received: from f3 (ag119225.dynamic.ppp.asahi-net.or.jp. [157.107.119.225])
        by smtp.gmail.com with ESMTPSA id y190sm14543502pfb.82.2020.02.24.16.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 16:30:21 -0800 (PST)
Date:   Tue, 25 Feb 2020 09:30:16 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Kaaira Gupta <kgupta@es.iitr.ac.in>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linxfoundation.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: add braces around macro arguments
Message-ID: <20200225003016.GA360989@f3>
References: <20200221195649.GA18450@kaaira-HP-Pavilion-Notebook>
 <20200224053225.GB312634@f3>
 <20200224075231.GA4806@kaaira-HP-Pavilion-Notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224075231.GA4806@kaaira-HP-Pavilion-Notebook>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/02/24 13:22 +0530, Kaaira Gupta wrote:
> On Mon, Feb 24, 2020 at 02:32:25PM +0900, Benjamin Poirier wrote:
> > On 2020/02/22 01:26 +0530, Kaaira Gupta wrote:
> > > Fix checkpatch.pl warnings of adding braces around macro arguments to
> > > prevent precedence issues by adding braces in qlge_dbg.c
> > > 
> > > Signed-off-by: Kaaira Gupta <kgupta@es.iitr.ac.in>
> > > ---
> > >  drivers/staging/qlge/qlge_dbg.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
> > > index 8cf39615c520..c7af2548d119 100644
> > > --- a/drivers/staging/qlge/qlge_dbg.c
> > > +++ b/drivers/staging/qlge/qlge_dbg.c
> > > @@ -1525,7 +1525,7 @@ void ql_dump_regs(struct ql_adapter *qdev)
> > >  #ifdef QL_STAT_DUMP
> > >  
> > >  #define DUMP_STAT(qdev, stat)	\
> > > -	pr_err("%s = %ld\n", #stat, (unsigned long)qdev->nic_stats.stat)
> > > +	pr_err("%s = %ld\n", #stat, (unsigned long)(qdev)->nic_stats.stat)
> > >  
> > >  void ql_dump_stat(struct ql_adapter *qdev)
> > >  {
> > > @@ -1578,12 +1578,12 @@ void ql_dump_stat(struct ql_adapter *qdev)
> > >  #ifdef QL_DEV_DUMP
> > >  
> > >  #define DUMP_QDEV_FIELD(qdev, type, field)		\
> > > -	pr_err("qdev->%-24s = " type "\n", #field, qdev->field)
> > > +	pr_err("qdev->%-24s = " type "\n", #field, (qdev)->(field))
> > >  #define DUMP_QDEV_DMA_FIELD(qdev, field)		\
> > >  	pr_err("qdev->%-24s = %llx\n", #field, (unsigned long long)qdev->field)
> >                                                                    ^^^^
> > You missed one.
> 
> It makes the line characaters greater than 80. Shall I still add braces?
> I mean it's better that I add them to prevent precedence issues, but it
> adds another warning, hence I wasn't sure.

Generally speaking, it's ok to spread the macro body onto multiple
lines.
In this case, it would be better to replace this printk format type with
"%pad". See Documentation/core-api/printk-formats.rst
