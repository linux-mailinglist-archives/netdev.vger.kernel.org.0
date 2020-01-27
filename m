Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E95A2149ED4
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 06:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgA0FnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 00:43:06 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46843 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgA0FnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 00:43:05 -0500
Received: by mail-lf1-f67.google.com with SMTP id z26so5295370lfg.13
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 21:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=50k0l7tr+r4CbxpOdaQ60uyiV5MAaABmH1TGLvaz+g0=;
        b=VGtPAul9FeDoL67YNtnmtHwXGAgzZmn07fEv+WUb1Nm9emKvlvJ5JWNlrgX/GifhYt
         kTKk1K6n0KQVULFEIhi6N+OCHBcr3OHbAlr54Wt7FL7YbH3mcIk0usRBDUTQNDqCKXOV
         7PZqvi7RXqifvRBq50+5gXir7gv2EZvCKGoKw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=50k0l7tr+r4CbxpOdaQ60uyiV5MAaABmH1TGLvaz+g0=;
        b=naejwGNixxxltf7V1fVS1cMG9udgG+3WDo0Z959f59Y4/qb4OlL2GhipCbZ5qAtRil
         1ETUQvLskaS9LPWwPihT+8B+A7IiJTXErGjQfrPqJTj0KWZzRa9b1HUN0DNNXaEzIL1h
         Ip5QoRADr+zuc4IKUnhw0sVvHhJS19QhalTyVAQkt6+YH7gahOrKee+RPQ/ZYLv9jqQH
         ADuH3mje4Jqx1/f95B0qTB5E2Ke2cjpA1/FzqqSPm4He97wvncEn0o1vU1YRGRLv7KHd
         0eiyB/kJm0w5hhPty6eVPFx3jkZm63b2XwJ6wsqjcd+6K+gydxI+ecyDJlCFZ6gBZdmp
         yODQ==
X-Gm-Message-State: APjAAAUIEFdWwqArfc4/elpcPmpNE/Ala/B+b9Zphr65DrEuMjYisb+U
        Mj3MT3IY+EODEiRLQwhPlYzbdNdxh92GSaZzq1mFdg==
X-Google-Smtp-Source: APXvYqyk83UiGRM/BOpcDJqYbZ72F63B6e6oUBQQmMZESkkXSbONTozE8tRPlTWZSAimqSq3l543Y5HbRSKs2h0566s=
X-Received: by 2002:ac2:4884:: with SMTP id x4mr7452383lfc.92.1580103783545;
 Sun, 26 Jan 2020 21:43:03 -0800 (PST)
MIME-Version: 1.0
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
 <1580029390-32760-15-git-send-email-michael.chan@broadcom.com> <20200126161826.0e4df544@cakuba>
In-Reply-To: <20200126161826.0e4df544@cakuba>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Mon, 27 Jan 2020 11:12:52 +0530
Message-ID: <CAACQVJrc66xBDQRi0a_tShW6Ngtqtxwn5FUM_T8krt0cNe9d-w@mail.gmail.com>
Subject: Re: [PATCH net-next 14/16] devlink: add macros for "fw.roce" and "board.nvm_cfg"
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 5:48 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 26 Jan 2020 04:03:08 -0500, Michael Chan wrote:
> > --- a/Documentation/networking/devlink/devlink-info.rst
> > +++ b/Documentation/networking/devlink/devlink-info.rst
> > @@ -59,6 +59,11 @@ board.manufacture
> >
> >  An identifier of the company or the facility which produced the part.
> >
> > +board.nvm_cfg
> > +-------------
> > +
> > +Non-volatile memory version of the board.
>
> Could you describe a little more detail? Sounds a little similar to
> fw.psid which Mellanox has added, perhaps it serves the same purpose
> and we could reuse that one?
It is almost similar. We can reuse and update documentation in
bnxt.rst mentioning
that parameter set is present in NVM .

Thanks.
