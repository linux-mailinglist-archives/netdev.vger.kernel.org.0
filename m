Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6E726B302
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgIOW6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbgIOW5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 18:57:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45106C06174A
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 15:57:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3AE2013B61D58;
        Tue, 15 Sep 2020 15:40:55 -0700 (PDT)
Date:   Tue, 15 Sep 2020 15:57:40 -0700 (PDT)
Message-Id: <20200915.155740.1721457219073977323.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Subject: Re: [PATCH net-next 0/8] mlxsw: Introduce fw_fatal health reporter
 and test cmd to trigger test event
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200915084058.18555-1-idosch@idosch.org>
References: <20200915084058.18555-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 15 Sep 2020 15:40:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Tue, 15 Sep 2020 11:40:50 +0300

> From: Ido Schimmel <idosch@nvidia.com>
> 
> Jiri says:
> 
> This patch set introduces a health reporter for mlxsw that reports FW
> fatal events. Alongside that, it introduces a test command that is used
> to trigger a dummy FW fatal event by user:
> 
> $ sudo devlink health test pci/0000:03:00.0 reporter fw_fatal
> 
> $ devlink health
> pci/0000:03:00.0:
>   reporter fw_fatal
>     state error error 1 recover 0 last_dump_date 2020-07-27 last_dump_time 16:33:27 auto_dump true
> 
> $ sudo devlink health dump show pci/0000:03:00.0 reporter fw_fatal -j -p
> {
>     "irisc_id": 0,
>     "event": [
>         "id": 3 ],
>     "method": "query",
>     "long_process": false,
>     "command_type": "mad",
>     "reg_attr_id": 0
> }
> 
> As a dependency, the FW validation and flashing is moved to core.c.

Series applied, thanks everyone.
