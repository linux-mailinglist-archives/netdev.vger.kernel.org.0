Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0EED8FA4A
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 07:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfHPFRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 01:17:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55940 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfHPFRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 01:17:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 319A5133F18A3;
        Thu, 15 Aug 2019 22:17:52 -0700 (PDT)
Date:   Thu, 15 Aug 2019 22:17:49 -0700 (PDT)
Message-Id: <20190815.221749.1827065487915332350.davem@davemloft.net>
To:     hayeswang@realtek.com
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8152: divide the tx and rx bottom functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2F18D43A3@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-301-Taiwan-albertk@realtek.com>
        <20190815.135851.1942927063321516679.davem@davemloft.net>
        <0835B3720019904CB8F7AA43166CEEB2F18D43A3@RTITMBSVM03.realtek.com.tw>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 22:17:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 16 Aug 2019 02:59:16 +0000

> David Miller [mailto:davem@davemloft.net]
>> Sent: Friday, August 16, 2019 4:59 AM
> [...]
>> Theoretically, yes.
>> 
>> But do you have actual performance numbers showing this to be worth
>> the change?
>> 
>> Always provide performance numbers with changes that are supposed to
>> improve performance.
> 
> On x86, they are almost the same.
> Tx/Rx: 943/943 Mbits/sec -> 945/944
> 
> For arm platform,
> Tx/Rx: 917/917 Mbits/sec -> 933/933
> Improve about 1.74%.

Belongs in the commit message.
