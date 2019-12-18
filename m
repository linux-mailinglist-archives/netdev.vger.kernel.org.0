Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66CE1123F3D
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 06:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfLRFrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 00:47:16 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47002 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfLRFrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 00:47:16 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9972F14FEC577;
        Tue, 17 Dec 2019 21:47:15 -0800 (PST)
Date:   Tue, 17 Dec 2019 21:38:23 -0800 (PST)
Message-Id: <20191217.213823.770260276225386300.davem@davemloft.net>
To:     petrm@mellanox.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, mrv@mojatatu.com,
        idosch@mellanox.com, jiri@resnulli.us
Subject: Re: [PATCH net-next mlxsw v1 00/10] Add a new Qdisc, ETS
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1576515562.git.petrm@mellanox.com>
References: <cover.1576515562.git.petrm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 21:47:15 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>
Date: Mon, 16 Dec 2019 17:01:36 +0000

> The IEEE standard 802.1Qaz (and 802.1Q-2014) specifies four principal
> transmission selection algorithms: strict priority, credit-based shaper,
> ETS (bandwidth sharing), and vendor-specific. All these have their
> corresponding knobs in DCB. But DCB does not have interfaces to configure
> RED and ECN, unlike Qdiscs.
 ...

I have no problem with this new schedule or how it is coded.

But I really want there to be some documentation blurb in the Kconfig
entry (less verbose) and in a code comment of the scheduler itself
(more verbose) which explains where this is derived from.

People can indeed look at the commit but I think if someone just sees
the new Kconfig or looks at the code they should be able to read
something there that says what this thing is.

The commit log message for patch #4 would be good to use as a basis.

Thank you.
