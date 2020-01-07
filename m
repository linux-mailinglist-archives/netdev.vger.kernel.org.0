Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4AB7131D8E
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 03:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbgAGCXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 21:23:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57152 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbgAGCXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 21:23:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 06F32159E228D;
        Mon,  6 Jan 2020 18:23:01 -0800 (PST)
Date:   Mon, 06 Jan 2020 18:22:59 -0800 (PST)
Message-Id: <20200106.182259.1907306689510314367.davem@davemloft.net>
To:     Jiping.Ma2@windriver.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stmmac: debugfs entry name is not be changed when udev
 rename device name.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <15aedd71-e077-4c6c-e30c-9396d16eaeec@windriver.com>
References: <20200106023341.206459-1-jiping.ma2@windriver.com>
        <20200106.134557.2214546621758238890.davem@redhat.com>
        <15aedd71-e077-4c6c-e30c-9396d16eaeec@windriver.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jan 2020 18:23:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiping Ma <Jiping.Ma2@windriver.com>
Date: Tue, 7 Jan 2020 09:00:53 +0800

> 
> 
> On 01/07/2020 05:45 AM, David Miller wrote:
>> From: Jiping Ma <jiping.ma2@windriver.com>
>> Date: Mon, 6 Jan 2020 10:33:41 +0800
>>
>>> Add one notifier for udev changes net device name.
>>>
>>> Signed-off-by: Jiping Ma <jiping.ma2@windriver.com>
>> This doesn't apply to 'net' and since this is a bug fix that is where
>> you should target this change.
> What's the next step that I can do?

Respin your patch against the net GIT tree so that it applies clean.y
