Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6AF453B92
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 22:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhKPVWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 16:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbhKPVWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 16:22:22 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF27DC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 13:19:24 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id m27so990917lfj.12
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 13:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=JYSkOoz9hJraJdSP4aDP5lXbqFmye8utYzpxd6yMi80=;
        b=gnXOezpuSYRUY/jxBDwLGxVoLwnbMkzmtsnTluo9FzDGiJM7/kxgUFA2S//fc1oCAc
         NRf7bLQEl3iY3z3JktYPWtjtMxhfwnUIm7XnC8Ch8Fal283zCj8Ru51hnniIb6jL723Q
         cDYcwdq5qSdL/Bayk4oKlDau5dv+5pu0um2CLOYs+yn1qR79O0/UfXFD6DW0XlvjK3B0
         8GRHXTz0W1v3jUAeI5qQNgJEa/29pVGV11KWsY+Uwc5oI7n5nmvOcI9LPqWGfMWayYZk
         syIg+/4pl7Os+xy8JZINuwHy+114iD/c3twTK0+Q+XEema1HgXWIFvMMvPIwbe5C0i6f
         Txig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=JYSkOoz9hJraJdSP4aDP5lXbqFmye8utYzpxd6yMi80=;
        b=qRossfupBgwdFWGni6imFxi5x9ugbF03YKJDo1Q96CATeWgRWa9nzgBs2/gmdlZLuD
         lTFlk8cRxCbz0QD5cA3QFotbeISelxfAc57tkvzu9b/OpYGV0p3XvPFcKSkZq+zZSDtm
         z7WzchUEVu3wVbbHzIJzoKblsB7qVneyDTPtAHIyKjB7j3xsl+KZMuApgY4SKz0BAH7Q
         ElsmnOLUSQmWxKGVxgTU4IzQq4cLfxhvFG2ihUuQjkORMf49aJ9hT0X9lWhSgGuYJe3h
         MFi//dwOgeKknu6Rc7wkfbFjfGxVHuUz/DiYE7ex2TFI47FCsEvMFybQsXWiO6twieHd
         eKsQ==
X-Gm-Message-State: AOAM533bRnakn1yy8CZA74FgCN98fQL7W0a6fr0fJpVEJv4hhqmNRCVY
        rts3w3zC4TzuwYlkWHYWtPriLlLrhWrTeo9vnyk=
X-Google-Smtp-Source: ABdhPJxxrROllz5a3JTpsgdyyVYNIuwQ0OJ6XeHMC4wOPakafSICDsP4IYRKHzfkP4X3YhmWcS5wuJUg6sgOy3U9yos=
X-Received: by 2002:a05:6512:1102:: with SMTP id l2mr9924342lfg.469.1637097563119;
 Tue, 16 Nov 2021 13:19:23 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6520:3672:b0:14d:3700:d190 with HTTP; Tue, 16 Nov 2021
 13:19:22 -0800 (PST)
Reply-To: anawilliam152@citromail.hu
From:   "Anna S. William" <susanwilliam2152@gmail.com>
Date:   Tue, 16 Nov 2021 21:19:22 +0000
Message-ID: <CA+moBQyJt1_mA=HY=GiWDGT=5FLjqTzbyd3GTzJg_P2PQxia4w@mail.gmail.com>
Subject: Guten Morgen,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guten Morgen,

Ich bin Anna S. William. Dieser Brief ist sehr privilegiert und
es erfordert Ihre sofortige Aufmerksamkeit, da wir einen unserer
Kunden aus Ihrem Land verloren haben und er vor seinem Tod eine
befristete Einzahlung in H=C3=B6he von 4,7 Mio. bei unserer Bank hatte.

Angesichts Ihrer Nationalit=C3=A4t mit unserem verstorbenen Kunden Michael,=
 I.
Wenn Sie der Bank als Beg=C3=BCnstigter des Erbschaftsfonds vorgestellt
werden m=C3=B6chten, teilen wir beide die Mittel zu 50% bis 50% auf, sobald
das Geld auf Ihr Konto =C3=BCberwiesen wurde.

Ich freue mich auf Ihre sofortige Antwort.

Mit freundlichen Gr=C3=BC=C3=9Fen,
Anna S. William.
