Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DBF1E3698
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 05:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgE0Dee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 23:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgE0Dee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 23:34:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89055C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 20:34:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DCA2B1278BD57;
        Tue, 26 May 2020 20:34:33 -0700 (PDT)
Date:   Tue, 26 May 2020 20:34:33 -0700 (PDT)
Message-Id: <20200526.203433.1693371931109409198.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 00/14] mlxsw: Various trap changes - part 2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200525230556.1455927-1-idosch@idosch.org>
References: <20200525230556.1455927-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 20:34:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Tue, 26 May 2020 02:05:42 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patch set contains another set of small changes in mlxsw trap
> configuration. It is the last set before exposing control traps (e.g.,
> IGMP query, ARP request) via devlink-trap.
> 
> Tested with existing devlink-trap selftests. Please see individual
> patches for a detailed changelog.

Since this is just a cleanup of existing code, series applied since it
is independent of the discussion Ido is having with Jakub.
