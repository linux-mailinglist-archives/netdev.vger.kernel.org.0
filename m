Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08AF4178756
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 02:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387398AbgCDBB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 20:01:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37804 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727725AbgCDBB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 20:01:58 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C742C15AD1959;
        Tue,  3 Mar 2020 17:01:57 -0800 (PST)
Date:   Tue, 03 Mar 2020 17:01:57 -0800 (PST)
Message-Id: <20200303.170157.1654569852060975852.davem@davemloft.net>
To:     mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] mptcp: Improve DATA_FIN transmission
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200228234741.57086-1-mathew.j.martineau@linux.intel.com>
References: <20200228234741.57086-1-mathew.j.martineau@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 17:01:57 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Date: Fri, 28 Feb 2020 15:47:38 -0800

> MPTCP's DATA_FIN flag is sent in a DSS option when closing the
> MPTCP-level connection. This patch series prepares for correct DATA_FIN
> handling across multiple subflows (where individual subflows may
> disconnect without closing the entire MPTCP connection) by changing the
> way the MPTCP-level socket requests a DATA_FIN on a subflow and
> propagates the necessary data for the TCP option.

Series applied, thanks Mat.
