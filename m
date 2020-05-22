Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1161C1DF2B8
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731261AbgEVXIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731175AbgEVXIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:08:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC59FC061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 16:08:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 641AB1274E615;
        Fri, 22 May 2020 16:08:31 -0700 (PDT)
Date:   Fri, 22 May 2020 16:08:30 -0700 (PDT)
Message-Id: <20200522.160830.2254128790497563433.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net 0/2] mlxsw: Various fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200521121145.1076075-1-idosch@idosch.org>
References: <20200521121145.1076075-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 16:08:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 21 May 2020 15:11:43 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Patch #1 from Jiri fixes a use-after-free discovered while fuzzing mlxsw
> / devlink with syzkaller.
> 
> Patch #2 from Amit works around a limitation in new versions of arping,
> which is used in several selftests.

Series applied, thanks.
