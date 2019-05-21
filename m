Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7D5258B7
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbfEUUNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:13:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44654 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727283AbfEUUNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 16:13:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5957514C7E00B;
        Tue, 21 May 2019 13:13:33 -0700 (PDT)
Date:   Tue, 21 May 2019 13:13:32 -0700 (PDT)
Message-Id: <20190521.131332.1853878239025310670.davem@davemloft.net>
To:     mmanning@vyatta.att-mail.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] ipv6: Consider sk_bound_dev_if when binding a raw
 socket to an address
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190520185717.24914-1-mmanning@vyatta.att-mail.com>
References: <20190520185717.24914-1-mmanning@vyatta.att-mail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 May 2019 13:13:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mike Manning <mmanning@vyatta.att-mail.com>
Date: Mon, 20 May 2019 19:57:17 +0100

> IPv6 does not consider if the socket is bound to a device when binding
> to an address. The result is that a socket can be bound to eth0 and
> then bound to the address of eth1. If the device is a VRF, the result
> is that a socket can only be bound to an address in the default VRF.
> 
> Resolve by considering the device if sk_bound_dev_if is set.
> 
> Signed-off-by: Mike Manning <mmanning@vyatta.att-mail.com>

Applied.
