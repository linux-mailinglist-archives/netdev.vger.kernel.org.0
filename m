Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E372927045D
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 20:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgIRSuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 14:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgIRSuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 14:50:07 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9D3221534;
        Fri, 18 Sep 2020 18:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600455007;
        bh=C04hKHpfXxZc3qVlnTUSdheD+XdxjQOSmX6QKSVP5+A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=y0yJpiD8foQUCxal6D6CxYqfHAlGEn3zfiiHs0QheN2xoUhgctjoFuX+wiCUlh4N1
         qpBanAs/FPN7TWFfTlB+rBaG7TRIkpB1E7r7jR7pdx9AFu3V/buyjxfHEcgn7seGlW
         UZG6eglazP5Ifhq2moFK1X6HHgD/KGdyCskNX8n4=
Message-ID: <163953ee9704adb6963be1222b8037a3109ae71b.camel@kernel.org>
Subject: Re: [PATCH net-next] hinic: modify irq name
From:   Saeed Mahameed <saeed@kernel.org>
To:     Luo bin <luobin9@huawei.com>, davem@davemloft.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com, chiqijun@huawei.com,
        zengweiliang.zengweiliang@huawei.com
Date:   Fri, 18 Sep 2020 11:50:05 -0700
In-Reply-To: <20200918092322.3058-1-luobin9@huawei.com>
References: <20200918092322.3058-1-luobin9@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-09-18 at 17:23 +0800, Luo bin wrote:
> Make a distinction between different irqs by netdev name or pci name.
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>
> ---
> 

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>


