Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9030184E52
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 19:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgCMSFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 14:05:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43468 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgCMSFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 14:05:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 32C42159D1390;
        Fri, 13 Mar 2020 11:05:45 -0700 (PDT)
Date:   Fri, 13 Mar 2020 11:05:42 -0700 (PDT)
Message-Id: <20200313.110542.570427563998639331.davem@davemloft.net>
To:     kyk.segfault@gmail.com
Cc:     willemdebruijn.kernel@gmail.com, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, David.Laight@aculab.com
Subject: Re: [PATCH v2] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CABGOaVTzjJengG0e8AWFZE9ZG1245keuQHfRJ0zpoAMQrNmJ6g@mail.gmail.com>
References: <91fafe40-7856-8b22-c279-55df5d06ca39@gmail.com>
        <e8b84bcaee634b53bee797aa041824a4@AcuMS.aculab.com>
        <CABGOaVTzjJengG0e8AWFZE9ZG1245keuQHfRJ0zpoAMQrNmJ6g@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Mar 2020 11:05:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yadu Kishore <kyk.segfault@gmail.com>
Date: Fri, 13 Mar 2020 12:06:34 +0530

>> Yes, given the discussion I have no objections. The change to
>> skb_segment in v2 look fine.
> 
> I'm assuming that the changes in patch V2 are ok to be accepted and merged
> to the kernel. Please let me know if there is anything else that is pending
> from my side with respect to the patch.

If your patch isn't active in the networking development patchwork instance,
it is not pending to be applied and you must resend it.
