Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061A92C784F
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 08:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgK2HFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 02:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgK2HFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 02:05:37 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2969EC0613D1
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 23:04:57 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id u21so264567qtw.11
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 23:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KHp+SmzIRemWn7zqWRezheXkfscJQeCe5emaplzDX54=;
        b=Ubh5kVG4EXd+LW2o/eJ9K3VbQq70fTsCem09z+l9IUrK72Azd7K5TwxmgbA1cNbDeG
         6tUkpExFGquDJYPQ2N3585CRzOgKzTGnUw29T/8I7+U0b6OX3hpj5cVZHOFRw2kB3Gyo
         byxjDl3jZmzOfPnZ8zJ5wRFuf+JR0CcfQtIgU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KHp+SmzIRemWn7zqWRezheXkfscJQeCe5emaplzDX54=;
        b=aHH9N6YCvyQqngiR0LGKoZK6ePpsRJ0jWZ5RLfiEQo6VCUCyb2dtdrZlEw4gcNvluo
         PayFsz1UAQIH8n7EKCThCaDpvyW6VJaZ5YGy7N/ypnBI767NtllQhgn6p2n9GWtSwLmO
         9vm9x7MhSpuOcbauDh/T/AjgFt8kw2AFTBwNi0iJfS+e+gtAtYxUR3lPDtnKJbHHqr40
         kkbam4qI39GoSc2rfgc7K562x4TIuulyWbO4qQ4i015BBwkjqqOYRkGM/pGiWwe1gSWb
         gKfgzYsomwhS1DNuZUtOGRgX1UkVa8oBbY9GahKw9QqYm+WiaLCDOYy57VrPZ9G/3qeF
         aulg==
X-Gm-Message-State: AOAM532dL8rWq0yMInCuL37pyhMOo77mr/UGdcWeUNZreCVjvm6BnusL
        QM1x9IubwcOcTHR0sHzvHPpota/b3QXgmEMtG7YMJzryQhE=
X-Google-Smtp-Source: ABdhPJyZPjFfR3jj3wYlXtBKwfnNGmag9XL4nXJTm9DvUKxCtrSmQzhq20aAWvMuA/weXSQ/CLFFJDA/3KWgePQP2g4=
X-Received: by 2002:ac8:488d:: with SMTP id i13mr16692368qtq.148.1606633495837;
 Sat, 28 Nov 2020 23:04:55 -0800 (PST)
MIME-Version: 1.0
References: <CAH6h+heNaKFT-xYdbOfYUa0Vp=Ybohb6A0TQ=N1EJDvFE6wbpw@mail.gmail.com>
In-Reply-To: <CAH6h+heNaKFT-xYdbOfYUa0Vp=Ybohb6A0TQ=N1EJDvFE6wbpw@mail.gmail.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Sat, 28 Nov 2020 23:04:46 -0800
Message-ID: <CACKFLikcVv0VrC1CX+BWKGM9n6J+nOSkJcB97m3RpxqO0svJCA@mail.gmail.com>
Subject: Re: NETDEV WATCHDOG: s1p1 (bnxt_en): transmit queue 2 timed out
To:     Marc Smith <msmith626@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d61cff05b539821e"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000d61cff05b539821e
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 25, 2020 at 11:39 AM Marc Smith <msmith626@gmail.com> wrote:

> [17879.279213] bnxt_en 0000:01:09.0 s1p1: TX timeout detected,
> starting reset task!
> [17883.075299] bnxt_en 0000:01:09.0 s1p1: Resp cmpl intr err msg: 0x51
> [17883.075302] bnxt_en 0000:01:09.0 s1p1: hwrm_ring_free type 1
> failed. rc:fffffff0 err:0
> [17886.957100] bnxt_en 0000:01:09.0 s1p1: Resp cmpl intr err msg: 0x51
> [17886.957103] bnxt_en 0000:01:09.0 s1p1: hwrm_ring_free type 2
> failed. rc:fffffff0 err:0
> [17890.843023] bnxt_en 0000:01:09.0 s1p1: Resp cmpl intr err msg: 0x51
> [17890.843025] bnxt_en 0000:01:09.0 s1p1: hwrm_ring_free type 2
> failed. rc:fffffff0 err:0

These messages could be caused by IRQ issues or firmware issues.  It
seems that one IRQ vector that is shared by 1 TX ring (type 1) and 2
RX rings (type 2) is not getting the interrupt.  It caused the
original TX timeout and the interrupt issue persisted during the
recovery to free these rings.

> firmware-version: 214.0.191.0

This firmware is about 2 years old.  I'll have someone get back to you
on how to upgrade and what version to upgrade to.

Thanks.

--000000000000d61cff05b539821e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQQgYJKoZIhvcNAQcCoIIQMzCCEC8CAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg2XMIIE6DCCA9CgAwIBAgIOSBtqCRO9gCTKXSLwFPMwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UE
CxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMT
Ckdsb2JhbFNpZ24wHhcNMTYwNjE1MDAwMDAwWhcNMjQwNjE1MDAwMDAwWjBdMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25h
bFNpZ24gMiBDQSAtIFNIQTI1NiAtIEczMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
tpZok2X9LAHsYqMNVL+Ly6RDkaKar7GD8rVtb9nw6tzPFnvXGeOEA4X5xh9wjx9sScVpGR5wkTg1
fgJIXTlrGESmaqXIdPRd9YQ+Yx9xRIIIPu3Jp/bpbiZBKYDJSbr/2Xago7sb9nnfSyjTSnucUcIP
ZVChn6hKneVGBI2DT9yyyD3PmCEJmEzA8Y96qT83JmVH2GaPSSbCw0C+Zj1s/zqtKUbwE5zh8uuZ
p4vC019QbaIOb8cGlzgvTqGORwK0gwDYpOO6QQdg5d03WvIHwTunnJdoLrfvqUg2vOlpqJmqR+nH
9lHS+bEstsVJtZieU1Pa+3LzfA/4cT7XA/pnwwIDAQABo4IBtTCCAbEwDgYDVR0PAQH/BAQDAgEG
MGoGA1UdJQRjMGEGCCsGAQUFBwMCBggrBgEFBQcDBAYIKwYBBQUHAwkGCisGAQQBgjcUAgIGCisG
AQQBgjcKAwQGCSsGAQQBgjcVBgYKKwYBBAGCNwoDDAYIKwYBBQUHAwcGCCsGAQUFBwMRMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFGlygmIxZ5VEhXeRgMQENkmdewthMB8GA1UdIwQYMBaA
FI/wS3+oLkUkrk1Q+mOai97i3Ru8MD4GCCsGAQUFBwEBBDIwMDAuBggrBgEFBQcwAYYiaHR0cDov
L29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3RyMzA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL3Jvb3QtcjMuY3JsMGcGA1UdIARgMF4wCwYJKwYBBAGgMgEoMAwGCisG
AQQBoDIBKAowQQYJKwYBBAGgMgFfMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNp
Z24uY29tL3JlcG9zaXRvcnkvMA0GCSqGSIb3DQEBCwUAA4IBAQConc0yzHxn4gtQ16VccKNm4iXv
6rS2UzBuhxI3XDPiwihW45O9RZXzWNgVcUzz5IKJFL7+pcxHvesGVII+5r++9eqI9XnEKCILjHr2
DgvjKq5Jmg6bwifybLYbVUoBthnhaFB0WLwSRRhPrt5eGxMw51UmNICi/hSKBKsHhGFSEaJQALZy
4HL0EWduE6ILYAjX6BSXRDtHFeUPddb46f5Hf5rzITGLsn9BIpoOVrgS878O4JnfUWQi29yBfn75
HajifFvPC+uqn+rcVnvrpLgsLOYG/64kWX/FRH8+mhVe+mcSX3xsUpcxK9q9vLTVtroU/yJUmEC4
OcH5dQsbHBqjMIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4G
A1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNV
BAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQL
ExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMK
R2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aE
yiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5
uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bL
yCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg
6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkW
qQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8w
HQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+
yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5
RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBov
Hd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX42
68NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o
2HLO02JQZR7rkpeDMdmztcpHWD9fMIIFRDCCBCygAwIBAgIMXmemodY7nThKPhDVMA0GCSqGSIb3
DQEBCwUAMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQD
EypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMwHhcNMjAwOTIxMTQ0
MzQ4WhcNMjIwOTIyMTQ0MzQ4WjCBjjELMAkGA1UEBhMCSU4xEjAQBgNVBAgTCUthcm5hdGFrYTES
MBAGA1UEBxMJQmFuZ2Fsb3JlMRYwFAYDVQQKEw1Ccm9hZGNvbSBJbmMuMRUwEwYDVQQDEwxNaWNo
YWVsIENoYW4xKDAmBgkqhkiG9w0BCQEWGW1pY2hhZWwuY2hhbkBicm9hZGNvbS5jb20wggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCzvTuOFaHAhIIrIXYLJ1QZpV36s3f9hlbZaYtz/62Y
SlCURfQ+8H3lJAzgIK2y0H/wT6TqqTDDJiRnDEm/g+5cRmc+bgdu6tGTmj0TIB5Z9wl5SCszDgme
/pPQJf8bD0McWRyaJctmS3DJWgBKl3Fg+tEwUtE4vjA2Yc8WK/S2gtZopdx2gDtvb9ckkJO1LENm
VqhZWob5BsD9/3+ouwWAGUFyA14cXchjfxAeuf4j03ckshYX3DVIp802zOgdQZ5QPfeLUIDSj4yF
ENt96uQJNu/QKZCsRxnu8bu9XkzIQTTFs7+NKghvf+h9ck5SSEvV5vlzS8HDlhKReyLBOxx5AgMB
AAGjggHQMIIBzDAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsGAQUFBwEBBIGRMIGOME0GCCsGAQUFBzAC
hkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3BlcnNvbmFsc2lnbjJzaGEy
ZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL2dzcGVy
c29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYm
aHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBEBgNVHR8E
PTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJn
My5jcmwwJAYDVR0RBB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUyZbpLEwR
KZHEh+rXp6GbCZmMEwUwDQYJKoZIhvcNAQELBQADggEBADZsABrJEwqeVLJJcX+rKN/oFPl/Sb1f
4NQRqf0J5IHlqI7oSUUaSVHviPvq4QyTMh7P9KHkuTwANTnTPr4f4y1SirdtxgZKy1xDmt1KjL5u
nA4rBLSA+Kp/mo0DMxKKQY/LsZNS3Zn+HIAZpXTUEFotC5qgN35ua7sP0hTynKzfLG8Fi565tQkX
Si7Gzq+VM1jcLa3+kjHalTIlC7q7gkvVhgEwmztW1SuO7pJn0/GOncxYGQXEk3PIH3QbPNO8VMkx
3YeEtbaXosR5XLWchobv9S5HB9h4t0TUbZh2kX0HlGzgFLCPif27aL7ZpahFcoCS928kT+/V4tAj
BB+IwnkxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMC
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgSf8obwUc3J7j
0VFOECvIjL6kLDrtyopIBiTAhSIDqIowGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAxMTI5MDcwNDU2WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAJRG8ZPubuRKscmnrdhgp2/n+Tpf1X4P
w0tZy84aBkbidhuzZYjycWHEL47cVSP0DT/ogKCSbMrzvWyOMKSB1+GpIieATmNHTkGh9HhOzd11
kRGjMYcsvCFu5kkmbUWECY5f7XIcPnKqZou9A728Nxoifh1DaOZGIlKKMytIe7BwsQh9tBn1IHG9
UlTlTNtsqz36f9OfJEnYnY5PNhDMcQLjiMhnpw905X0hTERy7h14Ppx33n1K8NZdHaVFQtoDIPSE
UIzgqr6dYdKIcHP6issoRocAHELLi9l2QA75xdvVjX9COVqKSL9ivRK/P1U1g24Fd8qu1Q+Bzdle
/UywhnA=
--000000000000d61cff05b539821e--
