Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589D4250DD2
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 02:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgHYAtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 20:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728251AbgHYAtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 20:49:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEFAC061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 17:49:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4DC3712951BBE;
        Mon, 24 Aug 2020 17:32:36 -0700 (PDT)
Date:   Mon, 24 Aug 2020 17:49:21 -0700 (PDT)
Message-Id: <20200824.174921.2282920459705835900.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Subject: Re: [PATCH net-next 0/7] mlxsw: Misc updates
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200823080628.407637-1-idosch@idosch.org>
References: <20200823080628.407637-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 17:32:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun, 23 Aug 2020 11:06:21 +0300

> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patch set includes various updates for mlxsw.
> 
> Patches #1-#4 adjust the default burst size of packet trap policers to
> conform to Spectrum-{2,3} requirements. The corresponding selftest is
> also adjusted so that it could reliably pass on these platforms.
> 
> Patch #5 adjusts a selftest so that it could pass with both old and new
> versions of mausezahn.
> 
> Patch #6 significantly reduces the runtime of tc-police scale test by
> changing the preference and masks of the used tc filters.
> 
> Patch #7 prevents the driver from trying to set invalid ethtool link
> modes.

Applied, thanks Ido.
