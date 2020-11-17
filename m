Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C342B6C90
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 19:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730591AbgKQSFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 13:05:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgKQSFs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 13:05:48 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 092332462E;
        Tue, 17 Nov 2020 18:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605636348;
        bh=7o4mQ4udJ8S+UBM7dBLJ4tJBI9T4gOmBJHCi70XyM8Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cpjxBcPjme+zkBvoBNQpYHlAsu9y3PZAIIVl7WWjNFXC7/oF6Th1mAf6ccLRKeuTF
         au24Klr7sGloUdIyS+BrWOwkAlNFvNa5/mssHOo94gW+JFJJn+HQM49Lh7BgaNaOfY
         lr4wfWioAOeEua5ySnHbBSKh7GkY050C7QBaVkFU=
Date:   Tue, 17 Nov 2020 10:05:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     <amitkarwar@gmail.com>, <siva8118@gmail.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] rsi_91x: fix error return code in rsi_reset_card()
Message-ID: <20201117100547.12ed38ee@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1605582454-39649-1-git-send-email-zhangchangzhong@huawei.com>
References: <1605582454-39649-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 11:07:34 +0800 Zhang Changzhong wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: 17ff2c794f39 ("rsi: reset device changes for 9116")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

FWIW please try to tag driver/net/wireless with [PATCH wireless],
Kalle will be taking those via the wireless drivers tree.
