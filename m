Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93BCC179ADB
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 22:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388262AbgCDV0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 16:26:16 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46298 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgCDV0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 16:26:15 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C558715ABF01F;
        Wed,  4 Mar 2020 13:26:14 -0800 (PST)
Date:   Wed, 04 Mar 2020 13:26:11 -0800 (PST)
Message-Id: <20200304.132611.1082983925572874313.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     lesliemonis@gmail.com, netdev@vger.kernel.org,
        tahiliani@nitk.edu.in, gautamramk@gmail.com
Subject: Re: [PATCH net-next v2 0/4] pie: minor improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200304124917.0fbba371@kicinski-fedora-PC1C0HJN>
References: <20200304185602.2540-1-lesliemonis@gmail.com>
        <20200304124917.0fbba371@kicinski-fedora-PC1C0HJN>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Mar 2020 13:26:15 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 4 Mar 2020 12:49:17 -0800

> On Thu,  5 Mar 2020 00:25:58 +0530 Leslie Monis wrote:
>> This patch series includes the following minor changes with
>> respect to the PIE/FQ-PIE qdiscs:
>> 
>>  - Patch 1 removes some ambiguity by using the term "backlog"
>>            instead of "qlen" when referring to the queue length
>>            in bytes.
>>  - Patch 2 removes redundant type casting on two expressions.
>>  - Patch 3 removes the pie_vars->accu_prob_overflows variable
>>            without affecting the precision in calculations and
>>            makes the size of the pie_vars structure exactly 64
>>            bytes.
>>  - Patch 4 realigns a comment affected by a change in patch 3.
>> 
>> Changes from v1 to v2:
>>  - Kept 8 as the argument to prandom_bytes() instead of changing it
>>    to 7 as suggested by David Miller.
> 
> I was wondering if patch 3 changes make user-visible changes but it
> seems those should be only slight accuracy adjustments, so LGTM. FWIW:
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Series applied, thanks everyone.
