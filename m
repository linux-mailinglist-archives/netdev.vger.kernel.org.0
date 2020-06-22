Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2906720421C
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 22:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbgFVUor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 16:44:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728421AbgFVUor (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 16:44:47 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 741D62076A;
        Mon, 22 Jun 2020 20:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592858686;
        bh=kS6Uoybp+uv0rgW5ZPADRgzJ/JhDOOrsBOC9xmxRys8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XmS8lT0PlQFUncpet6RPPNKJiTytxgchIQppj2jc87hagFVBEo+8Ql/sDjA93gw2V
         xppXiWF4HGNFdnANH9VrVtroo6KHFOiae3pLMuLElLUvR+1kWmdgBhcC1GTEZDN2mH
         Yikpwe2t+9MOfh2+wE9RxWptGDpvy8zmZqVX78Qk=
Date:   Mon, 22 Jun 2020 13:44:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Li Heng <liheng40@huawei.com>
Cc:     <vishal@chelsio.com>, <davem@davemloft.net>,
        <hariprasad@chelsio.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] net: cxgb4: fix return error value in t4_prep_fw
Message-ID: <20200622134444.78f3fd74@kicinski-fedora-PC1C0HJN>
In-Reply-To: <1592621361-39925-1-git-send-email-liheng40@huawei.com>
References: <1592621361-39925-1-git-send-email-liheng40@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Jun 2020 10:49:21 +0800 Li Heng wrote:
> t4_prep_fw goto bye tag with positive return value when something
> bad happened and which can not free resource in adap_init0.
> so fix it to return negative value.
> 
> Fixes: 16e47624e76b ("cxgb4: Add new scheme to update T4/T5 firmware")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Li Heng <liheng40@huawei.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

I don't remember signing off on this..


