Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0071E4E28
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 21:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgE0Tae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 15:30:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgE0Tad (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 15:30:33 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CAE320723;
        Wed, 27 May 2020 19:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590607833;
        bh=yB3E8aqzW3OvKuaG42APyedRVwI1AwVLwI54ZqxWZvw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RPokBkyI2Dkc0L+na1ltgQA27uvepDoIrOcyYJirgyJJRP8hwlu+ZG7XPrD9/LoK8
         /wzB75ReeiPnHEXoLy8hiQu+DtlGR5U+HR4858RwVEBfHHmlv/gwjYhyI/vCoa1kjz
         1FDnFPXbCtvjHZ8CvcCfVyqJT3TNUTYnsyEI6yQI=
Date:   Wed, 27 May 2020 12:30:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     tanhuazhong <tanhuazhong@huawei.com>
Cc:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH V2 net-next 0/2] net: hns3: adds two VLAN feature
Message-ID: <20200527123031.7fd4834d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <356be994-7cf9-e7b2-8992-46a70bc6a54b@huawei.com>
References: <1590061105-36478-1-git-send-email-tanhuazhong@huawei.com>
        <20200521121707.6499ca6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200521.143726.481524442371246082.davem@davemloft.net>
        <cb427604-05ee-504c-03d0-fcce16b3cfcc@huawei.com>
        <356be994-7cf9-e7b2-8992-46a70bc6a54b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 May 2020 10:31:59 +0800 tanhuazhong wrote:
> Hi, Jakub & David.
> 
> For patch#1, is it acceptable adding "ethtool --get-priv-flags"
> to query the VLAN. If yes, I will send a RFC for it.

The recommended way of implementing vfs with advanced vlan
configurations is via "switchdev mode" & representors.
