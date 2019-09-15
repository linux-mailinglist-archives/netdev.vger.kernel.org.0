Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7FDB315E
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 20:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfIOSdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 14:33:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39930 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfIOSdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 14:33:12 -0400
Received: from localhost (93-63-141-166.ip28.fastwebnet.it [93.63.141.166])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9E2C8153E75E7;
        Sun, 15 Sep 2019 11:33:04 -0700 (PDT)
Date:   Sun, 15 Sep 2019 19:32:41 +0100 (WEST)
Message-Id: <20190915.193241.878202512573492759.davem@davemloft.net>
To:     akiyano@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        sameehj@amazon.com, ndagan@amazon.com
Subject: Re: [PATCH V1 net-next 01/11] net: ena: add intr_moder_rx_interval
 to struct ena_com_dev and use it
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1568326128-4057-2-git-send-email-akiyano@amazon.com>
References: <1568326128-4057-1-git-send-email-akiyano@amazon.com>
        <1568326128-4057-2-git-send-email-akiyano@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Sep 2019 11:33:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <akiyano@amazon.com>
Date: Fri, 13 Sep 2019 01:08:38 +0300

> @@ -1307,8 +1304,8 @@ static void ena_com_update_intr_delay_resolution(struct ena_com_dev *ena_dev,
>  	ena_dev->intr_delay_resolution = intr_delay_resolution;
>  
>  	/* update Rx */
> -	for (i = 0; i < ENA_INTR_MAX_NUM_OF_LEVELS; i++)
> -		intr_moder_tbl[i].intr_moder_interval /= intr_delay_resolution;
> +	ena_dev->intr_moder_rx_interval /= intr_delay_resolution;
> +
>  
>  	/* update Tx */

Now there are two empty lines here, please remove one of them.
