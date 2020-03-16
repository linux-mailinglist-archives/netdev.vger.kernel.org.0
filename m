Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 217D6187532
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732737AbgCPV4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732636AbgCPV4S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 17:56:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36F5620719;
        Mon, 16 Mar 2020 21:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584395777;
        bh=OZR5Xd8iB+ZM7yXCOTP3bEuYN8Sf5wRXOma5K07r6JQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PdpUud8j6BW6rNkRerno5S7Idd8ZCaF5ihfJ3+/TrEWSPFFsOWtkV/TjubFAr4+Mq
         +idxNKS2v47l/mODmdcssXsEBcIP1li60eqXWM6xA5lBkp0AWilaEww65Jwp4SFAAe
         h4kbyHs2BScHe7NLwL7h1QbOOh/nE2emwQQhG9x0=
Date:   Mon, 16 Mar 2020 14:56:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <akiyano@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: Re: [PATCH V1 net 4/7] net: ena: remove code that does nothing
Message-ID: <20200316145615.238af848@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1584362304-274-5-git-send-email-akiyano@amazon.com>
References: <1584362304-274-1-git-send-email-akiyano@amazon.com>
        <1584362304-274-5-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Mar 2020 14:38:21 +0200 akiyano@amazon.com wrote:
> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> Both key and func parameters are pointers on the stack.
> Setting them to NULL does nothing.
> The original intent was to leave the key and func unset in this case,
> but for this to happen nothing needs to be done as the calling
> function ethtool_get_rxfh() already clears key and func.
> 
> This commit removes the above described useless code.
> 
> Fixes: 0c8923c0a64f ("net: ena: rss: fix failure to get indirection table")
> Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>

Why is this a fix?
