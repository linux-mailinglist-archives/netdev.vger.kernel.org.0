Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFA362C28
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 00:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbfGHWxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 18:53:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59796 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbfGHWxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 18:53:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7A9DC12DAD56E;
        Mon,  8 Jul 2019 15:53:40 -0700 (PDT)
Date:   Mon, 08 Jul 2019 15:53:40 -0700 (PDT)
Message-Id: <20190708.155340.25577128500215935.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     pshelar@ovn.org, netdev@vger.kernel.org, dev@openvswitch.org
Subject: Re: [PATCH net-next] net: openvswitch: use netif_ovs_is_port()
 instead of opencode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190705160546.4847-1-ap420073@gmail.com>
References: <20190705160546.4847-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 15:53:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Sat,  6 Jul 2019 01:05:46 +0900

> Use netif_ovs_is_port() function instead of open code.
> This patch doesn't change logic.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied.
