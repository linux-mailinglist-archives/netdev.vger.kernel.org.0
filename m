Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C64E198319
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 20:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgC3SMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 14:12:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40606 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgC3SMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 14:12:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C203A15C49958;
        Mon, 30 Mar 2020 11:12:20 -0700 (PDT)
Date:   Mon, 30 Mar 2020 11:12:20 -0700 (PDT)
Message-Id: <20200330.111220.1695575152624561637.davem@davemloft.net>
To:     eranbe@mellanox.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        michael.chan@broadcom.com, saeedm@mellanox.com
Subject: Re: [PATCH net-next v2 0/3] Devlink health auto attributes refactor
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1585479955-29828-1-git-send-email-eranbe@mellanox.com>
References: <1585479955-29828-1-git-send-email-eranbe@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 11:12:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>
Date: Sun, 29 Mar 2020 14:05:52 +0300

> This patchset refactors the auto-recover health reporter flag to be
> explicitly set by the devlink core.
> In addition, add another flag to control auto-dump attribute, also
> to be explicitly set by the devlink core.
> 
> For that, patch 0001 changes the auto-recover default value of 
> netdevsim dummy reporter.
> 
> After reporter registration, both flags can be altered be administrator
> only.
> 
> Changes since v1:
> - Change default behaviour of netdevsim dummy reporter
> - Move initialization of DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP 

Series applied, thank you.
