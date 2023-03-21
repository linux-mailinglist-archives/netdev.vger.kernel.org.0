Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365156C2C43
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbjCUIZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbjCUIZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:25:38 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B64DE382
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 01:25:27 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id x11so12946659pja.5
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 01:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1679387127;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mg87V04JtnpHr7VrK9R478rJNm0nPJQ8G1KUUpq12t0=;
        b=Qikm1mtPBLnvCSy8HxEo4BpH2PiTqi7RD+g5k41l0e1FmYMTrhSy4d6zsYfDVP8Blh
         VrNYCuYW9O9T3qeA5iZ8kFG7WWk12IoyPkhhmoPZhQmLd43k07zr3LKE6wl6wOv88TXn
         dYukpVwt983fcIo3GwXnUY4+smyAYAmlZZpJA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679387127;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mg87V04JtnpHr7VrK9R478rJNm0nPJQ8G1KUUpq12t0=;
        b=EEtJ+xqUBkVnNU3uhrMQqR8mAYINplsK+FMD/v2vaT4QgjAkMZVl960rl6ePHn6EVD
         D0HDndNIispIIspmsJ0jxNrXg9yFg6WLUoovXNxMeaELsAmayf92c/o5Ii5iabtaCTCL
         h3m9TGr6ak4L4Wstld6G/NuiIj9efXXRyrAwUwGBj+aH6Dv4N6H498r3Q7wRstymLt+I
         DhH8ghTBXhRjpiuVn07GcHLv3+fCEY7A8dwdebCS1wK0nV5rvOM4rApF3Irggm28PNjk
         Iul78pOPgz7wGdi3ICavryTFg1vZaXaEMOBlc2B85Ftrz8u9tuok2mBR/rQ6O3WDoXCo
         0wgg==
X-Gm-Message-State: AO0yUKWLXlhaLd5CQUi8/Kk9VFDBzZihIBwNXbOHq11CxXEqQ8YE+9tA
        +wPesTZQmVBaF3bb59TkmLdlmiAp/jfk3S7LVVFF8Q==
X-Google-Smtp-Source: AK7set89rE6W4egj44dj5+gIJ1O+GwmDIiwtSJDWJo/8WcL+qCmf26CzgGNeSftOOMzLIgyhQHTA3tI5HnlPOWO9K44=
X-Received: by 2002:a17:90a:f287:b0:23d:20c:2065 with SMTP id
 fs7-20020a17090af28700b0023d020c2065mr371421pjb.1.1679387126703; Tue, 21 Mar
 2023 01:25:26 -0700 (PDT)
MIME-Version: 1.0
References: <CALs4sv2KkjwRrHTEhCneDmN0JJV-x5Db=+ApXOObLpOcPR0=1Q@mail.gmail.com>
 <AHkARAASI0ycAeWt4ZCNhKpF.3.1679377487974.Hmail.mocan@ucloud.cn>
In-Reply-To: <AHkARAASI0ycAeWt4ZCNhKpF.3.1679377487974.Hmail.mocan@ucloud.cn>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Tue, 21 Mar 2023 13:55:15 +0530
Message-ID: <CALs4sv0rK7+PhwawDGt0q3mdoD3ncmLQHSXkqYMofp6rSOa3Ug@mail.gmail.com>
Subject: Re: Re: [PATCH] net/net_failover: fix queue exceeding warning
To:     Faicker Mo <faicker.mo@ucloud.cn>
Cc:     Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002627b405f764c90f"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000002627b405f764c90f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 21, 2023 at 11:17=E2=80=AFAM Faicker Mo <faicker.mo@ucloud.cn> =
wrote:
>
> When tx from the net_failover device, the actual tx queue number is the s=
alve device.

Then why is primary OK..

> The ndo_select_queue of net_failover device returns the txq which is the =
primary device txq
> if the primary device is OK.

This is what is done in all the functions. I don't think there is a problem=
.
Not sure if there is an issue I am not getting, at least with the descripti=
on.
I will let the maintainer take the call. Thanks.

> This number may be bigger than the default 16 of the net_failover device.
>  A warning will be reported in netdev_cap_txqueue which device is the net=
_failover.
>
>
> From: Pavan Chebbi <pavan.chebbi@broadcom.com>
>  Date: 2023-03-21 13:11:52
> To:Faicker Mo <faicker.mo@ucloud.cn>
>  cc: Sridhar Samudrala <sridhar.samudrala@intel.com>,"David S. Miller" <d=
avem@davemloft.net>,Eric Dumazet <edumazet@google.com>,Jakub Kicinski <kuba=
@kernel.org>,Paolo Abeni <pabeni@redhat.com>,netdev@vger.kernel.org,linux-k=
ernel@vger.kernel.org
> Subject: Re: [PATCH] net/net_failover: fix queue exceeding warning>On Tue=
, Mar 21, 2023 at 8:15=E2=80=AFAM Faicker Mo <faicker.mo@ucloud.cn> wrote:
> >>
> >> If the primary device queue number is bigger than the default 16,
> >> there is a warning about the queue exceeding when tx from the
> >> net_failover device.
> >>
> >
> >Can you describe the issue more? If the net device has not implemented
> >its own selection then netdev_pick_tx should take care of the
> >real_num_tx_queues.
> >Is that not happening?
> >
> >> Signed-off-by: Faicker Mo <faicker.mo@ucloud.cn>
> >> ---
> >>  drivers/net/net_failover.c | 8 ++------
> >>  1 file changed, 2 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
> >> index 7a28e082436e..d0c916a53d7c 100644
> >> --- a/drivers/net/net_failover.c
> >> +++ b/drivers/net/net_failover.c
> >> @@ -130,14 +130,10 @@ static u16 net_failover_select_queue(struct net_=
device *dev,
> >>                         txq =3D ops->ndo_select_queue(primary_dev, skb=
, sb_dev);
> >>                 else
> >>                         txq =3D netdev_pick_tx(primary_dev, skb, NULL)=
;
> >> -
> >> -               qdisc_skb_cb(skb)->slave_dev_queue_mapping =3D skb->qu=
eue_mapping;
> >> -
> >> -               return txq;
> >> +       } else {
> >> +               txq =3D skb_rx_queue_recorded(skb) ? skb_get_rx_queue(=
skb) : 0;
> >>         }
> >>
> >> -       txq =3D skb_rx_queue_recorded(skb) ? skb_get_rx_queue(skb) : 0=
;
> >> -
> >>         /* Save the original txq to restore before passing to the driv=
er */
> >>         qdisc_skb_cb(skb)->slave_dev_queue_mapping =3D skb->queue_mapp=
ing;
> >>
> >> --
> >> 2.39.1
> >>
>
>

--0000000000002627b405f764c90f
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
OltyqaGBuzv+bJTUL+bmV7E4QBLIqGt4jVr1R9hJdH6KxXwJdyfHZ9C6qXmoe2NQhiFUyBOJ0wgk
dB9Z1IU7nCwvNKYg2JMoJs93tIgbhPJg/D7pqW8gabkCAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcGF2YW4uY2hlYmJpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUEV6y/89alKPoFbKUaJXsvWu5
fdowDQYJKoZIhvcNAQELBQADggEBAEHSIB6g652wVb+r2YCmfHW47Jo+5TuCBD99Hla8PYhaWGkd
9HIyD3NPhb6Vb6vtMWJW4MFGQF42xYRrAS4LZj072DuMotr79rI09pbOiWg0FlRRFt6R9vgUgebu
pWSH7kmwVXcPtY94XSMMak4b7RSKig2mKbHDpD4bC7eGlwl5RxzYkgrHtMNRmHmQor5Nvqe52cFJ
25Azqtwvjt5nbrEd81iBmboNTEnLaKuxbbCtLaMEP8xKeDjAKnNOqHUMps0AsQT8c0EGq39YHpjp
Wn1l67VU0rMShbEFsiUf9WYgE677oinpdm0t2mdCjxr35tryxptoTZXKHDxr/Yy6l6ExggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwV/XkICjVscn4SNZMw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIEnzuvMKoOv1TKEbE6AyciMMRn4Ak7yB
y1nvasC8KytZMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDMy
MTA4MjUyN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAXEyczhyOM6cLriVKf0NBTFDJ1yKRv28WGbzFVEzS7fPB1eWPV
Vp0sb0Oml8vZSJpZ1E3Cz5IfQ9OB2Y7C/GyVOr6rZbYd+V+WM4eEtaXMk/XdbgYMYE3cgqVYfhSW
UoyJRf8HCLUhs8SFuN7pKBLfir72QxDr81Xy4Q03PlhEMluCg2eq4qBgrS9ywT+Mx2CAFYTM0VKS
kAQlX4o80eQBa4tNIoBjP7suWDUJ56mMNaxSyThanBYsRM/V7/RLL0rAclTZcn0fVLLezsnOJw6e
I3Jx3Xp2NoKBPxE5Sfzu5gbo97sA2tHkF25ACcHWcnUllVrIXJ3phB+z/+6z0xZK
--0000000000002627b405f764c90f--
