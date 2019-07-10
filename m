Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D275642EA
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 09:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfGJHc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 03:32:56 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:45793 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727290AbfGJHc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 03:32:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1562743975; x=1594279975;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=sjG8ku6+W5v5awx8flcDasikc66jlGfghcpLlMkY5xU=;
  b=iu9bCyfIJEVTU1ETcj0yR+4k0NAm0CO1ba6UCB8GSO1zzDDGYN8kShIi
   kyUuT3QxeT6pgK82PAs6qgBv3R0wypW+84HTimwfsAt1kusWVqaJhOm7j
   UYcESwxZcJ4+Vf9KJZDD+iTqaLwrFUyoW8kD9gSxZs3pyGP5+4kIjaEQJ
   0=;
X-IronPort-AV: E=Sophos;i="5.62,473,1554768000"; 
   d="scan'208";a="773977521"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 10 Jul 2019 07:32:54 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-e34f1ddc.us-east-1.amazon.com (Postfix) with ESMTPS id 652ECA1FCD;
        Wed, 10 Jul 2019 07:32:52 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 10 Jul 2019 07:32:51 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.160.245) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 10 Jul 2019 07:32:46 +0000
Subject: Re: [PATCH v6 rdma-next 0/6] RDMA/qedr: Use the doorbell overflow
 recovery mechanism for RDMA
To:     Michal Kalderon <michal.kalderon@marvell.com>,
        <ariel.elior@marvell.com>, <jgg@ziepe.ca>, <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <sleybo@amazon.com>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <7b2f2205-6b5d-c9e7-2d59-296367e517ac@amazon.com>
Date:   Wed, 10 Jul 2019 10:32:41 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190709141735.19193-1-michal.kalderon@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.160.245]
X-ClientProxiedBy: EX13D25UWB001.ant.amazon.com (10.43.161.245) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/07/2019 17:17, Michal Kalderon wrote:
> This patch series uses the doorbell overflow recovery mechanism
> introduced in
> commit 36907cd5cd72 ("qed: Add doorbell overflow recovery mechanism")
> for rdma ( RoCE and iWARP )
> 
> The first three patches modify the core code to contain helper
> functions for managing mmap_xa inserting, getting and freeing
> entries. The code was taken almost as is from the efa driver.
> There is still an open discussion on whether we should take
> this even further and make the entire mmap generic. Until a
> decision is made, I only created the database API and modified
> the efa and qedr driver to use it. The doorbell recovery code will be based
> on the common code.
> 
> Efa driver was compile tested only.

For the whole series:
Tested-by: Gal Pressman <galpress@amazon.com>
