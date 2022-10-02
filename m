Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF485F2192
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 08:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiJBGhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 02:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiJBGhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 02:37:05 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5692C2B240
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 23:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664692624; x=1696228624;
  h=references:from:to:cc:date:in-reply-to:message-id:
   mime-version:subject;
  bh=zl+MHKAr2gHFromR8trQi6XfbxBkheuBPRPenN8unlQ=;
  b=VdsNzmz6KgjBOi8vY3wIPyFQEngQJ2Cp5itbxbhXz5nG5f12II/yX8Yg
   Ru0V5vAa8tmjbRtu2ObY0GF9Nj0Ej6rcFAnhiqKTLHEZIux6VK7RU/Dzx
   w6+SYoVM1mqv+KzMK4a3PIdtdEXvhys2zCAp6g67DkzoMfjG0OhFM10ro
   g=;
X-IronPort-AV: E=Sophos;i="5.93,361,1654560000"; 
   d="scan'208";a="135980777"
Subject: Re: [PATCH -next] net: ena: Remove unused variable 'tx_bytes'
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2022 06:36:49 +0000
Received: from EX13D20EUB004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com (Postfix) with ESMTPS id 08E1545CB7;
        Sun,  2 Oct 2022 06:36:48 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX13D20EUB004.ant.amazon.com (10.43.166.228) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Sun, 2 Oct 2022 06:36:46 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.162.55) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.12; Sun, 2 Oct 2022 06:36:41 +0000
References: <20221010031936.2885327-1-chenzhongjin@huawei.com>
User-agent: mu4e 1.6.10; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Chen Zhongjin <chenzhongjin@huawei.com>, <netdev@vger.kernel.org>
CC:     <akiyano@amazon.com>, <darinzon@amazon.com>, <ndagan@amazon.com>,
        <saeedb@amazon.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <nkoler@amazon.com>,
        <42.hyeyoo@gmail.com>
Date:   Sun, 2 Oct 2022 09:35:38 +0300
In-Reply-To: <20221010031936.2885327-1-chenzhongjin@huawei.com>
Message-ID: <pj41zlo7uuivf0.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.162.55]
X-ClientProxiedBy: EX13D02UWB001.ant.amazon.com (10.43.161.240) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-12.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Chen Zhongjin <chenzhongjin@huawei.com> writes:

> CAUTION: This email originated from outside of the 
> organization. Do not click links or open attachments unless you 
> can confirm the sender and know the content is safe.
>
>
>
> Reported by Clang [-Wunused-but-set-variable]
>
> 'commit 548c4940b9f1 ("net: ena: Implement XDP_TX action")'
> This commit introduced the variable 'tx_bytes'. However this 
> variable
> is never used by other code except iterates itself, so remove 
> it.
>
> Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c 
> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 6a356a6cee15..c8dfb9287856 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -1876,7 +1876,6 @@ static int ena_clean_xdp_irq(struct 
> ena_ring *xdp_ring, u32 budget)
>  {
>         u32 total_done = 0;
>         u16 next_to_clean;
> -       u32 tx_bytes = 0;
>         int tx_pkts = 0;
>         u16 req_id;
>         int rc;
> @@ -1914,7 +1913,6 @@ static int ena_clean_xdp_irq(struct 
> ena_ring *xdp_ring, u32 budget)
>                           "tx_poll: q %d skb %p completed\n", 
>                           xdp_ring->qid,
>                           xdpf);
>
> -               tx_bytes += xdpf->len;
>                 tx_pkts++;
>                 total_done += tx_info->tx_descs;

Nice catch. Thanks

Acked-by: Shay Agroskin <shayagr@amazon.com>
