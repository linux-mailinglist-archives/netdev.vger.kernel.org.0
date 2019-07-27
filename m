Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF3C77C16
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 23:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfG0Vc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 17:32:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40506 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfG0Vc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 17:32:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5D5A515358387;
        Sat, 27 Jul 2019 14:32:57 -0700 (PDT)
Date:   Sat, 27 Jul 2019 14:32:56 -0700 (PDT)
Message-Id: <20190727.143256.1370023740547512866.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 0/3] mlxsw: spectrum_acl: Forbid unsupported
 filters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190727173257.6848-1-idosch@idosch.org>
References: <20190727173257.6848-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 14:32:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sat, 27 Jul 2019 20:32:54 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Patches #1-#2 make mlxsw reject unsupported egress filters. These
> include filters that match on VLAN and filters associated with a
> redirect action. Patch #1 rejects such filters when they are configured
> on egress and patch #2 rejects such filters when they are configured in
> a shared block that user tries to bind to egress.
> 
> Patch #3 forbids matching on reserved TCP flags as this is not supported
> by the current keys that mlxsw uses.

Series applied, thanks.
