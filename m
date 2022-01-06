Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FD34863C4
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 12:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbiAFLdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 06:33:45 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:50647 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238526AbiAFLdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 06:33:44 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V15yeda_1641468821;
Received: from 30.225.24.14(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V15yeda_1641468821)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 06 Jan 2022 19:33:42 +0800
Message-ID: <998065f4-eb0e-3799-4bdb-345daf2d963d@linux.alibaba.com>
Date:   Thu, 6 Jan 2022 19:33:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net v4] net/smc: Reset conn->lgr when link group
 registration fails
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641451455-41647-1-git-send-email-guwen@linux.alibaba.com>
 <96521e26-7d51-7451-3cf4-cca37da9dc24@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <96521e26-7d51-7451-3cf4-cca37da9dc24@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/1/6 6:00 pm, Karsten Graul wrote:

> Looks like I missed a prereq patch here, but wo'nt conn->lgr be set to NULL
> after smc_conn_free() called smc_lgr_unregister_conn()?

Right... I should hold a local copy of lgr in smc_conn_abort().

My another RFC patch removes 'conn->lgr = NULL' from smc_lgr_unregister_conn(),
so I make a mistake here...

I will fix this. Thank you.

Wen Gu
