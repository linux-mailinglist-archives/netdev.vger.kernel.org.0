Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6091DFD48
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 07:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgEXFG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 01:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbgEXFG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 01:06:56 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDA3C061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 22:06:56 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id l17so6792095ybk.1
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 22:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P8TlOT+kD0T7TdQDo/fqrwNb+3xZxUJSDrmsS5Oo7L0=;
        b=EHZNJRYvVGRggxN9Yxka5oQjymAPxpKYCjJcCE41hzTIg1xoKjazfEb0+Pbauk0+QX
         Q2WA/votOlGrFmeOJd3SdOj4YybgCCGFjAuE12dU/hGzICZ41jq8aqKIgMb0UOiwSB+i
         yVaO0MZFn+EtroSBS+h0h/JsS1hqOAHJXkY7M5HUMLkeVJYcZRKAu8QPDcw+uf4vPkWM
         DNVGYtw1ZGRXYX0IT9s4n0TaHoGDuYUCdhS+Bm8xWSlNMia81Fbfl/dxSzbII0Tib/cC
         RZzmJVJX1wkkHlfC7B94HGx31byNJISDCewOV73T/hCQU9a9NrFaGxRLqIol/O+Mhc01
         SJeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P8TlOT+kD0T7TdQDo/fqrwNb+3xZxUJSDrmsS5Oo7L0=;
        b=bPRY3cxySku8TisOR5gJhEmL1S2fx9TF+MNCc7IpoMS1BmW5AOa1gNZne4KELoSag9
         9VTFIL521OnFc8MJCc2nMrylx0SrdG95HeUzXO5kWSIx2cGtfvqNdA0HA1H3+DKCyFEg
         XsxD4Rzbn12ac6KlDRuU5AeiWdLRQj6fAWn/BH38OJWCVN5llJcSNuO81HkW530eP3Mn
         rzdHFsk6dW1BoN9kJ4mGAgco16koTIaDThT2eqr6P0ci6Z/TMavqrZZHjxy6M44vIude
         3SmD9NsE6YWYFYl9k7ArvGX0BaURpZOMlNirrpNX98dC9FHD3ryYjD9uzVSIiBrWMVjY
         LgIg==
X-Gm-Message-State: AOAM532nt8Z+gC2tXDAk+wBN0jVhIGkZzXQcYDDYacWQUaQnms1rplPB
        8e0rrcUmqS8BawVPfW88FwZgXck0XIq9wYpgOUqGfw==
X-Google-Smtp-Source: ABdhPJxorcKaRPVSRwQntl7iG0PRLCo5/TQ0HnfYhQtnCjkFNEhpIRSlXAZN8/EWeL6GdXEgPWQofdy0XBTSwjDqiWE=
X-Received: by 2002:a25:c4c2:: with SMTP id u185mr34692861ybf.79.1590296815066;
 Sat, 23 May 2020 22:06:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200524015144.44017-1-icoolidge@google.com>
In-Reply-To: <20200524015144.44017-1-icoolidge@google.com>
From:   Erik Kline <ek@google.com>
Date:   Sat, 23 May 2020 22:06:43 -0700
Message-ID: <CAAedzxqg8SJgwtvq=G9ZytAGhpZ=Q7MwJNPsm-XYs0p_zo-7ug@mail.gmail.com>
Subject: Re: [PATCH] iproute2: ip addr: Accept 'optimistic' flag
To:     "Ian K. Coolidge" <icoolidge@google.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c7e87705a65dd406"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000c7e87705a65dd406
Content-Type: text/plain; charset="UTF-8"

patched and tested on a 5.6.13 system

Acked-by: Erik Kline <ek@google.com>


On Sat, 23 May 2020 at 19:01, Ian K. Coolidge <icoolidge@google.com> wrote:
>
> This allows addresses added to use IPv6 optimistic DAD.
> ---
>  ip/ipaddress.c           | 7 ++++++-
>  man/man8/ip-address.8.in | 7 ++++++-
>  2 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> index 80d27ce2..48cf5e41 100644
> --- a/ip/ipaddress.c
> +++ b/ip/ipaddress.c
> @@ -72,7 +72,7 @@ static void usage(void)
>                 "           [-]tentative | [-]deprecated | [-]dadfailed | temporary |\n"
>                 "           CONFFLAG-LIST ]\n"
>                 "CONFFLAG-LIST := [ CONFFLAG-LIST ] CONFFLAG\n"
> -               "CONFFLAG  := [ home | nodad | mngtmpaddr | noprefixroute | autojoin ]\n"
> +               "CONFFLAG  := [ home | nodad | optimistic | mngtmpaddr | noprefixroute | autojoin ]\n"
>                 "LIFETIME := [ valid_lft LFT ] [ preferred_lft LFT ]\n"
>                 "LFT := forever | SECONDS\n"
>                 "TYPE := { vlan | veth | vcan | vxcan | dummy | ifb | macvlan | macvtap |\n"
> @@ -2335,6 +2335,11 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
>                                 ifa_flags |= IFA_F_HOMEADDRESS;
>                         else
>                                 fprintf(stderr, "Warning: home option can be set only for IPv6 addresses\n");
> +               } else if (strcmp(*argv, "optimistic") == 0) {
> +                       if (req.ifa.ifa_family == AF_INET6)
> +                               ifa_flags |= IFA_F_OPTIMISTIC;
> +                       else
> +                               fprintf(stderr, "Warning: optimistic option can be set only for IPv6 addresses\n");
>                 } else if (strcmp(*argv, "nodad") == 0) {
>                         if (req.ifa.ifa_family == AF_INET6)
>                                 ifa_flags |= IFA_F_NODAD;
> diff --git a/man/man8/ip-address.8.in b/man/man8/ip-address.8.in
> index 2a553190..fe773c91 100644
> --- a/man/man8/ip-address.8.in
> +++ b/man/man8/ip-address.8.in
> @@ -92,7 +92,7 @@ ip-address \- protocol address management
>
>  .ti -8
>  .IR CONFFLAG " := "
> -.RB "[ " home " | " mngtmpaddr " | " nodad " | " noprefixroute " | " autojoin " ]"
> +.RB "[ " home " | " mngtmpaddr " | " nodad " | " optimstic " | " noprefixroute " | " autojoin " ]"
>
>  .ti -8
>  .IR LIFETIME " := [ "
> @@ -258,6 +258,11 @@ stateless auto-configuration was active.
>  (IPv6 only) do not perform Duplicate Address Detection (RFC 4862) when
>  adding this address.
>
> +.TP
> +.B optimistic
> +(IPv6 only) When performing Duplicate Address Detection, use the RFC 4429
> +optimistic variant.
> +
>  .TP
>  .B noprefixroute
>  Do not automatically create a route for the network prefix of the added
> --
> 2.27.0.rc0.183.gde8f92d652-goog
>

--000000000000c7e87705a65dd406
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIO/gYJKoZIhvcNAQcCoIIO7zCCDusCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ggxhMIIEkjCCA3qgAwIBAgINAewckktV4F6Q7sAtGDANBgkqhkiG9w0BAQsFADBMMSAwHgYDVQQL
ExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMK
R2xvYmFsU2lnbjAeFw0xODA2MjAwMDAwMDBaFw0yODA2MjAwMDAwMDBaMEsxCzAJBgNVBAYTAkJF
MRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSEwHwYDVQQDExhHbG9iYWxTaWduIFNNSU1FIENB
IDIwMTgwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCUeobu8FdB5oJg6Fz6SFf8YsPI
dNcq4rBSiSDAwqMNYbeTpRrINMBdWuPqVWaBX7WHYMsKQwCOvAF1b7rkD+ROo+CCTJo76EAY25Pp
jt7TYP/PxoLesLQ+Ld088+BeyZg9pQaf0VK4tn23fOCWbFWoM8hdnF86Mqn6xB6nLsxJcz4CUGJG
qAhC3iedFiCfZfsIp2RNyiUhzPAqalkrtD0bZQvCgi5aSNJseNyCysS1yA58OuxEyn2e9itZJE+O
sUeD8VFgz+nAYI5r/dmFEXu5d9npLvTTrSJjrEmw2/ynKn6r6ONueZnCfo6uLmP1SSglhI/SN7dy
L1rKUCU7R1MjAgMBAAGjggFyMIIBbjAOBgNVHQ8BAf8EBAMCAYYwJwYDVR0lBCAwHgYIKwYBBQUH
AwIGCCsGAQUFBwMEBggrBgEFBQcDCTASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQWBBRMtwWJ
1lPNI0Ci6A94GuRtXEzs0jAfBgNVHSMEGDAWgBSP8Et/qC5FJK5NUPpjmove4t0bvDA+BggrBgEF
BQcBAQQyMDAwLgYIKwYBBQUHMAGGImh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9yb290cjMw
NgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LXIzLmNybDBn
BgNVHSAEYDBeMAsGCSsGAQQBoDIBKDAMBgorBgEEAaAyASgKMEEGCSsGAQQBoDIBXzA0MDIGCCsG
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
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMFEGCCsGAQUFBwEBBEUwQzBBBggr
BgEFBQcwAoY1aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NzbWltZWNhMjAx
OC5jcnQwHwYDVR0jBBgwFoAUTLcFidZTzSNAougPeBrkbVxM7NIwPwYDVR0fBDgwNjA0oDKgMIYu
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9jYS9nc3NtaW1lY2EyMDE4LmNybDANBgkqhkiG9w0B
AQsFAAOCAQEAiDHgzjxAxMFZIMoofcZ8owcPlEMNeCXaz4/qehn81jhU06SmvtE81MB0Nh4pvct7
kxE9dxRsXzGKGDTOOAgPW/g3oplhUYxihuFKpjjdWpxmNUmk8zHK78E5fBdq/XLSEULsYEPNWvMI
Whi7+faCy9975o19xpQNhh5iykkm7Avrh1ZekSZ5SjG86PMwy8RPGlpBwfykfp9F+UoGn2gePlvA
oleSV067+WuMFXRjIz59TafU0KuLjprqgblNicBpA92Fh3W+G1D//778shEAvrjhd9dUrgOZuMl3
v9K2woAQHxJyK4hHKdpuy08C9bMqCtnEwlGbKBfKaO9uKPzdAjGCAmEwggJdAgEBMF8wSzELMAkG
A1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExITAfBgNVBAMTGEdsb2JhbFNpZ24g
U01JTUUgQ0EgMjAxOAIQAVMDySmh7XCUegJ9yTLs0TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG
9w0BCQQxIgQgxt5cyIG6eQyh02y1yiadc7AxcvI5TuLigQgAiSl9/wEwGAYJKoZIhvcNAQkDMQsG
CSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAwNTI0MDUwNjU1WjBpBgkqhkiG9w0BCQ8xXDBa
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqG
SIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAC/QBk+0
bWAcWGJIK8tQ6FnOhuib0cZa02a3mOju1JFBSb+e0EKFiVrzghHU41VAVVxNYb/Wr+Eb2s16BqN1
zEB8fEe0EoGVBzs5N0CyeGXxrYcUqfkb+jjdT+Il7+fGH89SG2420r8r9MEPify9k1+Xv+FdVByn
27VKYPd+D0wotYX38jukr+gzGLinaF1JiLbOeEmxHDQhn1FgxutMMeOAT9TM1qcvAuw8Vp3M18Zi
+jkTnh15E2pOzxN0G0+l9KDiuCd524nT1neCHVXpfnlMdUbydFBHGCvgTOi6Ms3EuFfRGIR/3ulR
hQUIQSbnDsVEIgTS0VD+fHH6I7hzNfA=
--000000000000c7e87705a65dd406--
