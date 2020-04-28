Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126841BCC0A
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 21:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbgD1TEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 15:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728539AbgD1TEq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 15:04:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 543C7206A1;
        Tue, 28 Apr 2020 19:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588100686;
        bh=wOY1lzHrygU4YuLLZoxHEFspmB2HHj/GBQD7CeIi6+M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0gnl6WNqF0sz7P7p1kNzfO4ntW3VOCu9rVqgncSaIlBYLLYScHlzKb5V/DbRfIfLL
         uhE/G/pO0Lbk246vlOnvMKLngE7mc4vXw4KfBvFEZ4eJrvPQ1HczMQdnJ516BTpEt1
         febIrNXjMmB1DbntfOr/pOvbF8LRISl/FhabSSdM=
Date:   Tue, 28 Apr 2020 12:04:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <sameehj@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>,
        Igor Chauskin <igorch@amazon.com>
Subject: Re: [PATCH V2 net-next 09/13] net: ena: implement
 ena_com_get_admin_polling_mode()
Message-ID: <20200428120443.09c4931f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200428072726.22247-10-sameehj@amazon.com>
References: <20200428072726.22247-1-sameehj@amazon.com>
        <20200428072726.22247-10-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Apr 2020 07:27:22 +0000 sameehj@amazon.com wrote:
> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> Before this commit there was a function prototype named
> ena_com_get_ena_admin_polling_mode() that was never implemented.
> 
> This commit:
> 1. Changes the name of the function by removing the redundant double "ena_" in it.
> 2. Adds an implementation to the function.
> 3. Fixes a typo in the description of the function.
> 
> Signed-off-by: Igor Chauskin <igorch@amazon.com>
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>

Doesn't look like this function is called upstream, though.

You should just remove it.
