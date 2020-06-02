Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F323F1EBFE4
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 18:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgFBQXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 12:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgFBQXf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 12:23:35 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 949312067B;
        Tue,  2 Jun 2020 16:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591115015;
        bh=l+upT3zNHX1qOiTFn9tTGFJptMpSCriS2MkzAldyRtc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pDDIfivmU498g+Eu8MjggbQXa7lz0c+cq0Pkw9ty0LPKWpayjzjgoxbxIM8sAROBd
         8N7FL/tjTEPLF+ixcP4khCYFvUDFAfea5B4+MmhVhMSvr/LLpUtmWYmoR6R+NYS35T
         Y0S0TKe3M+mQ9gVCVhTk2KnR+8L8COaqeb2fAM5w=
Date:   Tue, 2 Jun 2020 09:23:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <sameehj@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: Re: [PATCH V1 net 0/2] Fix xdp in ena driver
Message-ID: <20200602092333.53d88bb5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200602132151.366-1-sameehj@amazon.com>
References: <20200602132151.366-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Jun 2020 13:21:49 +0000 sameehj@amazon.com wrote:
> From: Sameeh Jubran <sameehj@amazon.com>
> 
> This patchset includes 2 XDP related bug fixes.

Both of them have this problem

Fixes tag: Fixes: cad451dd2427 ("net: ena: Implement XDP_TX action")
Has these problem(s):
	- Subject does not match target commit subject
	  Just use
		git log -1 --format='Fixes: %h ("%s")'
