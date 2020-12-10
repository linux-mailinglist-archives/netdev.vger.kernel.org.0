Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F812D516C
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgLJDdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:33:41 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:34406 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729935AbgLJDdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:33:32 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 6DC3D4D259C1A;
        Wed,  9 Dec 2020 19:32:47 -0800 (PST)
Date:   Wed, 09 Dec 2020 19:32:47 -0800 (PST)
Message-Id: <20201209.193247.530989187832756241.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net-next 0/3] mptcp: a bunch of fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1607508810.git.pabeni@redhat.com>
References: <cover.1607508810.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 19:32:47 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Wed,  9 Dec 2020 12:03:28 +0100

> This series includes a few fixes following-up the
> recent code refactor for the MPTCP RX and TX paths.
> 
> Boundling them together, since the fixes are somewhat
> related.
Series applied, thanks.

