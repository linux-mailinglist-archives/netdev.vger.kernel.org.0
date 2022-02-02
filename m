Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC8C4A72A6
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 15:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbiBBOE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 09:04:28 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:40340 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234785AbiBBOE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 09:04:27 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V3RttOi_1643810662;
Received: from 192.168.0.104(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V3RttOi_1643810662)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Feb 2022 22:04:23 +0800
Message-ID: <d7ccabf9-04b1-c3a8-8d79-61860f145780@linux.alibaba.com>
Date:   Wed, 2 Feb 2022 22:04:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v2 net-next 3/3] net/smc: Fallback when handshake
 workqueue congested
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, matthieu.baerts@tessares.net
References: <cover.1643380219.git.alibuda@linux.alibaba.com>
 <2d3f81193fc7a245c50b30329d0e84ae98427a33.1643380219.git.alibuda@linux.alibaba.com>
 <YfTDjXh8zP3WBAtg@TonyMac-Alibaba>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <YfTDjXh8zP3WBAtg@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Copy that. I'll try it in next version.

Thanks.

在 2022/1/29 下午12:33, Tony Lu 写道:

> Using a netlink knob to control behavior with static key should be more
> flexible. As I appended in the previous version of this patch.
> 
> Thank you,
> Tony Lu
