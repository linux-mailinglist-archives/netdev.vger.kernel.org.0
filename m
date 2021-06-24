Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9023B36F2
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 21:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhFXT1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 15:27:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232761AbhFXT1i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 15:27:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D6446120D;
        Thu, 24 Jun 2021 19:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624562719;
        bh=CwkdQfxM87pFck5WZQl+d+3M/hBoii1QI7y9yJq/eyw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JgSMFh32CqDR5YG/qgrE1rI2U3L/Qwd9hU+dY5uhxxoVJQ2ZbEvLFFnbkKFn5EBhT
         Q5SNlzG0RRCWW4fMZP1sYLyt8/aLmQsm3baBS6qkghxb1wUODGcEwG1HlhScjYZPqj
         ef7Yd/zMy7iG7HscuDEWS++27S/85Y9qLER9Iqr7e/keXrhyATtcq8TGRszcKrh/N5
         wZIlBp6fueFTEBWVaq0U3SG4R//nKXo7x6x+sXb+hyg4xoD3inXSMHp3Sv2u1aCk5V
         N9I/txpjSbXW79BYi1bkdBxJWfCBhIp+MgzJnCY8Ti9jjgDCIB5Q9V2Zt73QGNJ2V7
         1MsWGjnH/Oqqw==
Date:   Thu, 24 Jun 2021 12:25:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <lipeng321@huawei.com>
Subject: Re: [PATCH net-next 3/3] net: hns3: add support for link diagnosis
 info in debugfs
Message-ID: <20210624122517.7c8cb329@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1624545405-37050-4-git-send-email-huangguangbin2@huawei.com>
References: <1624545405-37050-1-git-send-email-huangguangbin2@huawei.com>
        <1624545405-37050-4-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Jun 2021 22:36:45 +0800 Guangbin Huang wrote:
> In order to know reason why link down, add a debugfs file
> "link_diagnosis_info" to get link faults from firmware, and each bit
> represents one kind of fault.
> 
> usage example:
> $ cat link_diagnosis_info
> Reference clock lost

Please use ethtool->get_link_ext_state instead.
