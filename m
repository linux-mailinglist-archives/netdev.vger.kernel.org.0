Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522CA375651
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 17:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbhEFPPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 11:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234918AbhEFPPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 11:15:12 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC83C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 08:14:13 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id p6so4239765qtk.13
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 08:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RLGRHCgH4lU1rV57MkIqDIyKGqIBFc2tr1shEmauer8=;
        b=c9BaneLusafr4MXmoLsqKuqoFiZlcRumRT1pkm+vjn2WgRmkL9R5Cp2ta/QH++Iapg
         7vMOsi/apau631LeygHxelhigjVSjQCytI052IguABTEuSW/Inz0MzR/3bgjDXoG+F1a
         Y8GuW8eevQvcLuwvny8QmkNevzbwaBj9fOUx4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RLGRHCgH4lU1rV57MkIqDIyKGqIBFc2tr1shEmauer8=;
        b=SizqdlscwM5FxGBgO4rtGt9PPfVa1diXwKH5NpugRJSLxC7oQERX8feKlUDe28UjVV
         3gDobEI5AoR56cKkmVe3iF0IAXOprqnHe+SLOsC2w8zuarivgnoDgZwUpAuziHyNtQSy
         G7IDGLH/sQJ3EJAD90wyhmEVXMLyqt4v87whp5qblQ3VAUzh6YeslRlzPckXjoNGCRGt
         rI03XRQPpqWqPo+TR6nWTnYrTRuKpw/QB5ZppXIv0jboY15n6aE5i/ApOYOcbvew7GNo
         DeN7M3kKM3Shmi7g0zF9cmGdlsAzmcEfrXt7c0eXvFpEaTYbY/Dz2hXh+LWvtJ20OZjS
         ZM1A==
X-Gm-Message-State: AOAM530YrRNpZvoSen3Ae1XIixP/Fsy5FomU6FpaQU8S3o89175+Cs/5
        otG25NV01g5/L9Kxp+Nur1uGRpsbqJV9n+l4VEiFKA==
X-Google-Smtp-Source: ABdhPJzY99UbXFXiTTNBac67lFA35QdB98WGilhxaNIpI7CiR0QEXI6un3JZRZLD+2z1Oeu0y6njpS0LNsAfU9LCMtc=
X-Received: by 2002:ac8:5358:: with SMTP id d24mr4682263qto.351.1620314051825;
 Thu, 06 May 2021 08:14:11 -0700 (PDT)
MIME-Version: 1.0
References: <1620254099-5270-1-git-send-email-michael.chan@broadcom.com> <CAKgT0UcBrPeEUDsfOmEX6GOC7Tbf-P+gUzefLi8HyC6q4sm+7Q@mail.gmail.com>
In-Reply-To: <CAKgT0UcBrPeEUDsfOmEX6GOC7Tbf-P+gUzefLi8HyC6q4sm+7Q@mail.gmail.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Thu, 6 May 2021 08:14:00 -0700
Message-ID: <CACKFLi=gzKF-3ybUG2-dxfOoQ8CSpEuHaFugK_sRHq-y3Lyp5w@mail.gmail.com>
Subject: Re: [PATCH net] bnxt_en: Fix and improve .ndo_features_check().
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Gospodarek <gospo@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000085ad1705c1aac3b7"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000085ad1705c1aac3b7
Content-Type: text/plain; charset="UTF-8"

On Wed, May 5, 2021 at 6:01 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Wed, May 5, 2021 at 3:43 PM Michael Chan <michael.chan@broadcom.com> wrote:
> > +static bool bnxt_exthdr_check(struct bnxt *bp, struct sk_buff *skb, int nw_off,
> > +                             u8 *nextproto)
> > +{
> > +       struct ipv6hdr *ip6h = (struct ipv6hdr *)(skb->data + nw_off);
> > +       int hdr_count = 0;
> > +       u8 nexthdr;
> > +       int start;
> > +
> > +       /* Check that there are at most 2 IPv6 extension headers, no
> > +        * fragment header, and each is <= 64 bytes.
> > +        */
> > +       start = nw_off + sizeof(*ip6h);
> > +       nexthdr = ip6h->nexthdr;
> > +       while (ipv6_ext_hdr(nexthdr)) {
> > +               struct ipv6_opt_hdr _hdr, *hp;
> > +               int hdrlen;
> > +
> > +               if (hdr_count >= 3 || nexthdr == NEXTHDR_NONE ||
> > +                   nexthdr == NEXTHDR_FRAGMENT)
> > +                       return false;
> > +               hp = skb_header_pointer(skb, start, sizeof(_hdr), &_hdr);
> > +               if (!hp)
> > +                       return false;
> > +               if (nexthdr == NEXTHDR_AUTH)
> > +                       hdrlen = ipv6_authlen(hp);
> > +               else
> > +                       hdrlen = ipv6_optlen(hp);
> > +
> > +               if (hdrlen > 64)
> > +                       return false;
> > +               nexthdr = hp->nexthdr;
> > +               start += hdrlen;
> > +               hdr_count++;
> > +       }
> > +       if (nextproto)
> > +               *nextproto = nexthdr;
> > +       return true;
> > +}
> > +
>
> You should really be validating the nexthdr in all cases. I'm assuming
> your offloads are usually for TCP and UDP. You should probably be
> validating that you end with that if you are going to advertise the
> CSUM and GSO offloads.

Yes, I agree with you that we should check for TCP/UDP here.

> This still largely falls short of being able to determine if your
> hardware can handle offloading the packet or not. It would likely make
> much more sense to look at parsing all the way from the L2 up through
> the inner-most L4 header in the case of tunnels to verify that you can
> support offloading it.
>
> For example if I had a packet that had unsupported inner IPv6
> extension headers it doesn't look like it would be caught by this as
> you are only checking the outer headers and the UDP port.
>

I missed the inner ipv6 extension header check for the UDP and GRE
cases.  Thanks for the review.

--00000000000085ad1705c1aac3b7
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFahbFm2hoGwyWbOsdPmdEvXcRD6fmU+
GtPuzzwJLNLhMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDUw
NjE1MTQxMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBsuqRVn7sy2phByyUUQmpJJj7kYaG2o0yzAdHEfjT7NsUegPeV
6d+5dXUU6H1rZTfQZEhawHoyJ84EaxGmQBtDiZwEh6f5hg3dwmDDLltbgIqimEJdXu1xcF5h4vKf
C+AGOkvMrCGXl57yuRvA6S5ijNNpkpBlsQDrgouRrFApTXjBlOgemuriW6kHb+4K2HJEE0sOEHs+
JwtXNd3xVZwQTq/uyvd5Yo+4Mt0+9jWQYErbp0m2Kqa5a8RC9Qt6CcqhmBcSHfI42nut3h4hV0e6
bqmXqnWYOqayYq7Fmuwfe1nI+9t5adeWRqwnw0pus6SjGVAiseB9+1Jh0UNgFoKB
--00000000000085ad1705c1aac3b7--
