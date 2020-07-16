Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464E122194B
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 03:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgGPBJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 21:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgGPBJF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 21:09:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 840A820775;
        Thu, 16 Jul 2020 01:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594861744;
        bh=jYWsrjLkIFJZ1tP1W9LY+s0qv4XzPAQyh0d/e9ZotZE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fXquVxXErIaP5wvFvoVBxHT4PcEv9FPEO+gLmwhFsrVxKPQ2KI7dTBVlXqSUvIKg0
         I/LK62WqqC5YwjPF3n8bwhL9sderesD9hU3iC/vBK/PT+O05iH7J6owdXx7Sg7JfbI
         qXiWKEF5K8u3QdxjshYeF5h2myToy7AZ3LQIh/nI=
Date:   Wed, 15 Jul 2020 18:09:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
Subject: Re: [PATCH net-next v3] hinic: add firmware update support
Message-ID: <20200715180903.70455664@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200715073023.20240-1-luobin9@huawei.com>
References: <20200715073023.20240-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 15:30:23 +0800 Luo bin wrote:
> add support to update firmware by the devlink flashing API
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

Applied, thank you.
