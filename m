Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A823AFD3F
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 17:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfD3Pwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 11:52:42 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40202 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfD3Pwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 11:52:42 -0400
Received: by mail-pf1-f194.google.com with SMTP id u17so3299403pfn.7;
        Tue, 30 Apr 2019 08:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7/b+2duQICy1y+ecxJRYIc+INIY4RDrRkp1RL9mwtcs=;
        b=FaXTYEAztMGyzcxjHiz2aPnGm4sAuLKKicQuYzXk0v05EhoYiEKo+sdhFqVWRgoH3o
         O0c1lnUYx9fse5g6dXwhI13bGTY+1rmCJ7BrIpAeBWCxUNRCwklkyMKPUOQmm+v8ASw/
         eHGXBUxcZjhoUuGeZr8PHqyWlhkqBuPscIh9NSgEfCMBUoDclNMY7CzSOjsqmDK68Rmc
         yQoKhs46FhL2WsbOtM6qXO5mLC4rDc1HcSEAyGyNZoflvCR429gWfkhlhlvm6i7AxBNX
         TdhRey7G1j6z9OeCIEueCaKI/C2DaUg5thAdP7OXwD0/qbX/60XchRFmBvuuxS5xyoZA
         SITg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7/b+2duQICy1y+ecxJRYIc+INIY4RDrRkp1RL9mwtcs=;
        b=oA9m+ad5Sgme+VslzwcN1bRi+xDWcw0ZEXpxdGpUZP5QVB922XRYUzmUkaS5JBHjfO
         atWPg6gO684HDLn785zUgMdujXLJa8UxRkk12cGtN4QDMGQOp6CW/8SqBC+eP3+SC3rd
         iYUCCk4D7i+lnPnJXbP/lmw/3zYBnsSIzXpsRW88AZ+9MTrVHn1v90M5aztAPRADQf1X
         8CjR5M499CjN/2vHxQ1x32yXWAIYPqzQIRoFxozKo+QRmH0xwaU/ADxtpdslcluBpC5p
         wS1JdR3fxjfacUWsMYb4vB1fAVCenHBi3QWmUO1HPiL7d5sIr4zD+BCNYMjpSCt94owW
         VMSw==
X-Gm-Message-State: APjAAAU9iYZR3aOAsCd1MKef1qy9pxFAsLIva3dMxc8/TzXAr2JkXGwj
        PiEpHgafb+P+T1zrns7LBCwAfnt56JacQcIHY9g=
X-Google-Smtp-Source: APXvYqx0JQ/FmaJMdOQR+31KTzap5cQmFU0vz61jMjQS3XY4+Rf+IqSkMyhO5MlPJ+ZvIhHNb3U3lm3I9GiN4kljCOc=
X-Received: by 2002:a63:8e4b:: with SMTP id k72mr24604737pge.428.1556639561344;
 Tue, 30 Apr 2019 08:52:41 -0700 (PDT)
MIME-Version: 1.0
References: <59169e7b-d58c-8c7e-e644-f8a7c8f60188@siemens.com>
In-Reply-To: <59169e7b-d58c-8c7e-e644-f8a7c8f60188@siemens.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 30 Apr 2019 18:52:30 +0300
Message-ID: <CAHp75VexN0jBLun8s0MMOD3d5b+LsvuS9UFENyXLTeo0OFHHRQ@mail.gmail.com>
Subject: Re: [PATCH] stmmac: pci: Fix typo in IOT2000 comment
To:     Jan Kiszka <jan.kiszka@siemens.com>
Cc:     David Miller <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Su Bao Cheng <baocheng.su@siemens.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 8:51 AM Jan Kiszka <jan.kiszka@siemens.com> wrote:
>
> From: Jan Kiszka <jan.kiszka@siemens.com>
>

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
> index cc1e887e47b5..26db6aa002d1 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
> @@ -160,7 +160,7 @@ static const struct dmi_system_id quark_pci_dmi[] = {
>                 .driver_data = (void *)&galileo_stmmac_dmi_data,
>         },
>         /*
> -        * There are 2 types of SIMATIC IOT2000: IOT20202 and IOT2040.
> +        * There are 2 types of SIMATIC IOT2000: IOT2020 and IOT2040.
>          * The asset tag "6ES7647-0AA00-0YA2" is only for IOT2020 which
>          * has only one pci network device while other asset tags are
>          * for IOT2040 which has two.
> --
> 2.16.4



-- 
With Best Regards,
Andy Shevchenko
