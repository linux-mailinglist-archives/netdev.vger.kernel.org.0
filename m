Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E12581553
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 16:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239230AbiGZOcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 10:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239101AbiGZOcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 10:32:10 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3908B2A27B
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 07:32:09 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id bz13so10526950qtb.7
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 07:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WReQ3Pe/2TpgekMzWYEUTpxQGpWaSThYmN2MvLd0Cgg=;
        b=X+nAf1AZ0Jim/OE1aIpEyaRJZRIehFTKsRPgGySdJ9b9Rxn/L9pWYxc8HW1NYToDVV
         Jf4jeHPtg0UEMWswcf6rgO2IXx8ijDW+omdyQly5YSOsAm/HrI471yEDMrWqmG+r/ANc
         /IsYujWoCmxuXNw6j2ze/7qdK/EyYq7vNuhY8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WReQ3Pe/2TpgekMzWYEUTpxQGpWaSThYmN2MvLd0Cgg=;
        b=3JGl+0G5hRr6fpLYDNh7VuwBcN7c1Ih5S/E/1M6fRx/Q9aSS3TE9QrdN+Uc20JjoiI
         LWqIodEYv39TExCfoX5Ocq0YWWndexxUjXKiq0y+vSWLNauPG8JsPUaKY5GmemNo//y5
         Lq3LAe0ca8bKF1HBnipM/0ygsnBL6y4XfSG33h9BjA8MYJvZxEwMjj+oNKMsOs6pq/se
         iI4k8H4VCed6gcauobsGHHDMiV3iD3+l4puWqWZTBdUck3a/O5+vMvWOhVHK129NINwd
         oHULjrrKkdpChE4HxpdNusHsSdXVcJ6DNVZTcUAxXCPWzgqPR2HA2iJpTQpdd9uCccQw
         sdUw==
X-Gm-Message-State: AJIora/Ye63qUjLrAs56d/wxf93gJ6whqnEBBiJocj8NChY5+ltg2e67
        FwVCmA9gaoNSxjYoji+sfibRAMcEXfrRu2zCvNfCJw==
X-Google-Smtp-Source: AGRyM1sZyZ6/1oIt0j68b2Y3vt/KRMElLEYWssikMk1mIKS34Mkfy/p6stik9r+nCgm+WQB14cXpPlOm/rxJGP25lo8=
X-Received: by 2002:a05:622a:11c3:b0:31e:ebe7:692a with SMTP id
 n3-20020a05622a11c300b0031eebe7692amr14670028qtk.352.1658845928116; Tue, 26
 Jul 2022 07:32:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220724231458.93830-1-ajit.khaparde@broadcom.com>
 <20220724231458.93830-3-ajit.khaparde@broadcom.com> <Yt6JV0Vs7nSnI8KB@unreal>
 <CACZ4nhvkTtPjrtKnFuxo+m0TJdBB6S3Tdu1sx+UDS2bT3Y2XZg@mail.gmail.com> <Yt99cG7ZMGe1XhlL@unreal>
In-Reply-To: <Yt99cG7ZMGe1XhlL@unreal>
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
Date:   Tue, 26 Jul 2022 07:31:51 -0700
Message-ID: <CACZ4nhu5XbwFOqu+YvQy0iV=BuqzZ9ipm78GaEiSuyg9Du5RPg@mail.gmail.com>
Subject: Re: [PATCH 2/2] RDMA/bnxt_re: Use auxiliary driver interface
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@ziepe.ca,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        linux-rdma@vger.kernel.org,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000004dba5605e4b62a6c"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000004dba5605e4b62a6c
Content-Type: text/plain; charset="UTF-8"

On Mon, Jul 25, 2022 at 10:36 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Mon, Jul 25, 2022 at 09:58:30PM -0700, Ajit Khaparde wrote:
> > On Mon, Jul 25, 2022 at 5:15 AM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Sun, Jul 24, 2022 at 04:14:58PM -0700, Ajit Khaparde wrote:
> > > > Use auxiliary driver interface for driver load, unload ROCE driver.
> > > > The driver does not need to register the interface using the netdev
> > > > notifier anymore. Removed the bnxt_re_dev_list which is not needed.
> > > > Currently probe, remove and shutdown ops have been implemented for
> > > > the auxiliary device.
> > > >
> > > > BUG: DCSG01157556
> > > > Change-Id: Ice54f076c1c4fc26d4ee7e77a5dcd1ca21cf4cd0
> > >
> > > Please remove the lines above.
> > Apologies for missing that.
> >
> > >
> > > > Signed-off-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
> > > > ---
> > > >  drivers/infiniband/hw/bnxt_re/bnxt_re.h       |   9 +-
> > > >  drivers/infiniband/hw/bnxt_re/main.c          | 405 +++++++-----------
> > > >  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  64 ---
> > > >  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c |  65 +++
> > > >  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |   3 +
> > > >  5 files changed, 232 insertions(+), 314 deletions(-)
> > >
> > > <...>
> > >
> > > > +static DEFINE_IDA(bnxt_aux_dev_ids);
> > > > +
> > > >  static int bnxt_register_dev(struct bnxt_en_dev *edev, unsigned int ulp_id,
> > > >                            struct bnxt_ulp_ops *ulp_ops, void *handle)
> > >
> > > I would expect that almost all code in bnxt_ulp.c will go after this change.
> > I agree. My plan was to get these QA tested, initial Aux Bus changes
> > in this release with a follow on series to clean this up further.
> > Does that sound reasonable?
>
> No, please prepare complete series and we will review it.
> There is much harder to do it when the change is partial.
I am fine with that. Thanks

>
> Thanks
>
> > Thanks for the feedback.
> >
> > Thanks
> > Ajit
> >
> > >
> > > Thanks
>
>

--0000000000004dba5605e4b62a6c
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
RIaCW0xx+14NTQe17dkH6CEEpmCjejneq/FU0gmbuorwHoP9mOiqeh23/ZKVpmFO/eiDtvMNAMDW
6LzhOk/pMklUPTHu/gQNW3OQebyhyFUHiBSp8rDkfWZT57Asd0PtdQIDAQABo4IB2zCCAdcwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAlBgNVHREEHjAcgRphaml0LmtoYXBhcmRlQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUPHif0ihgndR0
h7r3sANaOIu2yM8wDQYJKoZIhvcNAQELBQADggEBAAEuLXDnP0Xd2zAMpQobXLUyqbpqGMO6ycQc
Xq4H2YYlSNKVwPA+ZAVdUOzbSimBKlx8mzAEHkI3Ll1yXlYeT4UwkfWV9fioyGuQelLN1sGzi5bm
WEpaSIbR1eiJMtzxUPwpRTn19gHZVueIot2Gw0fEYgHiMJpUr6xBWv2QNXULu/E8qvbXIRh2iycq
5rWFggX/JHglO8nVqzb1ImzqzVMFnDN15h3j8ryy2MIvZ8VDQRP7l81IXaTvVwaKpWMgV6rfQOi6
aOQZuOKkad7qoCkS5N2oSsvxi+rZtDaJJNsDjs05y5JZZQtBlfAmdYS+mmvkPjZ1iaLTzk59o/Yo
fNkxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQphPQ
U+7K4aDRwxAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAayQ8zslvh/+r4CWFXa
2phrfjAa5k5nlU4vyA9pEfYwMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDcyNjE0MzIwOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBJGAYbSYIkFTlskbMwr+BNEreyt606ALu1sR9t
8wgB8CHjYtp1bRCH2RJjMeSixfTkanHkz/7PoNYZ0H7jvC4zYiknUoHZSTovNTxVdSkstV56ZWWZ
BLDgPq+0vHe01GXvgTLvvjkxYqhn+7hy+tkgvRBJ+WmhWoIjE6h4gbR6o0/I2Vs9Anr9cTHTm8ej
WfMF0IGlpefePCBjO7tRgonUKaOwj7ZfYZFGMO1VSTCWe+Cr0OLydXOGFF1zd9AZIeEhXDxU1xVi
+DjcYBvSuYa0eFUCgcuB4SxDjan50nPpBHq7NahEmqJZQeGOwZvwdVBR+IbG6kjduRX9e4S/nH5i
--0000000000004dba5605e4b62a6c--
