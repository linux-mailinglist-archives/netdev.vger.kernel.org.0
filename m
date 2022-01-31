Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E5C4A40E1
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358702AbiAaLBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358445AbiAaLAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:00:17 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C67FC06176D
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 02:59:31 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id h7so16348332iof.3
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 02:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=FANIUiWvB3mdY3zLX2DODg2pUIL5eGT5wlydl6jYk40=;
        b=Hy4QzdJnSxdg5GIgw0nCwmi0gjML3n5cny2gld+5/rI5196yLd12xvP6N7LBmx65/n
         qILZMxYOlb+VBzjZrCg896+CVlR2SLc6f+WpN6lyRLTkfyWxlYA63cI2QUMsEgTIYq1c
         VRL4HNNC2kIyU16xAe6VyoHlNhIHv9mczE1zssIxdDBygn6D2BPwo/XAWJNqRMASZ2Dq
         yZxWrv8DUbv+uMJverpu1MhsgcV4b3vRNoXa2uyn5bo25Pb/5p2hQlMsoWmYebCBDCJD
         GjDhDoBcmmXgZL74zftZAkr0Rw6FLwL0/jzp5kj/UR37sO8Js0t8mGwGyrpI2mLOPNpu
         0GuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=FANIUiWvB3mdY3zLX2DODg2pUIL5eGT5wlydl6jYk40=;
        b=VzFnyvkNHHCCbkhsHBWstSTV7/S2UYQNRys0KckntLLLEWPRbuzSv8L1M8rxI42k0D
         9nkXjJph2R5iehUY4h+Xi80nRwpUYJljaXq9sdl+cfZOwUPLwcdUqsOKKcFty7Ople8H
         6h1HS0Zci8UYz3s7VNIdfP21wZdKPqgNy7OJiII/8BkpY0ppQhZjhxXVnbnGO5Cl+OjR
         wCzp9CJOHRT2Ts7fAmG8u88q6RRyRqKp5m8O4BKvk2HjtPHLNo3LdNg67wH58Qb4u2HZ
         g4Wlklz3k1Ri+oPvxowsXG4UsoHXyd+byLmZ7akwTLhKTEa1ZML7/jQbYFRJfdLoBOQC
         ouDQ==
X-Gm-Message-State: AOAM532EzTjjAkQJ0rWN4LoP5y4wQ1w7/oyfzgIi2bRL6zpB3TOrHPwM
        hCelW/tGps2NXm3T2aTmFFxzQnfnL3g7uYzdHHM=
X-Google-Smtp-Source: ABdhPJyia9VIjicXafubC2VjGdU01tny+88l0Ycxe3DKaKeOyUTFlA4LLKTxDKWWNigVvRhiFi9kYx5K7cHHm0s8/hs=
X-Received: by 2002:a02:aa09:: with SMTP id r9mr10286804jam.199.1643626771044;
 Mon, 31 Jan 2022 02:59:31 -0800 (PST)
MIME-Version: 1.0
Reply-To: daniellakyle60@gmail.com
Sender: drdanielmorris11111@gmail.com
Received: by 2002:a05:6638:1248:0:0:0:0 with HTTP; Mon, 31 Jan 2022 02:59:30
 -0800 (PST)
From:   Mrs daniell akyle <daniellakyle60@gmail.com>
Date:   Mon, 31 Jan 2022 11:59:30 +0100
X-Google-Sender-Auth: 5pmMZCS9vXWmOwBoU1Dt2uIUmsw
Message-ID: <CAKFcj-MtTareGvTX3Yo749sS2d4H56Fxx0cF0uKGPGQc=0xqUA@mail.gmail.com>
Subject: Ahoj
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pozdravy
Jmenuji se pan=C3=AD Daniella Kyleov=C3=A1, je mi 58 let
Filip=C3=ADny. V sou=C4=8Dasn=C3=A9 dob=C4=9B jsem hospitalizov=C3=A1n na F=
ilip=C3=ADn=C3=A1ch, kde jsem
podstupuje l=C3=A9=C4=8Dbu akutn=C3=ADho karcinomu j=C3=ADcnu. jsem um=C3=
=ADraj=C3=ADc=C3=AD,
vdova, kter=C3=A1 se rozhodla darovat =C4=8D=C3=A1st sv=C3=A9ho majetku spo=
lehliv=C3=A9 osob=C4=9B
kter=C3=A1 tyto pen=C3=ADze pou=C5=BEije na pomoc chud=C3=BDm a m=C3=A9n=C4=
=9B privilegovan=C3=BDm. Chci
poskytnout dar ve v=C3=BD=C5=A1i 3 700 000 =C2=A3 na sirotky nebo charitati=
vn=C3=AD organizace
ve va=C5=A1=C3=AD oblasti. Zvl=C3=A1dne=C5=A1 to? Pokud jste ochotni tuto n=
ab=C3=ADdku p=C5=99ijmout
a ud=C4=9Blejte p=C5=99esn=C4=9B tak, jak v=C3=A1m =C5=99=C3=ADk=C3=A1m, pa=
k se mi vra=C5=A5te pro dal=C5=A1=C3=AD vysv=C4=9Btlen=C3=AD.
pozdravy
Pan=C3=AD Daniella Kyleov=C3=A1
