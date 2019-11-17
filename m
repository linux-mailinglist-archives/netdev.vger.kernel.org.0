Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D89ECFFA7A
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 16:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfKQP25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 10:28:57 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:41198 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfKQP25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 10:28:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1574004536; x=1605540536;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=WHWsOINgMarlEDm0f02H983ywgwXKWtCbSQ4LBiTABs=;
  b=szbkSJbV444DVlI4CNece5tDaByyBhcUD//pUPxbcukTJy65wo8e9oey
   SXkK8FNCE9SAmnDe/hQRL/n2tmVmnuPcxGedGg2XLdR0TENDeYt/ydcEp
   mxtPUR5LZImbUTxuA08HVi4rFDZlk6iSZJ2BYQKGiEussOobXA1IXdU+D
   E=;
IronPort-SDR: 8LTLXDbACEMr8sqBGd2qIiwPRkh98omGIUogT7MHD0HtMdlm6eKX+x9QSTOzUnU5592+AcQqXQ
 X0PKcKNhF11g==
X-IronPort-AV: E=Sophos;i="5.68,316,1569283200"; 
   d="scan'208";a="8514090"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 17 Nov 2019 15:28:52 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-f14f4a47.us-west-2.amazon.com (Postfix) with ESMTPS id A6AFCA2071;
        Sun, 17 Nov 2019 15:28:51 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 17 Nov 2019 15:28:51 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.161.189) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 17 Nov 2019 15:28:47 +0000
Subject: Re: [PATCH] net/mlx4_en: fix mlx4 ethtool -N insertion
To:     <lrizzo@google.com>
CC:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tariqt@mellanox.com>
References: <20191115201225.92888-1-lrizzo@google.com>
 <20191116.131058.1856199123293908506.davem@davemloft.net>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <a26095dd-7fda-72c8-57e1-72da7b8d1b59@amazon.com>
Date:   Sun, 17 Nov 2019 17:28:42 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191116.131058.1856199123293908506.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.189]
X-ClientProxiedBy: EX13D23UWA004.ant.amazon.com (10.43.160.72) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/11/2019 23:10, David Miller wrote:
> From: Luigi Rizzo <lrizzo@google.com>
> Date: Fri, 15 Nov 2019 12:12:25 -0800
> 
>> ethtool expects ETHTOOL_GRXCLSRLALL to set ethtool_rxnfc->data with the
>> total number of entries in the rx classifier table.  Surprisingly, mlx4
>> is missing this part (in principle ethtool could still move forward and
>> try the insert).
>>
>> Tested: compiled and run command:
>> 	phh13:~# ethtool -N eth1 flow-type udp4  queue 4
>> 	Added rule with ID 255
>>
>> Signed-off-by: Luigi Rizzo <lrizzo@google.com>
>> Change-Id: I18a72f08dfcfb6b9f6aa80fbc12d58553e1fda76
> 
> Luigi, _always_ CC: the appropriate maintainer when making changes to the
> kernel, as per the top-level MAINTAINERS file.

You should also remove the Change-Id tag before submission.
