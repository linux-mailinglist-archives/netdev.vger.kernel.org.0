Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413AF44F441
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 17:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235241AbhKMRAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 12:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231912AbhKMRAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 12:00:53 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5A6C061766
        for <netdev@vger.kernel.org>; Sat, 13 Nov 2021 08:58:01 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id w23so2562662uao.5
        for <netdev@vger.kernel.org>; Sat, 13 Nov 2021 08:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Y5xrcoQVIg2YEh3v1j5Qs7Wbw0zmiBD1dx0P9N3lmL4=;
        b=gkcgJu7b2Ts2e71rbcSeOIGDBWBL5rtmHXS5dcljwSX+Qf8WECbYHFs8DCqZk4KeWf
         OZXZjewppjZwdywG0WtMt8MQRucVBkvEBEQZTSqnni1Xpbz/Ni25y4WINEq0sy9G1Ivp
         DA3MHdU+F4O7QLYYlSmtw2FzD7EZV1FPT6uYY/ts+kaV9JaurDL6KnD1bIJHM6oSN7uK
         g7NDCD2+QdwtDiNwL51siOnTZn5nQ3q/sgLij2aUobGMIYBBSsOsnTIZ+FSHlpW3ei03
         3WSi/cnxx3PyaBR2Ph65Lyro/TIlDT+KvD24lpYtt3HVZTlaeEmv7ntqRwVXPHJ2CKBa
         3INw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=Y5xrcoQVIg2YEh3v1j5Qs7Wbw0zmiBD1dx0P9N3lmL4=;
        b=n/LbLArp5zp4xERssVKR+Qjfet1kVNIb/H6xr/aQ0AEBB6f7X91lYBWcpr2LsJ6fJM
         tYNSoHBzv04NFm3BnstgiJRshCfP2DKqEK8/aEtQ6/urnIuUE/R+3Q8OJGQYRbq7uWWo
         EHbTTdJTFP6RE87XfYIJjRIHB7mXcq68gSkfZXkZFom5lwFaKAleNBOl75x+nk8OGh2B
         kT6G/PeV8y7tdiipnuUzKxjTiq4ZGaA/f+Tn/uRL7FcvokdV9g6IJg0TLmwD+gmgHcfQ
         sGnRR+NySF4WkR/lj2tU3kK0Ey6wc0NiQUg540e/dgAGS9UkCJ8K8Pi3HUGOO7k1vFGY
         rSXA==
X-Gm-Message-State: AOAM532x8xRdBPYmpzPBYkePEM5U7MQXxa7vis2XYPQ2OpOioE5OKkEr
        JdRScHQVVBs3AEBy2zTdjKup95AHDHdp3ADYxPo=
X-Google-Smtp-Source: ABdhPJwTP3jV3U3FZx0eHB4H5Ti+CyfNKPMm4t3EoG6J8pC6nZ+HzvTAhFY427zAUVB4Pz5M+G4vRW/Ca4sRkRaJNzA=
X-Received: by 2002:a67:de88:: with SMTP id r8mr21663668vsk.15.1636822679978;
 Sat, 13 Nov 2021 08:57:59 -0800 (PST)
MIME-Version: 1.0
Sender: jameswiliamsjw682@gmail.com
Received: by 2002:a59:adcd:0:b0:238:c90d:602 with HTTP; Sat, 13 Nov 2021
 08:57:59 -0800 (PST)
From:   DINA MCKENNA <dinamckennahowley@gmail.com>
Date:   Sat, 13 Nov 2021 16:57:59 +0000
X-Google-Sender-Auth: QL68xz_91zzkh6RUBQGhyKa-cpk
Message-ID: <CAJMpOnc_5VKOjYD87JKtyFkSYRibtFX=wM=+BdhPxtm44G-Hjg@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello my dear ,.

 I sent this mail praying it will get to you in a good condition of
health, since I myself are in a very critical health condition in
which I sleep every night without knowing if I may be alive to see the
next day. I bring peace and love to you. It is by the grace of God, I
had no choice than to do what is lawful and right in the sight of God
for eternal life and in the sight of man, for witness of God=E2=80=99s merc=
y
and glory upon my life. I am Mrs. Dina Mckenna. Howley, a widow. I am
suffering from a long time brain tumor, It has defiled all forms of
medical treatment, and right now I have about a few months to leave,
according to medical experts. The situation has gotten complicated
recently with my inability to hear proper, am communicating with you
with the help of the chief nurse herein the hospital, from all
indication my conditions is really deteriorating and it is quite
obvious that, according to my doctors they have advised me that I may
not live too long, Because this illness has gotten to a very bad
stage. I plead that you will not expose or betray this trust and
confidence that I am about to repose on you for the mutual benefit of
the orphans and the less privilege. I have some funds I inherited from
my late husband, the sum of ($ 11,000,000.00, Eleven Million Dollars).
Having known my condition, I decided to donate this fund to you
believing that you will utilize it the way i am going to instruct
herein. I need you to assist me and reclaim this money and use it for
Charity works therein your country  for orphanages and gives justice
and help to the poor, needy and widows says The Lord." Jeremiah
22:15-16.=E2=80=9C and also build schools for less privilege that will be
named after my late husband if possible and to promote the word of God
and the effort that the house of God is maintained. I do not want a
situation where this money will be used in an ungodly manner. That's
why I'm taking this decision. I'm not afraid of death, so I know where
I'm going. I accept this decision because I do not have any child who
will inherit this money after I die.. Please I want your sincerely and
urgent answer to know if you will be able to execute this project for
the glory of God, and I will give you more information on how the fund
will be transferred to your bank account. May the grace, peace, love
and the truth in the Word of God be with you and all those that you
love and care for.

I'm waiting for your immediate reply.

May God Bless you,
Mrs. Dina. Mckenna.
