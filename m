Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D417E132FCA
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 20:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgAGTpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 14:45:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51266 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728748AbgAGTpj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 14:45:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fLI3vbFuQeo6MNH7rDpLpEc7V3nP+2LA0KTZKh7sdb0=; b=ej2rYTh/Mm4onKMAJCnljY8y6y
        yPFbdNCvIAZxLpwpC2uA1BNLJR9pSOcK6m1Fm1mh05w7wjdDK5pgOUO7OYu+VYxLMS1X5YfY7WCu9
        ZMTJLnMulzTO/UYS0hlxo4euE/9sCWTJ8PRfVUXtV+C5bkAIi7jKVZPdIdXC0NK+s3io=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iounI-0004k6-Nk; Tue, 07 Jan 2020 20:45:36 +0100
Date:   Tue, 7 Jan 2020 20:45:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next 3/4] ionic: restrict received packets to mtu
 size
Message-ID: <20200107194536.GB16895@lunn.ch>
References: <20200107034349.59268-1-snelson@pensando.io>
 <20200107034349.59268-4-snelson@pensando.io>
 <20200107130949.GA23819@lunn.ch>
 <112c6fd3-6565-e88a-dde5-520770d9f024@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <112c6fd3-6565-e88a-dde5-520770d9f024@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> 

Hi Shannon

> In my experience the driver typically tells the NIC about the current
> max_frame size (e.g. MTU + ETH_HLEN), the NIC only copies max_frame bytes,
> and the NIC returns an error indication on a packets that had more than
> max_frame.

Having played around with a few different NICs for DSA, it seems more
like 75% don't care about the 'MRU' and will happily accept bigger
frames.

Anyway, it does not hurt to drop received frames bigger than what you
can transmit.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
