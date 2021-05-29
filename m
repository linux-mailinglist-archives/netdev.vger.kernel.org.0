Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866893949F8
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 04:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhE2CdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 22:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhE2CdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 22:33:20 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D53CC061574
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 19:31:45 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id h21so4136610qtu.5
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 19:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ow2N5Kc5dD5VtYEoE/h60UigO5WqYON2lCnZqogQ/Aw=;
        b=MlroPb3t6ToJU4NQBR8s3oUzV6aKuVVgTTcaeoM5vaQh+a7hcN9owafgK+JHfkuJ+4
         P0kmH8eOgKhrFWSeacxEHS4MtFzI2QnQdFlNp9gvjDQrxrIsQJNEuHttM9EsdP2pc0YN
         mLxiZ5dGnwwRb5j7fdnD93MSnqjLBLziCX2TA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ow2N5Kc5dD5VtYEoE/h60UigO5WqYON2lCnZqogQ/Aw=;
        b=EIYWGvXBtwgZwmqlPcyhrnvepiIIA13LhE188ZJAWWRAy/hWYX9fgk9+E50fpDKU0F
         w/lu8t4IfqWm2iOukubTGxnWLd6qQ3mYQb0xM4jiic/Ho0KADEnEFzO4mLKM6xFoTiMI
         YyhMo3Kdd6uWchNjWjXmAb0WmxjfSjlVqPVx4cv9sOTeoU0k2ZenStX2N/4UJIynAVoZ
         dMDMzAGaYz9q50Rwf/bcBDsGctp1lP0kU24Q/nTH5ARxFNeZNw9FbVDmTRF1Eg016jDh
         vdNsv7Wi29o3V2vqF6i/rRO0Xt+GJLjdGwIITVPfBLTfJqqki6vvzkFh7Gb1Az3xFux3
         C5ew==
X-Gm-Message-State: AOAM5324u+5tcGvdeBUNxUUr0GokOxjyR4aIXaXlDNrANiZTYKjN3YGi
        diVB9jgWkO85dVNnu1hKRKTsNAGn472McHb4vwA8Vw==
X-Google-Smtp-Source: ABdhPJzIypvPgOoWnvXDxaJCnknHjNxPsiqKzYJ0DCzJlCQz9RrNx6rDF4DCXVETk7c0ilnlay8QZroRUlN2TcJDDos=
X-Received: by 2002:ac8:1342:: with SMTP id f2mr6154782qtj.148.1622255503105;
 Fri, 28 May 2021 19:31:43 -0700 (PDT)
MIME-Version: 1.0
References: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
 <1622249601-7106-6-git-send-email-michael.chan@broadcom.com> <20210528183908.3c84bff4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210528183908.3c84bff4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Fri, 28 May 2021 19:31:30 -0700
Message-ID: <CACKFLi=0fq26Su6wBwEG-8bhPuEU0JB7O=mUtZ=01KLKOyYxsg@mail.gmail.com>
Subject: Re: [PATCH net-next 5/7] bnxt_en: Get the RX packet timestamp.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Andrew Gospodarek <gospo@broadcom.com>,
        richardcochran@gmail.com, Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000006538505c36ecbe5"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000006538505c36ecbe5
Content-Type: text/plain; charset="UTF-8"

On Fri, May 28, 2021 at 6:39 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 28 May 2021 20:53:19 -0400 Michael Chan wrote:
> > +     struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
> > +     u64 time;
> > +
> > +     if (!ptp)
> > +             return -ENODEV;
> > +
> > +     time = READ_ONCE(ptp->old_time);
>
> READ_ONCE() on a u64? That's not gonna prevent tearing the read on 32
> bit architectures, right?

Right, we should add a conditional lock for 32-bit architectures.

>
> > +     *ts = (time & BNXT_HI_TIMER_MASK) | pkt_ts;
> > +     if (pkt_ts < (time & BNXT_LO_TIMER_MASK))
> > +             *ts += BNXT_LO_TIMER_MASK + 1;
>
> The stamp is from the MAC, I hope, or otherwise packet which could have
> been sitting on the ring for some approximation of eternity. You can
> easily see a packet stamp older than the value stashed in ptp->old_time
> if you run soon after the refresh.

The hardware returns the low 32-bit timestamp of the packet.
ptp->old_time contains the full 48-bit of the time counter that we
sample periodically.  We're getting the upper 16-bit from
ptp->old_time to form the complete timestamp for the packet.
ptp->old_time is between 1 and 2 sampling periods before the current
time.  The sampling period should be 1 second.

Yeah, if the RX packet is older than 1 to 2 seconds, the upper part
can potentially be wrong if it has wrapped around.

--00000000000006538505c36ecbe5
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJF1kVxNw6yuV6LPW7ZzCa6G/HDBaELI
eOIHssKfW0TXMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDUy
OTAyMzE0M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAo3jXcqF0ULH//uvOX3Fqf/rnx5mm/nzjzIE5GmmTV/ZKv32bC
JlbCFjgUX2tE23UCbrNCJapUoEJzvhPc/AB3ar8CqgDbUx1UJj67igXSLRfX11q0gZte4nCocvn8
aTboHh9YEM8DeoF3zW4zE7rHcW2keEr+UCPy6X0C6+JcaHL6rsQrCpSREThvgsBkKU4Womfa5yKW
qIz9pbBlZuXX20vUmTvl3zM1yTnC3wUlXcVLEqn4j4/KmsIkwjshtfZHdmBnEmu6g3DQVtUJok8D
iao8kIRsbPXE67Wz4PEc2n6v7QHSEa41VfvBoyT8IWlIbnQqJgLdZSdKwbA+0ygi
--00000000000006538505c36ecbe5--
