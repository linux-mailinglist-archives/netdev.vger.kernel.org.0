Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0471B1544
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgDTTAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726439AbgDTTAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 15:00:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9137DC061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 12:00:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CB9F011946237;
        Mon, 20 Apr 2020 12:00:13 -0700 (PDT)
Date:   Mon, 20 Apr 2020 12:00:12 -0700 (PDT)
Message-Id: <20200420.120012.14410492020615892.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 0/2] mlxsw: Two small changes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200419070106.3471528-1-idosch@idosch.org>
References: <20200419070106.3471528-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 12:00:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun, 19 Apr 2020 10:01:04 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Patch #1 increases the scale of supported IPv6 nexthops groups when each
> group has one nexthop and all are using the same nexthop device, but
> with a different gateway IP.
> 
> Patch #2 adjusts a register definition in accordance with recent
> firmware changes.

Series applied, thanks.
