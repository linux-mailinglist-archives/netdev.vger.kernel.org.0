Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48CB282BDF
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 08:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731898AbfHFGlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 02:41:50 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:27618 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731731AbfHFGlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 02:41:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1565073709; x=1596609709;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=uwYfDE0m2ARKujVSzsPRQ4binIhLn7GSuPeTq53+GP8=;
  b=IdZptExFg+y7rSSIIT5ZDeAjSjv0Vejn5bnE6QmIiGxKsZdaHkq4VULK
   9jzrgOLFHyN+XqkOABLLO0nP2UTH0y9PN1Wwc8dm4Hmg532sInx15Otew
   rReFxJVB8ZVHD/vaMG4k1fCtaOIg35WFLcJbvsLGOJIcF7lwyu3M3UDa1
   Y=;
X-IronPort-AV: E=Sophos;i="5.64,352,1559520000"; 
   d="scan'208";a="691225114"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 06 Aug 2019 06:41:47 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-5bdc5131.us-west-2.amazon.com (Postfix) with ESMTPS id 47CFDA0151;
        Tue,  6 Aug 2019 06:41:47 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 6 Aug 2019 06:41:46 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.162.197) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 6 Aug 2019 06:41:42 +0000
Subject: Re: [PATCH iproute2-next] rdma: Add driver QP type string
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Leon Romanovsky <leon@kernel.org>
References: <20190804080756.58364-1-galpress@amazon.com>
 <fd623a4e-d076-3eea-2d1e-7702812b0dfc@gmail.com>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <d156ece6-79bf-f9a4-8b79-a5abf738476d@amazon.com>
Date:   Tue, 6 Aug 2019 09:41:37 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <fd623a4e-d076-3eea-2d1e-7702812b0dfc@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.197]
X-ClientProxiedBy: EX13D30UWC002.ant.amazon.com (10.43.162.235) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/08/2019 22:08, David Ahern wrote:
> On 8/4/19 2:07 AM, Gal Pressman wrote:
>> RDMA resource tracker now tracks driver QPs as well, add driver QP type
>> string to qp_types_to_str function.
> 
> "now" means which kernel release? Leon: should this be in master or -next?

Now means the patch is merged to RDMA's for-rc branch (5.3).
