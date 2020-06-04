Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3061EDB93
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 05:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgFDDMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 23:12:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgFDDMn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 23:12:43 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 830DE20772;
        Thu,  4 Jun 2020 03:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591240363;
        bh=2IwBZn4wgZefzrbrDDXJ1RWmMwjpIWajHNf915KGOvY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eN2qIgyQsA42Yax2xXhvcJI4/Xh18zFX8H8VC9zdL7dikFyyDQoamXwWUNzNDtwS4
         8wAnxgKFn5b3ppnhniE6U+91Pa85bAGq6tBEPmAAG0U+5DeqZfCm6vL2Hy8aSrKK77
         fyYf+ZMGG+XvM6D+eGIpgqQN1VkMgtm26BrcFv2o=
Date:   Wed, 3 Jun 2020 20:12:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <sameehj@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: Re: [PATCH V2 net 0/2] Fix xdp in ena driver
Message-ID: <20200603201241.6372bc41@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200603085023.24221-1-sameehj@amazon.com>
References: <20200603085023.24221-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Jun 2020 08:50:21 +0000 sameehj@amazon.com wrote:
> From: Sameeh Jubran <sameehj@amazon.com>
> 
> This patchset includes 2 XDP related bug fixes

All clean now :)

Acked-by: Jakub Kicinski <kuba@kernel.org>
