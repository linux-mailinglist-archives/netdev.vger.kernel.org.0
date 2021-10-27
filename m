Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B0943CC72
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237799AbhJ0Olv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:41:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33662 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231462AbhJ0Olu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 10:41:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GE8dI0QyjhW+8qK2l/hMr0UeoLYBgV2bsz3Gdm35mVY=; b=RQDVWQG14uUU9bti//OtaVaVHL
        X7gHT8DsdHSnCeHJiUMQSfhh6Muf+ZaTZ3+T1PwDnt4CWz/J7UL/p5Y3ikzCXzVQ+U3CX3fB5fUVr
        qMYVsDvBcSHQ8gXwnBtQz7jbdjqe4y17x1psvihF0Axrgjhq6jBGaIUaOFoqETXlTuYQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mfk5J-00Bu8J-Am; Wed, 27 Oct 2021 16:39:21 +0200
Date:   Wed, 27 Oct 2021 16:39:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Shai Malin <smalin@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>
Subject: Re: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
Message-ID: <YXlkmb4UvQc6P0pq@lunn.ch>
References: <20211026193717.2657-1-manishc@marvell.com>
 <20211026140759.77dd8818@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR18MB465598CDD29377C300C3184CC4859@PH0PR18MB4655.namprd18.prod.outlook.com>
 <20211027070341.159b15fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027070341.159b15fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> All the patch is doing is changing some offsets. Why can't you just
> make the offset the driver uses dependent on the FW version?
> 
> Would be great if the engineer who wrote the code could answer that.

It is also not clear why the offsets need to change. Why not add the
new facility at the end, so the offsets don't change?

    Andrew
