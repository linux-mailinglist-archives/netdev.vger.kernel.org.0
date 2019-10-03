Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F24ACAD77
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390403AbfJCRmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:42:23 -0400
Received: from mx2.ucr.edu ([138.23.62.3]:45431 "EHLO mx2.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732374AbfJCRmS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 13:42:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1570124537; x=1601660537;
  h=mime-version:references:in-reply-to:from:date:message-id:
   subject:to:cc;
  bh=2oSVnWrA/ed2JzasVs3JgdgieJU/Tv5Q4JjDOo4kYyI=;
  b=SpaGV/wayM93jNINO+cvDhmNcdyLInESdxEmD9+E8tDQPhnoMQ3jW1N5
   6g1N3IfICH01AxEldzCWLSVM4WVBLrHo3Oss9czziYzGtKLcODVVuS8Bp
   /OFrXEZEdjxqttoNf8EoRPMaCh8Yo+SSsbAXFqeUnTBHLy6bekthyEupC
   X3Q0nFfrTkkGPxomo2j5Q9CJXYFmMZv3KlM2VdgdsTLBnLs3enNQavuQ4
   aV1r5NkaDmvDLfe7sbIPhKUclRE4JOoXEC5BnvD5LrNm+rE9cQdPLcEef
   yoT1kYunZLVrA4Ih+SIomGYVvpaUZr5SO4+HdfUeSjxDXEOQnIZlsmPsf
   g==;
IronPort-SDR: jUAJvDFM+Gw5duK6SeyHcgDqirlZRuRCDqsT8gFMjNrN3hX+QTJo7XH7YFqlWRjCmag+BDcQs4
 gd+m1qDyxtOz9UfioO5+RAK1KhCPgKA8vXr278SvR7hPr7z1+srvN4dEvwcscuPi5vCsRrWkGN
 D4NyMGvfaReC67tsBgNKl+SLe437n6jBBQV84QWVKBSTGvVZFaHSYS2Iavq14sDhYuJPaal0gu
 nbAs3L8OwoKxsZz5SAel39tjBKCPzAaknH4kmofAR6cVBzLwEPP66P4dmj0yKLbrnl71oZ6KHz
 I6o=
IronPort-PHdr: =?us-ascii?q?9a23=3Ai8kVuB8+TazEYf9uRHKM819IXTAuvvDOBiVQ1K?=
 =?us-ascii?q?B41OocTK2v8tzYMVDF4r011RmVBN6dt6IP0rON+4nbGkU4qa6bt34DdJEeHz?=
 =?us-ascii?q?Qksu4x2zIaPcieFEfgJ+TrZSFpVO5LVVti4m3peRMNQJW2aFLduGC94iAPER?=
 =?us-ascii?q?vjKwV1Ov71GonPhMiryuy+4ZLebxhGiTanbr5/Lxq6oRjMusQYnIBvNrs/xh?=
 =?us-ascii?q?zVr3VSZu9Y33loJVWdnxb94se/4ptu+DlOtvwi6sBNT7z0c7w3QrJEAjsmNX?=
 =?us-ascii?q?s15NDwuhnYUQSP/HocXX4InRdOHgPI8Qv1Xpb1siv9q+p9xCyXNtD4QLwoRT?=
 =?us-ascii?q?iv6bpgRQT2gykbKTE27GDXitRxjK1FphKhuwd/yJPQbI2MKfZyYr/RcdYcSG?=
 =?us-ascii?q?FcXMheSjZBD5uzYIsBDeUPPehWoYrgqVUQsRSzHhWsCP/1xzNUmnP6wa833u?=
 =?us-ascii?q?I8Gg/GxgwgGNcOvWzWo9X0NaYSUf21zK7VxjrAb/NZwzb945XPfxEhoPCMXa?=
 =?us-ascii?q?h/ccvNxUUzGQ7IlUiQppD/Pz+PyOsCrnWb4vNmWOmyiGAnsxl8riazysookI?=
 =?us-ascii?q?XEhYIYxkra+Sllw4s5P8O0RFJnbdOiDZBerTuVN5FsTcMnW2xovSE6xaAYtp?=
 =?us-ascii?q?OjZygKzYgnxwbYa/yab4iE+hLjW/iVITd/nH9lfaiwhxe28US5zu38VNS43E?=
 =?us-ascii?q?9EriZbjtXAqmoB1xPU6siARft9+lmu1SyT2ADU7+FIOUE0lazFJJ492rM8iI?=
 =?us-ascii?q?YfvEDZEiL1mEj6lrGaelkn9+Sy9ejrfqnqqoeZN4BuiwH+Nqoumta4AeQ9Kg?=
 =?us-ascii?q?UPX2ma+eSm273i4UH1XLtHg+YrkqbFqpDWP9oUqbOkAwNNyIYs9w6/Dyu60N?=
 =?us-ascii?q?QfhXQHKkxKeA6agIf3JVHDO+74DfihjFS2ijtrxO7JPqfnAprTKnjPirDhfa?=
 =?us-ascii?q?xy6x0U9A1m4dlB5p4cL7AFJP/pEhv9vcLVCzc1OhK5xuLgBsk70I4CDzGhGK?=
 =?us-ascii?q?icZZLTo1+V4aodI+CNLNsEqjb0KqB9vNbzhmV/lFMAK/r6laALYWy1S6w1a3?=
 =?us-ascii?q?6SZmDh15JYST8H?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2EZAACmMpZdgMjQVdFlHAEBAQQBAQw?=
 =?us-ascii?q?EAQGBUwcBAQsBhA8qhCKIIoY7gg+TfoUogXsBCAEBAQ4vAQGEQAKCRiM0CQ4?=
 =?us-ascii?q?CAwkBAQUBAQEBAQUEAQECEAEBCQ0JCCeFQoI6KQGDPAEBAQEDEhEEUhALCwM?=
 =?us-ascii?q?GAQMCAh8HAgIiEgEFARwGEyKDAIILojOBAzyKMXV/M4hmAQkNgUgSeigBjA2?=
 =?us-ascii?q?CF4N1Lj6HUYJYBIE3AQEBlSuWUgEGAoIRFIxUiEQbgjqLeosMLadIDyOBL4I?=
 =?us-ascii?q?SMxolLVIGZ4FOUBAUggeOLiQwkV0BAQ?=
X-IPAS-Result: =?us-ascii?q?A2EZAACmMpZdgMjQVdFlHAEBAQQBAQwEAQGBUwcBAQsBh?=
 =?us-ascii?q?A8qhCKIIoY7gg+TfoUogXsBCAEBAQ4vAQGEQAKCRiM0CQ4CAwkBAQUBAQEBA?=
 =?us-ascii?q?QUEAQECEAEBCQ0JCCeFQoI6KQGDPAEBAQEDEhEEUhALCwMGAQMCAh8HAgIiE?=
 =?us-ascii?q?gEFARwGEyKDAIILojOBAzyKMXV/M4hmAQkNgUgSeigBjA2CF4N1Lj6HUYJYB?=
 =?us-ascii?q?IE3AQEBlSuWUgEGAoIRFIxUiEQbgjqLeosMLadIDyOBL4ISMxolLVIGZ4FOU?=
 =?us-ascii?q?BAUggeOLiQwkV0BAQ?=
X-IronPort-AV: E=Sophos;i="5.67,253,1566889200"; 
   d="scan'208";a="12603420"
Received: from mail-lj1-f200.google.com ([209.85.208.200])
  by smtp2.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Oct 2019 10:42:16 -0700
Received: by mail-lj1-f200.google.com with SMTP id v24so1076313ljh.23
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 10:42:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wd1GZqfs3ucUwfHbxzulPDp/Jo879CDaNWhNw++ir9w=;
        b=NU3+d4gad/7QN1gvGtxRmg4VlGphugp30q0/JMgqEoTWtiXzeWIB0RTaKKbZhQdyK4
         APE8g+8fIy3cB2r6/bSDI30WED2RD3bQUbBsKYz4Ks71NKTmSqmEJgz6A4mrW8+xiWU4
         n39gvYY5K2PiToGi7GKvZz1puC7Lo6AQaBDKdHkUE6VpbISYTK4w0sqe/OC7RKnYcA1N
         7rwzhKWgWgMBpOGSNITwIg0pyeR9TLDxOqnSvG9xgDQkLSurF8DOilF7HmEgi6AGYLl4
         gIByMlFbA5OXx2CcECh3ayws2UYcn58OCZ+7ys26wYxGnhwFer19f65YTIX1MwutiNaU
         z/eQ==
X-Gm-Message-State: APjAAAWIjNf0vQdeQJM5/doNC36SM0BCu8I7NI+28Lne6M59IKCYeSee
        TUSyO6eYzGQeuzZE7gvlNYFgqDANsavV7tzMbHNSCjnk/X+CSOCMU6yEsu+c88NpCpee23CpI7a
        8d0BDQKSaG5c465+wj2J7opqKJKSiSJyiYw==
X-Received: by 2002:a2e:89cd:: with SMTP id c13mr6816565ljk.92.1570124534491;
        Thu, 03 Oct 2019 10:42:14 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzgu0O4OmhLkdiHm32veyD7C/ytrOWhZhDZJotP5u235A/EygW4DdMB91Rj/Yujb4YY94JdkOSA+bQNUAlgoYs=
X-Received: by 2002:a2e:89cd:: with SMTP id c13mr6816554ljk.92.1570124534252;
 Thu, 03 Oct 2019 10:42:14 -0700 (PDT)
MIME-Version: 1.0
References: <20191001202439.15766-1-yzhai003@ucr.edu> <20191002.142214.252882219207569928.davem@davemloft.net>
In-Reply-To: <20191002.142214.252882219207569928.davem@davemloft.net>
From:   Yizhuo Zhai <yzhai003@ucr.edu>
Date:   Thu, 3 Oct 2019 10:42:58 -0700
Message-ID: <CABvMjLTzcwN5h+Fn-nNc4VcSr71skh-813u+mCb+EW5wGOT0+g@mail.gmail.com>
Subject: Re: [PATCH] net: hisilicon: Fix usage of uninitialized variable in
 function mdio_sc_cfg_reg_write()
To:     David Miller <davem@davemloft.net>
Cc:     Chengyu Song <csong@cs.ucr.edu>, Zhiyun Qian <zhiyunq@cs.ucr.edu>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David:

Thanks for your feedback. "regmap_write()" could also fail and cause
influence on the caller. If patches for "regmap_write()" are needed,
then the title could be changed from "uninitialized use" to "miss
return check".

On Wed, Oct 2, 2019 at 2:22 PM David Miller <davem@davemloft.net> wrote:
>
> From: Yizhuo <yzhai003@ucr.edu>
> Date: Tue,  1 Oct 2019 13:24:39 -0700
>
> > In function mdio_sc_cfg_reg_write(), variable "reg_value" could be
> > uninitialized if regmap_read() fails. However, "reg_value" is used
> > to decide the control flow later in the if statement, which is
> > potentially unsafe.
> >
> > Signed-off-by: Yizhuo <yzhai003@ucr.edu>
>
> Applied, but really this is such a pervasive problem.
>
> So much code doesn't check the return value from either regmap_read
> or regmap_write.
>
> _EVEN_ in the code you are editing, the patch context shows an unchecked
> regmap_write() call.
>
> > @@ -148,11 +148,15 @@ static int mdio_sc_cfg_reg_write(struct hns_mdio_device *mdio_dev,
> >  {
> >       u32 time_cnt;
> >       u32 reg_value;
> > +     int ret;
> >
> >       regmap_write(mdio_dev->subctrl_vbase, cfg_reg, set_val);
>         ^^^^^^^^^^^^
>
> Grepping for regmap_{read,write}() shows how big an issue this is.
>
> I don't know what to do, maybe we can work over time to add checks to
> all calls and then force warnings on unchecked return values so that
> the problem is not introduced in the future.



-- 
Kind Regards,

Yizhuo Zhai

Computer Science, Graduate Student
University of California, Riverside
