Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5337C1BE056
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgD2OLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:11:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59338 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727119AbgD2OLF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 10:11:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+vHAMoqQnDQpOixhUfky9LKFwZ/RbB5JXgw62LfiHsE=; b=bv2PwJwBqHfkjMMvHKq0qYR3ft
        LRzgYsTI+JmDffSiFFD7mTEWQaJCV/RwN4Hv4yu+If7r01qG3ZjI9BLULHDoUFraS2MC/MlJoQnQc
        l3xt6kOoQLgBPNA5sqmVIW0ekwEwrfin9KH1c4JMBWfRhOzADRv4MutCXmztFZed0ry8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTnQU-000GJt-VN; Wed, 29 Apr 2020 16:11:02 +0200
Date:   Wed, 29 Apr 2020 16:11:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "cphealy@gmail.com" <cphealy@gmail.com>,
        Leonard Crestez <leonard.crestez@nxp.com>
Subject: Re: [EXT] Re: [PATCH net-next] net: ethernet: fec: Prevent MII event
 after MII_SPEED write
Message-ID: <20200429141102.GK30459@lunn.ch>
References: <20200428175833.30517-1-andrew@lunn.ch>
 <20200428.143339.1189475969435668035.davem@davemloft.net>
 <HE1PR0402MB2745408F4000C8B2C119B9EDFFAD0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
 <20200428.203439.49635882087657701.davem@davemloft.net>
 <HE1PR0402MB2745963E2B675BAC95A61E55FFAD0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HE1PR0402MB2745963E2B675BAC95A61E55FFAD0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >> Applied to net-next, thanks.
> > >
> > > David, it is too early to apply the patch, it will introduce another
> > > break issue as I explain in previous mail for the patch.
> > 
> > So what should I do, revert?
> 
> If you can revert the patch, please do it. 
> Thanks, David.

Hi David

Please do revert. I will send a new version of the patch
soon. Probably RFC this time!

      Andrew
