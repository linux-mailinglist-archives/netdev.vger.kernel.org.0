Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE952AE5C7
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 02:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732427AbgKKBU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 20:20:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:57414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732023AbgKKBU5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 20:20:57 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DA23221F7;
        Wed, 11 Nov 2020 01:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605057657;
        bh=2IFauiL6HwogucNNRrZFTFm6Fj9WFjJpz/10yTF/PAI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=v9nk2lJjZunSPzACR8fgfzA2upvDu2aIZE3sL+GBZCuecVk3eBA0LSyzWd97Plo9I
         zPvvYwJZmANbG9UuJMQFPILrzyYe7yyyBlJZu3W1jNs5ZNiQfWbPgf7tsajnKSxr6d
         Fu1u82uqX//ktG3Dfql04iqUSd9E6bhLm8TycUkU=
Date:   Tue, 10 Nov 2020 17:20:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH V2 net-next 05/11] net: hns3: add support for dynamic
 interrupt moderation
Message-ID: <20201110172055.27ab308f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604892159-19990-6-git-send-email-tanhuazhong@huawei.com>
References: <1604892159-19990-1-git-send-email-tanhuazhong@huawei.com>
        <1604892159-19990-6-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 11:22:33 +0800 Huazhong Tan wrote:
> Add dynamic interrupt moderation support for the HNS3 driver.
> 
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

I'm slightly confused here. What does the adaptive moderation do in
your driver/device if you still need DIM on top of it?
