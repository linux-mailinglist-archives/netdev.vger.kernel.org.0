Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDEE43D7EFD
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 22:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhG0USU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbhG0UST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:18:19 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2F9C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:18:18 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id m13so213117iol.7
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EGfLd9D8CJ0XM8pNkBp/RBltPnDlCoaQe6KBAezvO04=;
        b=g7xMssaF+tdCP9oijWOYFkWd+H55lfjYbqo6OzOAEXuOdQ3+ip7eT622oVKinOFf1p
         66uc2Hg23s704ueA5HhrfPMNFanCrwTpJ9M23sV6+sxsA+kJIRouQ6i442sxhbhMRB2f
         6fd3NIVCpzW+oUglzwXH0WgvG9HDO8A6C7zSyG9i3TtYU68RmuJKTxm/CafmX/6MTBxf
         E9lY8vNdYuKTCT1JmMHnte6L/7paCsXOcPItJ0rQvPJglDJUnwDv0RibjCvXkYD/aEbp
         sP2IcTZn1AhKArh2bQoIin/0evLTm68htv74AbnDSX9OdnKDM6smAhz/ojXtACdRCrx3
         aVQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EGfLd9D8CJ0XM8pNkBp/RBltPnDlCoaQe6KBAezvO04=;
        b=Xg3Z//mo7qPKEeZWEKXU2XY4FhoS0jT/XA2VvyoT400eTVFrD1kbxhhSbyYm5u8Esa
         DeLUQuAXA80uhFZhvAdU6OZiYR9vWwQxcx9zgzsvG6abJko/tJ20qqvtAHd04IoAY9u3
         h8EeobeeLz5/6ckynu1bExEkpRidATryp/95HCiSgO7YgQz9vLkiUA/7jtnlPRuET35g
         cggnwXbw3PmYS2fRCa7gelZLe6FL2Q3PDDZgX3mDlHM/HFgdWu7mFO8PDKt+Rj7viY1T
         l9UBLsF6rxwTTM1XZ9dGujwEFrHSu7gwuJ5uWCzCQdzv4GwivDi3eToKrtIItE74zRKa
         oLNw==
X-Gm-Message-State: AOAM532RdBQt//7cR5BCqja87EJ7fwPZjgb0lp1FDrrf09nDPrw3YvYE
        HXtNtonBozTc/AAy8l/QGy+fle/aNzQjJmaECnWTN9TWMHpTwA6CVYhxaw==
X-Google-Smtp-Source: ABdhPJzdYgF7ua/8SX1bFAaXWqsm0OEi75CCI50iFNU5UspYEDR9M97eLyOJlLLzlK7dQOK8ZzG9nfutC4q59xjnmx0=
X-Received: by 2002:a05:6602:48c:: with SMTP id y12mr16699755iov.14.1627417098287;
 Tue, 27 Jul 2021 13:18:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210726194603.14671-1-gerhard@engleder-embedded.com>
 <20210726194603.14671-5-gerhard@engleder-embedded.com> <YP8f8lXieL+Ld1eW@lunn.ch>
In-Reply-To: <YP8f8lXieL+Ld1eW@lunn.ch>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Tue, 27 Jul 2021 22:18:07 +0200
Message-ID: <CANr-f5xp7DG9idmg-Mn+Tj6+a+pxrajVw-h8Tm4O6NAjB1AJYw@mail.gmail.com>
Subject: Re: [PATCH net-next 4/5] tsnep: Add TSN endpoint Ethernet MAC driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 10:50 PM Andrew Lunn <andrew@lunn.ch> wrote:
> Hi Gerhard

Hi Andrew

> > +int tsnep_read_md(struct tsnep_adapter *adapter, int phy, int reg, u16 *data)
> > +{
> > +     u32 md;
> > +     int retval = 0;
> > +
> > +     if (mutex_lock_interruptible(&adapter->md_lock) != 0)
> > +             return -ERESTARTSYS;
>
> This probably means you have something wrong with your architecture.
> The core mdio layer will serialise access to the mdio bus. So you
> should not need such locks.
>
> > +int tsnep_enable_loopback(struct tsnep_adapter *adapter, int speed)
> > +{
> > +     int phy_address = adapter->phydev->mdio.addr;
> > +     u16 val;
> > +     int retval;
> > +
> > +     adapter->loopback = true;
> > +     adapter->loopback_speed = speed;
> > +
> > +     retval = tsnep_read_md(adapter, phy_address, MII_BMCR, &val);
>
> And this might be why you have these locks?
>
> A MAC driver should never directly touch the PHY hardware. Use the
> phy_loopback(phydev) call.

I will try to use phy_loopback(phydev) . Thanks for the advice!

Gerhard
