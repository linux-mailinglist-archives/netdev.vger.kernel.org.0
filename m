Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13552A74E0
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 02:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733176AbgKEBZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 20:25:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:59224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727536AbgKEBZi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 20:25:38 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D08BC206CB;
        Thu,  5 Nov 2020 01:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604539538;
        bh=qz4yYQPleYZbmYkefx6rykyEYB+BXcy5LdvQc/5RlZY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2O5lFPS2WLh5ugldP62GfCoVHycgJP13/7otcNEes96C4JFqtwJU4HHI0ycNldo0M
         rHAXQEGpCqJorLN/6FKbsiya/q17PP2uVVC6MkMKRPhnCdbCk1KLfItWDrIU+CDz4B
         GIMRADhmXuPevLY+baJDv86I+Hjv2VAV334TDI+c=
Date:   Wed, 4 Nov 2020 17:25:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     Zou Wei <zou_wei@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] dpaa_eth: use false and true for bool variables
Message-ID: <20201104172536.140caa93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <AM6PR04MB397628B89D6A10C973FF3162EC110@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <1604405100-33255-1-git-send-email-zou_wei@huawei.com>
        <AM6PR04MB397628B89D6A10C973FF3162EC110@AM6PR04MB3976.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 12:13:29 +0000 Madalin Bucur wrote:
> > Fix coccicheck warnings:
> > 
> > ./dpaa_eth.c:2549:2-22: WARNING: Assignment of 0/1 to bool variable
> > ./dpaa_eth.c:2562:2-22: WARNING: Assignment of 0/1 to bool variable
> > 
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Zou Wei <zou_wei@huawei.com>
> 
> Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>

Applied, thanks!
