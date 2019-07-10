Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F2C64607
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 14:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfGJMKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 08:10:11 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:31786 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfGJMKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 08:10:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1562760610; x=1594296610;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=keN8EFn+IHg5hXYYMmmGsxMpxiPk60sc+gcoGB+dD7M=;
  b=NW36NFr+XI9CRjcQrsBKodDRWC9uNX8Q+9E0nbrQAP0qm7xot1lCQaBy
   QcuOXJPsx8zs2FMbH16NPu2J9RabeZFtoxfHrakuVx9BWEoagn7JdwztR
   nrlQb37ixVHOHxj5M/wEkN0PtFPtFBJmAf29kcqG2EAHyL+V4iaH7FA4N
   Q=;
X-IronPort-AV: E=Sophos;i="5.62,474,1554768000"; 
   d="scan'208";a="815382902"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 10 Jul 2019 12:10:03 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id C5405A2362;
        Wed, 10 Jul 2019 12:10:02 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 10 Jul 2019 12:10:02 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.161.115) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 10 Jul 2019 12:09:58 +0000
Subject: Re: [PATCH v6 rdma-next 2/6] RDMA/efa: Use the common mmap_xa helpers
To:     Michal Kalderon <michal.kalderon@marvell.com>,
        <ariel.elior@marvell.com>, <jgg@ziepe.ca>, <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
 <20190709141735.19193-3-michal.kalderon@marvell.com>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <ba7809c0-5ab1-ac5e-bcf9-57d2930d21ed@amazon.com>
Date:   Wed, 10 Jul 2019 15:09:52 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190709141735.19193-3-michal.kalderon@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.115]
X-ClientProxiedBy: EX13D06UWA001.ant.amazon.com (10.43.160.220) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/07/2019 17:17, Michal Kalderon wrote:
> Remove the functions related to managing the mmap_xa database.
> This code was copied to the ib_core. Use the common API's instead.
> 
> Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>

Thanks Michal,
Acked-by: Gal Pressman <galpress@amazon.com>
