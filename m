Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098B11E04BD
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 04:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388691AbgEYCcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 22:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388110AbgEYCcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 22:32:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A979C061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 19:32:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6A7CC1280D091;
        Sun, 24 May 2020 19:32:43 -0700 (PDT)
Date:   Sun, 24 May 2020 19:32:40 -0700 (PDT)
Message-Id: <20200524.193240.1449992359091713647.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 00/11] mlxsw: Various trap changes - part 1
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200524215107.1315526-1-idosch@idosch.org>
References: <20200524215107.1315526-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 24 May 2020 19:32:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Mon, 25 May 2020 00:50:56 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patch set contains various changes in mlxsw trap configuration.
> Another set will perform similar changes before exposing control traps
> (e.g., IGMP query, ARP request) via devlink-trap.
> 
> Tested with existing devlink-trap selftests. Please see individual
> patches for a detailed changelog.

Series applied, thank you.
