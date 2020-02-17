Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86F8516089E
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgBQDUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:20:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48198 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgBQDUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:20:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 50330155A0493;
        Sun, 16 Feb 2020 19:20:30 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:20:29 -0800 (PST)
Message-Id: <20200216.192029.620157434622045157.davem@davemloft.net>
To:     mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] mptcp: Protect subflow socket options before
 connection completes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200214221429.26156-1-mathew.j.martineau@linux.intel.com>
References: <20200214221429.26156-1-mathew.j.martineau@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:20:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Date: Fri, 14 Feb 2020 14:14:29 -0800

> Userspace should not be able to directly manipulate subflow socket
> options before a connection is established since it is not yet known if
> it will be an MPTCP subflow or a TCP fallback subflow. TCP fallback
> subflows can be more directly controlled by userspace because they are
> regular TCP connections, while MPTCP subflow sockets need to be
> configured for the specific needs of MPTCP. Use the same logic as
> sendmsg/recvmsg to ensure that socket option calls are only passed
> through to known TCP fallback subflows.
> 
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

Applied.
