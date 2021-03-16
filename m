Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9390933CF4C
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 09:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbhCPIIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 04:08:14 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:47175 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbhCPIIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 04:08:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1615882088; x=1647418088;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=vXhZg/DXGRvH2+b4ZN4G8P9S48DiGuq0aLrbcPR496Q=;
  b=BgqNu6hRRDbgtkObuJMVRY83y53i3KGRR9lOsi9+STM87cA4T5T2ztJG
   /0NlT7JQopIbTYcr1zwim+IADLWEawMUmi1uHywFrZgH6p0544jk0hVOF
   R0il45oOoR2t7HLK5D8tNdogxZzKqXRblNLOb0icLuvm2LoMamEKRQKRD
   0=;
X-IronPort-AV: E=Sophos;i="5.81,251,1610409600"; 
   d="scan'208";a="120806475"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 16 Mar 2021 08:08:01 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id D43FBA240F;
        Tue, 16 Mar 2021 08:07:57 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.162.213) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 16 Mar 2021 08:07:51 +0000
References: <20210316032737.1429-1-yuzenghui@huawei.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netanel@amazon.com>, <akiyano@amazon.com>, <gtzalik@amazon.com>,
        <saeedb@amazon.com>, <corbet@lwn.net>, <wanghaibin.wang@huawei.com>
Subject: Re: [PATCH net] docs: net: ena: Fix ena_start_xmit() function name
 typo
In-Reply-To: <20210316032737.1429-1-yuzenghui@huawei.com>
Date:   Tue, 16 Mar 2021 10:07:29 +0200
Message-ID: <pj41zlczvzldxa.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.162.213]
X-ClientProxiedBy: EX13D03UWC002.ant.amazon.com (10.43.162.160) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Zenghui Yu <yuzenghui@huawei.com> writes:

> The ena.rst documentation referred to end_start_xmit() when it 
> should refer
> to ena_start_xmit(). Fix the typo.
>
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  Documentation/networking/device_drivers/ethernet/amazon/ena.rst 
>  | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git 
> a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst 
> b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> index 3561a8a29fd2..f8c6469f2bd2 100644
> --- 
> a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> +++ 
> b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> @@ -267,7 +267,7 @@ DATA PATH
>  Tx
>  --
>  
> -end_start_xmit() is called by the stack. This function does the 
> following:
> +ena_start_xmit() is called by the stack. This function does the 
> following:
>  
>  - Maps data buffers (skb->data and frags).
>  - Populates ena_buf for the push buffer (if the driver and 
>  device are

Acked-by: Shay Agroskin <shayagr@amazon.com>

Thanks for this fix
