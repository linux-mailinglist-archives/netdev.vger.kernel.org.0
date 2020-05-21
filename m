Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003351DD6F5
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730121AbgEUTRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:17:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729475AbgEUTRL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 15:17:11 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DBD020738;
        Thu, 21 May 2020 19:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590088631;
        bh=4qnrRQ27oizGdgO+E+zxet1jvDwFXh83YpFO4yaaDAw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vyEkoDZWqJ+8FSdTFGj81+mwGYik3fgXZEPL9lMDwFKDRcTY6KLOSCD3+59IYyITo
         ued8anBAxVZnjRw62wMhDuK11IJBqEd5ebkQcrQ4wn6w4GsNuH1/9iVM3dKhrsw4X2
         cVuI9cn/jaf45xIYvNxPugmxPmCWvYQw+wq+4Sm4=
Date:   Thu, 21 May 2020 12:17:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH V2 net-next 0/2] net: hns3: adds two VLAN feature
Message-ID: <20200521121707.6499ca6b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1590061105-36478-1-git-send-email-tanhuazhong@huawei.com>
References: <1590061105-36478-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 May 2020 19:38:23 +0800 Huazhong Tan wrote:
> This patchset adds two new VLAN feature.
> 
> [patch 1] adds a new dynamic VLAN mode.
> [patch 2] adds support for 'QoS' field to PVID.
> 
> Change log:
> V1->V2: modifies [patch 1]'s commit log, suggested by Jakub Kicinski.

I don't like the idea that FW is choosing the driver behavior in a way
that's not observable via standard Linux APIs. This is the second time
a feature like that posted for a driver this week, and we should
discourage it.
