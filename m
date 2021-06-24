Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DC93B2705
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 07:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhFXFxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 01:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbhFXFxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 01:53:41 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FB5C061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 22:51:09 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id a13so5173494wrf.10
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 22:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t4ISMUcRmX6Ch5CMg+5GMKJ6odpf8T/aWVd13rXF/EY=;
        b=ZNH6xfSRic6oz11HyqcqDgTAD4ubtfrjxgJY/NCvZQP/aeCAVvRexscAS0Pf/H5U1y
         1zXyX2G4PBBuYA20Ydf4/za1OClhAdeVj2hFi2czCDQQ252Ggv/p/oOUh6skkDXu0fOb
         87mHKUtHlRPwflUp0p9IR8l7QE/xQrAeBldpzuMx5u6Dl9x2SeKK8O51KRV67XUMFTia
         I881qlyj+/+T0iD8wANKDMRksV/b5EnWpq1B6pckOtPL91p4Qa0oFsB10qBMhd1ItlOz
         WiXfYY8Iwn3mCOXdIExrPLH43lMEki6sTUG6HPt0ijSXAnGogY4tjX9khMPoH4F0N7MS
         kLgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t4ISMUcRmX6Ch5CMg+5GMKJ6odpf8T/aWVd13rXF/EY=;
        b=h02GMxofWhz9wkZPEAJ5K+pbjNW9rCxMtIV1jMHR0AY8ri/nw2xxbU5NdZTqd0nM55
         vKHYLIA7N3lswYj7y31EODgVVrSQ3dzcUlZENdwAUanbDwlV6n2fA5sieimOpo0fMtM3
         dLWtu8epWkMzXgqjATQWrWH7Jph4u6kwOVHRokhjITvB+sv+8chVW7mexuewPDAlyYNu
         XOPRXxhBs8ZHjompMuQ4UaQod92+a9TGvSwMIm/F+NucP2AJ+BcD+fGNVWmHJAfBy7FF
         ZLfu2AQcNgsBZdOhaaYqRhYL6TQLH/ObSrilSCx07C/Z7FIvxxy/CnTvQg0smqq8ywB1
         3HEg==
X-Gm-Message-State: AOAM532qTRxPOH18wGhb7zZrVvVPIBix9QDSbkqBeH3QtUB70EwRSB/S
        HOS4pxPCDODtGppMo7zFXdGYq38Fn5T3E7fFiGc=
X-Google-Smtp-Source: ABdhPJzcNRCuS9siX5ch95kB6otCrU8ON/F1ijiFw3qq7x+oLShtKpBuMW+Xcw1MEYn5eGZjX8XMR/ZiNAZ/v12gwaA=
X-Received: by 2002:a5d:6783:: with SMTP id v3mr2198335wru.217.1624513867726;
 Wed, 23 Jun 2021 22:51:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210624041316.567622-1-sukadev@linux.ibm.com> <20210624041316.567622-8-sukadev@linux.ibm.com>
In-Reply-To: <20210624041316.567622-8-sukadev@linux.ibm.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Thu, 24 Jun 2021 00:50:57 -0500
Message-ID: <CAOhMmr7vpmgQPSJ7Ga0kbCU++QsoaFnd7KetWp38mszad7=Xmw@mail.gmail.com>
Subject: Re: [PATCH net 7/7] ibmvnic: parenthesize a check
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Brian King <brking@linux.ibm.com>,
        Cristobal Forno <cforno12@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 11:17 PM Sukadev Bhattiprolu
<sukadev@linux.ibm.com> wrote:
>
> Parenthesize a check to be more explicit and to fix a sparse warning
> seen on some distros.
>
> Fixes: 91dc5d2553fbf ("ibmvnic: fix miscellaneous checks")
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index 363a5d5503ad..697b9714fc76 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -3367,7 +3367,7 @@ static int enable_scrq_irq(struct ibmvnic_adapter *adapter,
>                 /* H_EOI would fail with rc = H_FUNCTION when running
>                  * in XIVE mode which is expected, but not an error.
>                  */
> -               if (rc && rc != H_FUNCTION)
> +               if (rc && (rc != H_FUNCTION))

It is unnecessary and this is not an issue with the latest sparse.
Just curious what was the version on that distro?
