Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA2B3C4355
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbfJAV7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:59:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53438 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbfJAV7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 17:59:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5755C1264DFD4;
        Tue,  1 Oct 2019 14:59:36 -0700 (PDT)
Date:   Tue, 01 Oct 2019 14:59:35 -0700 (PDT)
Message-Id: <20191001.145935.1154310059311623456.davem@davemloft.net>
To:     nicolas.dichtel@6wind.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ipv6: minor code reorg in
 inet6_fill_ifla6_attrs()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190930120216.22404-1-nicolas.dichtel@6wind.com>
References: <20190930120216.22404-1-nicolas.dichtel@6wind.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 14:59:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Mon, 30 Sep 2019 14:02:16 +0200

> Just put related code together to ease code reading: the memcpy() is
> related to the nla_reserve().
> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Applied.
