Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019BF1FA0E8
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 22:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730800AbgFOUFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 16:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728773AbgFOUFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 16:05:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26417C061A0E;
        Mon, 15 Jun 2020 13:05:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4EB0D120ED49A;
        Mon, 15 Jun 2020 13:05:05 -0700 (PDT)
Date:   Mon, 15 Jun 2020 13:05:04 -0700 (PDT)
Message-Id: <20200615.130504.858968576691085467.davem@davemloft.net>
To:     geliangtang@gmail.com
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        kuba@kernel.org, netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] mptcp: use list_first_entry_or_null
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6cf9b609f1d77b389165448b9a9b38f6bee48f87.1592209896.git.geliangtang@gmail.com>
References: <6cf9b609f1d77b389165448b9a9b38f6bee48f87.1592209896.git.geliangtang@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 13:05:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>
Date: Mon, 15 Jun 2020 16:34:28 +0800

> Use list_first_entry_or_null to simplify the code.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Applied, thanks.
