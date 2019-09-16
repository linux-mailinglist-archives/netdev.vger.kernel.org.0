Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05423B40C9
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 21:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733133AbfIPTHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 15:07:38 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]:41000 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbfIPTHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 15:07:38 -0400
Received: by mail-qk1-f171.google.com with SMTP id p10so1109450qkg.8
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 12:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5D5mLgicOG5L4o2tQ9gmy7tqAHtt8mEzjqSfJ0aYu9I=;
        b=e2MEhAtY/+psIvVGjyGJzVvgO/16/0epTKdyrMVXt12h4ujaW01RVcG3CxoS/O8hOQ
         D2oBOgQB8HdzP5NT3M1guk+Kz+lFsNdomQ8XTZb+7unKNnaQulPCTRXC5E9lXzuskiBa
         0TeO7FhNnptb6gcF+5iVM1EyT8sGkc3LxjB0sUe4drUaTSbRjbjGxdUpKURYMa255MyW
         RFian+hRKBsxWH5rdy86ZoqX5jQGDEhdgqVtYITvZ2Jla6uM1dAJ7RkHfC5AOFolwtBa
         s4JtKvip3bKQnBtnX1AL2rNSkPhW8dRbkPDnCeWN/7ziIqmKxTPIX5U7TZUEElZcQ6x+
         prKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5D5mLgicOG5L4o2tQ9gmy7tqAHtt8mEzjqSfJ0aYu9I=;
        b=Nihh98Uk9jsoKB/3duGeeTZg27jadhYeMkVu1c88OEES5NAEJJhMwdxNyKxlztjKWE
         y0su8wGlVG5XTAuc64VJobKpEqMTVfigSXiVpJwuIirQYA5p8X5wGvmJUf2Xsw69KHpF
         pHOxbhZYU3w8K0SlFeSu1+GjnBodkApjy1moI4ng6rJTT2IgPP9tSf0q96mRV9YPphny
         EZkWbUuHPlQPBBefCuIxwz6snaK9scCyoClXFgyQPMgfzq9qBIMBsaoUwD9ivpp8u2OB
         +3FC2F3ZSSsaPIOimPl6F/LQ+DSd3k7KufYBkdtyBlU9TSOv1KsNh7jwv5mOZyGqq5BP
         IFpw==
X-Gm-Message-State: APjAAAU2TaF/+MEHjw7q2+8+HRx4mDx9fQqUB6IEqXjLma1bAm5wCDLY
        KiXD0/Szw5l63L/v1/VRvIp+KnbhENUFhinNx5I=
X-Google-Smtp-Source: APXvYqwkIMudsjDpVECs3hNXUCxxPeTkFZAwDknwF9w4djYvnRHo37brinNgUR1zPuY3kJ6Aax8SlQQEfmbPf1ZYIow=
X-Received: by 2002:a37:65c7:: with SMTP id z190mr1515717qkb.483.1568660857034;
 Mon, 16 Sep 2019 12:07:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAD56B7fEGm439yn_MaWxbyfMUEtfjbijH8as99Xh2N+6bUQEGQ@mail.gmail.com>
 <20190914145443.GE27922@lunn.ch> <CAD56B7dF9Dqf1wwu=w60z0q+hkE5-noZRS4uuUfF4PhyNSa4Kw@mail.gmail.com>
 <20190916151316.GA8144@lunn.ch>
In-Reply-To: <20190916151316.GA8144@lunn.ch>
From:   Paul Thomas <pthomas8589@gmail.com>
Date:   Mon, 16 Sep 2019 15:07:25 -0400
Message-ID: <CAD56B7d5d+-OOvn0MOUz7O14QFs20CWgO9UVBx=VJobfqTfnag@mail.gmail.com>
Subject: Re: net: phy: micrel KSZ9031 ifdown ifup issue
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 11:13 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > When it is in the good state I see that reg 0x01 is 0x796d where bit
> > 1.2 reports 'Link is up' and bit 1.5 reports 'Auto-negotiation process
> > complete'. However, once I get to the bad state (it may take several
> > tries of ifdown, ifup to get there) then reg 0x01 is 0x7649 reporting
> > 'Link is down' and 'Auto-negotiation process not completed'. This can
> > be fixed by resetting the phy './phytool write eth0/3/0 0x9140'
> >
> > So, I guess that means the driver is doing what it is supposed to?
> > Could we add quirk or something to reset the phy again from the driver
> > if auto-negotiation doesn't complete with x seconds?
>
> Hi Paul
>
> Adding a timeout would make sense. But please try to hide all this
> inside the PHY driver. Since it is being polled, the read_status()
> should be called once per second, so you should be able to handle all
> this inside that driver callback.
Thanks Andrew,

It looks like there are more issues than just the auto-negotiation.
Even when the negotiated link comes back I never see any more rx
packets from the macb driver. I'll look into this more.

thanks,
Paul
