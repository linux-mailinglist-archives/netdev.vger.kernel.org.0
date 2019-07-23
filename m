Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEFEE72079
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 22:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387902AbfGWUHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 16:07:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35998 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728583AbfGWUHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 16:07:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A7351153BAEA1;
        Tue, 23 Jul 2019 13:07:00 -0700 (PDT)
Date:   Tue, 23 Jul 2019 13:07:00 -0700 (PDT)
Message-Id: <20190723.130700.1751825108559652751.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, ssuryaextr@gmail.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net 0/2] selftests: forwarding: GRE multipath fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723081926.30647-1-idosch@idosch.org>
References: <20190723081926.30647-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 13:07:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Tue, 23 Jul 2019 11:19:24 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Patch #1 ensures IPv4 forwarding is enabled during the test.
> 
> Patch #2 fixes the flower filters used to measure the distribution of
> the traffic between the two nexthops, so that the test will pass
> regardless if traffic is offloaded or not.

Series applied.
