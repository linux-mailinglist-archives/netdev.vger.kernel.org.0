Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1BF3337F41
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhCKUtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:49:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230341AbhCKUtV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 15:49:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 356EB64F71;
        Thu, 11 Mar 2021 20:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615495760;
        bh=r4A2Uzhk2S5JokDfrqWNxGxFkKNP7opY72lXYvkjXYc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PyG5lIDcHw9Rb1ex4L2Y3kMvfLWXe3l6/BdrVVROOdMK/klmUWAaZirgZ0ijkvdWB
         hGbM5m5aDi73dYQ0sZX6952mJzfgpE0I6O6Xlwt4JEEKG8mS8SkUfxxWxbyOVVAs6i
         uxBLD7dh19W6tdJAZ6zViavb+7U7lzFiZhlyqc4fBFmFc5YDLd+rnSuMQDeA7mtCGI
         zQ8IXLUaOburDsS+E6Z/b/FTRLNI84/auJRsqFjHzHB5lPRsVw4nfTDb6uqSzrwSy4
         nMcKmgeoGTOdCWK2H2Oz54/o1tmSnqbOT7KeeM/sivvujtFVS9vg9pAzNuIgIAikON
         H7J9CPK96D6wQ==
Date:   Thu, 11 Mar 2021 12:49:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>
Subject: Re: [PATCH net-next 0/2] net: hns3: two updates for -next
Message-ID: <20210311124918.263ddd0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1615428852-2637-1-git-send-email-tanhuazhong@huawei.com>
References: <1615428852-2637-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Mar 2021 10:14:10 +0800 Huazhong Tan wrote:
> This series includes two updates for the HNS3 ethernet driver.

Acked-by: Jakub Kicinski <kuba@kernel.org>
