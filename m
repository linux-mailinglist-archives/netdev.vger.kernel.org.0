Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015B136B796
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbhDZRKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbhDZRKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:10:23 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5C1C061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 10:09:41 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id o5so57230650qkb.0
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 10:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1lwGazPl/DeS/OJhv74bKQhLj3l22/PWVhEsnGdLLf8=;
        b=Vq7OCjLB2HF4n02iedF4lCyEm7+0ArCKl3j2cxBBhLqJmhz6zmuBVLlYNsjXSRkAqQ
         CHpACMa9/8SlanXWnxbfuoI8oUKtTCln/HJaw1Punix0aHKhPg6yQNE8dvQZ/mhGXtfm
         jo+fEX8E3OEOWXQpSYwADB24DO84OSy/t5y5g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1lwGazPl/DeS/OJhv74bKQhLj3l22/PWVhEsnGdLLf8=;
        b=e9N4MPPZeyLWtzSXliRrZm1tXzsgVsFdQuAqR7muANjFgFSJ2tM2Drf1mRPHUuW9eD
         myGYvyA8HLsui2/XImP2qi5myONV4/Jv2nLobKaltfYj5Zh8p6ZonIM2fG/amUao1dRE
         aWWX5WAhUIyLFzJ4/lFrBb5ELRDIzbz6+EwUPxFwt8jOu0qt//3vu8vF9YpshbrvO4NG
         NoPy6BsiYmuoW3PCxyjoiyjjMO1JYWtSyp1pcr6Uyew7RQ294FSkBCpu7aa8C3fG0yZl
         r5SToyjIZjPWlPma+099tVJiZTZbNTfM+4Aw7myJ4dmLwQDSR4y0/KvogeF0ArK5Y+nQ
         AEKA==
X-Gm-Message-State: AOAM5331vsjugxzDvJe+2ZrTf7OIejrtvzhxW2pQ7oAp/Wg2TDOUErwv
        W8g5DSG9tC2VUS8uyoxCTKnAZkTOszZSGLqRTLYqNd75xzlN1w==
X-Google-Smtp-Source: ABdhPJyt1oYJ5LMI/yhIVDwiwvvDZpT4P8IUxfHvewMlDhqFrFJXELvj61V+kACJdDvAh5QgnYFQrTf5XbAMdq8Spxs=
X-Received: by 2002:a37:65c1:: with SMTP id z184mr18630830qkb.431.1619456980555;
 Mon, 26 Apr 2021 10:09:40 -0700 (PDT)
MIME-Version: 1.0
References: <1619372727-19187-1-git-send-email-michael.chan@broadcom.com>
 <1619372727-19187-11-git-send-email-michael.chan@broadcom.com>
 <20210426092935.728fda80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACKFLinRRcoaxsiHZyYcywgRtOs0E5hJdQ0gjHPAj3991gMzHw@mail.gmail.com>
 <CACKFLimdhTTD-vmfjkFDME_uHUBZTEMbUgA0WvSzjhPMjOPn_w@mail.gmail.com> <20210426100019.53a82b13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210426100019.53a82b13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 26 Apr 2021 10:09:29 -0700
Message-ID: <CACKFLikyML+t3p_qhn-MGG4jbZppvp2pVBk-95B+0maVSKB1Qw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 10/10] bnxt_en: Implement .ndo_features_check().
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Andrew Gospodarek <gospo@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000015971305c0e33686"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000015971305c0e33686
Content-Type: text/plain; charset="UTF-8"

On Mon, Apr 26, 2021 at 10:00 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 26 Apr 2021 09:45:17 -0700 Michael Chan wrote:
> > On Mon, Apr 26, 2021 at 9:35 AM Michael Chan <michael.chan@broadcom.com> wrote:
> > > On Mon, Apr 26, 2021 at 9:29 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > On Sun, 25 Apr 2021 13:45:27 -0400 Michael Chan wrote:
> > > > This should have been "features & ~(CSUM | GSO)" if you actually
> > > > accepted my feedback.
> >
> > Sorry, hit send too early.  If it is not UDP, it could be GRE or IP
> > over IP for example, right?  Why do we need to turn off offload?
>
> All supported protocols can be included in the allow list.
> That's one of the costs of NETIF_F_IP_CSUM, the driver needs
> to make sure the device can understand the packet.

Only UDP encapsulations have the 2 port limitations.  The rest are supported.

>
> > > I mentioned extension headers as an example,
> >
> > Extension headers (Geneve for example) are supported.
>
> I thought the Geneve things were called options. I meant IPv6 extension
> headers, which the device may also support, but then the right thing to
> do is something like a call to ipv6_skip_exthdr() to retrieve the L4
> proto.

You're right and I misunderstood you.  I will double check for ipv6
extension headers support and will send a follow up patch.  Thanks.

--00000000000015971305c0e33686
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIDux3t6q0f5QJ+OyV/erAemRTgFhM9Nk
8CbF9jvG0N5PMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDQy
NjE3MDk0MVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCEfPzdh3SwSAo5boI2mYdLYsXQdAhdWEbuvQf+P+0xSywwKqsC
6rplQ3zu1ZFG1uL6HjOU4bWgbsojS7O2eDhejt/HC6MnJLEXCHfTY/shRjHj6PJMp88zT4WNQlUt
9rTmLxOuRz+xmchGSxeis4PbdhkNWQcOZm9ENnmhqGlW8CtR2J9rDHS/wfOAY0jBlKCODq/DyheS
Gqc2X+flJxLl6sE72j7zqJ5LbFGpInIXSFXU3kGHDmGlpxPmW1MDoqQvCTBb74zOfQvi01XdhCoL
RqwTnqVPoOD2i8y4LUVcRHo7+1MxihcGSxunAdbOdMKlxo/aHAEumbhU9SFecKEZ
--00000000000015971305c0e33686--
