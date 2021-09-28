Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D8841A725
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 07:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235054AbhI1FgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 01:36:20 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:48799 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231330AbhI1FgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 01:36:19 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UpuToG2_1632807276;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UpuToG2_1632807276)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 28 Sep 2021 13:34:37 +0800
Subject: Re: [RESEND PATCH v2] net: prevent user from passing illegal stab
 size
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:TC subsystem" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <cab456a9-680d-9791-599b-de003b88a9ea@linux.alibaba.com>
 <CAM_iQpUuST2d0LZ5i7dqz=E1uL4Wiizf5WNbdJ=vc-9MR20SyQ@mail.gmail.com>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <c2545718-a20a-355b-6158-ddeac91b942a@linux.alibaba.com>
Date:   Tue, 28 Sep 2021 13:34:36 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpUuST2d0LZ5i7dqz=E1uL4Wiizf5WNbdJ=vc-9MR20SyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My bad... failed to get the notify, please ignore the noise.

Regards,
Michael Wang

On 2021/9/28 下午1:11, Cong Wang wrote:
> Hi,
> 
> It has been applied, no need to resend.
> 
> commit b193e15ac69d56f35e1d8e2b5d16cbd47764d053
> Author:     王贇 <yun.wang@linux.alibaba.com>
> AuthorDate: Fri Sep 24 10:35:58 2021 +0800
> Commit:     David S. Miller <davem@davemloft.net>
> CommitDate: Sun Sep 26 11:09:07 2021 +0100
> 
>     net: prevent user from passing illegal stab size
> 
> Thanks.
> 
