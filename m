Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899CA613BE0
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 18:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbiJaRGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 13:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbiJaRGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 13:06:36 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A880B12AC6
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 10:06:32 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id x15so3242698qtv.9
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 10:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=GdLLhjkbS9Q/tdbyqOXVguevEZWa0PfgGh7kos5wxmo=;
        b=C8vzJJQxiGy9bxzb3GfCrpYXjV+jBvbeTwQoour5buELcZs2NbHJ/FcxXbLGG4VI1A
         Iv/VkxclkugkD+c5HqouXZwlVFL+7QI3w/QDyQ3uxNmU2a5+qkcjaqGD9EGrmIBijLe7
         2IdDM1plP6esMU9/V224n69QIfYdZw0zmN7+Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GdLLhjkbS9Q/tdbyqOXVguevEZWa0PfgGh7kos5wxmo=;
        b=iT4Hhx0qDKh56vE8B1ez0an1XGSg24uhra71MBtESZH6fbJNjooHTCgqvFcSnHGhqO
         1a0+Kio6eGRb3zRlbvOtuUDJ+VbHoQRLTFbeGyvE9993qvPZKrlJgXjTEm9ee36DHG0F
         C9vyAKexpUcQ4IlUwqPjxhiFj7e4+Jv+utkhd9VJzGt4gSURzfrT0yiP3yl76NGNnH7o
         p4P5kUR7Smhce4fpXhzW9IyQ3T0xo36WQ2mtCJ3CFtvQ7QlpqtTIGXg44319bOrXUFYQ
         Jv80x3TNYeiQtGcqTvTYb9ZO6/wycEH1urvVVDfSn1p57ArIDQcjZPVbEydIDPQ8Vyxj
         4ufg==
X-Gm-Message-State: ACrzQf3OBktOq1Z9j1DOaqeolYYQO/Gs3h+36/KoWoEEvt6WJfonba8d
        poEIvpgU+UTfhrUa0xqh0m8Zl3T+jwaQjiSRF3HEWp+FlOUZVb27h1ghVdEmHYhwl558m0YXzGe
        dRwhbZO4=
X-Google-Smtp-Source: AMsMyM6O56bXHyvJRjlj0zACBNJCY/jdwC2QPuRaQUwFGHNu4IUg2yc+sawIdew4JnxKbKCjPL3C6g==
X-Received: by 2002:ac8:6690:0:b0:3a5:2e05:3433 with SMTP id d16-20020ac86690000000b003a52e053433mr2220043qtp.618.1667235991701;
        Mon, 31 Oct 2022 10:06:31 -0700 (PDT)
Received: from linuxpc-ThinkServer-TS140.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w12-20020a05620a424c00b006bbc3724affsm5048982qko.45.2022.10.31.10.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 10:06:29 -0700 (PDT)
From:   Steven Hsieh <steven.hsieh@broadcom.com>
To:     jay.vosburgh@canonical.com
Cc:     andy@greyhouse.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        steven.hsieh@broadcom.com, vfalico@gmail.com
Subject: Re: [PATCH net-next] bonding: 3ad: bonding of links with different data rate
Date:   Mon, 31 Oct 2022 10:06:05 -0700
Message-Id: <20221031170605.644240-1-steven.hsieh@broadcom.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <15633.1666628709@famine>
References: <15633.1666628709@famine>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000fbbc305ec57a18b"
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000000fbbc305ec57a18b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Jay for reviewing patch request.
We decided not to move forward.
Instead of adding different speed links to one aggregator,
we can assign them to multiple aggregators and use ad_select=3Dbandwidth
to pick highest bandwidth aggregator.

Thanks
Steven H.

> From: Jay Vosburgh <jay.vosburgh@canonical.com>
> To: Steven Hsieh <steven.hsieh@broadcom.com>
> Cc: Andy Gospodarek <andy@greyhouse.net>,
> 	"David S. Miller" <davem@davemloft.net>,
> 	Eric Dumazet <edumazet@google.com>,
> 	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
> 	Veaceslav Falico <vfalico@gmail.com>,
> 	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
> Subject: Re: [PATCH net-next] bonding: 3ad: bonding of links with differe=
nt data rate
> Date: Mon, 24 Oct 2022 09:25:09 -0700	[thread overview]
> Message-ID: <15633.1666628709@famine> (raw)
> In-Reply-To: <20221022220158.74933-1-steven.hsieh@broadcom.com>
>=20
> Steven Hsieh <steven.hsieh@broadcom.com> wrote:
>=20
> >Current Linux Bonding driver supports IEEE802.3ad-2000.
> >Operation across multiple data rates=E2=80=94
> >All links in a Link Aggregation Group operate at the same data rate.
> >
> >In IEEE802.1AX-2014
> >Aggregation of links of different data rates is not prohibited
> >nor required by this standard.
>=20
> 	The -2014 and -2020 versions change a lot of things at once; I'm
> not sure we can just cherry pick out one thing (or maybe we can, I'm
> reading through the changes).  Notably, the -2020 version states, in
> reference to changes added at -2014,
>=20
> "[...] it explicitly allowed the aggregation of point-to-point links of
> any speed using any physical media or logical connection capable of
> supporting the Internal Sublayer Service specified in IEEE Std
> 802.1AC."
>=20
> 	whereas the -2008 standard specifies "CSMA/CD MACs" instead of
> the ISS from 802.1AC.  I'm not yet sure if this makes any relevant
> difference.

> >This patch provides configuration option to allow aggregation of links
> >with different speed.
>=20
> 	Have you tested all of the edge cases?  E.g., what is the
> behavior with and without the option enabled when an interface in an
> aggregator changes its speed?
>=20
> 	If you have tests, consider including test scripts in
> tools/testing/selftests/drivers/net/bonding/
>=20

In current code, when 2nd port is linked up with different speed,
it will not be part of active aggregator.

> >Enhancement is disabled by default and can be enabled thru
> > echo 1 > /sys/class/net/bond*/bonding/async_linkspeed
>=20
> 	New option settings like this require (a) support in iproute2
> (to set/get the option like any other bonding option), and (b) updates
> to the documentation (Documentation/networking/bonding.rst).
>=20
> 	I'm not completely sold on the name, either, "async" doesn't
> really describe "differing data rates" in my mind.  Perhaps an option
> named "ad_link_speed" with allowed values of "same" or "any"?



--=20
This electronic communication and the information and any files transmitted=
=20
with it, or attached to it, are confidential and are intended solely for=20
the use of the individual or entity to whom it is addressed and may contain=
=20
information that is confidential, legally privileged, protected by privacy=
=20
laws, or otherwise restricted from disclosure to anyone else. If you are=20
not the intended recipient or the person responsible for delivering the=20
e-mail to the intended recipient, you are hereby notified that any use,=20
copying, distributing, dissemination, forwarding, printing, or copying of=
=20
this e-mail is strictly prohibited. If you received this e-mail in error,=
=20
please return the e-mail to the sender, delete it from your computer, and=
=20
destroy any printed copy of it.

--0000000000000fbbc305ec57a18b
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
zqFsDrDD6cfwPFA8egCLRqlqcMvTsLO8Ak8PulZSDNLvAbFQEcKXLzfSS5I4bJEyNm+gDxU2ufWn
S26/TTgra4hsvkgl1igpsKFbDqYd5GXc4f+GLIfWlFUCAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZc3RldmVuLmhzaWVoQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUo47KV++PjdaGX8yl9SYgLyqh
UFcwDQYJKoZIhvcNAQELBQADggEBACv8VBuGccogpklAkOkvfL8jtr7AUHpm2ZaG6RzE4EzvGTat
uzvVLmsDVHyVsa1ioxXjqCHYllCoea6lm9UEzsidojI+YYnkuh62tdBeZ7holVEdpaq39FmL1cdH
CSwbr9nedhgKPjQtcnY41wCwI1HMCUFiB3XW9DcBh94PSvqvYGsx0gFFJoXt2at06iqSLji8Rot+
jsXWHybl7AZDcupjJeQoApn6y0weM2xKcoG0WeN5SDDvmXTPe3AZG4n1xK1S8sjPJstMr++KiYS8
8l4ubZbXNKvsYhBY1PRITsrjcHkZbsufMbH2ZHAyxVN2QirJnb3Jocji5QBdKAX+pAAxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxJVhM6Swu/6EH/BMgw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEICR3zLSnPHN6ydSRQ8CZks8EeXTQ0kvH
sONcqpF6iaBDMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMTAz
MTE3MDYzMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBUoQNqkr9FMKnGOYERZ0DX5PCvaGa/aTK/9EdrCCymdEGQt/bu
Ls4ysdDmu3jBTvsnr/dFLdwTwyJhy5vzGJ+juJ8ig+2Jtu7t6htsy7P1Fn7MjcvfZc8AgUE4lbd0
z2PiXsZdsa5tTX2V4+TVkOH4BMSSbuCELju3ThjH8364pah1e2yYQURLWF+4+BE38ULAk5ey4SnJ
a06XdRce0lbnFkI7jos2LSeozdiQyOoSSsU8g96Z7KOu/ZmpjvXAJrJesP5+uIiNfX6aqjJ7YqO+
fZLvW21L38/9i5tG3ELtJ6DoOGHosKuP4NN/35RwI0ExHBr4uQYWBQMnGBHe7c/i
--0000000000000fbbc305ec57a18b--
