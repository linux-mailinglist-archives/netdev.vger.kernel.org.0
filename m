Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96B04821C0
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 04:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237649AbhLaDPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 22:15:47 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:52735 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229953AbhLaDPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 22:15:47 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V0OfjCG_1640920544;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V0OfjCG_1640920544)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 31 Dec 2021 11:15:45 +0800
Date:   Fri, 31 Dec 2021 11:15:44 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Wen Gu <guwen@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Subject: Re: [PATCH net 1/2] net/smc: don't send CDC/LLC message if link not
 ready
Message-ID: <20211231031544.GA31579@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20211228090325.27263-1-dust.li@linux.alibaba.com>
 <20211228090325.27263-2-dust.li@linux.alibaba.com>
 <2b3dd919-029c-cd44-b39c-5467bb723c0f@linux.ibm.com>
 <20211230030226.GA55356@linux.alibaba.com>
 <c4f5827f-fe48-d295-6d97-3848cc144171@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4f5827f-fe48-d295-6d97-3848cc144171@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 07:55:01PM +0100, Karsten Graul wrote:
>On 30/12/2021 04:02, dust.li wrote:
>> On Wed, Dec 29, 2021 at 01:36:06PM +0100, Karsten Graul wrote:
>>> On 28/12/2021 10:03, Dust Li wrote:
>> I saw David has already applied this to net, should I send another
>> patch to add some comments ?
>
>You could send a follow-on patch with your additional information, which
>I find is very helpful! Thanks.

Sure, will do

>
>-- 
>Karsten
