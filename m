Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C5021A8DA
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgGIUXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:23:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbgGIUXO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 16:23:14 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EB9320720;
        Thu,  9 Jul 2020 20:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594326194;
        bh=d2HH2sCMfYdiHAR3XgX7+HdwNhr6+1f6WXjP3urtzbg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nz7zinD34/ubL7ctiV9MZxiASdMR7tIl4w3MaYgw4Q2f2WUvMJrwGkMF4oZp1W15d
         gOA053KhebT1u3r58M/IrL/wR1sfNE97vY9eodZh7n7SrdUmVJ4Gw9fouPb/kZl/gO
         E/a97CJ48YIuoEKqRKETY49aVl26DISuLzkgnZGQ=
Date:   Thu, 9 Jul 2020 13:23:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <akiyano@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: Re: [PATCH V1 net-next 6/8] net: ena: enable support of rss hash
 key and function changes
Message-ID: <20200709132311.63720a70@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1594321503-12256-7-git-send-email-akiyano@amazon.com>
References: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
        <1594321503-12256-7-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Jul 2020 22:05:01 +0300 akiyano@amazon.com wrote:
> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> Add the rss_configurable_function_key bit to driver_supported_feature.
> 
> This bit tells the device that the driver in question supports the
> retrieving and updating of RSS function and hash key, and therefore
> the device should allow RSS function and key manipulation.
> 
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>

Is this a fix of the previous patches? looks strange to just start
advertising a feature bit but not add any code..
