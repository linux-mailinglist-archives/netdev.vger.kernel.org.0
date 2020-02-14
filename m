Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A4515E501
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393897AbgBNQjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:39:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:59396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405572AbgBNQXQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:23:16 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 358AB24770;
        Fri, 14 Feb 2020 16:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697396;
        bh=tHBEN8NOq8IOs/1lnhrej7frLsU8zuE1qIkHE7AZWEw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=glsrI9FH9OojIbkuRHqUjCzu3nOZ8plBSN/xmVDkldPpMJn8CaoP6QWGM9wI8eFTN
         gqwwYXF/HKvPdRcMPQTethtM7bLAR/oCKzGCot4yuj+63JiYN0X/L8V2tW+TSYGWdZ
         /9NVYk04dqA9PWOJR2SskfXI5iWRyi2Cfc2gxTww=
Date:   Fri, 14 Feb 2020 08:23:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Taehee Yoo <ap420073@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 524/542] netdevsim: use __GFP_NOWARN to
 avoid memalloc warning
Message-ID: <20200214082314.0168201a@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20200214154854.6746-524-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
        <20200214154854.6746-524-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Feb 2020 10:48:36 -0500 Sasha Levin wrote:
> From: Taehee Yoo <ap420073@gmail.com>
> 
> [ Upstream commit 83cf4213bafc4e3c747f0a25ad22cfbf55af7e84 ]
> 
> vfnum buffer size and binary_len buffer size is received by user-space.
> So, this buffer size could be too large. If so, kmalloc will internally
> print a warning message.

Curious to see, I'm pretty sure Greg queued this yesterday.
