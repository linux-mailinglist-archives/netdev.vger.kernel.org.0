Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBD91559B4
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 15:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbgBGOgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 09:36:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43164 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgBGOgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 09:36:35 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD9F515AD7E0D;
        Fri,  7 Feb 2020 06:36:31 -0800 (PST)
Date:   Fri, 07 Feb 2020 15:36:30 +0100 (CET)
Message-Id: <20200207.153630.1432371073271757175.davem@davemloft.net>
To:     sergey.dyasli@citrix.com
Cc:     xen-devel@lists.xen.org, kasan-dev@googlegroups.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        aryabinin@virtuozzo.com, glider@google.com, dvyukov@google.com,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, george.dunlap@citrix.com,
        ross.lagerwall@citrix.com, akpm@linux-foundation.org,
        netdev@vger.kernel.org, wei.liu@kernel.org, paul@xen.org
Subject: Re: [PATCH v3 4/4] xen/netback: fix grant copy across page boundary
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200207142652.670-5-sergey.dyasli@citrix.com>
References: <20200207142652.670-1-sergey.dyasli@citrix.com>
        <20200207142652.670-5-sergey.dyasli@citrix.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Feb 2020 06:36:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Dyasli <sergey.dyasli@citrix.com>
Date: Fri, 7 Feb 2020 14:26:52 +0000

> From: Ross Lagerwall <ross.lagerwall@citrix.com>
> 
> When KASAN (or SLUB_DEBUG) is turned on, there is a higher chance that
> non-power-of-two allocations are not aligned to the next power of 2 of
> the size. Therefore, handle grant copies that cross page boundaries.
> 
> Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
> Signed-off-by: Sergey Dyasli <sergey.dyasli@citrix.com>
> Acked-by: Paul Durrant <paul@xen.org>

This is part of a larger patch series to which netdev was not CC:'d

Where is this patch targetted to be applied?

Do you expect a networking ACK on this?

Please do not submit patches in such an ambiguous manner like this
in the future, thank you.
