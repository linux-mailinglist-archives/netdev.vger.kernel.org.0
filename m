Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0141DF0EB
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731081AbgEVVIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731025AbgEVVIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 17:08:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1078C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 14:08:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6671E123C0675;
        Fri, 22 May 2020 14:08:43 -0700 (PDT)
Date:   Fri, 22 May 2020 14:08:42 -0700 (PDT)
Message-Id: <20200522.140842.2220492664724501714.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     irusskikh@marvell.com, mstarovoitov@marvell.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 00/12] net: atlantic: QoS implementation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200522105857.759e7589@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200522081948.167-1-irusskikh@marvell.com>
        <20200522105857.759e7589@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 14:08:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 22 May 2020 10:58:57 -0700

> On Fri, 22 May 2020 11:19:36 +0300 Igor Russkikh wrote:
>> This patch series adds support for mqprio rate limiters and multi-TC:
>>  * max_rate is supported on both A1 and A2;
>>  * min_rate is supported on A2 only;
>> 
>> This is a joint work of Mark and Dmitry.
>> 
>> To implement this feature, a couple of rearrangements and code
>> improvements were done, in areas of TC/ring management, allocation
>> control, etc.
>> 
>> One of the problems we faced is conflicting ptp functionality, which
>> consumes a whole traffic class due to hardware limitations.
>> Patches below have a more detailed description on how PTP and multi-TC
>> co-exist right now.
>> 
>> v2:
>>  * accommodated review comments (-Wmissing-prototypes and
>>    -Wunused-but-set-variable findings);
>>  * added user notification in case of conflicting multi-TC<->PTP
>>    configuration;
>>  * added automatic PTP disabling, if a conflicting configuration is
>>    detected;
>>  * removed module param, which was used for PTP disabling in v1;
>> 
>> v1: https://patchwork.ozlabs.org/cover/1294380/
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Series applied, thanks everyone.
