Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF06625EBAB
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 01:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgIEXDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 19:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbgIEXDs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 19:03:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6E6B20760;
        Sat,  5 Sep 2020 23:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599347028;
        bh=TC37Jr9CH1SiN22R8yexzJg9Q1StKgezt2BQhpkmJJM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WHlDiCmwWwTb+kDUL362Bf49SPvh/jq7LLIfDLY3LSy/44KlgDQtR3S+VJuqUl8Ta
         QKoFv/fl9sC72jVdxIvkE/8q0Za3RIQLcnY+dm2JNirPoKqjIvUXK8niKgHsoW1y3I
         oi903j21yb8DoOrjo7xBAWjL6vb9BQ4rRk6KZNe4=
Date:   Sat, 5 Sep 2020 16:03:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     <davem@davemloft.net>, <gustavo@embeddedor.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] NFC: digital: Remove two unused macroes
Message-ID: <20200905160346.26d3d0f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200904130157.17812-1-wanghai38@huawei.com>
References: <20200904130157.17812-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Sep 2020 21:01:57 +0800 Wang Hai wrote:
> DIGITAL_NFC_DEP_REQ_RES_TAILROOM is never used after it was introduced.
> DIGITAL_NFC_DEP_REQ_RES_HEADROOM is no more used after below
> commit e8e7f4217564 ("NFC: digital: Remove useless call to skb_reserve()")
> Remove them.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Applied.
