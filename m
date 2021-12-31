Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292264821C6
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 04:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242591AbhLaDYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 22:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhLaDYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 22:24:02 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A23DC061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 19:24:02 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id h2so47494807lfv.9
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 19:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dAymm1KXvjZLG+ZBiq9YPw1SnqnACX4pYUtynWJomAo=;
        b=KjpWUdKNzXyHapmI0csO4ux1tiytDKKqWA8I0nmn9HjcXWDhgAzwOQ5+FYSm/VR+2p
         QIRnh36Xni+Q1Z5BpGJrB7j+SXu5XB5NMZtF1v9dWqUJC7tV0Bbt8L0A67kyCCsdZ3Z6
         nNG3kUY7+Z1OoeAvzsFTiHKIRD9mREI+J1Thc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dAymm1KXvjZLG+ZBiq9YPw1SnqnACX4pYUtynWJomAo=;
        b=yN8GzDtJ2ZbmaCSO5NU0gNk56o+ARATP166+M38guvfyaPYZ9qBVCPil4yeWrfZ2RM
         FvIuPtZvyW1up9sFEVsrZsXdI3PuUlN51zTz8G08l6+tv2qmOfNLh+5rGkyzAOUSB/4+
         U2KCHxhPfp4ZYan+nGjrTrhbc4BCjSKwrYMfsFwrh1IqkccgKwXCNHLSeTm1WHjzNlj+
         BkvbBnHEKR3CgCpPkKa3EzFyhUsRwU3kqlihonpbAjeO+ECu9WcmCNqeA1t4Sd/Gk45Q
         7TXs1SoSJKH1uHL5ayOZg9N/003ukPzMbPxmYSsXZM5KM7gBeFlNWD3jinLWJHpzTBYO
         jodw==
X-Gm-Message-State: AOAM531gUmjX6fvzJdAsqe09W+H+yMhxK0fHysdnZT9zAz0unjsEC3aV
        eEjlSL/cd5J7BuW2uoy/qlcB1KHcpglZpv9zvMz58+qCllnxAQ==
X-Google-Smtp-Source: ABdhPJxCaxjlz/Q3MnI2SJj5x2rps7m6hP995EIO8V17d9Irz7MPkOCufePZuQo1euCu6RNkMkWduJtLZTgUAN7A9vc=
X-Received: by 2002:ac2:5b4f:: with SMTP id i15mr30259346lfp.379.1640921040305;
 Thu, 30 Dec 2021 19:24:00 -0800 (PST)
MIME-Version: 1.0
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-5-dmichail@fungible.com> <Yc30mG7tPQIT2HZK@lunn.ch>
 <CAOkoqZk0O0NidoHuAf4Qbp3e35P7jbPKMYXS=56XWgMx1BceYg@mail.gmail.com>
 <Yc4x97vqj2fU9Zg/@lunn.ch> <CAOkoqZk3tgLi-iY0gju8KAwWvcyHXJUQ61MxAij9BwfMrakniA@mail.gmail.com>
 <Yc5p5iAELXFCuY9t@lunn.ch>
In-Reply-To: <Yc5p5iAELXFCuY9t@lunn.ch>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Thu, 30 Dec 2021 19:23:47 -0800
Message-ID: <CAOkoqZnJfDUZX8oaE=UGU-Wc6YH5FzNwKFe+09KTxbw4tDYugA@mail.gmail.com>
Subject: Re: [PATCH net-next 4/8] net/funeth: ethtool operations
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 6:24 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Dec 30, 2021 at 05:23:56PM -0800, Dimitris Michailidis wrote:
> > On Thu, Dec 30, 2021 at 2:26 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > > I _think_ this is wrong. pause->autoneg means we are autoneg'ing
> > > > > pause, not that we are using auto-neg in general. The user can have
> > > > > autoneg turned on, but force pause by setting pause->autoneg to False.
> > > > > In that case, the pause->rx_pause and pause->tx_pause are given direct
> > > > > to the MAC, not auto negotiated.
> > > >
> > > > Having this mixed mode needs device FW support, which isn't there today.
> > >
> > > So if you are asked to set pause with pause->autoneg False, return
> > > -EOPNOTSUPP. And pause get should always return True. It is O.K, to
> > > support a subset of a feature, and say you don't support the
> > > rest. That is much better than wrongly implementing it until your
> > > firmware gets the needed support.
> >
> > include/uapi/linux/ethtool.h has this comment
> >
> >  * If the link is autonegotiated, drivers should use
> >  * mii_advertise_flowctrl() or similar code to set the advertised
> >  * pause frame capabilities based on the @rx_pause and @tx_pause flags,
> >  * even if @autoneg is zero. ...
> >
> > I read this as saying that pause->autoneg is ignored if AN is on and the
> > requested pause settings are fed to AN. I believe this is what the code
> > here implements.
> >
> > Whereas you are saying that pause->autoneg == 0 should force
> > despite AN. Right?
>
> Take a look at phylink_ethtool_set_pauseparam() and accompanying
> functions. This is a newish central implementation for any MAC/PHY
> with Linux controlling the hardware. There are ambiguities in the API
> description, so it would be better if your driver/firmware combo does
> the same a the core Linux code. When Russell wrote that code, there
> was quite a bit of discussion what the documentation actually means.

OK. If I understand correctly AN on and pause->autoneg != 0 means
negotiate requested settings and accept resolution result, while
AN on and pause->autoneg == 0 means negotiate settings and adopt
them as the resolution result. I'll mark the latter combination unsupported
for now.

>
>     Andrew
