Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD53E141E6B
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 15:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgASOJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 09:09:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48722 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgASOJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 09:09:02 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B64A614EADFA0;
        Sun, 19 Jan 2020 06:09:01 -0800 (PST)
Date:   Sun, 19 Jan 2020 15:08:57 +0100 (CET)
Message-Id: <20200119.150857.2254625426487985777.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netlink: make getters tolerate NULL nla arg
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200119123239.GB795@breakpoint.cc>
References: <20200116145522.28803-1-fw@strlen.de>
        <20200117.040849.2032549448991143345.davem@davemloft.net>
        <20200119123239.GB795@breakpoint.cc>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jan 2020 06:09:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Sun, 19 Jan 2020 13:32:39 +0100

> Less than 24 hours after I saw this patch marked rejected syzbot
> reported another incarnation of this pattern.

Which is exactly what we want to happen.
