Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE4CA6A3B6
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 10:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730801AbfGPITl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 04:19:41 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:42353 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbfGPITl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 04:19:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1563265180; x=1594801180;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Jh6xClsdaLwicVbTKrHqdmsiuSDX9G9DLNiqVhM/SwU=;
  b=lX5y9sinwWhB2PCUaRy/UaqPaIdfPubqFpWnWFT9/us94eX/Gdyn+wVX
   daArAV55PE5duI88ZnC+7o465S5h0Vy4kfrss66cLbhbaNoaeiIVmSfcO
   oizhT3eUiDF+MmPOcuxuNGxbPf0vqGVfBrDexYr6mMU/g8A2Z6WEmz3DV
   8=;
X-IronPort-AV: E=Sophos;i="5.62,497,1554768000"; 
   d="scan'208";a="774720069"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 16 Jul 2019 08:19:38 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 42C64141704;
        Tue, 16 Jul 2019 08:19:36 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 16 Jul 2019 08:19:36 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.161.115) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 16 Jul 2019 08:19:31 +0000
Subject: Re: [PATCH iproute2-rc 8/8] rdma: Document counter statistic
To:     Leon Romanovsky <leon@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Mark Zhang <markz@mellanox.com>,
        "RDMA mailing list" <linux-rdma@vger.kernel.org>
References: <20190710072455.9125-1-leon@kernel.org>
 <20190710072455.9125-9-leon@kernel.org>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <92db561d-e89c-0e09-ef2e-9eb9535d504f@amazon.com>
Date:   Tue, 16 Jul 2019 11:19:26 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190710072455.9125-9-leon@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.115]
X-ClientProxiedBy: EX13D07UWA001.ant.amazon.com (10.43.160.145) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/07/2019 10:24, Leon Romanovsky wrote:
> +.SH "EXAMPLES"
> +.PP
> +rdma statistic show
> +.RS 4
> +Shows the state of the default counter of all RDMA devices on the system.
> +.RE
> +.PP
> +rdma statistic show link mlx5_2/1
> +.RS 4
> +Shows the state of the default counter of specified RDMA port
> +.RE
> +.PP
> +rdma statistic qp show
> +.RS 4
> +Shows the state of all qp counters of all RDMA devices on the system.
> +.RE
> +.PP
> +rdma statistic qp show link mlx5_2/1
> +.RS 4
> +Shows the state of all qp counters of specified RDMA port.
> +.RE
> +.PP
> +rdma statistic qp show link mlx5_2 pid 30489
> +.RS 4
> +Shows the state of all qp counters of specified RDMA port and belonging to pid 30489
> +.RE
> +.PP
> +rdma statistic qp mode
> +.RS 4
> +List current counter mode on all deivces

"deivces" -> "devices".
