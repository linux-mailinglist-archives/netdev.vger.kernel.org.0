Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5CD1DEE6B
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 19:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730772AbgEVRjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 13:39:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730720AbgEVRjK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 13:39:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D75A20756;
        Fri, 22 May 2020 17:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590169149;
        bh=RRhumbpcXuP6sfYkFPLXxlQCEq9VlFfm+mydeGn9aho=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JVI1Pqcr+F/6/5sNrTQWxtzkb/EpjwA50vIt4rKfOQ4uCHLBS10fzJ2WFfOP3q0Cv
         0m/CdlgjC2u5bRzq+Sg5bj43w88O/ckKB/qIYUKY6AEQmJL3KCIJE5WjIdE7BJcPpJ
         hYq/dzw7+TZB002FyO7jIFKg/Tl+QYoWKbWmw9MY=
Date:   Fri, 22 May 2020 10:39:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>
Subject: Re: [PATCH net-next 1/5] net: hns3: add support for VF to query
 ring and vector mapping
Message-ID: <20200522103907.2eec2b6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1590115786-9940-2-git-send-email-tanhuazhong@huawei.com>
References: <1590115786-9940-1-git-send-email-tanhuazhong@huawei.com>
        <1590115786-9940-2-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 May 2020 10:49:42 +0800 Huazhong Tan wrote:
> From: Guangbin Huang <huangguangbin2@huawei.com>
> 
> This patch adds support for VF to query the mapping of ring and
> vector.
> 
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

Could you explain a little more what this is doing?

Also what's using this? In the series nothing is making this request.
