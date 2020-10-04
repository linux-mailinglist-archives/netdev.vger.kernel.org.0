Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A0F282DEB
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 00:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgJDWGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 18:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgJDWGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 18:06:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2B6C0613CE;
        Sun,  4 Oct 2020 15:06:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 760251278226A;
        Sun,  4 Oct 2020 14:49:18 -0700 (PDT)
Date:   Sun, 04 Oct 2020 15:06:05 -0700 (PDT)
Message-Id: <20201004.150605.23325138792161072.davem@davemloft.net>
To:     rikard.falkeborn@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pshelar@ovn.org, dev@openvswitch.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.01.org
Subject: Re: [PATCH net-next 0/2] net: Constify struct genl_ops
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201004215810.26872-1-rikard.falkeborn@gmail.com>
References: <20201004215810.26872-1-rikard.falkeborn@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 04 Oct 2020 14:49:18 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Date: Sun,  4 Oct 2020 23:58:08 +0200

> Make a couple of static struct genl_ops const to allow the compiler to put
> them in read-only memory. Patches are independent.

These do not apply cleanly to net-next, please respin.
