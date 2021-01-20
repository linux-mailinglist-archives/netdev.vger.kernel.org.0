Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6E12FCA37
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 06:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbhATE70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 23:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729214AbhATE5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 23:57:09 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865F3C061575
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 20:56:29 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id f22so3935873vsk.11
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 20:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1x0GvBrhIE3guQHtJT5d05YAxTfxBC5yIx0DKgzboo0=;
        b=e0Y27CFyZtVTyHkUlM8/q8VU8EBqnfqw5/Ic4BUKWtNqUflnH41Q8UiUaaY2oqMzAE
         SLj0aS8ko2QKga7Row1JhI0gR7f+Mi9R6F1TZYBky17qLDlsC0C4K6q68G4mVczg7obQ
         9Bpcn3Vz4sNNi1UBbxmsbvoOFA4XMmdHAw/3UxU4Ddp1yIvTNYDTOkhkjksALKj1v4rf
         KhpTja78Rp3JsoMSQwPrLeIaYzWniIblS0WKTd5ipc/VgQ3FZBNKHxFgN9dLUgyTbKhK
         G0127oSUIJffmjY+LTDmqBTgcJGRw8pZxxOYQjvj3oUg1ZO8VU6rrRol1QixhMp1nTRU
         mHjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1x0GvBrhIE3guQHtJT5d05YAxTfxBC5yIx0DKgzboo0=;
        b=Kf3dIi5QfsLK986sLJ703HQDvrG1a9/e1gp1i4GTcJLhgHsns/ZT2sJTyCXGNzUO4G
         jFpwq5BftET2VMJgi0/9wGzWHBuKB52N0xPWjqX7rmKcwSxn8GO9f2c/7J76/aZqhnDD
         zGUjpbYs/SKubyps4G/UQsxT1Mef89odB1r+ZPUGWGZc4W8jvZ//oKjoef1dSofvIVS3
         AiyO0ytYMezrRMGPtCokKX8hCcWnAcjxIECdxxoV9vlBv4QYF8S9C7GNV5FzR0PQzlMu
         8ybQ8K71nZvubFCmHMWowSlw1oU+nMsOa7tEK5pES4ykf6fnYC3f3ky8j0dRLeSucf2T
         eiag==
X-Gm-Message-State: AOAM533r8z3x5kEdLvlVfrNStRdNisq9kGisEwoR2ZLEV12qMYyAvvdW
        DYVKj2kfxUIr2FxXaAHNuND/yeij5IKmSfLG530=
X-Google-Smtp-Source: ABdhPJxzVRHoLND7MbF6oSWcHGeW+ZxipldGfDR+/G40d6NESKNN02vTnt5PLLOvb75RJhzeAmg/Ari+bdd6tUGJQUs=
X-Received: by 2002:a67:ec45:: with SMTP id z5mr5408650vso.10.1611118588754;
 Tue, 19 Jan 2021 20:56:28 -0800 (PST)
MIME-Version: 1.0
References: <20210118054611.15439-1-gciofono@gmail.com> <20210118115250.GA1428@t-online.de>
In-Reply-To: <20210118115250.GA1428@t-online.de>
From:   Giacinto Cifelli <gciofono@gmail.com>
Date:   Wed, 20 Jan 2021 05:56:18 +0100
Message-ID: <CAKSBH7H15a9zuYAhoc5RkUXM=9+2mZdKV5m8vYLkD3uTvRcqdA@mail.gmail.com>
Subject: Re: [PATCH] net: usb: qmi_wwan: added support for Thales Cinterion
 PLSx3 modem family
To:     Reinhard Speyerer <rspmn@t-online.de>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>, rspmn@arcor.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Reinhard,

>
> AFAIK the {QMI_FIXED_INTF(0x1e2d, 0x006f, 8)} is redundant and can simply
> be deleted. Please see also commit 14cf4a771b3098e431d2677e3533bdd962e478d8
> ("drivers: net: usb: qmi_wwan: add QMI_QUIRK_SET_DTR for Telit PID 0x1201")
> and commit 97dc47a1308a3af46a09b1546cfb869f2e382a81
> ("qmi_wwan: apply SET_DTR quirk to Sierra WP7607") for the corresponding
> examples from other UE vendors.
>
thank you for these suggestions.  Indeed I have removed that line,
retested, and the interface works properly.
I am submitting a v2 patch.

Regards,
Giacinto
