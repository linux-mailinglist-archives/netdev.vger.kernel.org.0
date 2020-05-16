Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F681D64C3
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 01:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgEPXmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 19:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726670AbgEPXmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 19:42:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C70C061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 16:42:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 42B5D1272E70A;
        Sat, 16 May 2020 16:42:49 -0700 (PDT)
Date:   Sat, 16 May 2020 16:42:48 -0700 (PDT)
Message-Id: <20200516.164248.1604724273149782093.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/6] mlxsw: Reorganize trap data
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200516224310.877237-1-idosch@idosch.org>
References: <20200516224310.877237-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 May 2020 16:42:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun, 17 May 2020 01:43:04 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patch set does not include any functional changes. It merely
> reworks the internal storage of traps, trap groups and trap policers in
> mlxsw to each use a single array.
> 
> These changes allow us to get rid of the multiple arrays we currently
> have for traps, which make the trap data easier to validate and extend
> with more per-trap information in the future. It will also allow us to
> more easily add per-ASIC traps in future submissions.
> 
> Last two patches include minor changes to devlink-trap selftests.
> 
> Tested with existing devlink-trap selftests.

Series applied, thanks.
