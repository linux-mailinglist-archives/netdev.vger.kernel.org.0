Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D947A33AE25
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 10:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhCOJCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 05:02:00 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:22779 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhCOJBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 05:01:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1615798903; x=1647334903;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=L1t2HqnlO7990sJbch3O4sVrvU6b4LxDMuwpwNAvqLU=;
  b=JYlkLcVvk5n/jfgOs9YDrGHYdvP31OzRKLQWaZFfzH3o093u5c2wNw0a
   tZDHWYqnm+yRH6gcZ84LG13DJGsTIoG7qRB1MUyrFMksq3woSFRovMQhs
   SGcIm+SBxWYadylxsaTUjp+ZUkL5ySDRX+su8O0IA2iSvtxQA/xpWzk4U
   s=;
IronPort-HdrOrdr: A9a23:0YlRuq9aWpbHWouHXnduk+BqI+orLtY04lQ7vn1ZYzY9SK2lvu
 qpm+kW0gKxtSYJVBgb6Le9EYSJXH+0z+8W3aA/JrGnNTOIhEKJK8VY4ZLm03ncHUTFh41g/I
 NBV4Q7N9HqF1h9iq/BkW2FOvIt2sOO/qztpcq29QYJcShScK1r4wp0DQyWe3cGPDVuPpYyGJ
 qC6scvnVPJEh4qR/+2CXUfU+/Iq8ejrv/bSCQbDB0q4hTmt1OVwYP9eiL34j4jST9Vhb8t/W
 /Z+jaU2oyT99u/yhPaylbJ6YVXlNbL2rJ4dbWxo/lQDC7thAaubJlgXLPHnAldmpDI1GoX
X-IronPort-AV: E=Sophos;i="5.81,249,1610409600"; 
   d="scan'208";a="94501544"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 15 Mar 2021 09:01:26 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 0510AA2740;
        Mon, 15 Mar 2021 09:01:23 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.160.48) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 15 Mar 2021 09:01:18 +0000
References: <20210314222221.3996408-1-unixbhaskar@gmail.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
CC:     <netanel@amazon.com>, <akiyano@amazon.com>, <gtzalik@amazon.com>,
        <saeedb@amazon.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <sameehj@amazon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rdunlap@infradead.org>
Subject: Re: [PATCH] ethernet: amazon: ena: A typo fix in the file ena_com.h
In-Reply-To: <20210314222221.3996408-1-unixbhaskar@gmail.com>
Date:   Mon, 15 Mar 2021 11:00:57 +0200
Message-ID: <pj41zlft0wlrjq.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.160.48]
X-ClientProxiedBy: EX13D35UWB001.ant.amazon.com (10.43.161.47) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Bhaskar Chowdhury <unixbhaskar@gmail.com> writes:

> Mundane typo fix.
>
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_com.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h 
> b/drivers/net/ethernet/amazon/ena/ena_com.h
> index 343caf41e709..73b03ce59412 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_com.h
> +++ b/drivers/net/ethernet/amazon/ena/ena_com.h
> @@ -124,7 +124,7 @@ struct ena_com_io_cq {
>
>  	/* holds the number of cdesc of the current packet */
>  	u16 cur_rx_pkt_cdesc_count;
> -	/* save the firt cdesc idx of the current packet */
> +	/* save the first cdesc idx of the current packet */
>  	u16 cur_rx_pkt_cdesc_start_idx;
>
>  	u16 q_depth;

Acked-by: Shay Agroskin <shayagr@amazon.com>

Thanks for your patch
