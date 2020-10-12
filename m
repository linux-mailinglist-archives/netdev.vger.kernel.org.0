Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEFC28AC56
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 05:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgJLDG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 23:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbgJLDG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 23:06:58 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C50C0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 20:06:58 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id x16so2071033ljh.2
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 20:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tb/rzZTw8ZDN1Is6naiIzSz13tW/JpR7iOIy4INW31o=;
        b=Gzje64cnFMxqV65zwuQIgNSD60gSw7zGF4dD4gEFZrnqwFb/M5584v/U6d1tg84W7E
         IvFPUUj8T9Iko3Zmi9frfX+fFVqbOQz6XfW9y6MLWd3oyOGB7jozeiINJSbZo2DmUt90
         H+uKrMjqtjxFLvyg/PspuWtDsQlLlprw6pVWQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tb/rzZTw8ZDN1Is6naiIzSz13tW/JpR7iOIy4INW31o=;
        b=UOhLIBrJoMHgjYcxT4UlTqgNirxMLkudBUwfB2HvKXn8CY9JXVKRhpUcIbZBx2Maw5
         yO3heYNkY8yUUsnT37uAXlOjmP3xEhOPaqey0gYiJ/tYLdNN0N/95KcpJahzn6AFS+ts
         5hFwdJJa7dIJM+6NKRggkoro6lRVSmJeZIBfjkcJbw4cT6Qsh24+Uj+DPcbvmf4ynaWI
         UAzlubBPDlcd+Dbm3KhXVMwgtNFJWL1YwU/i3tGBzjSHqLJgjjvetJT0wpfC8NQrX7lI
         oUrEVlFL7Ja9nt4hSvg++JWkuIuTenAL49MmkysJvXKqlhnbLRp/twevJmSKNCyBb60Q
         FOKg==
X-Gm-Message-State: AOAM530zeZfrcbU6ursFVidJV71aAXpPF7tDbR+N3s3+XqVBiAGOsdNc
        636qSEIXs78wwU3uQ8cHToavUZldUlxxloxvYIm+/Q==
X-Google-Smtp-Source: ABdhPJyFnaiS8qaK4tjTurSkti3bWKTPsEUvLMf/V6zmtFVr/l7ay1jEdn9v7Nw6FRwZlPyk09YuW+kfw25QcEYhWiM=
X-Received: by 2002:a2e:98cf:: with SMTP id s15mr9040563ljj.320.1602472016104;
 Sun, 11 Oct 2020 20:06:56 -0700 (PDT)
MIME-Version: 1.0
References: <1602411781-6012-1-git-send-email-michael.chan@broadcom.com>
 <1602411781-6012-10-git-send-email-michael.chan@broadcom.com>
 <20201011150219.14af9c57@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CACKFLi=VfJdQ6S+7xAD_isrBt+fzH=Q5YfNbmrUhDcXnknP5rA@mail.gmail.com>
In-Reply-To: <CACKFLi=VfJdQ6S+7xAD_isrBt+fzH=Q5YfNbmrUhDcXnknP5rA@mail.gmail.com>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Mon, 12 Oct 2020 08:36:45 +0530
Message-ID: <CAACQVJqHSom+d3Rjxjx0j6d4t6-O+8GUVE4y-cYbWKTyBVWUGQ@mail.gmail.com>
Subject: Re: [PATCH net-next 9/9] bnxt_en: Add stored FW version info to
 devlink info_get cb.
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Andrew Gospodarek <gospo@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000004fff9405b17097bb"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000004fff9405b17097bb
Content-Type: text/plain; charset="UTF-8"

On Mon, Oct 12, 2020 at 4:01 AM Michael Chan <michael.chan@broadcom.com> wrote:
>
> On Sun, Oct 11, 2020 at 3:02 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Sun, 11 Oct 2020 06:23:01 -0400 Michael Chan wrote:
> > > +     rc = bnxt_hwrm_nvm_get_dev_info(bp, &nvm_dev_info);
> > > +     if (rc)
> > > +             return rc;
> >
> > This will not cause an error to be returned for the entire operation on
> > older FW or HW, right?
> >
>
> I don't think so.  This firmware call has been around for many years.
> The call was recently extended to return the stored version
> information but older firmware will still return successfully without
> the stored versions.  I'll ask Vasundhara to double check on this.
Yes, older firmware will return success and does not set the new flag
support for stored firmware versions. Only in error cases, older or
newer FW will return error. Thanks.

--0000000000004fff9405b17097bb
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
YS3R0dCZgl93IjbqtxySfyXCYBVcbmNI7TXYwPKDp3rYDuXJN+UPU+LuUTcffMyOyxGH45mhNXx5
RnSV48nP5wIDAQABo4IB1jCCAdIwDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBN
BggrBgEFBQcwAoZBaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25h
bHNpZ24yc2hhMmczb2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWdu
LmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYI
KwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQC
MAAwRAYDVR0fBD0wOzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFs
c2lnbjJzaGEyZzMuY3JsMCoGA1UdEQQjMCGBH3Zhc3VuZGhhcmEtdi52b2xhbUBicm9hZGNvbS5j
b20wEwYDVR0lBAwwCgYIKwYBBQUHAwQwHwYDVR0jBBgwFoAUaXKCYjFnlUSFd5GAxAQ2SZ17C2Ew
HQYDVR0OBBYEFKBXZ7bBA/b6lD9vCs1cnu0EUStlMA0GCSqGSIb3DQEBCwUAA4IBAQCUtbsWJbT8
mRvubq/HDaw7J1CrT0eVmhcStWb5oowqIv1vvivRBoNWBjCv8ME5o4mlhqb0f2uB1EqIL1B3oC4M
wslo5mPAA3SLSuE0k13VBajU3pBwidjPpuFZTXcmuZoRWTYp1iLFQHMoPF6ngcxlAzymFSxRhrDD
SqTlHafZ5cHnPvs2Vi1YYknDHNkg9Zu8jTqkIH35RfqBohg0aA37+n/4DivO4AkFT0uf/GAgmE3M
9TB6C6XSpcJwqMFie4QajeEVIuP7Iig2m95mEulo5aRerZDiITfACxDeZLEXlvVwaC/8E7MAnf0a
N9w2B4rts1llOp2FaxkZiIJC+xnGMYICbzCCAmsCAQEwbTBdMQswCQYDVQQGEwJCRTEZMBcGA1UE
ChMQR2xvYmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25hbFNpZ24gMiBD
QSAtIFNIQTI1NiAtIEczAgxWYvjrsGxnl1+028wwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcN
AQkEMSIEIJdGWhNlVxpe+qmJdRNnoIbxqdcJS1l80VWLDlFcWWXxMBgGCSqGSIb3DQEJAzELBgkq
hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIwMTAxMjAzMDY1NlowaQYJKoZIhvcNAQkPMVwwWjAL
BglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG
9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCI4ealu2+o
Hy7Y9FwDOd7HL2gYLX3XAzJSD5AbtDGwGtWpnvfSBXAuxBB864nBgO0VLtGosLVei7liNWbbk354
4N+8zu6zLuE1j4xkW+wCQa9i4nSE3LY2WmVmYo5IXPx+Xkpl9gd7qEt30wZtPbebxOwbwf4FKuIm
vUmA+ZINuEhg1LRBBIjrcMMR7YnCrv/rBJpO3mqbMEdCMR66PBi0fR5dCjuTcgTiQOSOu/kQw/4z
2OY9A7tZf2eFptKsAVW8VtazAbpEM30N5QqnLDPiDb7sLVFuwzkiRzOZSIiBxt6+MoJoRhuIzyHC
NuDqK/gRErw7PeLSCjsvzxUkQ0AN
--0000000000004fff9405b17097bb--
