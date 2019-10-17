Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA0DDB222
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 18:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502028AbfJQQRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 12:17:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50818 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390456AbfJQQRd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 12:17:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hWsCtqoArOgNErY48M2iOin53oYnCZbWFLPfHGmnMVo=; b=SK8J2NQ6JYkFN81PSHbyMCtvbV
        RgyBT217Q9tdQEKFwVpb2MA2TyKL8D9g63yJaHu5l/04MBhRtUNM9I4S5gIDxXyZJKGpuZWrzX8KT
        tO37524+UhSqlDAKmVkdA4aea7TD3iwy8zjGMH4F2bg0icqzaNmiGBTlH0CLEHG+Kw8k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iL8Sg-0005CA-8y; Thu, 17 Oct 2019 18:17:14 +0200
Date:   Thu, 17 Oct 2019 18:17:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chen Wandun <chenwandun@huawei.com>
Cc:     igor.russkikh@aquantia.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: aquantia: add an error handling in
 aq_nic_set_multicast_list
Message-ID: <20191017161714.GQ17013@lunn.ch>
References: <1571279116-4421-1-git-send-email-chenwandun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571279116-4421-1-git-send-email-chenwandun@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 10:25:16AM +0800, Chen Wandun wrote:
> From: Chenwandun <chenwandun@huawei.com>

Hi Chen

There needs to be some sort of commit message. What [problems are you
seeing? That does this fix?

Thanks
	Andrew
