Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC44B282F57
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 06:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgJEEPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 00:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgJEEPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 00:15:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10D2C0613CE;
        Sun,  4 Oct 2020 21:15:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 120D7127CF945;
        Sun,  4 Oct 2020 20:58:25 -0700 (PDT)
Date:   Sun, 04 Oct 2020 21:15:09 -0700 (PDT)
Message-Id: <20201004.211509.1806096319887910594.davem@davemloft.net>
To:     rikard.falkeborn@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, mptcp@lists.01.org, pshelar@ovn.org,
        dev@openvswitch.org
Subject: Re: [PATCH net-next v2 0/2] net: Constify struct genl_small_ops
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201004234417.12768-1-rikard.falkeborn@gmail.com>
References: <20201004234417.12768-1-rikard.falkeborn@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 04 Oct 2020 20:58:25 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Date: Mon,  5 Oct 2020 01:44:15 +0200

> Make a couple of static struct genl_small_ops const to allow the compiler
> to put them in read-only memory. Patches are independent.
> 
> v2: Rebase on net-next, genl_ops -> genl_small_ops

Applied, thank you.
