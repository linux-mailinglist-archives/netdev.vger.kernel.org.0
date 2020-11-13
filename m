Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2812B165C
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 08:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgKMHZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 02:25:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgKMHZq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 02:25:46 -0500
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27CDC20797;
        Fri, 13 Nov 2020 07:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605252345;
        bh=fyFpUkmXI+91nudOGLPsLDWf4nslbcl2UmwUnjAtWFI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ao88GgYvL//H9ysQ6kM/seqVeaRDnZM2euh5tSokcvAk9dC8lo6dIhMXzCB3uKE+F
         rsn0ARIUSV4eg94M5yVD4XX8L8iMZdDkzOELlx0NEg22mxvfAGza2lTWYLE0dxD+ry
         YXsahSspGW91VegzwFgSi7UxJvEGhDYPNMc8V9rY=
Received: by mail-ej1-f46.google.com with SMTP id cw8so11861265ejb.8;
        Thu, 12 Nov 2020 23:25:45 -0800 (PST)
X-Gm-Message-State: AOAM530x5rGmAF07OC/RF19wrrpVmlQd2rABwOPgFKppbBrOlWHNdOzM
        dYEYpBxOUHu1Wkd21Ki4+/Et82Lpd9dQgb3nxIA=
X-Google-Smtp-Source: ABdhPJyuf/IEWcY2xcADRIotc8slqeZFRlQp07bGOyY/9HllRFvbQq3cMOXR/Ypc9RrYDYYh1g0MSLSIFDxtiRyAfIo=
X-Received: by 2002:a17:906:5618:: with SMTP id f24mr669714ejq.381.1605252343758;
 Thu, 12 Nov 2020 23:25:43 -0800 (PST)
MIME-Version: 1.0
References: <CGME20201113050719epcms2p7ba0a549e386259a01753714da1b79ea3@epcms2p7>
 <20201113050719epcms2p7ba0a549e386259a01753714da1b79ea3@epcms2p7>
In-Reply-To: <20201113050719epcms2p7ba0a549e386259a01753714da1b79ea3@epcms2p7>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Fri, 13 Nov 2020 08:25:32 +0100
X-Gmail-Original-Message-ID: <CAJKOXPePgqWQpJjOeJ9U0jcNG7et6heAid2HnrPeWTDKXLUgjA@mail.gmail.com>
Message-ID: <CAJKOXPePgqWQpJjOeJ9U0jcNG7et6heAid2HnrPeWTDKXLUgjA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] nfc: s3fwrn82: Add driver for Samsung
 S3FWRN82 NFC Chip
To:     bongsu.jeon@samsung.com
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 at 06:09, Bongsu Jeon <bongsu.jeon@samsung.com> wrote:
>
>
> Add driver for Samsung S3FWRN82 NFC controller.
> S3FWRN82 is using NCI protocol and I2C communication interface.
>
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  drivers/nfc/Kconfig             |   1 +
>  drivers/nfc/Makefile            |   1 +
>  drivers/nfc/s3fwrn82/Kconfig    |  15 ++
>  drivers/nfc/s3fwrn82/Makefile   |  10 ++
>  drivers/nfc/s3fwrn82/core.c     | 133 +++++++++++++++
>  drivers/nfc/s3fwrn82/i2c.c      | 288 ++++++++++++++++++++++++++++++++
>  drivers/nfc/s3fwrn82/s3fwrn82.h |  86 ++++++++++
>  7 files changed, 534 insertions(+)
>  create mode 100644 drivers/nfc/s3fwrn82/Kconfig
>  create mode 100644 drivers/nfc/s3fwrn82/Makefile
>  create mode 100644 drivers/nfc/s3fwrn82/core.c
>  create mode 100644 drivers/nfc/s3fwrn82/i2c.c
>  create mode 100644 drivers/nfc/s3fwrn82/s3fwrn82.h

No, this is a copy of existing s3fwrn5.

Please do not add drivers which are duplicating existing ones but
instead work on extending them.

Best regards,
Krzysztof
