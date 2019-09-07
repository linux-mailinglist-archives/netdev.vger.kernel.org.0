Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 525FCAC76F
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 17:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392634AbfIGP6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 11:58:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33204 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389788AbfIGP6L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Sep 2019 11:58:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BPFXfTuuawVcjqRBXwYB+uvmu3LaIBpabNB/L8tEuH4=; b=SgzlbGJd4j88MtGVS43gBMnuLu
        XKe4CVre5r5GJddgaZVQi1ahyys42kNPIRfYtUqus9TOytgAJLnx+bF8qftjE4+PGzmRyFrETbfbV
        Gm65NRetYptC8o2hohyjqIKhIFErcabz0tRZC9eI6/GGRJLY5jketl66+TSVy4al1gi8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i6d6D-0006Bx-KJ; Sat, 07 Sep 2019 17:58:05 +0200
Date:   Sat, 7 Sep 2019 17:58:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     davem@davemloft.net, kstewart@linuxfoundation.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethernet: micrel: Use DIV_ROUND_CLOSEST directly to make
 it readable
Message-ID: <20190907155805.GE21922@lunn.ch>
References: <1567698828-26825-1-git-send-email-zhongjiang@huawei.com>
 <20190906194050.GB2339@lunn.ch>
 <5D732078.6080902@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D732078.6080902@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 07, 2019 at 11:14:00AM +0800, zhong jiang wrote:
> On 2019/9/7 3:40, Andrew Lunn wrote:
> > On Thu, Sep 05, 2019 at 11:53:48PM +0800, zhong jiang wrote:
> >> The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
> >> but is perhaps more readable.
> > Hi Zhong
> >
> > Did you find this by hand, or did you use a tool. If a tool is used,
> > it is normal to give some credit to the tool.
> With the following help of Coccinelle. 

It is good to mention Coccinelle or other such tools. They often exist
because of university research work, and funding for such tools does
depend on publicity of the tools, getting the credit they deserve.

       Andrew
