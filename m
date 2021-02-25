Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512F93251BB
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 15:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhBYOuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 09:50:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:32952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhBYOuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 09:50:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E19C064EF5;
        Thu, 25 Feb 2021 14:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614264565;
        bh=DsYhGdHyM92p9LWSYyztwOh0Qzau7xU7O/Y4MtM9Z2c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jD8RiWwYnXCyoHV9JldmO3BuGr0m6pqDs7MW2XTHjoPIQUyRtlZO6R8zplDBDc7U4
         +TcjVB6xt98qpp2VhZRanrD5dfNEzhbF8ktzThZ787xaSfqYQTVJibqO11letezFAJ
         TSY/9qXj1RQQhP901d2oJQ3jRYOyaXgpfTJ+EuR1z7EDH291/Gze57aj2SN0V1FXuA
         2GA677Vvi7O1nNS+u1zck6fu2ktv3tPVdQe0RPUPK0VOiaYkVIdRuNYgO5ttLnlN9e
         WAk8mfN/6WDquUHFzOt7SIq5qMHq4+bEN26P1/NdqAXXevXCez7PRBZciqmNV3Bqs+
         /AH3pmdPdzC4A==
Received: by mail-oi1-f178.google.com with SMTP id l133so6297044oib.4;
        Thu, 25 Feb 2021 06:49:24 -0800 (PST)
X-Gm-Message-State: AOAM533lhTrYcTkEFCq3pNvN3rD+RSDOcZgEyUW2up+lAUlIxl3+ia06
        Xd/hnEjmYhnzhdvspRlPM709QYMxxvysrf1Eh10=
X-Google-Smtp-Source: ABdhPJyymIARUbozE05A6gacutZ/7Q0QJ6V9TzRvlCsOckh9k57YV+WSWWx9lo40HrNHiXAddgG3x9+L7g8zNTDzzkE=
X-Received: by 2002:aca:b457:: with SMTP id d84mr2183926oif.4.1614264564065;
 Thu, 25 Feb 2021 06:49:24 -0800 (PST)
MIME-Version: 1.0
References: <20210225143910.3964364-1-arnd@kernel.org> <20210225143910.3964364-2-arnd@kernel.org>
 <20210225144341.xgm65mqxuijoxplv@skbuf> <CAK8P3a0W3_SvWyvWZnMU=QoqCDe5btL3O7PHUX8EnZVbifA4Fg@mail.gmail.com>
In-Reply-To: <CAK8P3a0W3_SvWyvWZnMU=QoqCDe5btL3O7PHUX8EnZVbifA4Fg@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 25 Feb 2021 15:49:08 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1gQgtWznnqKDdJJK2Vxf25Yb_Q09tX0UvcfopKN+x0jw@mail.gmail.com>
Message-ID: <CAK8P3a1gQgtWznnqKDdJJK2Vxf25Yb_Q09tX0UvcfopKN+x0jw@mail.gmail.com>
Subject: Re: [PATCH 2/3] net: dsa: tag_ocelot_8021q: fix driver dependency
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 3:47 PM Arnd Bergmann <arnd@kernel.org> wrote:
> On Thu, Feb 25, 2021 at 3:43 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Thu, Feb 25, 2021 at 03:38:32PM +0100, Arnd Bergmann wrote:
> > > From: Arnd Bergmann <arnd@arndb.de>
> > >
> > > When the ocelot driver code is in a library, the dsa tag

I see the problem now, I should have written 'loadable module', not 'library'.
Let me know if I should resend with a fixed changelog text.

       Arnd
