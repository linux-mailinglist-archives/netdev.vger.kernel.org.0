Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C86BD984E5
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 22:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbfHUT7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 15:59:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32864 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729763AbfHUT7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 15:59:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 62B3F14C2210B;
        Wed, 21 Aug 2019 12:59:13 -0700 (PDT)
Date:   Wed, 21 Aug 2019 12:59:10 -0700 (PDT)
Message-Id: <20190821.125910.2301425172924175320.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, dsahern@gmail.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/7] mlxsw: Add devlink-trap support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190821071937.13622-1-idosch@idosch.org>
References: <20190821071937.13622-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 12:59:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed, 21 Aug 2019 10:19:30 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patchset adds devlink-trap support in mlxsw.
> 
> Patches #1-#4 add the necessary APIs and defines in mlxsw.
> 
> Patch #5 implements devlink-trap support for layer 2 drops. More drops
> will be added in the future.
> 
> Patches #6-#7 add selftests to make sure that all the new code paths are
> exercised and that the feature is working as expected.

Series applied, although that rate should really be configurable somehow.
10Kpps seems quite arbitrary...
