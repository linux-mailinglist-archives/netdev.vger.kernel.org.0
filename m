Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE562D8470
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 05:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436773AbgLLERQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 23:17:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:48244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732226AbgLLEQw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 23:16:52 -0500
Date:   Fri, 11 Dec 2020 20:16:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607746571;
        bh=q0KcmtdEpJjrwcIUnyXZpE1+qAC1yYcyiqW9AOD2aX4=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Njr63/Mo0T4LINkkGDyUHPlXV8s7uZ1mqNoWNmWHwBNpD5aKckYHSwrJgWl2asQAL
         rfKORS5SsWMP/Pj4rKQfy6buid4GOLBqfvIW6AzXu3naAebWy81XABZ6GxUJ8V5V1h
         jvShKtGilm6424nD5tHqjOg1lyKwPFKdXgNbVKCIYAn6433Fv98I88kqJL3i/ELPZ5
         vIJy9EFQpDHMnYIZUWueXPmwllwS2tf74x1+qPSXPucQbsU311KIu50R/qryphbQfI
         yf/bwO09Qp41RFoGrnH5zW24hFGcWfY1fDJtD0Aq8Q0/Xf3UQ/ddyGzWlnjST3y8sp
         eVsZ3aCDYs2JA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sagis@google.com>,
        <jonolson@google.com>
Subject: Re: [PATCH net-next] gve: simplify the gve code return expression
Message-ID: <20201211201610.4e63dd55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201211083706.1565-1-zhengyongjun3@huawei.com>
References: <20201211083706.1565-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 16:37:06 +0800 Zheng Yongjun wrote:
> Simplify the return expression at diffrent gve_adminq.c file, simplify this all.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Does not apply, please rebase.
