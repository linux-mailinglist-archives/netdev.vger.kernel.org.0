Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019BF27F3E6
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgI3VHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3VHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 17:07:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03A0C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 14:07:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4228313C623D5;
        Wed, 30 Sep 2020 13:50:27 -0700 (PDT)
Date:   Wed, 30 Sep 2020 14:07:11 -0700 (PDT)
Message-Id: <20200930.140711.2037315331365169389.davem@davemloft.net>
To:     petrm@nvidia.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, idosch@nvidia.com
Subject: Re: [PATCH net-next 0/6] mlxsw: PFC and headroom selftests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1601462261.git.petrm@nvidia.com>
References: <cover.1601462261.git.petrm@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 30 Sep 2020 13:50:27 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>
Date: Wed, 30 Sep 2020 12:49:06 +0200

> Recent changes in the headroom management code made it clear that an
> automated way of testing this functionality is needed. This patchset brings
> two tests: a synthetic headroom behavior test, which verifies mechanics of
> headroom management. And a PFC test, which verifies whether this behavior
> actually translates into a working lossless configuration.
> 
> Both of these tests rely on mlnx_qos[1], a tool that interfaces with Linux
> DCB API. The tool was originally written to work with Mellanox NICs, but
> does not actually rely on anything Mellanox-specific, and can be used for
> mlxsw as well as for any other NIC-like driver. Unlike Open LLDP it does
> support buffer commands and permits a fire-and-forget approach to
> configuration, which makes it very handy for writing of selftests.
> 
> Patches #1-#3 extend the selftest devlink_lib.sh in various ways. Patch #4
> then adds a helper wrapper for mlnx_qos to mlxsw's qos_lib.sh.
> 
> Patch #5 adds a test for management of port headroom.
> 
> Patch #6 adds a PFC test.
> 
> [1] https://github.com/Mellanox/mlnx-tools/

These look fine, series applied, thank you.
