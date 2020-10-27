Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1220129A34D
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 04:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443692AbgJ0D1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 23:27:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439504AbgJ0D1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 23:27:44 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DD042072E;
        Tue, 27 Oct 2020 03:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603769264;
        bh=Hapa08REslWlehDmAK3eEhf8UVGF9csOzrCzRD8cSC0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2MkBZ7XEnG8/d4v9jPoGR2YK6bL8dbNSUqgHdgUANrgOajiGC0NyNPCAQcyDiqCyu
         5Kqc01TLrG1TumWp29ORXjbbfrPwOAda+9T90d00bLqCnVrB0wA8DijChoiJcF4wH1
         oFWjCaiCgA7i2LCJFxHbcPmpJtVkehgTMemu7agk=
Date:   Mon, 26 Oct 2020 20:27:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Zenghui Yu <yuzenghui@huawei.com>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wanghaibin.wang@huawei.com>, <tanhuazhong@huawei.com>
Subject: Re: [PATCH net] net: hns3: Clear the CMDQ registers before
 unmapping BAR region
Message-ID: <20201026202742.3bbdfae8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <416bed1a-ce64-d326-3a7a-a8c8258c0bac@huawei.com>
References: <20201023051550.793-1-yuzenghui@huawei.com>
        <3c5c98f9-b4a0-69a2-d58d-bfef977c68ad@huawei.com>
        <e74f0a72-92d1-2ac9-1f4b-191477d673ef@huawei.com>
        <20201026161325.6f33d9c8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <bca7fb17-2390-7ff3-d62d-fe279af6a225@huawei.com>
        <20201026182557.43dcb486@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <416bed1a-ce64-d326-3a7a-a8c8258c0bac@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 09:42:01 +0800 Yunsheng Lin wrote:
> On 2020/10/27 9:25, Jakub Kicinski wrote:
> > On Tue, 27 Oct 2020 09:24:10 +0800 Yunsheng Lin wrote:  
> >>> Fixes: 862d969a3a4d ("net: hns3: do VF's pci re-initialization while PF doing FLR")    
> >>
> >> The correct Fixes tag should be:
> >>
> >> Fixes: e3338205f0c7 ("net: hns3: uninitialize pci in the hclgevf_uninit")  
> > 
> > Why is that?
> > 
> > Isn't the issue the order of cmd vs pci calls? e3338205f0c7 only takes
> > the pci call from under an if, the order was wrong before.  
> 
> You are right, the e3338205f0c7 only add the missing hclgevf_pci_uninit()
> when HCLGEVF_STATE_IRQ_INITED is not set.
> 
> So I think the tag you provided is correct, thanks.

Great, added the tag and applied, thanks!
