Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50C02E208D
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 19:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgLWSo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 13:44:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:50044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727093AbgLWSo2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 13:44:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11948217A0;
        Wed, 23 Dec 2020 18:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608749028;
        bh=Yw4YuXV2PR9Z9ldOFm4X+Z2605fR7rxNqfAcSLMGoiY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pGABDBh4x9M6PqytNW2nX8hbjc1VYcFB1j62rc20zP14AIXMDuGR7DyVTKA3vigSW
         44N+PmaKbXSmvRbNSKElK8QvZyy95Wi3gCcKIMqShnwKSSQYynvHZm6IR23yqsrV3B
         EgQ/QuZpCPe2q4EVYREUjOZk9B0c3hSabZ/9tiTuXFPFZfLWB5GihRRTl2W3C+RHLv
         yGl03/4Iqykpc7ODHoe6rEyKkRVzGX8Qzc+MO7exU93mypVdRFatkzatezSio4yNFg
         rtnQnPBaitBxNfzHjHB+3ESo2cs15vsHWY0aIVvaYgUH126letstS1NTr5RvZLlh4m
         YEi2hC15UDUcA==
Date:   Wed, 23 Dec 2020 10:43:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <jmaloy@redhat.com>, <ying.xue@windriver.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <tipc-discussion@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: tipc: Replace expression with offsetof()
Message-ID: <20201223104347.4f50ebd6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201222133407.19861-1-zhengyongjun3@huawei.com>
References: <20201222133407.19861-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Dec 2020 21:34:07 +0800 Zheng Yongjun wrote:
> Use the existing offsetof() macro instead of duplicating code.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

# Form letter - net-next is closed

We have already sent the networking pull request for 5.11 and therefore
net-next is closed for new drivers, features, code refactoring and
optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after 5.11-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
