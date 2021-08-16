Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD8B3EDF2F
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbhHPVSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:18:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52650 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231750AbhHPVSi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 17:18:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kMWO17uroZoWE99yM+teIahXpEmXjbr7uxr0ADzSYXE=; b=D3CQoKEZpkE+iWTOSXDF/Wa3Dg
        FkFlm1lBg5bE2FfnmT524cwap7V9GWmojVuwAQ4qWZ2m5W9diaI+gAivl4A49HAtMJHPaLFzXrjRE
        FaGbLlKVlWAuL//0lxWBujKNc8hPOuV4rBHpU8k3d7djWUHQd18gEIan0lcQQMt0PCOw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mFjzc-000RQB-72; Mon, 16 Aug 2021 23:18:00 +0200
Date:   Mon, 16 Aug 2021 23:18:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Lee Jones <lee.jones@linaro.org>, Marc Zyngier <maz@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 1/2] irqchip: irq-meson-gpio: make it possible to build
 as a module
Message-ID: <YRrWCC1E1nKDsx4N@lunn.ch>
References: <87im0m277h.wl-maz@kernel.org>
 <CAGETcx9OukoWM_qprMse9aXdzCE=GFUgFEkfhhNjg44YYsOQLw@mail.gmail.com>
 <87sfzpwq4f.wl-maz@kernel.org>
 <CAGETcx95kHrv8wA-O+-JtfH7H9biJEGJtijuPVN0V5dUKUAB3A@mail.gmail.com>
 <CAGETcx8bpWQEnkpJ0YW9GqX8WE0ewT45zqkbWWdZ0ktJBhG4yQ@mail.gmail.com>
 <YQuZ2cKVE+3Os25Z@google.com>
 <YRpeVLf18Z+1R7WE@google.com>
 <CAGETcx-gSJD0Ra=U_55k3Anps11N_3Ev9gEQV6NaXOvqwP0J3g@mail.gmail.com>
 <YRrOvJBLp3WreEUf@lunn.ch>
 <CAGETcx_Q2-7B5RpHSfDu1KB0n+pT8nkCwGsthN20QBvgePcUtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_Q2-7B5RpHSfDu1KB0n+pT8nkCwGsthN20QBvgePcUtQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 02:02:12PM -0700, Saravana Kannan wrote:
> On Mon, Aug 16, 2021 at 1:46 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > Not that I'm aware of. Andrew added a "Reviewed-by" to all 3 of my
> > > proper fix patches. I didn't think I needed to send any newer patches.
> > > Is there some reason you that I needed to?
> > > https://lore.kernel.org/lkml/20210804214333.927985-1-saravanak@google.com/T/#t
> >
> > https://patchwork.kernel.org/project/netdevbpf/list/?series=&submitter=&state=*&q=net%3A+mdio-mux%3A+Delete+unnecessary+devm_kfree&archive=both&delegate=
> >
> > State Changes Requested. I guess because you got the subject wrong.
> 
> I'm assuming the prefix is wrong? What should it be? I went by looking
> at the latest commit in:
> $ git log --oneline  drivers/net/mdio/
> ac53c26433b5 net: mdiobus: withdraw fwnode_mdbiobus_register
> 
> What prefix do I need to use to be considered correct?
> net: mdio:?

https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

and in particular:

https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html#how-do-i-indicate-which-tree-net-vs-net-next-my-patch-should-be-in

	Andrew
