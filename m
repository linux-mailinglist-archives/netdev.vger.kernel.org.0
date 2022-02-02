Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A154A7115
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 13:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344225AbiBBMyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 07:54:03 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:42243 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233535AbiBBMyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 07:54:02 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V3S.Kr4_1643806438;
Received: from 30.236.29.213(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V3S.Kr4_1643806438)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Feb 2022 20:54:00 +0800
Message-ID: <0c4ab79c-5f46-5e56-5326-631a9bc1d4a7@linux.alibaba.com>
Date:   Wed, 2 Feb 2022 20:53:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v2 net-next 1/3] net/smc: Make smc_tcp_listen_work()
 independent
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        matthieu.baerts@tessares.net
References: <cover.1643380219.git.alibuda@linux.alibaba.com>
 <53383b68f056b4c6d697935d2ea1c170618eebbe.1643380219.git.alibuda@linux.alibaba.com>
 <0b99dc4d-319e-e4fa-b4bf-ddce5005be47@linux.ibm.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <0b99dc4d-319e-e4fa-b4bf-ddce5005be47@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That's right, 'extern' is unnecessary, I'll remove it soon.

Looking forward for more advise.

Thanks.


>>   
>> +extern struct workqueue_struct	*smc_tcp_ls_wq;	/* wq for tcp listen work */
> 
> I don't think this extern is needed, the work queue is only used within af_smc.c, right?
> Even the smc_hs_wq would not need to be extern, but this would be a future cleanup.
> 
>>   extern struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
>>   extern struct workqueue_struct	*smc_close_wq;	/* wq for close work */
>>   
