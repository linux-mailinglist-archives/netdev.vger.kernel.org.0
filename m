Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60015EE83D
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbfKDTWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:22:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50354 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728174AbfKDTWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:22:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5C300151D4F95;
        Mon,  4 Nov 2019 11:22:43 -0800 (PST)
Date:   Mon, 04 Nov 2019 11:22:42 -0800 (PST)
Message-Id: <20191104.112242.221041713086828358.davem@davemloft.net>
To:     u9012063@gmail.com
Cc:     pshelar@ovn.org, xiangxia.m.yue@gmail.com, dev@openvswitch.org,
        netdev@vger.kernel.org
Subject: Re: [ovs-dev] [PATCH net-next v6 05/10] net: openvswitch: optimize
 flow-mask looking up
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CALDO+SYq2FGK5i=LDxKx8GYAEF=juMRNSXe0URb+rvGog1FYTw@mail.gmail.com>
References: <1572618234-6904-6-git-send-email-xiangxia.m.yue@gmail.com>
        <CAOrHB_CkZJ+w3LvUyzUZRgnFa1JnkkKY85XsjEMvXD4geAzW4g@mail.gmail.com>
        <CALDO+SYq2FGK5i=LDxKx8GYAEF=juMRNSXe0URb+rvGog1FYTw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Nov 2019 11:22:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Tu <u9012063@gmail.com>
Date: Mon, 4 Nov 2019 05:59:27 -0800

> Nack to this patch.

These changes are already in net-next.

If you already pointed out these problems in previous discussions, I'm
sorry about that.
