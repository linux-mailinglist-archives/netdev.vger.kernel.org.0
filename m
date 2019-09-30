Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2394C2910
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfI3VqZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Sep 2019 17:46:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39192 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfI3VqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 17:46:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C994C15435B54;
        Mon, 30 Sep 2019 11:06:54 -0700 (PDT)
Date:   Mon, 30 Sep 2019 11:06:51 -0700 (PDT)
Message-Id: <20190930.110651.1802452095339417928.davem@davemloft.net>
To:     michal.vokac@ysoft.com
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, vivien.didelot@gmail.com,
        linux-kernel@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH net] net: dsa: qca8k: Use up to 7 ports for all
 operations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1569488357-31415-1-git-send-email-michal.vokac@ysoft.com>
References: <1569488357-31415-1-git-send-email-michal.vokac@ysoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Sep 2019 11:06:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Vok·Ë <michal.vokac@ysoft.com>
Date: Thu, 26 Sep 2019 10:59:17 +0200

> The QCA8K family supports up to 7 ports. So use the existing
> QCA8K_NUM_PORTS define to allocate the switch structure and limit all
> operations with the switch ports.
> 
> This was not an issue until commit 0394a63acfe2 ("net: dsa: enable and
> disable all ports") disabled all unused ports. Since the unused ports 7-11
> are outside of the correct register range on this switch some registers
> were rewritten with invalid content.
> 
> Fixes: 6b93fb46480a ("net-next: dsa: add new driver for qca8xxx family")
> Fixes: a0c02161ecfc ("net: dsa: variable number of ports")
> Fixes: 0394a63acfe2 ("net: dsa: enable and disable all ports")
> Signed-off-by: Michal Vok·Ë <michal.vokac@ysoft.com>

Applied.
