Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA03D668A
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 17:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731310AbfJNPvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 11:51:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44930 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730314AbfJNPvA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 11:51:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=V6rqbb+UANVF+/Q8llIZetnk+Zj3g1WyfTEY9wi1GD4=; b=cprVr47S8jsGQKekpBktgrN3PE
        p2LsiEIAEPzKfcDSu5dX/7PQSgqcb34UC1mDAhLp4kS+yYo1HhxC+a5EibMndo86ZZQh2lcCykZb/
        ZWqWOpPI86z5QvtcNwzCF5U81fRdnmOF8iwJCXOIvF9YHXaAwZ7WIpfENtPsSiTkIsmM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iK2cZ-00068I-SD; Mon, 14 Oct 2019 17:50:55 +0200
Date:   Mon, 14 Oct 2019 17:50:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Simon Edelhaus <sedelhaus@marvell.com>
Subject: Re: [PATCH v2 net-next 02/12] net: aquantia: unify styling of bit
 enums
Message-ID: <20191014155055.GL21165@lunn.ch>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
 <e109ffd5253f59f25f71faf57f4f6c081c080ec8.1570531332.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e109ffd5253f59f25f71faf57f4f6c081c080ec8.1570531332.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 10:56:38AM +0000, Igor Russkikh wrote:
> From: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
> 
> Make some other bit-enums more clear about positioning,
> this helps on debugging and development
> 
> Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
> Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
