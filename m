Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497FE23192A
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 07:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgG2FhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 01:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgG2FhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 01:37:10 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88F0C061794;
        Tue, 28 Jul 2020 22:37:10 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id a65so7501268otc.8;
        Tue, 28 Jul 2020 22:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zuXA/WN2nlx83H9srxCo19LElvlaPaco/SoR1kFJVg0=;
        b=N++YDTwvJnJ4s9r+Jtio+v9Lqd0ElZdY+lozS2sh8rD0mRAl5vOSOdIa5XksrJNCX2
         Ok4Ezdg+kt4V6qADIsrcgGbDTKgpp6q5ywl/O+oX+QZ7/eEufWO2NrU+jeC34ifuovcv
         tHybsNBp9rQVu/R1nrBFcD8Y/qihGNGJvU2zQosLLaGwmridAZ+VY4E/5n7H5lLhGunZ
         Qn3GQDrhxsvtkNn4PV4CfecXXw0oqDZ9LwMn965d/xWHPpQ3WSrP9mjUwxVQGMRxHi6s
         Wc05RPcQNj1GjgL7gh9q3CuGrHtQrA8xt/DpQxHF7h0yH4qcp55qNBqL6k04cgiMu/nu
         ICVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zuXA/WN2nlx83H9srxCo19LElvlaPaco/SoR1kFJVg0=;
        b=IlIxhbHFtJIm8JvOxe1Un17CxAn56Ov9u8YHWjVvWXHTVaFl1mVtVFgm3FB2Q5Mpwi
         m2jgICsQeVBZzXVUVOp3kjNO6y87kDwV6JYq1SvHazc0AhO8xiG91i7P5Ym7upP0+7OI
         saGJnZnJyyqs0ohjdJ/NiWR2Oh/2cfsElN6x27jWNVY56ADaFnA6dIjBJcoO5L4gxd5l
         hEQnjBaTfBb3u76j+ykUcBEvY/HgmGwD11M4FWY5Ldw1IctQWNlv+dq5vc6wHKZ+a2Rt
         JdQ9XQhsG/8WX59KTv78iHblBL1c/B557KWkSrCVo9npXSbHKKT0dSrrMaPkDAt5iIlj
         ptHw==
X-Gm-Message-State: AOAM532HG7hKdM8TNeqCOlwuTovJAIrTcS6LkZBpuSnow3j8m9BANquB
        O0s2DcfX11dXWLd79VXCMGdFRuwJLyAXTVJG4AY=
X-Google-Smtp-Source: ABdhPJwXzoU/5XehKtvMsRaxuN/8/3yEG7bdRXxBKM15dtcQ6WOP64UKEj+QhDgL5ElWpRzZHNDVFLuaKyXy9fTHL2A=
X-Received: by 2002:a05:6830:4c8:: with SMTP id s8mr26530231otd.368.1596001030180;
 Tue, 28 Jul 2020 22:37:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200728182610.2538-1-dhiraj.sharma0024@gmail.com>
In-Reply-To: <20200728182610.2538-1-dhiraj.sharma0024@gmail.com>
From:   Dhiraj Sharma <dhiraj.sharma0024@gmail.com>
Date:   Wed, 29 Jul 2020 11:06:56 +0530
Message-ID: <CAPRy4h2Kzqj449PYPjPFmd7neKLR4TTZY8wq51AWqDrTFEFGJA@mail.gmail.com>
Subject: Re: [PATCH] staging: qlge: qlge_dbg: removed comment repition
To:     manishc@marvell.com, Greg KH <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

 I know that I should ask for reviews etc after a week but the change
is for my eudyptula task and until it doesn't get merged little
penguin will not pass the task for me so please look at it.


Thank You
Dhiraj Sharma

On Tue, Jul 28, 2020 at 11:56 PM Dhiraj Sharma
<dhiraj.sharma0024@gmail.com> wrote:
>
> Inside function ql_get_dump comment statement had a repition of word
> "to" which I removed and checkpatch.pl ouputs zero error or warnings
> now.
>
> Signed-off-by: Dhiraj Sharma <dhiraj.sharma0024@gmail.com>
> ---
>  drivers/staging/qlge/qlge_dbg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
> index 985a6c341294..a55bf0b3e9dc 100644
> --- a/drivers/staging/qlge/qlge_dbg.c
> +++ b/drivers/staging/qlge/qlge_dbg.c
> @@ -1298,7 +1298,7 @@ void ql_get_dump(struct ql_adapter *qdev, void *buff)
>          * If the dump has already been taken and is stored
>          * in our internal buffer and if force dump is set then
>          * just start the spool to dump it to the log file
> -        * and also, take a snapshot of the general regs to
> +        * and also, take a snapshot of the general regs
>          * to the user's buffer or else take complete dump
>          * to the user's buffer if force is not set.
>          */
> --
> 2.17.1
>
