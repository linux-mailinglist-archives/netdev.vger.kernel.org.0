Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087961458EA
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 16:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgAVPmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 10:42:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgAVPmF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 10:42:05 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ECD7217F4;
        Wed, 22 Jan 2020 15:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579707724;
        bh=Sp347QtjZN1Z0zySpBaOxoH6I8NgHQVnUNe7iuXyDSU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IM0KM0ZCEcrcZEhz3iIaZUbZLx3toaC1RMNDiKzU90kuhmeB9p7UIUPDofbbpZ1ms
         vYtAi+wGfkEdM20PVC58qS0T4XyCBY3RHZsEr7kxrzcM9fMZoWZFfeBaK7E76SdWV7
         GBuJjVgwmwDUbU10petg8lO2gcOF/zralhqWCncg=
Date:   Wed, 22 Jan 2020 07:42:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     gautamramk@gmail.com
Cc:     netdev@vger.kernel.org,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Sachin D . Patil" <sdp.sachin@gmail.com>,
        "V . Saicharan" <vsaicharan1998@gmail.com>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>
Subject: Re: [PATCH net-next v6 10/10] net: sched: add Flow Queue PIE packet
 scheduler
Message-ID: <20200122074203.00566700@cakuba>
In-Reply-To: <20200122113533.28128-11-gautamramk@gmail.com>
References: <20200122113533.28128-1-gautamramk@gmail.com>
        <20200122113533.28128-11-gautamramk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jan 2020 17:05:33 +0530, gautamramk@gmail.com wrote:
> +	err = tcf_block_get(&q->block, &q->filter_list, sch, extack);
> +	if (err)
> +		goto init_failure;

I think you're missing a tcf_block_put() call or equivalent.
