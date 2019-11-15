Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9302FDF02
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 14:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfKONg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 08:36:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:41646 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727329AbfKONg2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 08:36:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 993A2B210;
        Fri, 15 Nov 2019 13:36:26 +0000 (UTC)
Date:   Fri, 15 Nov 2019 14:36:25 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     linux-kernel@vger.kernel.org, yuqi jin <jinyuqi@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Paul Burton <paul.burton@mips.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] lib: optimize cpumask_local_spread()
Message-ID: <20191115133625.GD29990@dhcp22.suse.cz>
References: <1573091048-10595-1-git-send-email-zhangshaokun@hisilicon.com>
 <20191108103102.GF15658@dhcp22.suse.cz>
 <c6f24942-c8d6-e46a-f433-152d29af8c71@hisilicon.com>
 <20191112115630.GD2763@dhcp22.suse.cz>
 <00856999-739f-fd73-eddd-d71e4e94962e@hisilicon.com>
 <20191114144317.GJ20866@dhcp22.suse.cz>
 <9af13fea-95a6-30cb-2c0e-770aa649a549@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9af13fea-95a6-30cb-2c0e-770aa649a549@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 15-11-19 17:09:13, Shaokun Zhang wrote:
[...]
> Oh, my mistake, for the previous instance, I don't list all IRQs and
> just choose one IRQ from one NUMA node. You can see that the IRQ
> number is not consistent :-).
> IRQ from 345 to 368 will be bound to CPU cores which are in NUMA node2
> and each IRQ is corresponding to one core.
> 

This is quite confusing then. I would suggest providing all IRQ used for
the device with the specific node affinity to see the difference in the
setup.

-- 
Michal Hocko
SUSE Labs
