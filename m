Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD3D1B826B
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 01:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgDXXX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 19:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgDXXX1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 19:23:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31F0A214AF;
        Fri, 24 Apr 2020 23:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587770607;
        bh=RjkafEpEUlQYwXmiRYMLYyVW1y9J3/I8SnW+sAOLIww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HV8jmH/SAcHEHgDgQ60/GA2j/puMEj3tRbY/nBniFWjKcxufSx8NbpB7kOUd8Q80A
         i9w7c0QTzGN5M7+vTOFOfz+uEvLkPc0zCFXC/lRaw8+/zpC7/3+C2g7++l5tAecg7A
         owDeZ7Z1dveUZF4X/UAmHjUdDpDmxuqy30YW7WvY=
Date:   Fri, 24 Apr 2020 16:23:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH net-next 0/8] net: hns3: refactor for MAC table
Message-ID: <20200424162325.4547ce9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1587694993-25183-1-git-send-email-tanhuazhong@huawei.com>
References: <1587694993-25183-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Apr 2020 10:23:05 +0800 Huazhong Tan wrote:
> This patchset refactors the MAC table management, configure
> the MAC address asynchronously, instead of synchronously.
> Base on this change, it also refines the handle of promisc
> mode and filter table entries restoring after reset.

Looks like in patch 2 you could also remove the check if allocated_size
is NULL if there is only once caller ;) But that's a nit, series seems
okay:

Acked-by: Jakub Kicinski <kuba@kernel.org>
