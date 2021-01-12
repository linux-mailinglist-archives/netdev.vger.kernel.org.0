Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7272F265B
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 03:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730865AbhALCj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 21:39:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbhALCjz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 21:39:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF22722CAD;
        Tue, 12 Jan 2021 02:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610419155;
        bh=b6GBjyepUMR8c3Bnd+8yw9hOFJEKD9I570MzfcXyRtE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uEx6MTvVDjfKk7BupQbG5VrgG+0ADFnDcuwsQV1eRw73/cS0RRTZSYuZHvIG+MtFW
         mEbTJqaOVV6Ym48wgHYAZGs/vf32rGa1HA9T7pZWH0skHabZRqt2yZJbvnJpFQKadJ
         vI9y/c+vHUzL6V5FBSEpTfLBrDDb+lqUPTt7pBtYH2YFsYRfJ2/b+vXYGxjUW1zMqK
         6ejArYTkISyI0UZwD0xDh6XO660l6nYgOJg6s2kOtLvzNUCr1eNKqZ57e4mvyo6Xe4
         CoSGDgaphCKFsts4AYwKLDAg59b5LayFX8hrVUNu+acAj7C0hXFMM+E1blEu5G7Jdo
         Ks/zAkr9XIrgw==
Date:   Mon, 11 Jan 2021 18:39:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chris Snook <chris.snook@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, corbet@lwn.net,
        Jay Cliburn <jcliburn@gmail.com>
Subject: Re: [PATCH net 1/9] MAINTAINERS: altx: move Jay Cliburn to CREDITS
Message-ID: <20210111183914.2b18ac82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMXMK6uWAmghRw-G3P=315iZyQO+HaELUB_hQ1E6rVLGfVG6Hw@mail.gmail.com>
References: <20210111052759.2144758-1-kuba@kernel.org>
        <20210111052759.2144758-2-kuba@kernel.org>
        <CAMXMK6uWAmghRw-G3P=315iZyQO+HaELUB_hQ1E6rVLGfVG6Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Jan 2021 21:36:24 -0800 Chris Snook wrote:
> On Sun, Jan 10, 2021 at 9:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > Jay was not active in recent years and does not have plans
> > to return to work on ATLX drivers.
> >
> > Subsystem ATLX ETHERNET DRIVERS
> >   Changes 20 / 116 (17%)
> >   Last activity: 2020-02-24
> >   Jay Cliburn <jcliburn@gmail.com>:
> >   Chris Snook <chris.snook@gmail.com>:
> >     Tags ea973742140b 2020-02-24 00:00:00 1
> >   Top reviewers:
> >     [4]: andrew@lunn.ch
> >     [2]: kuba@kernel.org
> >     [2]: o.rempel@pengutronix.de
> >   INACTIVE MAINTAINER Jay Cliburn <jcliburn@gmail.com>
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> I'm overdue to be moved to CREDITS as well. I never had alx hardware,
> I no longer have atl1c or atl1e hardware, and I haven't powered on my
> atl1 or atl2 hardware in years.

Your call, obviously, but having someone familiar with the code and the
hardware look at the patches and provide Ack or Review tags is in
itself very, very helpful. There is no requirement to actually test any
of the changes or develop new features.
