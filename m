Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E0D125799
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 00:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfLRXQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 18:16:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57636 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbfLRXQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 18:16:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8233515400201;
        Wed, 18 Dec 2019 15:16:48 -0800 (PST)
Date:   Wed, 18 Dec 2019 15:16:48 -0800 (PST)
Message-Id: <20191218.151648.1742732216376608428.davem@davemloft.net>
To:     petrm@mellanox.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, mrv@mojatatu.com,
        idosch@mellanox.com, jiri@resnulli.us
Subject: Re: [PATCH net-next mlxsw v2 00/10] Add a new Qdisc, ETS
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1576679650.git.petrm@mellanox.com>
References: <cover.1576679650.git.petrm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Dec 2019 15:16:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>
Date: Wed, 18 Dec 2019 14:55:06 +0000

> The IEEE standard 802.1Qaz (and 802.1Q-2014) specifies four principal
> transmission selection algorithms: strict priority, credit-based shaper,
> ETS (bandwidth sharing), and vendor-specific. All these have their
> corresponding knobs in DCB. But DCB does not have interfaces to configure
> RED and ECN, unlike Qdiscs.
> 
> In the Qdisc land, strict priority is implemented by PRIO. Credit-based
> transmission selection algorithm can then be modeled by having e.g. TBF or
> CBS Qdisc below some of the PRIO bands. ETS would then be modeled by
> placing a DRR Qdisc under the last PRIO band.
> 
> The problem with this approach is that DRR on its own, as well as the
> combination of PRIO and DRR, are tricky to configure and tricky to offload
> to 802.1Qaz-compliant hardware. This is due to several reasons:
 ...
> So instead, this patch set introduces a new Qdisc, which is based on
> 802.1Qaz wording. It is PRIO-like in how it is configured, meaning one
> needs to specify how many bands there are, how many are strict and how many
> are ETS, quanta for the latter, and priomap.
 ...

Series applied, thanks.
