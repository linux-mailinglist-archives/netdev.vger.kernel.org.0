Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED56577BC7
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 22:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388188AbfG0UXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 16:23:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39734 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387841AbfG0UXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 16:23:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20DB61533CD32;
        Sat, 27 Jul 2019 13:23:15 -0700 (PDT)
Date:   Sat, 27 Jul 2019 13:23:14 -0700 (PDT)
Message-Id: <20190727.132314.1888016313569976606.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     antoine.tenart@bootlin.com, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, mw@semihalf.com,
        stefanc@marvell.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] mvpp2: document HW checksum behaviour
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAGnkfhy_h_UfoefRmBjQgUgiX+954fQjX2kqa2hPLbKpLHU4rg@mail.gmail.com>
References: <20190725231546.23878-1-mcroce@redhat.com>
        <20190726125715.GB5031@kwain>
        <CAGnkfhy_h_UfoefRmBjQgUgiX+954fQjX2kqa2hPLbKpLHU4rg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 13:23:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Fri, 26 Jul 2019 16:35:59 +0200

> I see, there is a similar statement in mvpp2_port_probe().
> What about adding a static function which sets the flag, and add the
> comment there instead of duplicating the comment?

That sounds good to me.
