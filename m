Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8171614437
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 07:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbfEFFAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 01:00:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59910 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfEFFAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 01:00:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DF90B12EB032B;
        Sun,  5 May 2019 22:00:02 -0700 (PDT)
Date:   Sun, 05 May 2019 22:00:02 -0700 (PDT)
Message-Id: <20190505.220002.611130199920867387.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, idosch@mellanox.com, dsahern@gmail.com
Subject: Re: [PATCH net-next 0/7] net: Export functions for nexthop code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190505164056.1742-1-dsahern@kernel.org>
References: <20190505164056.1742-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 22:00:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Sun,  5 May 2019 09:40:49 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> This set exports ipv4 and ipv6 fib functions for use by the nexthop
> code. It also adds new ones to send route notifications if a nexthop
> configuration changes.

Since net-next is closed and you cannot therefore build upon this, I am not
applying this series.

Thanks.
