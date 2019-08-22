Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7B19A31A
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389463AbfHVWjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:39:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49880 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731958AbfHVWjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 18:39:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 985D01539419A;
        Thu, 22 Aug 2019 15:39:12 -0700 (PDT)
Date:   Thu, 22 Aug 2019 15:39:12 -0700 (PDT)
Message-Id: <20190822.153912.2269276523787180347.davem@davemloft.net>
To:     haiyangz@microsoft.com
Cc:     sashal@kernel.org, saeedm@mellanox.com, leon@kernel.org,
        eranbe@mellanox.com, lorenzo.pieralisi@arm.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        kys@microsoft.com, sthemmin@microsoft.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next,v5, 0/6] Add software backchannel and mlx5e HV
 VHCA stats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <DM6PR21MB133743FB2006A28AE10A170CCAA50@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1566512708-13785-1-git-send-email-haiyangz@microsoft.com>
        <20190822.153315.1245817410062415025.davem@davemloft.net>
        <DM6PR21MB133743FB2006A28AE10A170CCAA50@DM6PR21MB1337.namprd21.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 Aug 2019 15:39:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Thu, 22 Aug 2019 22:37:13 +0000

> The v5 is pretty much the same as v4, except Eran had a fix to patch #3 in response to
> Leon Romanovsky <leon@kernel.org>.

Well you now have to send me a patch relative to v4 in order to fix that.

When I say "applied", the series is in my tree and is therefore permanent.
It is therefore never appropriate to then post a new version of the series.
