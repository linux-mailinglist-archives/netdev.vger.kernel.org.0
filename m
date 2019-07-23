Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B39C5722AC
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392493AbfGWW4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:56:17 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:42269 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfGWW4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 18:56:17 -0400
Received: by mail-io1-f67.google.com with SMTP id e20so55067200iob.9;
        Tue, 23 Jul 2019 15:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=uN8sWFnMgUwQhVsWfzdxgk/YSjqdWKUBI/qD1iRb5SI=;
        b=B91uWi0pz7pnGTkbsInU+RBKq/g5LBEM3mF6eMvV+0/E/rK9rdVzyu4sGh8jiqd2og
         eA/qw/2cVK8PzA93ngIVXrFVfZ+NqRjVwEP7pz8ljEi0PIbLshrzgIpwx88QxLQwb+xy
         vtYKDdt7WqPe/Bh2HthaTLqh6eJ394BAGMfDT9A4LgKAvFfrVQ+LgpcKDheCotjXysKT
         iPhmMjLgX2TyjkVNfuUdal1ECe20GnUkCICHdlQZ/f5ddWve1AWkgkhJQBL9Qy6AJcSA
         oMp2JhnGVBvGRpUgqRXrFef8d1rp7oY0wimQZ+Z5zr8uk2+BGpd1UnbpRa9qMfw29Rv3
         tlaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=uN8sWFnMgUwQhVsWfzdxgk/YSjqdWKUBI/qD1iRb5SI=;
        b=cIEzaN4BZvh+Qh6AdqWmkcTZL7iKBm+3WNrKhJw0u0CT6+fY8k4F6MHjgsGUgoRwt0
         zo5yFjwlaEFFI4q1l4bNXfF+1CJei3RyztobQExw59cdBkrDk5SLoR5wx3Jqo2BWesxv
         qC6PllNRaSheszzhxP/TrMXxral/Rv9zJFX5tAvviwHXypH9UOSCKMOiZtR0peXEsxBo
         nDIUK7oR3U2MBAH9p/9n3KWPeJLloZOuWwK4PW8rUszgZnJPGzj6b8YBaIq1wt4SjFoF
         HBIBtP+ZI4xxDIrn8z1EEnXzL1tdvlcLgXmzOW18aIpCcxOZpd3OceLUATKfo6ySexE4
         4cxQ==
X-Gm-Message-State: APjAAAVRNlBsv0c+W8r6W9m5+yXl3ePp4SlutwAJ4hovTxje6U1reJas
        Pg+2o8ugLvAreQjI21g5mwTFW/65rqJB7vy8rUA=
X-Google-Smtp-Source: APXvYqxBfw92BBe1j9zTk+R5FTp7j3ADLDtnopfxPlrkn4v1jzb7veb0SZtkW+ccyOMKKS08SSQFdQURvaGi87KvGvo=
X-Received: by 2002:a6b:d81a:: with SMTP id y26mr69555168iob.126.1563922576001;
 Tue, 23 Jul 2019 15:56:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190722030401.69563-1-skunberg.kelsey@gmail.com> <20190723185811.8548-1-skunberg.kelsey@gmail.com>
In-Reply-To: <20190723185811.8548-1-skunberg.kelsey@gmail.com>
Reply-To: bjorn@helgaas.com
From:   Bjorn Helgaas <bjorn.helgaas@gmail.com>
Date:   Tue, 23 Jul 2019 17:56:04 -0500
Message-ID: <CABhMZUVAcJwJpN8BKZTTU7jUW6881KdBtoYs_3kSn+tDtOVqNw@mail.gmail.com>
Subject: Re: [PATCH v2] drivers: net: xgene: Remove acpi_has_method() calls
To:     Kelsey Skunberg <skunberg.kelsey@gmail.com>
Cc:     iyappan@os.amperecomputing.com, keyur@os.amperecomputing.com,
        quan@os.amperecomputing.com, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 1:59 PM Kelsey Skunberg
<skunberg.kelsey@gmail.com> wrote:
>
> acpi_evaluate_object will already return an error if the needed method
> does not exist. Remove unnecessary acpi_has_method() calls and check the
> returned acpi_status for failure instead.

> diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c b/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
> index 6453fc2ebb1f..5d637b46b2bf 100644
> --- a/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
> +++ b/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
> @@ -437,6 +437,7 @@ static void xgene_sgmac_tx_disable(struct xgene_enet_pdata *p)
>  static int xgene_enet_reset(struct xgene_enet_pdata *p)
>  {
>         struct device *dev = &p->pdev->dev;
> +       acpi_status status;
>
>         if (!xgene_ring_mgr_init(p))
>                 return -ENODEV;
> @@ -460,14 +461,13 @@ static int xgene_enet_reset(struct xgene_enet_pdata *p)
>                 }
>         } else {
>  #ifdef CONFIG_ACPI
> -               if (acpi_has_method(ACPI_HANDLE(&p->pdev->dev), "_RST"))
> -                       acpi_evaluate_object(ACPI_HANDLE(&p->pdev->dev),
> -                                            "_RST", NULL, NULL);
> -               else if (acpi_has_method(ACPI_HANDLE(&p->pdev->dev), "_INI"))
> +               status = acpi_evaluate_object(ACPI_HANDLE(&p->pdev->dev),
> +                                             "_RST", NULL, NULL);
> +               if (ACPI_FAILURE(status)) {
>                         acpi_evaluate_object(ACPI_HANDLE(&p->pdev->dev),
>                                              "_INI", NULL, NULL);
> +               }
>  #endif
> -       }

Oops, I don't think you intended to remove that brace.

If you haven't found it already, CONFIG_COMPILE_TEST is useful for
building things that wouldn't normally be buildable on your arch.

>         if (!p->port_id) {
>                 xgene_enet_ecc_init(p);
