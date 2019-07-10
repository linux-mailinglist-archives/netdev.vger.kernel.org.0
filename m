Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6CB36461C
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 14:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfGJMUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 08:20:05 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:18541 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbfGJMUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 08:20:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1562761204; x=1594297204;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=RJd+M170NMyymr0uvu5N2zRMOfJPbBOC+IfsjxL4iwQ=;
  b=hspuyUBoucFwm+W7WPKF7v1qq2RQE8vE61PlOKuQAAboClB8pCZ63WLY
   yL/lhQqMc6byxkKyVUiKInSYrYo1BO/jYavatv6FmOzUl2p4R2DWqcEnt
   qAgIaoHix4By2+CNdP5AuT6X2iKNAOy6cI0B6MY4SFzIpEv7lVd96BrJG
   8=;
X-IronPort-AV: E=Sophos;i="5.62,474,1554768000"; 
   d="scan'208";a="774007494"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 10 Jul 2019 12:20:02 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id E2230A2714;
        Wed, 10 Jul 2019 12:20:01 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 10 Jul 2019 12:20:01 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.161.88) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 10 Jul 2019 12:19:57 +0000
Subject: Re: [PATCH v6 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
To:     Michal Kalderon <michal.kalderon@marvell.com>,
        <ariel.elior@marvell.com>, <jgg@ziepe.ca>, <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
 <20190709141735.19193-2-michal.kalderon@marvell.com>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <11697fe6-a9e1-2a3d-a239-eebfe2b6a911@amazon.com>
Date:   Wed, 10 Jul 2019 15:19:52 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190709141735.19193-2-michal.kalderon@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.88]
X-ClientProxiedBy: EX13D07UWA001.ant.amazon.com (10.43.160.145) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/07/2019 17:17, Michal Kalderon wrote:
> Create some common API's for adding entries to a xa_mmap.
> Searching for an entry and freeing one.
> 
> The code was copied from the efa driver almost as is, just renamed
> function to be generic and not efa specific.
> 
> Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>

Reviewed-by: Gal Pressman <galpress@amazon.com>
