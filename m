Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591332F2C12
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 11:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388713AbhALJ7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 04:59:15 -0500
Received: from mail-yb1-f179.google.com ([209.85.219.179]:40013 "EHLO
        mail-yb1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbhALJ7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 04:59:15 -0500
Received: by mail-yb1-f179.google.com with SMTP id b64so1612770ybg.7;
        Tue, 12 Jan 2021 01:58:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dGNUkGeCzldSz5Jx25dtI9sopkbs7ZGwNPYz1mZfW3A=;
        b=aW9EJyHX+ccIeD9ALiZ4AO6PmBgZw+UBl2eiYH9KcAdFIy6Rdad20YZS4vV9blMaIh
         E9jjwrkWQUfnW3Gcqej9dgInKE4R5xtcQpa64T+8+sgsJ87FX9a1vIekqG/7g9nfUVDY
         FbnRdL9a1L9wyP3UVbZw3JUFsjKo9PSiWA+H/lnXFHn3C+kjIw5urRxLF6y5hS11aTQm
         twD2+ZgER5rnR2M+mYpHpfICbeldutYy1N6Hf0SGg7z3anZsQaxd+AoRyA5FOvfSB5xV
         rgLANlQkHplxqTuOQrmhiBbeY3IWt5HnUx53Q5cmIMIMdeHRriUfvvC98NtID1QAgjw0
         lbcg==
X-Gm-Message-State: AOAM530F0oqrNtiGUsoZQwxncbeSOM7MZ1KBCKb+AyhfK8/txmJVHC7I
        vWDUUtAZbNyPuzeKraSn54sjDcmVPsijFrC4nSw=
X-Google-Smtp-Source: ABdhPJw+eXujMb1kBAEv5nRJYDAF+/pYMZmPBq84N0+GBAcjBf03nyeAZL7ew1Y1byfhyo15kp79nKU8i2nUGxwmm7I=
X-Received: by 2002:a25:7c05:: with SMTP id x5mr5725712ybc.487.1610445514201;
 Tue, 12 Jan 2021 01:58:34 -0800 (PST)
MIME-Version: 1.0
References: <20210110124903.109773-1-mailhol.vincent@wanadoo.fr>
 <20210110124903.109773-2-mailhol.vincent@wanadoo.fr> <20210111171152.GB11715@hoboy.vegasvil.org>
 <CAMZ6RqJqWOGVb_oAhk+CSZAvsej_xSDR6jqktU_nwLgFpWTb9Q@mail.gmail.com> <0de66e27-8ac3-c2fe-a986-dc4a00ebcb00@pengutronix.de>
In-Reply-To: <0de66e27-8ac3-c2fe-a986-dc4a00ebcb00@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 12 Jan 2021 18:58:23 +0900
Message-ID: <CAMZ6Rq+6pV2nHYTMWP9yOhRxP0VVJHUfF9fQUPohHfXh++APqA@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] can: dev: add software tx timestamps
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
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

On Tue. 12 Jan 2021 at 16:58, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 1/12/21 1:00 AM, Vincent MAILHOL wrote:
> [...]
>
> > Mark: do you want me to send a v4 of that patch with above
> > comment removed or can you directly do the change in your testing
> > branch?
>
> Please send a patch on-top of linux-can-next/testing

Done: https://lore.kernel.org/linux-can/20210112095437.6488-1-mailhol.vincent@wanadoo.fr/


Yours sincerely,
Vincent
