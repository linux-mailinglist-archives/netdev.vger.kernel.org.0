Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF36B4A2F74
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 13:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344878AbiA2Meg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 07:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiA2Mec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 07:34:32 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA88C061714
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 04:34:31 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id e2so16113749wra.2
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 04:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Vnxjf/xCmMz8InPFdIcd1sXtxn7ZgVnD4gw67gfe3IQ=;
        b=aObNYHSEThds2JcaVaibMN26y//hnr4ogndSsu8c2ncJV/QzFgAMQi8NBUjjm7V9Z4
         Z/JOu7zNnTZYhSpVRRWW4EE2shBt4Jl/ayDHj4pPY7axhWTI3z+VamwrzWDOvtdrXDTp
         GpgGXo4nQTHDefsBNy26YxENZlE9IxJJvripLmgxWiK0El6OmreXytXU4GgGFF/stFzL
         YKcteNA2Lpd8sdFn6Tzkjy6mGt4zD3V8ncyZ1lc71CqZ/iTsLByIJxJ+nu3tEgG6THyl
         7QauWkiri9o0n3Z8aZW2rUE0TVpqn3DLTILHn15RQrp4lbxGbPcDHJOqlS3n/SUalyES
         HgCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=Vnxjf/xCmMz8InPFdIcd1sXtxn7ZgVnD4gw67gfe3IQ=;
        b=GvLameo0Z5rxUL3DraSy20jtqM/hvsM7BXunFm43VN7dB/9ASRRcuN6iLLjzNShqKh
         l1eZPdUQNunnPFuRs1/Ntf9qtQOlJXLijLNaK+67BhY69mhG22W/AZR/BiltfZoaplTJ
         3vmhsvREethrWIaY81ehu06g42k1JQ3JxzTecw4PqW4h21zNpM6HaengdQfNAJ1S+ciY
         4dctb+PhPladPM93rR+b2aXkl4uapFhJ8LqcpU6G0sdYIDuZgzcAvYD0SeIexUgrF2dJ
         ybrOHSK/x1raB5n6fs6JLmXfjdPR16bFCzNiCwi8hC57jDtSOHx+3UJnFb7TSMwbng05
         LcdQ==
X-Gm-Message-State: AOAM531DU5U/r/W4vgX3Ek/MeAvc2HAYuRXcT4+5OM/5SUVoiCfGMqpw
        oCBtQyWg+qhJ/uaH24b3l0Dv96bNU5vXAQS8ExQ=
X-Google-Smtp-Source: ABdhPJwgSBxb+Mwo4WM9NEtRULUmp45/SAK41nUaSWRKDLV8L9d/sPFK+mFywWzUSqye5qfdlqQnhsiDLajEaE2Ipf8=
X-Received: by 2002:adf:90ec:: with SMTP id i99mr10873765wri.484.1643459668915;
 Sat, 29 Jan 2022 04:34:28 -0800 (PST)
MIME-Version: 1.0
Reply-To: martinafrancis01@gmail.com
Sender: edwinasmith19933@gmail.com
Received: by 2002:a5d:64e2:0:0:0:0:0 with HTTP; Sat, 29 Jan 2022 04:34:28
 -0800 (PST)
From:   Martina Francis <martinafrancis655@gmail.com>
Date:   Sat, 29 Jan 2022 04:34:28 -0800
X-Google-Sender-Auth: JU2NMWT8UrnLOwWEeZVsbCwPKMU
Message-ID: <CACOfs0HdNKABqudC0kbV6ifuaoTDOswe0CPFgXZvD_0KnC--Dw@mail.gmail.com>
Subject: Guten Tag mein Lieber,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Guten Tag mein Lieber,
Wie geht es dir und deiner Familie?
Ich bin Mrs. Martina Francis, eine kranke Witwe, die ohne Kind vom
Krankenhausbett aus schreibt. Ich kontaktiere Sie, damit Sie wissen,
dass ich den Betrag von (2.700.000,00 USD MILLIONEN USD), den ich von
meinem verstorbenen Ehemann geerbt habe, f=C3=BCr wohlt=C3=A4tige Zwecke sp=
enden
m=C3=B6chte. Derzeit befindet sich der Fonds noch auf der Bank. K=C3=BCrzli=
ch
sagte mir mein Arzt, dass ich eine schwere Krebserkrankung habe und
mein Leben nicht mehr garantiert ist, deshalb habe ich diese
Entscheidung getroffen.

Ich m=C3=B6chte, dass Sie diesen Fonds f=C3=BCr arme Menschen, missbrauchte
Kinder, weniger Privilegierte, Kirchen, Waisenh=C3=A4user und leidende
Witwen in der Gesellschaft verwenden.

Bitte melden Sie sich sofort nach dem Lesen dieser Nachricht bei mir,
um weitere Einzelheiten zu dieser humanit=C3=A4ren Agenda zu erhalten.

Gott segne Sie, w=C3=A4hrend ich auf Ihre Antwort warte.


Frau Martina Francis.
