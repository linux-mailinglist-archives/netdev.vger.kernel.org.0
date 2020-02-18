Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADB7162108
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 07:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgBRGl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 01:41:26 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58768 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgBRGl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 01:41:26 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DEEC015B4B084;
        Mon, 17 Feb 2020 22:41:25 -0800 (PST)
Date:   Mon, 17 Feb 2020 22:41:25 -0800 (PST)
Message-Id: <20200217.224125.1346611413528118306.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, petrm@mellanox.com
Subject: Re: [PATCH net] selftests: forwarding: vxlan_bridge_1d: use more
 proper tos value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200217034315.30892-1-liuhangbin@gmail.com>
References: <20200217034315.30892-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 22:41:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Mon, 17 Feb 2020 11:43:15 +0800

> 0x11 and 0x12 set the ECN bits based on RFC2474, it would be better to avoid
> that. 0x14 and 0x18 would be better and works as well.
> 
> Reported-by: Petr Machata <petrm@mellanox.com>
> Fixes: 4e867c9a50ff ("selftests: forwarding: vxlan_bridge_1d: fix tos value")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied, thank you.
