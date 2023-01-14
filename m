Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB79C66ADBB
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 21:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjANUj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 15:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjANUj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 15:39:28 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7754C16
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 12:39:27 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id gz9-20020a17090b0ec900b002290bda1b07so3643024pjb.1
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 12:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RhOdmLOq4bbvydlZUVBJPr3XG697Zj8FfUzhqLKgikU=;
        b=MPUvMaS8ZIEvDbA5X+UWxVIB3EM9SubLdQZIr+Z8rHZXYbcJqjx+bAiLjxlrPj91Tf
         VCrOrQK6TeNnmkhQ0xoV8KZ1dTPoVgKXKczHmaYVSbMXKUVjOxmaGmR55xknixQcsEgA
         ZG4BtL4iDjOuO09BcpBnm6Rhbae1XxTe/mQA8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RhOdmLOq4bbvydlZUVBJPr3XG697Zj8FfUzhqLKgikU=;
        b=jAnOqrTOUIqdxfd1K21kjBKOcmlsKAAKJWVjCW80r7+9eSFjcNBoSxxHeH2avykwJu
         b14vpm78cP+uuMQlpEdpVncOcS8mQCyBOCAbL4JpextvBBbgLLZmAvjCougf+Z3yK7u6
         Faq9woTUl7XtJSPtoDOLQ7QABWi98GSgOmOqSAAs93MvSU0ktlYEkP7i+gvqYDmmZotU
         5oml66+Ebbl2ZFLN258cquBnUNAO8nrRkZkt5f/oTuaMY0InCw6unA2vOnj4HXoNWH0h
         Zt8GktK9gxOxmA3QtK0hX/IrtxtqNzuXVirDFUf5nbWQulwvYHXuswkubQuloUNO0zCS
         bS5A==
X-Gm-Message-State: AFqh2kpwH6yvGscLGMlO1clwQpSSAayJsAySQiaTNWatG0vhAQm62e+9
        WHcC2JMwqNHY/NgsdwTZ0XjhkAaao3E7H3KwNkKjLQ==
X-Google-Smtp-Source: AMrXdXuwYZ5X20003vRknVuxJXaQNHwfcP+UKKDKUGqxK6HR3DQ7nq7ypodOttkbxJ+rgEvrBvPitmdzDnF5l4400JM=
X-Received: by 2002:a17:902:c215:b0:193:2c1b:337c with SMTP id
 21-20020a170902c21500b001932c1b337cmr273485pll.76.1673728767005; Sat, 14 Jan
 2023 12:39:27 -0800 (PST)
MIME-Version: 1.0
References: <20230112202939.19562-1-ajit.khaparde@broadcom.com>
 <20230112202939.19562-2-ajit.khaparde@broadcom.com> <20230113221042.5d24bdde@kernel.org>
In-Reply-To: <20230113221042.5d24bdde@kernel.org>
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
Date:   Sat, 14 Jan 2023 12:39:09 -0800
Message-ID: <CACZ4nhuKo-h_dcSGuzAm4vJJuuxmnVo8jYO2scCxfqtktbCjfw@mail.gmail.com>
Subject: Re: [PATCH net-next v7 1/8] bnxt_en: Add auxiliary driver support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com,
        Leon Romanovsky <leonro@nvidia.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000a3c94405f23f5895"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000a3c94405f23f5895
Content-Type: text/plain; charset="UTF-8"

On Fri, Jan 13, 2023 at 10:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 12 Jan 2023 12:29:32 -0800 Ajit Khaparde wrote:
> > Add auxiliary driver support.
> > An auxiliary device will be created if the hardware indicates
> > support for RDMA.
> > The bnxt_ulp_probe() function has been removed and a new
> > bnxt_rdma_aux_device_add() function has been added.
> > The bnxt_free_msix_vecs() and bnxt_req_msix_vecs() will now hold
> > the RTNL lock when they call the bnxt_close_nic()and bnxt_open_nic()
> > since the device close and open need to be protected under RTNL lock.
> > The operations between the bnxt_en and bnxt_re will be protected
> > using the en_ops_lock.
> > This will be used by the bnxt_re driver in a follow-on patch
> > to create ROCE interfaces.
>
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > @@ -13178,6 +13178,9 @@ static void bnxt_remove_one(struct pci_dev *pdev)
> >       struct net_device *dev = pci_get_drvdata(pdev);
> >       struct bnxt *bp = netdev_priv(dev);
> >
> > +     bnxt_rdma_aux_device_uninit(bp);
> > +     bnxt_aux_dev_free(bp);
>
> You still free bp->aux_dev synchronously..
>
> > +void bnxt_aux_dev_free(struct bnxt *bp)
> > +{
> > +     kfree(bp->aux_dev);
>
> .. here. Which is called on .remove of the PCI device.
>
> > +     bp->aux_dev = NULL;
> > +}
> > +
> > +static struct bnxt_aux_dev *bnxt_aux_dev_alloc(struct bnxt *bp)
> > +{
> > +     return kzalloc(sizeof(struct bnxt_aux_dev), GFP_KERNEL);
> > +}
> > +
> > +void bnxt_rdma_aux_device_uninit(struct bnxt *bp)
> > +{
> > +     struct bnxt_aux_dev *bnxt_adev;
> > +     struct auxiliary_device *adev;
> > +
> > +     /* Skip if no auxiliary device init was done. */
> > +     if (!(bp->flags & BNXT_FLAG_ROCE_CAP))
> > +             return;
> > +
> > +     bnxt_adev = bp->aux_dev;
> > +     adev = &bnxt_adev->aux_dev;
> > +     auxiliary_device_delete(adev);
> > +     auxiliary_device_uninit(adev);
> > +     if (bnxt_adev->id >= 0)
> > +             ida_free(&bnxt_aux_dev_ids, bnxt_adev->id);
> > +}
> > +
> > +static void bnxt_aux_dev_release(struct device *dev)
> > +{
> > +     struct bnxt_aux_dev *bnxt_adev =
> > +             container_of(dev, struct bnxt_aux_dev, aux_dev.dev);
> > +     struct bnxt *bp = netdev_priv(bnxt_adev->edev->net);
> > +
> > +     bnxt_adev->edev->en_ops = NULL;
> > +     kfree(bnxt_adev->edev);
>
> And yet the reference counted "release" function accesses the bp->adev
> like it must exist.
>
> This seems odd to me - why do we need refcounting on devices at all
> if we can free them synchronously? To be clear - I'm not sure this is
> wrong, just seems odd.
I followed the existing implementations in that regard. Thanks

>
> > +     bnxt_adev->edev = NULL;
> > +     bp->edev = NULL;
> > +}

--000000000000a3c94405f23f5895
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
pZEyqKnwS1lKCzjX7mV5W955rFsFxChdAKfw0HilwtqdY24mhy62+GeaEkD0gYIj1tCmw9gnQToc
K+0s7xEunfR9pBrzmOwS3OQbcP0nJ8SmQ8R+reroH6LYuFpaqK1rgQIDAQABo4IB2zCCAdcwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAlBgNVHREEHjAcgRphaml0LmtoYXBhcmRlQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUbrcTuh0mr2qP
xYdtyDgFeRIiE/gwDQYJKoZIhvcNAQELBQADggEBALrc1TljKrDhXicOaZlzIQyqOEkKAZ324i8X
OwzA0n2EcPGmMZvgARurvanSLD3mLeeuyq1feCcjfGM1CJFh4+EY7EkbFbpVPOIdstSBhbnAJnOl
aC/q0wTndKoC/xXBhXOZB8YL/Zq4ZclQLMUO6xi/fFRyHviI5/IrosdrpniXFJ9ukJoOXtvdrEF+
KlMYg/Deg9xo3wddCqQIsztHSkR4XaANdn+dbLRQpctZ13BY1lim4uz5bYn3M0IxyZWkQ1JuPHCK
aRJv0SfR88PoI4RB7NCEHqFwARTj1KvFPQi8pK/YISFydZYbZrxQdyWDidqm4wSuJfpE6i0cWvCd
u50xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwM2Vrj
4nZK0WWosNswDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIEibUqxCGK9air9IRdJh
VJAzXnZiw5eY68irRfOGHJs1MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIzMDExNDIwMzkyN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCUjVLbJ2n+KT1gZ1aztUY9nkpJZl9QKbPmHm/K
+MpeuwePxnWHOE7Gpse8MaE1IeeT5JdtXlEBqCdd9jgTleiK4OtHf/iPvb9taon9uBAl3f2MBMPH
kDA/jMgIhdpp9w4/DKgwjmg8GSNgVybMHSgjvAmq2wzDGgDj0Cy2MVtQzcmfsNxYVd2A9KVLf04a
xYuilQa1lxBkPyvbR1TdPLTfhGO0ZOChFTSWaO23ryDgEpORKMt5JIqN1TMinn5a+8lXIp97Tr31
bihWgfN403TdKTuE79gLygVO31GRQ6k8mF9AptilTpVmD3nqfOSPtq2h4I1C7kD0aoHhpqe32ESy
--000000000000a3c94405f23f5895--
