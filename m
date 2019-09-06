Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8806AB90A
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 15:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393130AbfIFNPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 09:15:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59972 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388106AbfIFNPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 09:15:09 -0400
Received: from localhost (unknown [88.214.184.128])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 78D8F152F5C9A;
        Fri,  6 Sep 2019 06:15:06 -0700 (PDT)
Date:   Fri, 06 Sep 2019 15:15:05 +0200 (CEST)
Message-Id: <20190906.151505.1486178691190611604.davem@davemloft.net>
To:     jasowang@redhat.com
Cc:     jgg@mellanox.com, mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, aarcange@redhat.com,
        jglisse@redhat.com, linux-mm@kvack.org
Subject: Re: [PATCH 0/2] Revert and rework on the metadata accelreation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7785d39b-b4e7-8165-516c-ee6a08ac9c4e@redhat.com>
References: <20190905122736.19768-1-jasowang@redhat.com>
        <20190905135907.GB6011@mellanox.com>
        <7785d39b-b4e7-8165-516c-ee6a08ac9c4e@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Sep 2019 06:15:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Fri, 6 Sep 2019 18:02:35 +0800

> On 2019/9/5 下午9:59, Jason Gunthorpe wrote:
>> I think you should apply the revert this cycle and rebase the other
>> patch for next..
>>
>> Jason
> 
> Yes, the plan is to revert in this release cycle.

Then you should reset patch #1 all by itself targetting 'net'.
