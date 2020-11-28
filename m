Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72CC2C7438
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbgK1Vtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbgK1Sv4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 13:51:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A9D6222B9;
        Sat, 28 Nov 2020 10:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606558101;
        bh=K/iIYj+kIGt+48i8IMDdZxcxyK8TswoGc81YwNkQpnM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hy8dxdqRBBL5x5Lxy4RkpGVDtTDX5vSodkX2Le+WmOhKv79wO0d3OA6eaU2U98gi2
         hyvcpDgdKBwm2WlrkvFBcVmQuEPLLWdqBU7tMZ3+eGsIxAnTA/6DLtRaievibnbC/V
         2Lp6RGDQMzTRVTfT93NvRgzOCPxPr0uSK/+wzYwM=
Date:   Sat, 28 Nov 2020 11:09:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?utf-8?B?5YiY5b+X5pet?= <liuzx@knownsec.com>
Cc:     Sasha Levin <sashal@kernel.org>, Florian Westphal <fw@strlen.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Edward Cree <ecree@solarflare.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [Patch stable] netfilter: clear skb->next in NF_HOOK_LIST()
Message-ID: <X8Ih2Ta1fVdj8+vy@kroah.com>
References: <20201121034317.577081-1-xiyou.wangcong@gmail.com>
 <20201121222249.GU15137@breakpoint.cc>
 <20201122172413.GG643756@sasha-vm>
 <tencent_6C31555D2B46173F013EA6CC@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_6C31555D2B46173F013EA6CC@qq.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 28, 2020 at 05:09:18PM +0800, 刘志旭 wrote:
> I still didn't see this patch in stable queue yet. Since we've a working POC to panic the&nbsp;
> system (see https://bugzilla.kernel.org/show_bug.cgi?id=209823), I think it's necessary
> to merge this patch ASAP, thanks.

Odd, I don't think Sasha pushed out his patch queue.  I've applied this
now, thanks.

greg k-h
