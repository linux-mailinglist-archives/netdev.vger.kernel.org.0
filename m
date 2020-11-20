Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A902BA2E1
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 08:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgKTHRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 02:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgKTHRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 02:17:14 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14414C0617A7
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 23:17:14 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id b16so6475584qtb.6
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 23:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qzTq7FPGo6/MP/RsOybH3FHhc+4mwCcb1wEQQuX3PV8=;
        b=TDqJwx+q+tGy+4L9Jf7wALS5oAPcgBKvPGxWQN+lv3/xeB1l8kx1jWcOXeEMAtCTo7
         WC8DYJ0dmxc6Z5rvNgIppaGbjpo2av3C9m2cAvpJLuOdcVGEt/AyUlkZv/DVMalvjEaw
         hgvWI4SSC/QH/V1Yu2QnLGq8Tzk0mFZ0JOz2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qzTq7FPGo6/MP/RsOybH3FHhc+4mwCcb1wEQQuX3PV8=;
        b=eSMzPig2t7Fn5Noo6wPIN0qhzElZNOzc0Dw5oDZSgyOI79J1GiHfR3kVSARwriMsaA
         6SpQsY7pBbFEPRGD+ivIql78oxSvKSCvkw+5YokUHVG3z7cAO5BXaF1VOTddPen1THuL
         YVNEXOQAVGNSSEuWSjQpppou/J5hGybZrxOQKk3FYCPGN4cnLnZLdybMftHdkDLwSceC
         QDs/IjxNaGNVWOuWfPbXlYs9ZtGNe+84yhOfa51f2j498aDzJoBrnbGJF0x44PtcRBO5
         Tc+M87ZQmmRMvMrLtTYjHyQ9gle0IxhbSLEbZK+OSE13kpBSWFA6QC8oTkhKa4ru3RVn
         5IGA==
X-Gm-Message-State: AOAM531AATDySO31HuQIVic7VGbZD5vS7a4rBtWUFl/Dc3iQhfbuksWa
        XgQYJrOS0rpgSyNwzgPh4qletv0jRlIQyXR57Y8kyg==
X-Google-Smtp-Source: ABdhPJx/eC9KnP7s2NwSVaEcdk04k18m7EKL83AP6lLCbA027oPQLUgOEbP/71EKYM87y4byuAR+jMUKOJmcTDbufBk=
X-Received: by 2002:ac8:74c9:: with SMTP id j9mr14398512qtr.208.1605856632944;
 Thu, 19 Nov 2020 23:17:12 -0800 (PST)
MIME-Version: 1.0
References: <1605792621-6268-1-git-send-email-zhangchangzhong@huawei.com>
 <CAKOOJTyJ_R6cTij0uZweOm2aFCDg+AG3qGcOSb=wsOSQKzL60g@mail.gmail.com> <20201119215309.0f9c4b82@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201119215309.0f9c4b82@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Thu, 19 Nov 2020 23:17:01 -0800
Message-ID: <CACKFLimkjTmZZe4Wpy0YERit=nVa6tPkUQ9L5Pwx4gYg-=Qc7w@mail.gmail.com>
Subject: Re: [PATCH net] bnxt_en: fix error return code in bnxt_init_board()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Edwin Peer <edwin.peer@broadcom.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Jeffrey Huang <huangjw@broadcom.com>,
        Eddie Wai <eddie.wai@broadcom.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000032807605b484a2c9"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000032807605b484a2c9
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 19, 2020 at 9:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 19 Nov 2020 10:53:23 -0800 Edwin Peer wrote:
> > > Fix to return a negative error code from the error handling
> > > case instead of 0, as done elsewhere in this function.
> > >
> > > Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
> > > Reported-by: Hulk Robot <hulkci@huawei.com>
> > > Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
>
> > >         if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) != 0 &&
> > >             dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)) != 0) {
> > >                 dev_err(&pdev->dev, "System does not support DMA, aborting\n");
> > > +               rc = -EIO;
> > >                 goto init_err_disable;
>
> Edwin, please double check if this shouldn't jump to
> pci_release_regions() (or maybe it's harmless 'cause
> PCI likes to magically release things on its own).

Good point.  We definitely should call pci_release_regions() for correctness.

I will send out the patch shortly.  Thanks.

--00000000000032807605b484a2c9
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ENt96uQJNu/QKZCsRxnu8bu9XkzIQTTFs7+NKghvf+h9ck5SSEvV5vlzS8HDlhKReyLBOxx5AgMB
AAGjggHQMIIBzDAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsGAQUFBwEBBIGRMIGOME0GCCsGAQUFBzAC
hkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3BlcnNvbmFsc2lnbjJzaGEy
ZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL2dzcGVy
c29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYm
aHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBEBgNVHR8E
PTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJn
My5jcmwwJAYDVR0RBB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUyZbpLEwR
KZHEh+rXp6GbCZmMEwUwDQYJKoZIhvcNAQELBQADggEBADZsABrJEwqeVLJJcX+rKN/oFPl/Sb1f
4NQRqf0J5IHlqI7oSUUaSVHviPvq4QyTMh7P9KHkuTwANTnTPr4f4y1SirdtxgZKy1xDmt1KjL5u
nA4rBLSA+Kp/mo0DMxKKQY/LsZNS3Zn+HIAZpXTUEFotC5qgN35ua7sP0hTynKzfLG8Fi565tQkX
Si7Gzq+VM1jcLa3+kjHalTIlC7q7gkvVhgEwmztW1SuO7pJn0/GOncxYGQXEk3PIH3QbPNO8VMkx
3YeEtbaXosR5XLWchobv9S5HB9h4t0TUbZh2kX0HlGzgFLCPif27aL7ZpahFcoCS928kT+/V4tAj
BB+IwnkxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMC
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgxxIFE55jo398
uO8oTDVEC9icVroqXn6P8oIALWaC6IQwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAxMTIwMDcxNzEzWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAAEj+RDzZkJa75XuqsEFIILhx2BWhcuv
C7Vp+pOmiHH3TRkF1Ll1dXxEX9djxyvKTQdFZHr3NnInOe9UuS+DRwdWJanN+qIEMsGvRpgJUuLt
NbIpMA/3YE/xqng7HeTKyGTXW9t3+oA/W/OUkpDeR/3+WH67LoAdQmDaEKB3vQmgdwYSiHCpii29
zHsquRSMViCE3a77h6olxXyXjF/FHJjpq4+QpYoeaIUDStln/yBVsKg7Z5U7GjMv3iLw1z01dpBQ
o0LDqF7Rwo7g7dq12G2uW8W3AkNzBHG61uGdJVy/4Z5+qFJPqMyUsUIzl39PRovydfMnD2MFWxDg
4+PrzQs=
--00000000000032807605b484a2c9--
