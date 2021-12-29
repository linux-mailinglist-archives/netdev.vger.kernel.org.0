Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B74B4810A2
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 08:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239093AbhL2H0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 02:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239088AbhL2H0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 02:26:24 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F92C061574
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 23:26:24 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id u21so20446994oie.10
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 23:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=zOHJbgxEeKcTUS1M3dbg/CCHL8zxNc7o7Y1pwSiNVNQ=;
        b=ZixyloBR20Z/fY3cHOPgXMYm/ZWpUyLkM5wOMf2oTHAYGKyghETSVTI3NqzvMNHuHJ
         Oxuv5eB9sL8jPDjJ+I7lAkrmI48exxnyh3MaGyL1cKixWNE7jux8eJ3u1fNkUtMdEofo
         wGzdDGp/wQKCOHSMd5ytwCv5hSaUmc4fAdxSwhEOympDYn21oH2LOiY4hSWIwhMLZ1Ec
         hMoXgIEGgtrNf7hT9UqcuhFVM3P7nEpTPwnDWHUrvf1RAlWgy8sGObP8EWh6Qlybo6BF
         PxxPVVxbj4PbJB83w05IzZuwI9UTeJuBlSb6fiD1gr/MZoB73k6RcUYKPScansHuShBK
         nFdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=zOHJbgxEeKcTUS1M3dbg/CCHL8zxNc7o7Y1pwSiNVNQ=;
        b=yLZpqe/+CSvKz4XzcA0A+105LqN8j/XQC+F/1Xgpv47kDsHnrJqkv+5Ldr1/O4zU1z
         Zmmo+mmATS7OyOExFnlISx33VRSy+g2mY0EKJ5LPd8UqnOuiDCUoZRSb0dL4yTeYBvgV
         6QgMqgAJuAMEErTcQK1lgyQzFthy+vELqn51NsZXOtrOsNE7DM1EgBmRhUCr3NoAZQnT
         a0TvThUrXgBS5OgVB+xQ84ENV+vjOU3x5t83ALfeKs00r81aq+uAuB6/crWGKjRVZVjV
         ElxwtIOuPI7rS2/lSiTefwTyEa8Vp6sbsAP1OyD+tjdmlYNuMgOjy6rXNsCQ3FBQVr6d
         vXJQ==
X-Gm-Message-State: AOAM533m1h64HxsJh7dKtIP/YjHwgnSbIrDFXqOr863UFwEf3HlT8B7J
        MlSm0srapvkOtsUzVZnjMtQ1DLquYPBvhs3Vnwo=
X-Google-Smtp-Source: ABdhPJxnOALi1CSpBr6prZ5OSJYhmscxqw1E+pNyUxuxmRmpdM9cSp2JihN/Wi/sQo93qO7mWkIIn/Gla2VbyEjiYeg=
X-Received: by 2002:aca:c1c2:: with SMTP id r185mr6468389oif.168.1640762783383;
 Tue, 28 Dec 2021 23:26:23 -0800 (PST)
MIME-Version: 1.0
Sender: charityvangal@gmail.com
Received: by 2002:a4a:be8f:0:0:0:0:0 with HTTP; Tue, 28 Dec 2021 23:26:22
 -0800 (PST)
From:   DINA MCKENNA <dinamckennahowley@gmail.com>
Date:   Wed, 29 Dec 2021 07:26:22 +0000
X-Google-Sender-Auth: -00EqwX-qSmLPz0JbnJ-ksb9GtQ
Message-ID: <CABTbXjJsn+yifRRLFPiu=vWCA9G72mSLDSDd5_FCuzidTAW=sg@mail.gmail.com>
Subject: Calvary greetings.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello my dear,

 I sent this mail praying it will get to you in a good condition of
health, since I myself are in a very critical health condition in
which I sleep every night without knowing if I may be alive to see the
next day. I bring peace and love to you. It is by the grace of God, I
had no choice than to do what is lawful and right in the sight of God
for eternal life and in the sight of man, for witness of God=E2=80=99s merc=
y
and glory upon my life. I am Mrs. Dina. Howley Mckenna, a widow. I am
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

I'm waiting for your immediate reply..

May God Bless you,
Mrs. Dina. Howley Mckenna.
