Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2D71CCFDE
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 04:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgEKCrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 22:47:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbgEKCrS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 22:47:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A80392137B;
        Mon, 11 May 2020 02:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589165237;
        bh=A8Aw6FLd0vKcpfh3qqO/MhXEY70d/r0kw+hzhcCgnfw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X7lMBG5ZyCyn2BTwG0FzhPjqsWYaemZPK5yTD77hHZWN5i0X9nFo1DKjYFtTEkNrg
         /V+qAbHEetAFigl7hyN+4YzoUMXevpvdFgbS/9+Md6kOdrTaQs7HQ/yXx+TiYyzpyQ
         rGBT+o4C7fHeuWHoCz1uY1VBsWGgSENp2fFw4lP4=
Date:   Sun, 10 May 2020 19:47:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH net-next 0/5] net: hns3: misc updates for -next
Message-ID: <20200510194716.766a513d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1589016461-10130-1-git-send-email-tanhuazhong@huawei.com>
References: <1589016461-10130-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 May 2020 17:27:36 +0800 Huazhong Tan wrote:
> This patchset includes some misc updates for the HNS3 ethernet driver.
> 
> #1 & #2 add two cleanups.
> #3 provides an interface for the client to query the CMDQ's status.
> #4 adds a little optimization about debugfs.
> #5 prevents 1000M auto-negotiation off setting.

Applied, thank you!
