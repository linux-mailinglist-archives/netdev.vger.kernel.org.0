Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991F660E50C
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 17:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbiJZP6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 11:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233843AbiJZP6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 11:58:18 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCECC9E2D4
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 08:58:17 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so3004347pji.1
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 08:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PU3JS028oW5Muhd1hpJbyUvVW3+5B2ev5y3Fd9pMTMo=;
        b=CDbgG/ybHNLsFgXxrLeJbd6mfv0hdOeaafr9mQcJ593sKtFbRQFpldyuj2McdlACw7
         KWEdTgo7mV4efW9S7Wh2tW7qZ7H/sFWlzF3luHBASwwlpYtd/++fiMS4LhK0H47x/Ra5
         oXXF/CU7JXvloa/olb/8hhnxLc9uL/mCltBi0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PU3JS028oW5Muhd1hpJbyUvVW3+5B2ev5y3Fd9pMTMo=;
        b=mP/qTip3OjxByhpEBFU72ZMVeHcHT4qLVFhJ7cScC1UnpmQXjMSxkxrtPQCCVv75Pk
         gmBdxoQm1HBaTYlEKZKrhCiPS4XkYLJKQxWmZzNyj0q9ZXArkiC/53WpJOsh5GqoN9rU
         h65E5x50ZVk8hb7rLB6vihX+9y5nVYtoG/kcGsb8I6a28zJejYisRk+ComC4hC+0y1y2
         6uC3AIcd1hxbjrbmddLkB895eqNrgxwE84buTcxCciqo5e4ahw6lWv8e13Vu7RTP5fs2
         7+0eG88Dg8QrkXVak87UEG2sa9s4iNFAkv1/vdlylMMEr9mYiyWALjwvZTBpNxy4JVIK
         ApXQ==
X-Gm-Message-State: ACrzQf0D4ZIvdHXN3LaCLdpP9Yv9jv2Hxgs8PiD92EjiT/9DuIE9Mitn
        8Ma07TknJG3ye/BfTn4HfEJu8GjEp/6U61nNsBZ7uA==
X-Google-Smtp-Source: AMsMyM4ARSsIPDLGSpr/5lW0y7QoVlqRAQOUvVHbrqggGiWktFVND8/Vo72wma+CTnACerihB2PeR/HLo34D4dMuBQo=
X-Received: by 2002:a17:902:bd02:b0:178:1a1c:889 with SMTP id
 p2-20020a170902bd0200b001781a1c0889mr44369292pls.107.1666799897328; Wed, 26
 Oct 2022 08:58:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220724231458.93830-1-ajit.khaparde@broadcom.com>
 <20221025173110.33192-1-ajit.khaparde@broadcom.com> <20221025173110.33192-3-ajit.khaparde@broadcom.com>
 <Y1j8wv9nn6MmdlcB@unreal>
In-Reply-To: <Y1j8wv9nn6MmdlcB@unreal>
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
Date:   Wed, 26 Oct 2022 08:58:00 -0700
Message-ID: <CACZ4nhtmE9Dh9z_O9-A934+q0_8yHEyj+V-DcEsuEWFbPH6BGg@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] RDMA/bnxt_re: Use auxiliary driver interface
To:     Leon Romanovsky <leon@kernel.org>
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000cfd8c305ebf21701"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000cfd8c305ebf21701
Content-Type: text/plain; charset="UTF-8"

On Wed, Oct 26, 2022 at 2:24 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Tue, Oct 25, 2022 at 10:31:06AM -0700, Ajit Khaparde wrote:
> > Use auxiliary driver interface for driver load, unload ROCE driver.
> > The driver does not need to register the interface using the netdev
> > notifier anymore. Removed the bnxt_re_dev_list which is not needed.
> > Currently probe, remove and shutdown ops have been implemented for
> > the auxiliary device.
> >
> > Signed-off-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
> > Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
> > ---
> >  drivers/infiniband/hw/bnxt_re/bnxt_re.h       |   9 +-
> >  drivers/infiniband/hw/bnxt_re/main.c          | 387 +++++++-----------
> >  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  64 ---
> >  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c |  67 ++-
> >  drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |   3 +
> >  5 files changed, 214 insertions(+), 316 deletions(-)
>
> <...>
>
> > -static struct bnxt_en_dev *bnxt_re_dev_probe(struct net_device *netdev)
> > +static struct bnxt_en_dev *bnxt_re_dev_probe(struct auxiliary_device *adev)
> >  {
> > -     struct bnxt_en_dev *en_dev;
> > +     struct bnxt_aux_dev *aux_dev =
> > +             container_of(adev, struct bnxt_aux_dev, aux_dev);
> > +     struct bnxt_en_dev *en_dev = NULL;
> >       struct pci_dev *pdev;
> >
> > -     en_dev = ((struct bnxt*)netdev_priv(netdev))->edev;
> > -     if (IS_ERR(en_dev))
> > -             return en_dev;
> > +     if (aux_dev)
> > +             en_dev = aux_dev->edev;
> > +
> > +     if (!en_dev)
> > +             return NULL;
>
> Thank you for working to convert this driver to auxiliary bus. I'm
> confident that it will be ready soon.
Thanks

>
> In order to effectively review this series, you need to structure
> patches in such way that you don't remove in patch X+1 code that you
> added in patch X.
Sure. Moving from v1 to v2, I surely ran into the situation and cleaned them.
I will clean up the rest in case I missed something.

>
> Also you should remove maze of redundant functions that do nothing, but
> just call to another function with useless checks.
ACK

>
> Auxiliary devices shouldn't be created if en_dev == NULL.
ACK

& Thanks

>
> Thanks

--000000000000cfd8c305ebf21701
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
4nZK0WWosNswDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIA1Mtr9BZB0+ZZHwWDnW
ckwHghYZc0Js11sX0XufBwtTMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMTAyNjE1NTgxN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCJMEBoGYSkUaxQ2jOD+WqEpzDddRqsyEfeA616
sd2YAFXrKEuMD6tKg1ihP6w/HJGGAPXfgFlkbmv1BD5FjeEXZ0nczkJ4/3WixvowmxriIyOIusML
1PgY+9s2yibZwrSUwlAsYReHkGaEOv131hF317DFfe0imIJKcxpAcTqsbb3vkb2ilkIGdwUbV110
Ck+aYdR1AFgqM3DaDT9cQ85F8/YAX1aDe97BUdOU9i6yy2S/vV9dYGmNVk6ejNGMkOYik7t4oDwS
AJ0Rl/BevvEkCLUmZotb0zxkDDtDnFaax+cW3P+SmJzosWxfrDkdS6Yz0+PPfl9xPGDNRKONEJtd
--000000000000cfd8c305ebf21701--
