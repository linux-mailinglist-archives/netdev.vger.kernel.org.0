Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBA4D10118
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 22:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfD3UoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 16:44:14 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41407 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfD3UoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 16:44:13 -0400
Received: by mail-ot1-f68.google.com with SMTP id g8so12209922otl.8;
        Tue, 30 Apr 2019 13:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PTV15nJneVdfmyDcOrRVmlbOb/fi8FsOQi10bI3xRQw=;
        b=p9ATfaJmi5ZNgwSqlP9r7LDOw6tzURlyulmIIU6vapZqDyOudh7DnDErqBzVG9c9SP
         ReA2XymC4j5Jvi4KB2UhRmUAM68WSUWrUI2GVACGl/hB9qxaG3q9Ecd1vdPXWX7c80F1
         V7qDxTw2WLTiHuGy5UasIwmBwQBBALpWTqV+WTdzfWNrVRThwW1XYJzpuM7bHEjPFqsR
         C2j18a21kvPVS78oGX08tjY7OJoHUrzOxskU0hHtehO73nEF7K/wUx69Xs/QdIF8eyLd
         LwR+VKUVzoVoBCqMHWVf+wczCWsH1TpzwjuzU+2tgb1iqIg773B+4cGOv0Us8ZSXXMtV
         RXoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PTV15nJneVdfmyDcOrRVmlbOb/fi8FsOQi10bI3xRQw=;
        b=dPKipP+aQsvru9sJd7eMLr9OWnqkxttSOY6CLckM2053HNNDRTJ/kvug+/VV8cPfoo
         CZO71A9cVoBRNujvqTRvv5+7blmQt/Jc3d1Tv+EnHv/ArKFf4q5cccSkDmcOAxMAtJ9U
         w00r8KRqGGzZMUz1uTu587bC5UKbYnEupjOeOHY8Cw2SuUNADQ/qZVG9S+e1H6KBd+3l
         8DylAjCfFkyxE5fBbEuWfGKp9j7kgJbEQNcJ8spy+dh1BMeaWTfcMBx6/nmtHrwrclkd
         QYYgs4YR6sqAltoiDvn/LSr7+6AfajMmwqrjGRsQotKiFGvTn4/DYR00BRqZ5uwmeX6D
         vj5g==
X-Gm-Message-State: APjAAAUT1Nrksi0OU+YEKrzx7YfAvQEzuh8VWw5nKsbynMcQ8DJRXVoI
        8NLN5mhZwaVUByZbysU4kooHk34oomJGrtfRMr8=
X-Google-Smtp-Source: APXvYqwXp+++he2rIyQNsyjXebRLLugDsonVUFyzm+I44eP5vPdEPyYcmjJUrYL3Hdexr69kyb4YdSEIjFGG2j9HrQ8=
X-Received: by 2002:a9d:5e90:: with SMTP id f16mr2035975otl.86.1556657051625;
 Tue, 30 Apr 2019 13:44:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190426212112.5624-1-fancer.lancer@gmail.com>
 <20190426212112.5624-2-fancer.lancer@gmail.com> <20190426214631.GV4041@lunn.ch>
 <20190426233511.qnkgz75ag7axt5lp@mobilestation> <f27df721-47aa-a708-aaee-69be53def814@gmail.com>
 <CA+h21hpTRCrD=FxDr=ihDPr+Pdhu6hXT3xcKs47-NZZZ3D9zyg@mail.gmail.com>
 <20190429211225.ce7cspqwvlhwdxv6@mobilestation> <CA+h21hrbrc7NKrdhrEk-t7+atj-EdNfEpmy85XK7dOr4Cyj-ag@mail.gmail.com>
In-Reply-To: <CA+h21hrbrc7NKrdhrEk-t7+atj-EdNfEpmy85XK7dOr4Cyj-ag@mail.gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 30 Apr 2019 22:44:00 +0200
Message-ID: <CAFBinCC14+b_nnAMLf0RAET440jGMGz2KRheioffjM+-ftifRQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: phy: realtek: Change TX-delay setting for
 RGMII modes only
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Serge Semin <Sergey.Semin@t-platforms.ru>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vladimir,

On Tue, Apr 30, 2019 at 12:37 AM Vladimir Oltean <olteanv@gmail.com> wrote:
[...]
> Moreover, RGMII *always* needs clock skew. As a fact, all delays
> applied on RX and RX, by the PHY, MAC or traces, should always amount
> to a logical "rgmii-id". There's nothing that needs to be described
> about that. Everybody knows it.
thank you for mentioning this - I didn't know about it. I thought that
the delays have to be added in "some cases" only (without knowing the
definition of "some cases").

> What Linux gets told through the phy-mode property for RGMII is where
> there's extra stuff to do, and where there's nothing to do. There are
> also unwritten rules about whose job it is to apply the clock skew
> (MAC or PHY).That is 100% configuration and 0% description.
the phy-mode property is documented here [0] and the rgmii modes have
a short explanation about the delays.
that said: the documentation currently ignores the fact that a PCB
designer might have added a delay

> > Then in accordance with the phy-mode property value MAC and PHY drivers
> > determine which way the MAC and PHY are connected to each other and how
> > their settings are supposed to be customized to comply with it. This
> > interpretation perfectly fits with the "DT is the hardware description"
> > rule.
> >
>
> Most of the phy-mode properties really mean nothing. I changed the
> phy-mode from "sgmii" to "rgmii" on a PHY binding I had at hand and
> nothing happened (traffic still runs normally). I think this behavior
> is 100% within expectation.
the PHY drivers I know of don't complain if the phy-mode is not supported.
however, there are MAC drivers which complain in this case, see [1]
for one example


Martin


[0] https://github.com/torvalds/linux/blob/bf3bd966dfd7d9582f50e9bd08b15922197cd277/Documentation/devicetree/bindings/net/ethernet.txt#L17
[1] https://github.com/torvalds/linux/blob/bf3bd966dfd7d9582f50e9bd08b15922197cd277/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c#L187
