Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1117675707
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 20:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfGYSgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 14:36:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37010 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfGYSgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 14:36:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6C2FD143750E3;
        Thu, 25 Jul 2019 11:36:32 -0700 (PDT)
Date:   Thu, 25 Jul 2019 11:36:32 -0700 (PDT)
Message-Id: <20190725.113632.1050686888666568058.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/2] mlxsw: Two small updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723075742.29029-1-idosch@idosch.org>
References: <20190723075742.29029-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jul 2019 11:36:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Tue, 23 Jul 2019 10:57:40 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Patch #1, from Amit, exposes the size of the key-value database (KVD)
> where different entries (e.g., routes, neighbours) are stored in the
> device. This allows users to understand how many entries can be
> offloaded and is also useful for writing scale tests.
> 
> Patch #2 increases the number of IPv6 nexthop groups mlxsw can offload.
> The problem and solution are explained in detail in the commit message.

Series applied.
