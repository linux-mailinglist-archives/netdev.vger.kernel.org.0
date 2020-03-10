Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEDDA17EE94
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCJCaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:30:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34990 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbgCJCaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 22:30:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6D4AD120ED557;
        Mon,  9 Mar 2020 19:30:23 -0700 (PDT)
Date:   Mon, 09 Mar 2020 19:30:22 -0700 (PDT)
Message-Id: <20200309.193022.1244908011120629137.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] mptcp: don't auto-adjust rcvbuf size if
 locked
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200306202946.8285-1-fw@strlen.de>
References: <20200306202946.8285-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 19:30:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Fri,  6 Mar 2020 21:29:44 +0100

> The mptcp receive buffer is auto-sized based on the subflow receive
> buffer.  Don't do this if userspace specfied a value via SO_RCVBUF
> setsockopt.
> 
> Also update selftest program to provide a new option to set a fixed
> size.

Series applied, thank you.
