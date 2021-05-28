Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9E2394840
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 23:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhE1VUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 17:20:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbhE1VUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 17:20:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97ED5613B4;
        Fri, 28 May 2021 21:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622236746;
        bh=DAYzrFwNqMbaFaEZEpuYmq/HDRj3pLgr2A1vlHoUJkA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cJapOeOi6ZserwokvdjCQZMMAUuMzvOTyekdqalV4Ik6wFoyaFi6xb+0pXMGTcp02
         bqvqnyhlG30mOIi2plZYMKWBp2p2paRE/4YPtQANgR4bqvasApNNoPQF1bW9Ms4ghx
         59eu6y/h6aXFak0sAl1bNzTNXIMS1znQarblFcaQxWP6vra6NTM0eWRkGaks283EZI
         L0oIW6dyNwtFEmXamcEtfr+kjtotr1So3LAL7EJBSmvcWVBBVjtq7JGkqQ3gBGahOW
         86ia5oMNtun+LsuMxO54z2OFE3LjXV6r6+mrVLBGv6usZzFq0gaoe+/iR9KMkI5wM4
         vZ1y5ZqbVuD+g==
Date:   Fri, 28 May 2021 14:19:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>, <davem@davemloft.net>
Subject: Re: [PATCH -next 1/2] net: dsa: qca8k: check return value of read
 functions correctly
Message-ID: <20210528141905.2cd83f81@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210528082240.3863991-2-yangyingliang@huawei.com>
References: <20210528082240.3863991-1-yangyingliang@huawei.com>
        <20210528082240.3863991-2-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 16:22:39 +0800 Yang Yingliang wrote:
> @@ -1793,14 +1783,15 @@ static int qca8k_read_switch_id(struct qca8k_priv *priv)
>  	const struct qca8k_match_data *data;
>  	u32 val;
>  	u8 id;
> +	int ret;

ret before id to keep the reverse xmas tree ordering
