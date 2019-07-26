Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFAB76DD6
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 17:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbfGZPhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 11:37:07 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52646 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389022AbfGZPaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 11:30:11 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1hr2Ab-0003Zd-OJ; Fri, 26 Jul 2019 11:30:09 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by localhost.localdomain (8.15.2/8.14.6) with ESMTP id x6QFQWYh009330;
        Fri, 26 Jul 2019 11:26:32 -0400
Received: (from linville@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id x6QFQWwM009329;
        Fri, 26 Jul 2019 11:26:32 -0400
Date:   Fri, 26 Jul 2019 11:26:32 -0400
From:   "John W. Linville" <linville@tuxdriver.com>
To:     Artem Bityutskiy <dedekind1@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2] ethtool: igb: dump RR2DCDELAY register
Message-ID: <20190726152632.GB23037@tuxdriver.com>
References: <20190715065228.88377-1-artem.bityutskiy@linux.intel.com>
 <20190715105933.40924-1-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715105933.40924-1-dedekind1@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 01:59:33PM +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> Decode 'RR2DCDELAY' register which Linux kernel provides starting from version
> 5.3. The corresponding commit in the Linux kernel is:
>     cd502a7f7c9c igb: add RR2DCDELAY to ethtool registers dump
> 
> The RR2DCDELAY register is present in I210 and I211 Intel Gigabit Ethernet
> chips and it stands for "Read Request To Data Completion Delay". Here is how
> this register is described in the I210 datasheet:
> 
> "This field captures the maximum PCIe split time in 16 ns units, which is the
> maximum delay between the read request to the first data completion. This is
> giving an estimation of the PCIe round trip time."
> 
> In practice, this register can be used to measure the time it takes the NIC to
> read data from the host memory.
> 
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Queued for next release -- thanks!

John

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
