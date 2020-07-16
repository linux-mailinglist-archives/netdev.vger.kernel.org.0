Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AA42226F2
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbgGPP1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:27:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728150AbgGPP1N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 11:27:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88F9A2065F;
        Thu, 16 Jul 2020 15:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594913232;
        bh=HF59HhfAxezQDwn4F6WlpCVWM4NEHEuz/Hbn96vSJQ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hHunC/3Bn6ikzPz93QBo3Z+rR5FUz50/isQUSN8mCNHNh9TcS0C9+yxAIsxnE2h7P
         gaWn02IWJg/nviHEUXNLwf4ho2qjSLAzAYOFPXf4BnOFmtjsIMGqMtOH4P4inF7W/0
         rRWASga/M7kzHPMJyegfS34x9OfELgicZ84sYJmo=
Date:   Thu, 16 Jul 2020 08:27:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
Subject: Re: [PATCH net-next 2/2] hinic: add log in exception handling
 processes
Message-ID: <20200716082710.22dd7c97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200716125056.27160-3-luobin9@huawei.com>
References: <20200716125056.27160-1-luobin9@huawei.com>
        <20200716125056.27160-3-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jul 2020 20:50:56 +0800 Luo bin wrote:
> improve the error message when functions return failure and dump
> relevant registers in some exception handling processes
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>

For kernel builds with W=1 C=1 flags this patch adds 12 warnings to
drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c and 39 warnings to 
drivers/net/ethernet/huawei/hinic/hinic_hw_if.h.

It seems like you're missing byte swaps.
