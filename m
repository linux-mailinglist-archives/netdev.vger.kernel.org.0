Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C55217B670
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 06:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgCFFfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 00:35:16 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59678 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgCFFfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 00:35:15 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2123715ADABDD;
        Thu,  5 Mar 2020 21:35:15 -0800 (PST)
Date:   Thu, 05 Mar 2020 21:35:14 -0800 (PST)
Message-Id: <20200305.213514.1337555425416659597.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, cpaasch@apple.com
Subject: Re: [PATCH net v2] mptcp: always include dack if possible.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d4f2f87c56fa1662bbc39baaee74b26bc646e141.1583337038.git.pabeni@redhat.com>
References: <d4f2f87c56fa1662bbc39baaee74b26bc646e141.1583337038.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Mar 2020 21:35:15 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Wed,  4 Mar 2020 16:51:07 +0100

> Currently passive MPTCP socket can skip including the DACK
> option - if the peer sends data before accept() completes.
> 
> The above happens because the msk 'can_ack' flag is set
> only after the accept() call.
> 
> Such missing DACK option may cause - as per RFC spec -
> unwanted fallback to TCP.
> 
> This change addresses the issue using the key material
> available in the current subflow, if any, to create a suitable
> dack option when msk ack seq is not yet available.
> 
> v1 -> v2:
>  - adavance the generated ack after the initial MPC packet
> 
> Fixes: d22f4988ffec ("mptcp: process MP_CAPABLE data option")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied, thank you.
