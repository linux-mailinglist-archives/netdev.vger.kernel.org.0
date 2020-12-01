Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEAB02CA143
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 12:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbgLAL0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 06:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbgLAL0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 06:26:12 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A727EC0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 03:25:31 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id j10so2295848lja.5
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 03:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=14BjFNFwyg+6NnM52l4a5N7i21u1P5eIwmmLL2C77cU=;
        b=FC0GQfegsHytI9UHuHzsT0Xqy8szTYTMTqHuVjBpLWBFUM5vA3k4Un19Svc+gMEbSk
         Aqx0KIM9qOxEp24/S+8RlOTCrZ5PVxerk9ZktNXkpIOxNx2oId4Eb6sm7W6amGnw9geG
         4bFTh9B9ocYYdMMF8TP2iXejposXvdkudWIQA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=14BjFNFwyg+6NnM52l4a5N7i21u1P5eIwmmLL2C77cU=;
        b=VkwVzgoegkA/VsbAJkBb6L//A8z3wnY0o+1XmnJNbfKjOcQtCzpnaHNCBgz1BfCqW3
         GbQ+RxN8xOIZqNwHOCGeoswIalt5jVtwCqsezUfQCOdUsbdk5oGMISayJFHO7fjehBoj
         Qj8u+/SOnbd1JZBmfHssx2KSCODmfvnmPQXyNk9jhfzieS08mkX3t9ebNTfw8T2IG11q
         gG21cXf4ZonjncodmGUrVpeNSS95S/b95ux3BJMmo+eKcCn1kn2+kbHJjGC9suH+wYIm
         hUjlN9QSf/wSbFcT5/5q2dYgPCX1sDQ/7KyExQI10me+m+Xr9not+W4rpkQwn/RmxCB4
         Yh4Q==
X-Gm-Message-State: AOAM533Cpuz+96zrgRZGreE5PIQHJjmR4zvXL6wdK0KZTTvlBakk1SPs
        BiRutaPqVFl36KtqEwlXTkyB6UTe6cBmBYeU5kVVrQ==
X-Google-Smtp-Source: ABdhPJy42FZzyowKwweV81qqAJokQeCAhhDWPw0sCBJ2/H5jry1gA/fxAJnsC1Df/YipQlmQoVTpaQnp3Jb3/3hsdW0=
X-Received: by 2002:a2e:80c3:: with SMTP id r3mr1017538ljg.391.1606821929669;
 Tue, 01 Dec 2020 03:25:29 -0800 (PST)
MIME-Version: 1.0
References: <1606389296-3906-1-git-send-email-moshe@mellanox.com>
In-Reply-To: <1606389296-3906-1-git-send-email-moshe@mellanox.com>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Tue, 1 Dec 2020 16:55:18 +0530
Message-ID: <CAACQVJr_cYUUO=Nys=MeOLUno4sXy0a1PTwUk59hzjJZQz3j+w@mail.gmail.com>
Subject: Re: [PATCH iproute2-net 0/3] devlink: Add devlink reload action limit
 and stats
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000060b20d05b565620f"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000060b20d05b565620f
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 26, 2020 at 4:46 PM Moshe Shemesh <moshe@mellanox.com> wrote:
>
> Introduce new options on devlink reload API to enable the user to select
> the reload action required and constrains limits on these actions that he
> may want to ensure.
>
> Add reload stats to show the history per reload action per limit.
>
> Patch 1 adds the new API reload action and reload limit options to
>         devlink reload command.
> Patch 2 adds pr_out_dev() helper function and modify monitor function to
>         use it.
> Patch 3 adds reload stats and remote reload stats to devlink dev show.
>
>
> Moshe Shemesh (3):
>   devlink: Add devlink reload action and limit options
>   devlink: Add pr_out_dev() helper function
>   devlink: Add reload stats to dev show
>
>  devlink/devlink.c            | 260 +++++++++++++++++++++++++++++++++--
>  include/uapi/linux/devlink.h |   2 +
>  2 files changed, 249 insertions(+), 13 deletions(-)
I see man pages are not updated accordingly in this series. Will it be
updated in the follow-up patch?
>
> --
> 2.18.2
>

--00000000000060b20d05b565620f
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
AQkEMSIEINni20utx4jkPp73ETaEVmiPa3XyeBhwmJYXImGkNWy1MBgGCSqGSIb3DQEJAzELBgkq
hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIwMTIwMTExMjUzMFowaQYJKoZIhvcNAQkPMVwwWjAL
BglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG
9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAWjG97MY0C
9xuihhsC9arYRAMp7jz7TWfZRhUG51bLFTE994gk6+CqU64uiqGE75Vo8IAkTVy46Yld/ler6v6f
Xp8tjdQzf4Odh7YFLqINVdf+MYspZpj7c5lLIpjKpS85IIEeycEBgbk4oyDbXerRBIsCgj4g52+U
rrbbMHPKFQS+YbqDwR16c+oAevmNgfHyG2Y0tFdUYLNpiWOToUJGyER3Fgokob5jJ8xQzDH51+C9
a2X4VRASY7WMJ5bYr4wlGy0GZmKR2Zv5eWSl26UE6BUcWY1lYx1GL3aziTIkGIJwoD72lRuQ3Ewl
V9e01hw5DkUN7Yfo7OGAvVcHeAqH
--00000000000060b20d05b565620f--
