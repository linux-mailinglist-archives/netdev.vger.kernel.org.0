Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8442F2866
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 07:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387519AbhALGj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 01:39:26 -0500
Received: from mail-yb1-f176.google.com ([209.85.219.176]:36593 "EHLO
        mail-yb1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729049AbhALGjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 01:39:25 -0500
Received: by mail-yb1-f176.google.com with SMTP id y4so1210447ybn.3;
        Mon, 11 Jan 2021 22:39:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ElVoQG5KMy+Lp9Vbs8/Yd2MZ45smz4katwHziEUpjdc=;
        b=MTWCkB/dKdua3g2SMD2mcDlCFbJCNQ0E7A8jJ8YbGDCfwWZOGMUO2niICPIiHVaCRT
         oQOkYdPyUoTt9aYMzk3x0zTw5NOUYPzxvqOQwKFkxJMWPOHYILJs4oLakKC4DtDk66Z3
         v9zqQYu8Xc8DT23oC/hWxpIZTG1RpzoQFFpoYc3I0nkakZtvbNHJQ6F+usvD00n2WvUt
         o7JbXpDRNiGf0JDO2y+axgya3mrlQlGKeRWTzHbGVKnNj/hawcfGjhefsfDYB9WRxOV9
         sCrjGH0Ecb1YqGDICQI17cicDrh5vvEYIO34cFRQzK7YBTET+jrVWaZ+YTFZ1BPvEqfM
         4FsA==
X-Gm-Message-State: AOAM531CwFsXZ1j+UhtlCVhsxKQMd6qODjuULa086h0acyaQv+V1Zap8
        0NTHx8iVY4buKaUk1kS3+2vtC74QLLzFulj4z3s=
X-Google-Smtp-Source: ABdhPJxI/u45bSw7nEeJkusYuKv92FOTuJQ2Ko8zb3F/13IsBWpHuzj8aUiXLyr4ym5std5l5ZvBKiiYzGIbOW6FxrM=
X-Received: by 2002:a25:287:: with SMTP id 129mr4375547ybc.145.1610433524639;
 Mon, 11 Jan 2021 22:38:44 -0800 (PST)
MIME-Version: 1.0
References: <20210110124903.109773-1-mailhol.vincent@wanadoo.fr>
 <20210110124903.109773-2-mailhol.vincent@wanadoo.fr> <20210111171152.GB11715@hoboy.vegasvil.org>
 <CAMZ6RqJqWOGVb_oAhk+CSZAvsej_xSDR6jqktU_nwLgFpWTb9Q@mail.gmail.com> <20210112021420.GA18703@hoboy.vegasvil.org>
In-Reply-To: <20210112021420.GA18703@hoboy.vegasvil.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 12 Jan 2021 15:38:33 +0900
Message-ID: <CAMZ6RqKY-QiNi_=H_J3QpwPfy7KUSNHRD5ok_MqnWgR-bou2hQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] can: dev: add software tx timestamps
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 12 Jan 2021 at 11:14, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Tue, Jan 12, 2021 at 09:00:33AM +0900, Vincent MAILHOL wrote:
> > Out of curiosity, which programs do you use? I guess wireshark
> > but please let me know if you use any other programs (I just use
> > to write a small C program to do the stuff).
>
> I was thinking of PTP over DeviceNET (which, in turn, is over CAN).
> This is specified in Annex G of IEEE 1588.
>
> The linuxptp stack has modular design and could one day support
> DeviceNET.  It would be much easier for linuxptp if CAN interfaces
> support hardware time stamping in the same way as other network
> interfaces.

I actually also thought of implementing PTP but for a slightly
different goal: synchronise the clock of the different CAN
controllers connected to a same Linux host. But so far, it is
just a rough idea and I never looked really deep into the
technical details of linuxptp.

However, I did not know about DeviceNET. I am not really aware of
the use cases for industrial automation applications.

Glad to have asked, learnt something :)


Yours sincerely,
Vincent
