Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F56471719
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 23:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhLKWNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 17:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbhLKWNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 17:13:11 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98218C061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 14:13:11 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id h16so11730931ila.4
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 14:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=hD0jfu1MWy/UXBkBYsVvOAZPApZLyir6gKavdc4BceI=;
        b=hzTG+nuQy6CGG1nS1pWZnEukF/yktbATI/x1pUFUxFVWXEkTaVjlEQuSms6pkb4yDL
         BG9Cyk5iFf7iUaK5pU66u/Ja5vocoMJA+kxWmITID9+3tHPJQrrXoALg+qFCzOtcvg35
         ES59u6/a1LhbMz7Ad3C7u2bF00qDHIrtfb4mJCT9Y/4eAXIqzV47I0pPW6PGhy6DCHGv
         FzhkN2nVuLTZEMEw9qnELCPHZ5vkx9YCIOwjI21y6R8UsnJvudn8u6W7Gw1trC+SOKdk
         G9uhJFE3u5wYHoRXpZMO6LMJqi5IQuh8ZDDpSW9dLu6o+CgbIXfGAmqDFY0SGrphD3hP
         poMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=hD0jfu1MWy/UXBkBYsVvOAZPApZLyir6gKavdc4BceI=;
        b=c+4A6LtEW1fic+VHzDe3briNKDdrXWiA4Eb9O59S0qz4JPFouw/d5IuaNGK7chu4A2
         ZcEx0E+cPotB30SF60A3euQrqp+UWsBA/jP91eqEBOgHGPjjC0B3oIRxMlWWMZOulwXG
         COLCu/5LszYw6kXS4Zz0oPg29heGJa+ssenvQIGlZup5th/a/bg+eXQS7fZqN7TsMEBF
         ujBbULmVqxnH2gPHTjdiQdE7ESOj2b6plV/WdvkdicQq7PjDf76W4VLtM8u0nlPxCB5G
         +Mm5e9Gdejn8gjUipUfULx4i5X4kDDMjXYEmi8K4/IY6yROc1BQknIknbE4NQfzNftq3
         PWmA==
X-Gm-Message-State: AOAM530E5ccbGusmQZzGO2oQt+KllHTxUDxAtSKvSqtIBOA5AoWJh1bN
        kbPtqY2YcZo7+GcTI5uaOUjLqGMAJY8rriqHhPQ=
X-Google-Smtp-Source: ABdhPJzQiaGHbbhZHdAVIPmtLUfSKMMjehWQq0+vzGip5axzYOoxkYaOK14joceZicZXSukpTjEkiyk2p7SDVT7bFX4=
X-Received: by 2002:a05:6e02:1c2a:: with SMTP id m10mr24261896ilh.279.1639260790927;
 Sat, 11 Dec 2021 14:13:10 -0800 (PST)
MIME-Version: 1.0
Reply-To: martinafrancis022@gmail.com
Sender: abbasaleh284@gmail.com
Received: by 2002:a6b:6101:0:0:0:0:0 with HTTP; Sat, 11 Dec 2021 14:13:10
 -0800 (PST)
From:   Martina Francis <martinafrancis61@gmail.com>
Date:   Sat, 11 Dec 2021 14:13:10 -0800
X-Google-Sender-Auth: W7zFqETdjGxi4SBMvAvR8u3Yjw4
Message-ID: <CAOaTg0jQ7AG_LDZtZWYFp0DyK7+3KMS9Wu7Zwvj+oQJR08U1sQ@mail.gmail.com>
Subject: Bom Dia meu querido
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Bom Dia meu querido,
Como vai voc=C3=AA hoje, meu nome =C3=A9 Dona Martina Francis, uma vi=C3=BA=
va doente.
Eu tenho um fundo de doa=C3=A7=C3=A3o de ($ 2.700.000,00 USD) MILH=C3=95ES =
que quero
doar atrav=C3=A9s de voc=C3=AA para ajudar os =C3=B3rf=C3=A3os, vi=C3=BAvas=
, deficientes
f=C3=ADsicos e casas de caridade.

Por favor, volte para mim imediatamente ap=C3=B3s ler esta mensagem para
obter mais detalhes sobre esta agenda humanit=C3=A1ria.

Deus te aben=C3=A7oe enquanto espero sua resposta.
Sua irm=C3=A3.

Sra. Martina Francis.
