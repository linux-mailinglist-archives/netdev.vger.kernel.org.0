Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBF012D614
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 05:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfLaENk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 23:13:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50402 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbfLaENk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 23:13:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BBB7B13EDD453;
        Mon, 30 Dec 2019 20:13:39 -0800 (PST)
Date:   Mon, 30 Dec 2019 20:13:39 -0800 (PST)
Message-Id: <20191230.201339.552516920501359150.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     jakub.kicinski@netronome.com, richardcochran@gmail.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        vinicius.gomes@intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: sja1105: Remove restriction of zero
 base-time for taprio offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191227010354.26826-1-olteanv@gmail.com>
References: <20191227010354.26826-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Dec 2019 20:13:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 27 Dec 2019 03:03:54 +0200

> The check originates from the initial implementation which was not based
> on PTP time but on a standalone clock source. In the meantime we can now
> program the PTPSCHTM register at runtime with the dynamic base time
> (actually with a value that is 200 ns smaller, to avoid writing DELTA=0
> in the Schedule Entry Points Parameters Table). And we also have logic
> for moving the actual base time in the future of the PHC's current time
> base, so the check for zero serves no purpose, since even if the user
> will specify zero, that's not what will end up in the static config
> table where the limitation is.
> 
> Fixes: 86db36a347b4 ("net: dsa: sja1105: Implement state machine for TAS with PTP clock source")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied.
