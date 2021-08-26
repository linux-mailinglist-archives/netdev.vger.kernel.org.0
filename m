Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F063F9016
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 23:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243685AbhHZVSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 17:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbhHZVSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 17:18:45 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7486DC061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 14:17:57 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id y144so5029887qkb.6
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 14:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2dbezjWSe7D6F6hU5LkSBT9ACgQN4LkANVFNNs9hSzA=;
        b=KcpVjXQ1vg+H0QbyVZs1msSUkpH/LjinCATrCtdUqoqgpfYety8XaWI6dM4rLDaQ6W
         G2QZ6mtY/gtZbD09dy9C53/yIAtjX6pcDvuZLx8+8breu8XWP09mOrhKaKkHaUwyUjPY
         NInkiGTTrd6GVH5taQ79XzZITUpu4KVWDsd1c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2dbezjWSe7D6F6hU5LkSBT9ACgQN4LkANVFNNs9hSzA=;
        b=OeidQHdAWVB97M7EmlRcFv4tWCf7gBgaRIkzyYEMrjXm3zMLpEiUoEKj0CwH6hBlVE
         LJO5ZVYQWlSTdndQtxJq5++WBrTmsPDjHFy3huhkWLC0tcgsrpNvRNhsmkuDek6aY2m5
         DMn+q2eigiZMh63Z1mmlznPs+9S5/jY5zFOp/pKkGZfX9e8NhWr6bM+XJa0xLw5N5OEe
         RI+p2p/3Ld+suSZuQ2n8yq8Md5iDF87U0ScvRrT/7J5LI3XrDCrAcFaPJ9H4SR4GeynK
         r8VJ8fV5IGo5P0LN+X0ukNpT3phrczEujK0nXGI/b/qap9HUkTs54kHmNX1BN9rTl3ri
         Y3KQ==
X-Gm-Message-State: AOAM533T1YVpH7MG6720z1vS5tHYfKBnF/kwT9a3Svv2EJ7P3XX4ByhA
        q6a3WJyis7uUJYMCt9ISNusskfLugjkZYNzIWWFmYg==
X-Google-Smtp-Source: ABdhPJyylGsCsOKXNn/MAaDOVXT889LB8lgdX/3++VF230FNepIYJSLQVkArzvMwHuc3GSt0MN4IxlkuQWdc1xoWPgI=
X-Received: by 2002:a05:620a:bcc:: with SMTP id s12mr5965816qki.431.1630012676269;
 Thu, 26 Aug 2021 14:17:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210826131224.2770403-1-kuba@kernel.org> <20210826131224.2770403-3-kuba@kernel.org>
 <CACKFLimh-oLG7zNBgSCYqS1aJh5ivBJJK+5kkL1kqJU5NOHctA@mail.gmail.com> <20210826121821.2c926745@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210826121821.2c926745@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Thu, 26 Aug 2021 14:17:45 -0700
Message-ID: <CACKFLimgBca1mFLp05uLQ3-8N8m12=hVOGU7rk8WJFeYnfK13w@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/3] bnxt: count packets discarded because of netpoll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, olteanv@gmail.com
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000094c5a605ca7ce60b"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000094c5a605ca7ce60b
Content-Type: text/plain; charset="UTF-8"

On Thu, Aug 26, 2021 at 12:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 26 Aug 2021 11:43:58 -0700 Michael Chan wrote:
> > On Thu, Aug 26, 2021 at 6:12 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > @@ -10646,11 +10653,15 @@ static void bnxt_get_ring_stats(struct bnxt *bp,
> > >                 stats->multicast += BNXT_GET_RING_STATS64(sw, rx_mcast_pkts);
> > >
> > >                 stats->tx_dropped += BNXT_GET_RING_STATS64(sw, tx_error_pkts);
> > > +
> > > +               bsw_stats->rx.rx_netpoll_discards +=
> > > +                       cpr->sw_stats.rx.rx_netpoll_discards;
> >
> > Can we just add these rx_netpoll_discards counters directly to
> > stats->rx_dropped?  It looks simpler if we do it that way, right?
>
> To make sure - are you saying that instead of adding
>
>         struct bnxt_sw_stats    sw_stats_prev;
>
> we should accumulate in net_stats_prev->rx_dropped, and have
> the ethtool counter only report the discards since last down/up?
>
> Or to use the atomic counter on the netdev and never report
> in ethtool (since after patch 3 rx_dropped is a mix of reasons)?

OK.  I've reviewed the patch again and you need to keep the previous
netpoll discard counter so that you can report the total current and
previous netpoll discard counter under ethtool -S.

My suggestion would lump the previous netpoll discard counter into the
previous rx_dropped counter and you can only report the current
netpoll discard counter under ethtool -S.  But note that all the ring
related counters we currently report are current counters and do not
include old counters before the last reset.

--00000000000094c5a605ca7ce60b
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIApk52b1YNjWJqHplKHBf0oiUCmHAkF6
MoKxFAAqZ/hWMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgy
NjIxMTc1NlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAWUNr6M2VJcyQlagPzt2umvPf3aNXj+LJxTf76hXbezuEMggo5
GvKTSM2uG1xqi7KQxroMGm1U9wMqnpzMNx6q36hY8iv6Ihi78xe9T5JfQzrGFBDVeYTABHOZxu1Z
xtQ0UVelNrlqaJUGJLFCqolwKjxdW5dxhkd0RZz2e1SyS42nDJze8Mmk/ImHtJdIIzSazMy1AfIu
gySFOmnQ55VvJ4XCDVT3kQar9O4ytpv0ypPPt9UhBdi9EIxJ8kMPPH1mXYbrZYhFFJHFLxM7S040
z03TWh72NaAMQfDmxCbpRXRghftcFWX3yjH6gWTWg5zwHnJhEbtQGjskdTxe5hj9
--00000000000094c5a605ca7ce60b--
