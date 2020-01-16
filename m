Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67D6B13FC0F
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 23:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388369AbgAPWTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 17:19:19 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:46885 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730287AbgAPWTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 17:19:19 -0500
Received: by mail-oi1-f195.google.com with SMTP id 13so20349051oij.13
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 14:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HQ6NI3hAOyxut0DlXV7SKBOQkWQJgU/ToMDc1sI+DMU=;
        b=AbMbkqhLxfpe2NSsCNNuHxd9is8Zoq1owDEIMvTiNMIH+y1LqVKd2NmYGStN+VQp33
         4QsE65raYB4GvPQO42hDIhWi0B2UYm8ycD1xQoR2spQ+qIvXdzIqq2yOxWeQBav08fKQ
         jKOBgnqd3jgzfSZOJSVpmxqq5mtlstrkhsJeg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HQ6NI3hAOyxut0DlXV7SKBOQkWQJgU/ToMDc1sI+DMU=;
        b=cjrHF6VSGWUtLxAggFSrLjekWO1B31EQSC4TlKpVFbTi9CcR83a1t+cA6oCF1oviIj
         7kO0Fne9VQ/2bZ/oc/4xhuWiodLzxnZ6QcxVDB3jVqkminRnYAOCCfQrFCH/9Nwiia5e
         05wVpPgQQTZJGECIv4gFsQUY9BLy+sh3N0c+5o5qH1N/MCavXF5SJO99GPD0D69ou6TE
         KfBzXQRIkzdGy6Qb98gNEPhzJ52Wt3i1/749RPog+3an+PfJOrb47tbs81DaS9MWpQ+G
         Q4Tabfx2jo95ffQu3z+kePGN9d3X055zwoPW2etMao2EDdAOhkSE6MpzdozUaA+Zga71
         Oz+w==
X-Gm-Message-State: APjAAAWXGhebMsBVSqytsGCxZhJfwHso9P1SZy9axSE0MNlHidX7aKfr
        kyEpRsWftm53sKKp1oZhPqKhY9Y54QE3Wv/yN1Qcp7dV
X-Google-Smtp-Source: APXvYqyIDz0zv7ZiQP/ySnEkDwrr6l4CCI86+amQBGJKs92paKTVqLQDZGmc0LZV75xDfsQEeaLDbJJzPFU/xTRJILU=
X-Received: by 2002:aca:dd87:: with SMTP id u129mr1124655oig.14.1579213158511;
 Thu, 16 Jan 2020 14:19:18 -0800 (PST)
MIME-Version: 1.0
References: <CAH6h+hczhYdCebrXHnVy4tE6bXGhSJg4GZkfJVYEQtjjb-A-EQ@mail.gmail.com>
In-Reply-To: <CAH6h+hczhYdCebrXHnVy4tE6bXGhSJg4GZkfJVYEQtjjb-A-EQ@mail.gmail.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Thu, 16 Jan 2020 14:19:07 -0800
Message-ID: <CACKFLimgUxTV7Cgg5dYtWtvTsWpOK538UtLmyyxP0tTaYOzL6g@mail.gmail.com>
Subject: Re: 5.4.12 bnxt_en: Unable do read adapter's DSN
To:     Marc Smith <msmith626@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 2:08 PM Marc Smith <msmith626@gmail.com> wrote:
>
> Hi,
>
> I'm using the 'bnxt_en' driver with vanilla Linux 5.4.12. I have a
> Broadcom P225p 10/25 GbE adapter. I previously used this adapter with
> Linux 4.14.120 with no issues. Now with 5.4.12 I observe the following
> kernel messages during initialization:
> ...
> [    2.605878] Broadcom NetXtreme-C/E driver bnxt_en v1.10.0
> [    2.618302] bnxt_en 0000:00:03.0 (unnamed net_device)
> (uninitialized): Unable do read adapter's DSN
> [    2.622295] bnxt_en: probe of 0000:00:03.0 failed with error -95
> [    2.632808] bnxt_en 0000:00:0a.0 (unnamed net_device)
> (uninitialized): Unable do read adapter's DSN
> [    2.637043] bnxt_en: probe of 0000:00:0a.0 failed with error -95
> ...

I have received a similar report about this issue recently.  I believe
some kernels are not configured to read extended configuration space
and so the driver's call to read the DSN would fail on such a kernel.
This failure should not be considered a fatal error and the driver
should continue to load.  I will send out a driver patch to fix this
very shortly.

Thanks.
