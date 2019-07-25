Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 417317446E
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 06:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbfGYE2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 00:28:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36210 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbfGYE2d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 00:28:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jKhXcUdntY6Kwmna1uxpMklTyH3FF24TBvWH/eu+/sA=; b=NyE5E5aZ/tNNCzt/6j3ciTVIJJ
        sE9MqNNNBBLxs1jP26Sxnc42Z1GWWo+p01ImUET1uuIbE3c5E+43nnWRlkhz0LFCRnH2ks8rtNy7T
        luOTL11l43uUzycaypkhH7V06u0jAswkcVbbUNil/PcoGQxchHHXUdlvYMj8wU02w4Ck=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hqVMj-0003sl-94; Thu, 25 Jul 2019 06:28:29 +0200
Date:   Thu, 25 Jul 2019 06:28:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     liuyonglong <liuyonglong@huawei.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        shiju.jose@huawei.com
Subject: Re: [PATCH net] net: hns: fix LED configuration for marvell phy
Message-ID: <20190725042829.GB14276@lunn.ch>
References: <1563775152-21369-1-git-send-email-liuyonglong@huawei.com>
 <20190722.181906.2225538844348045066.davem@davemloft.net>
 <72061222-411f-a58c-5873-ad873394cdb5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72061222-411f-a58c-5873-ad873394cdb5@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 11:00:08AM +0800, liuyonglong wrote:
> > Revert "net: hns: fix LED configuration for marvell phy"
> > This reverts commit f4e5f775db5a4631300dccd0de5eafb50a77c131.
> >
> > Andrew Lunn says this should be handled another way.
> >
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> 
> Hi Andrew:
> 
> I see this patch have been reverted, can you tell me the better way to do this?
> Thanks very much!

Please take a look at the work Matthias Kaehlcke is doing. It has not
got too far yet, but when it is complete, it should define a generic
way to configure PHY LEDs.

    Andrew
