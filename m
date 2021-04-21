Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66B8367208
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245051AbhDURxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245044AbhDURxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 13:53:00 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F88C06138B
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 10:52:25 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id c6so31889276qtc.1
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 10:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=77tRPhlUDQVEVqMjk7aWTV0FS92Lspjs08SGNI2DdFY=;
        b=h7KQF7CFOqxi4OHMZIbD+D2kICDbiNh1JmAPIVV5ayM58Rgl0h0xvRJM11DlTyf//6
         6qbvswmwok5fw7EiYBQ4VGVNT4ly7zQlpKl7wxxB2D7NV3d4/2MZ717G5rVj6m1s6tYe
         AnIVK5AIDT39vOOiq1rIhcdN6vHUsl8+qWKz0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=77tRPhlUDQVEVqMjk7aWTV0FS92Lspjs08SGNI2DdFY=;
        b=Rl3/pYL9Q31ZkMrH2eGMdfEVq+lfNvLKP0zoonN8yldgCLajePeh34QlekLZdT9L+V
         0G379NXO0xHgJMMzuxkENoxh+KBb9IrZaDL/IwPrP7yqa79t9NPEJKQUjaNa4BGDYh0Q
         4RWcnMgvr/lotlM/ZFmETEmZ1tF6PqBo8tjcOkXqouBbK046prqTiOQwnwQ8Vsr4IR7b
         q6DTlzX1dDt+j2e/7Nh4D6VEcqHyKtbZHKAH6ypcQ5UldlHjKXKtzZbU0dqopOQUyuAp
         02QcKMTnlm+b5YFvjRyOSC0awttF3X12EamAazY+lkJQmNVED6Y2thj2tWry8iVxVQX3
         41Dg==
X-Gm-Message-State: AOAM531JW+gMHKMZdP0c+IIwsnJqpY1hkN2ciJULXfKw3cbL0B08Fcq1
        R6sfIcK8VMSu/vrPrnYn3BujNb/5qvws2Aq8EVmIbw==
X-Google-Smtp-Source: ABdhPJxcjXrceVF+1J6FvQMjqjVv+M3r7V95bsusoruXcGn6YwnMIACmTL5ka2RXx4hyazwu9SWsaO6pONRhTpCDss0=
X-Received: by 2002:ac8:574f:: with SMTP id 15mr21954102qtx.50.1619027544294;
 Wed, 21 Apr 2021 10:52:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210401065715.565226-1-leon@kernel.org> <20210401065715.565226-3-leon@kernel.org>
In-Reply-To: <20210401065715.565226-3-leon@kernel.org>
From:   Devesh Sharma <devesh.sharma@broadcom.com>
Date:   Wed, 21 Apr 2021 23:21:47 +0530
Message-ID: <CANjDDBh71JLvt_c=r49_EgGaEsUoFS2Y-6cw1QL3-CN1fJrPZA@mail.gmail.com>
Subject: Re: [PATCH rdma-next v2 2/5] RDMA/bnxt_re: Create direct symbolic
 link between bnxt modules
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Netdev <netdev@vger.kernel.org>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b433a405c07f39e1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000b433a405c07f39e1
Content-Type: text/plain; charset="UTF-8"

On Thu, Apr 1, 2021 at 12:27 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> Convert indirect probe call to its direct equivalent to create
> symbols link between RDMA and netdev modules. This will give
> us an ability to remove custom module reference counting that
> doesn't belong to the driver.
>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/hw/bnxt_re/main.c          | 7 +------
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 2 --
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h     | 1 -
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 1 +
>  4 files changed, 2 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
> index b30d37f0bad2..140c54ee5916 100644
> --- a/drivers/infiniband/hw/bnxt_re/main.c
> +++ b/drivers/infiniband/hw/bnxt_re/main.c
> @@ -610,15 +610,10 @@ static void bnxt_re_dev_unprobe(struct net_device *netdev,
>
>  static struct bnxt_en_dev *bnxt_re_dev_probe(struct net_device *netdev)
>  {
> -       struct bnxt *bp = netdev_priv(netdev);
>         struct bnxt_en_dev *en_dev;
>         struct pci_dev *pdev;
>
> -       /* Call bnxt_en's RoCE probe via indirect API */
> -       if (!bp->ulp_probe)
> -               return ERR_PTR(-EINVAL);
> -
> -       en_dev = bp->ulp_probe(netdev);
> +       en_dev = bnxt_ulp_probe(netdev);
>         if (IS_ERR(en_dev))
>                 return en_dev;
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index a680fd9c68ea..3f0e4bde5dc9 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -12859,8 +12859,6 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>         if (!BNXT_CHIP_P4_PLUS(bp))
>                 bp->flags |= BNXT_FLAG_DOUBLE_DB;
>
> -       bp->ulp_probe = bnxt_ulp_probe;
> -
>         rc = bnxt_init_mac_addr(bp);
>         if (rc) {
>                 dev_err(&pdev->dev, "Unable to initialize mac address.\n");
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> index 1259e68cba2a..eb0314d7a9b1 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> @@ -1745,7 +1745,6 @@ struct bnxt {
>         (BNXT_CHIP_P4(bp) || BNXT_CHIP_P5(bp))
>
>         struct bnxt_en_dev      *edev;
> -       struct bnxt_en_dev *    (*ulp_probe)(struct net_device *);
>
>         struct bnxt_napi        **bnapi;
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
> index 64dbbb04b043..a918e374f3c5 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
> @@ -491,3 +491,4 @@ struct bnxt_en_dev *bnxt_ulp_probe(struct net_device *dev)
>         }
>         return bp->edev;
>  }
> +EXPORT_SYMBOL(bnxt_ulp_probe);

Acked-By: Devesh Sharma <devesh.sharma@broadcom.com>
> --
> 2.30.2
>


-- 
-Regards
Devesh

--000000000000b433a405c07f39e1
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
TUsFTOuxP4FZ9JSu9FWkGJGPobx8FmEvg+HybmXuUG0+PU7EDHKNoW8AcgZvIQYbwfevqWBFwwRD
Paihaaj18xGk21lqZcO0BecWKYyV4k9E8poof1dH+GnKqwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRpkZXZlc2guc2hhcm1hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUEe3qNwswWXCeWt/hTDSC
KajMvUgwDQYJKoZIhvcNAQELBQADggEBAGm+rkHFWdX4Z3YnpNuhM5Sj6w4b4z1pe+LtSquNyt9X
SNuffkoBuPMkEpU3AF9DKJQChG64RAf5UWT/7pOK6lx2kZwhjjXjk9bQVlo6bpojz99/6cqmUyxG
PsH1dIxDlPUxwxCksGuW65DORNZgmD6mIwNhKI4Thtdf5H6zGq2ke0523YysUqecSws1AHeA1B3d
G6Yi9ScSuy1K8yGKKgHn/ZDCLAVEG92Ax5kxUaivh1BLKdo3kZX8Ot/0mmWvFcjEqRyCE5CL9WAo
PU3wdmxYDWOzX5HgFsvArQl4oXob3zKc58TNeGivC9m1KwWJphsMkZNjc2IVVC8gIryWh90xggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwhg1OJo0VLRNay
SHwwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIBc37BXAdam3/mxP56cl/sPFpdX/
9rgtT0Q2htI+iaCiMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDQyMTE3NTIyNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQArA2eOcvcYNb5DIqk/+p8QmNiQjrsh2c0LkG7cJESKx1zn
/QZFVq3KkGKCEy8mBbulN2xT+n4Nl50IFaiWDhesMRAmOEJfSdf1bsfOKTmd/QzA/le6jM/7sXfZ
Ru67yxHtnijdcoNYRROV3UbA//zQsN3/U8duXK+99PG8JPiBVbTVQoZrZFc/tSDBDNTmR+QbrcIL
x88lVKanHtlhdY5hzvB1Mrc928YVG7wpEF/pUUQ3gaceqPRtmtJ4jrJdlVv/fi8KKK0L0w65+hgg
1K+XZssgo6bfCnLVXBnT/jj/SFEK3SgZu3M6bPq1/tMGqMfQKB3kVyKQfMESfNSENfvz
--000000000000b433a405c07f39e1--
