Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459FC25C94A
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 21:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgICTTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 15:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728304AbgICTTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 15:19:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB2DC061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 12:19:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8823A15C9D862;
        Thu,  3 Sep 2020 12:02:36 -0700 (PDT)
Date:   Thu, 03 Sep 2020 12:19:22 -0700 (PDT)
Message-Id: <20200903.121922.1139193852592250784.davem@davemloft.net>
To:     jchapman@katalix.com
Cc:     tparkin@katalix.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] l2tp: miscellaneous cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <655103fe-6881-1122-bbcb-62c59af2b102@katalix.com>
References: <20200903085452.9487-1-tparkin@katalix.com>
        <655103fe-6881-1122-bbcb-62c59af2b102@katalix.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 03 Sep 2020 12:02:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: James Chapman <jchapman@katalix.com>
Date: Thu, 3 Sep 2020 14:39:30 +0100

> On 03/09/2020 09:54, Tom Parkin wrote:
>> This series of patches makes the following cleanups and improvements to
>> the l2tp code:
>>  
>>  * various API tweaks to remove unused parameters from function calls
>>  * lightly refactor the l2tp transmission path to capture more error
>>    conditions in the data plane statistics
>>  * repurpose the "magic feather" validation in l2tp to check for
>>    sk_user_data (ab)use as opposed to refcount debugging
>>  * remove some duplicated code
 ...
> Reviewed-by: James Chapman <jchapman@katalix.com>

Series applied, thanks everyone.
