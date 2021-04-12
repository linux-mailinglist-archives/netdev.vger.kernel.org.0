Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFBFF35CFD7
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 19:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244674AbhDLRv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 13:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244488AbhDLRv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 13:51:56 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2759C061574
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 10:51:37 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id i11so1196804qvu.10
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 10:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+89cR1SrYGWhC2EoyXao37LBvNEKOUxnFHajAcVYX18=;
        b=PKYN1Sdex8kbq8qAxtpxWrnbPTs/KxCEGtwpY8rsb7tghFKHoI9GNqDjAdDAiOT1N3
         6JwmwyPJIJXmRD1UPJL6RxdtnHV4q8iqD042ilc+nddXaKGQrv2g3yF5IiOWJ79apUSS
         lIha3MpM7A8D713iVmt7mkCHYzVxjTnvUTWQQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+89cR1SrYGWhC2EoyXao37LBvNEKOUxnFHajAcVYX18=;
        b=pGgEkS/+rvVnNJsY035duNBMB3ukL+r8a9Wy1oQn1qRUkmZg0TEVSWPEdRpevPtXHT
         rFrydrQu1Ok3na1Sr0NcDfUahPJkkGT0zUtLxpEO7TlwNdcKB6d48MMmttb62c16GE1m
         UtWeWTg03nV8NjCUfwYR2IOiO0j4gxoZOlwU5Qui8N/KlmxU4MXVWUikyYh6tSLAvEL5
         tGyI4AWfT/UxRLvJjH5RP2tygQmNNFBmWfPUZ7bz2fSUCjWXiX0wf8VP6s8t4pjGRGT6
         4rkVhulsYXvED4I/7xTCY9CvQC9TnNG7C2neTsnL6cXB8RyZpg/0ZFuTZr9rE7s85/ZH
         lfkw==
X-Gm-Message-State: AOAM532Pa8suooHgewb61dtliss3kdn1q8D6YV2MLik4COJ2uHGpNR+o
        wgWoxqNr8FIETuF0qTvUNCLpic4WYbVxY/vDxRw+fde9dms=
X-Google-Smtp-Source: ABdhPJw2ra3KIVhztACNTzmn9PVzbilK7NEdryJNGnzu+TWupqJdLH6lqELyWoGMPoKoXEIQlPlVoTI4mRMuvesy5zA=
X-Received: by 2002:a05:6214:14aa:: with SMTP id bo10mr2143479qvb.19.1618249896368;
 Mon, 12 Apr 2021 10:51:36 -0700 (PDT)
MIME-Version: 1.0
References: <1618186695-18823-1-git-send-email-michael.chan@broadcom.com>
 <1618186695-18823-5-git-send-email-michael.chan@broadcom.com>
 <YHP4piIPfdXca+uB@unreal> <CACKFLi=jOqZx-yBBnNFaCOyWTWBKZ=W1KvY2xX-sKAxxOv7kQw@mail.gmail.com>
 <YHSEaVtK/SfrwkRq@unreal>
In-Reply-To: <YHSEaVtK/SfrwkRq@unreal>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 12 Apr 2021 10:51:25 -0700
Message-ID: <CACKFLimkp8HafpK+cP4+ib9gDkqT9=Evvm-mPrRd9gAHyADcPA@mail.gmail.com>
Subject: Re: [PATCH net-next 4/5] bnxt_en: Refactor __bnxt_vf_reps_destroy().
To:     Leon Romanovsky <leon@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Gospodarek <gospo@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000041f26105bfca2afe"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000041f26105bfca2afe
Content-Type: text/plain; charset="UTF-8"

On Mon, Apr 12, 2021 at 10:33 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Mon, Apr 12, 2021 at 09:31:33AM -0700, Michael Chan wrote:
> > On Mon, Apr 12, 2021 at 12:37 AM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Sun, Apr 11, 2021 at 08:18:14PM -0400, Michael Chan wrote:
> > > > Add a new helper function __bnxt_free_one_vf_rep() to free one VF rep.
> > > > We also reintialize the VF rep fields to proper initial values so that
> > > > the function can be used without freeing the VF rep data structure.  This
> > > > will be used in subsequent patches to free and recreate VF reps after
> > > > error recovery.
> > > >
> > > > Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
> > > > Reviewed-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
> > > > Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> > > > ---
> > > >  drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c | 21 ++++++++++++++-----
> > > >  1 file changed, 16 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> > > > index b5d6cd63bea7..a4ac11f5b0e5 100644
> > > > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> > > > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> > > > @@ -288,6 +288,21 @@ void bnxt_vf_reps_open(struct bnxt *bp)
> > > >               bnxt_vf_rep_open(bp->vf_reps[i]->dev);
> > > >  }
> > > >
> > > > +static void __bnxt_free_one_vf_rep(struct bnxt *bp, struct bnxt_vf_rep *vf_rep)
> > > > +{
> > > > +     if (!vf_rep)
> > > > +             return;
> > >
> > > How can it be NULL if you check that vf_rep != NULL when called to
> > > __bnxt_free_one_vf_rep() ?
> > >
> >
> > For this patch, the if (!vf_rep) check here is redundant.  But it is
> > needed in the next patch (patch 5) that calls this function from
> > bnxt_vf_reps_free() in a different context.  Thanks.
>
> So add it in the patch that needs it.
>

As stated in the changelog, we added more code to make this function
more general and usable from another context.  The check for !vf_rep
is part of that.  In my opinion, I think it is ok to keep it here
given that the intent of this patch is to create a more general
function.  Thanks.

--00000000000041f26105bfca2afe
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPpKEN4xNzkyAxZ6j0k+C4Nack/+2+a3
f5eZEMThmtT1MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDQx
MjE3NTEzNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBcbma6DAfaRZfvMSUSLCgcDk+enQJTzNSC3CGAkugrU3xhswuX
Fnmx45K+G0lBpk9dpwLauGbTPD/gn2FxzZXqjm302BfwEvIgnPeOllNiHDzBIFONxJoCGVP/FiEj
zEWV+UutzysLl7eTLWY6JIoERm6t4smAc1yRkhgw/zD4vBoqxYuAutKi2qpasIfVWwfkjJuOmvbQ
gObaz7AGQhyDL23eXE9gCTvpAHbvbbsfoTs1TG5ju9ClsGC39o8AJTTCppGDPeC6K8t/UeOjFEe2
GurVcnwhYvVT7XgjeOZW7mRfi5YKh9QhRk8U2qiOMWhuyaMVIvh6QKRd8xfW8kgX
--00000000000041f26105bfca2afe--
