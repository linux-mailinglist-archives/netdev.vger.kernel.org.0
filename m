Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F03A36A39A
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 01:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhDXX3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 19:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhDXX3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 19:29:42 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA730C061574
        for <netdev@vger.kernel.org>; Sat, 24 Apr 2021 16:29:03 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id d19so17511077qkk.12
        for <netdev@vger.kernel.org>; Sat, 24 Apr 2021 16:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SvBBzZetwYnJPukMdSWf6+VLbaLbQBdVOS3YYmPmRAI=;
        b=MLvqsQhbPxsq+v8/y4VGBMIjClWYl1dIeJ8MHxcjHmAFg8k0PcKUj98utjlQ/kIxie
         8MM7eb5AcQ088TF2TqSpfTYDsKTFd9Ud1vXx4ccUqg3pwHIifFthoBjqVqqI0heqNtaM
         T7f7Dc7OGGdd6NoYNx0sBA25cuyW+bI8bgbVk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SvBBzZetwYnJPukMdSWf6+VLbaLbQBdVOS3YYmPmRAI=;
        b=abjK+kbg4157wjguEo985JB61vP2vBoFTlEIMSSTkeYClp0HTCSopwWGJ8LSFv422x
         RHgjFb7zy2lUiISI1po7JCwL0WgU12rxVj4bilcKa0LIFhyLG4ZFz/UZvOGORmU2Ozdo
         tGpZPfB6WeEM0fAjcpm2n6zYVzXSZRGx5ZaxonWD4t5zNAX1Mt5OYf6e5xsPgTfH4mm/
         cMQIKgPLVcC4TqDSRYz2M50/wpKAvwEhF7AUzQA5q1ay/G44B7dOqQ2R/p3DPW9dwWk5
         nCZe0QuTXVZ6Zj4EKmk3qS03N/AJSP/XAs2Bibc7BKF2VFALf1/04L0LMmKN6KQv7tc9
         +hhQ==
X-Gm-Message-State: AOAM5300l8iBkmOYiVVSkY/psusqw+Ie5vYa26UzAclLmorbnz8NYAJk
        iyY720jtJWJl8oS+EtZPX8KhljsAym3+Io16gFdvbUK2rJGlDw==
X-Google-Smtp-Source: ABdhPJyi8SBPm9ybgbN6Oejc0SQN/RrSGYN8jsRDooeJeRcIl1UH+z3HljQxGH9fY4Z5G58dc9/ClB773iGy1r4lbxM=
X-Received: by 2002:ae9:df46:: with SMTP id t67mr10760263qkf.269.1619306942642;
 Sat, 24 Apr 2021 16:29:02 -0700 (PDT)
MIME-Version: 1.0
References: <1619295271-30853-1-git-send-email-michael.chan@broadcom.com>
 <1619295271-30853-11-git-send-email-michael.chan@broadcom.com> <20210424145205.1bfbdb06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210424145205.1bfbdb06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Sat, 24 Apr 2021 16:28:51 -0700
Message-ID: <CACKFLim_KBajprWKRsk2pT3uEXR=1CfHKngSQH5o4AyBnjf3og@mail.gmail.com>
Subject: Re: [PATCH net-next 10/10] bnxt_en: Implement .ndo_features_check().
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Andrew Gospodarek <gospo@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001fb32705c0c0473f"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000001fb32705c0c0473f
Content-Type: text/plain; charset="UTF-8"

On Sat, Apr 24, 2021 at 2:52 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 24 Apr 2021 16:14:31 -0400 Michael Chan wrote:
> > +     features = vlan_features_check(skb, features);
> > +     if (!skb->encapsulation)
> > +             return features;
> > +
> > +     switch (vlan_get_protocol(skb)) {
> > +     case htons(ETH_P_IP):
> > +             l4_proto = ip_hdr(skb)->protocol;
> > +             break;
> > +     case htons(ETH_P_IPV6):
> > +             l4_proto = ipv6_hdr(skb)->nexthdr;
> > +             break;
> > +     default:
> > +             return features;
> > +     }
> > +
> > +     /* For UDP, we can only handle 1 Vxlan port and 1 Geneve port. */
> > +     if (l4_proto == IPPROTO_UDP) {
> > +             struct bnxt *bp = netdev_priv(dev);
> > +             __be16 udp_port = udp_hdr(skb)->dest;
> > +
> > +             if (udp_port != bp->vxlan_port && udp_port != bp->nge_port)
> > +                     return features & ~(NETIF_F_CSUM_MASK |
> > +                                         NETIF_F_GSO_MASK);
> > +     }
> > +     return features;
>
> This is still written a little too much like a block list.
>
> What if, for example it's a UDP tunnel but with extension headers?
> Is there any particular case that is served by not writing it as:
>
>         if (l4_proto == UDP && (port == bp->vxl_port ||
>                                 port == bp->nge_port))
>                 return features;
>         return features & ~(CSUM | GSO);
> ?

Sure, I can change it to check for port == instead of port != to make
it more straight forward.

--0000000000001fb32705c0c0473f
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIP/wasMi2G/IFg1KHEbbWxq+oKuifvDl
xpfJWVf2ImmTMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDQy
NDIzMjkwM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAt0y43bCrmBT3Gsr2JI/IJ2VqAkFvXLu83mY6ZyXldOPAwbtBX
HGFqhpzGxpqSdDH8aBeJjEmjwibW17hK+SDuu479cTTpimT0BrYvCnkTemZn/GRpDY3HrC+Y0cha
/g0U7PX9N/PngtK7MTUITU3utcbBy+E5teqjqAeVLQasQCKdeGk9Ytb0MyLn6gYq9lflvhfREfhp
+eXns2argLOnkgGVNQtuGqOmpOG77X9O/y6F0PZvTy8jmBQsj0uNrongOnHFCFgUgTBajFZvoIVp
IRyB94wy9eRk9DvzGPWwItE7VZtm5yypQ7bv9z2LOkCnGN3QXT+or4S3i7daBXGT
--0000000000001fb32705c0c0473f--
