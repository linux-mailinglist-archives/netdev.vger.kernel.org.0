Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F75A3CCFC
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 15:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389445AbfFKNaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 09:30:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45206 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728901AbfFKNaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 09:30:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sh/YWafpGpmQMqWw02/1rSu9P6QFIIWQVRPH71XCm2E=; b=rtJpd0dOv776DccTC5FgK80vpO
        N5RGrQPAkP5FiXYOi9XPNBVXNvJIMB83iIQZyWod3Xcmx7WD/f1GNE21JLARUqsCZx62Sq2bwThqq
        pabjJ0RZb+nGQcIpzFhz85Y40FLFZqYpSN2uj8WNvklPABd9we7aAz/5bjxhwnTOgmhQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hagqp-00061I-56; Tue, 11 Jun 2019 15:30:11 +0200
Date:   Tue, 11 Jun 2019 15:30:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 3/3] selftests: mlxsw: Add speed and
 auto-negotiation test
Message-ID: <20190611133011.GB22832@lunn.ch>
References: <20190610084045.6029-1-idosch@idosch.org>
 <20190610084045.6029-4-idosch@idosch.org>
 <20190610134820.GG8247@lunn.ch>
 <20190610135848.GB19495@splinter>
 <20190610140633.GI8247@lunn.ch>
 <20190611063526.GA6167@splinter>
 <20190611122255.GB20904@lunn.ch>
 <20190611130605.GA3940@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611130605.GA3940@splinter>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The test currently resides under
> tools/testing/selftests/drivers/net/mlxsw/, so it's specific to mlxsw.
> 
> I believe the 56G quirk is the only thing in the test that is specific
> to mlxsw. Should be possible to move it to
> tools/testing/selftests/net/forwarding/ and skip 56G for mlxsw.

Hi Ido

That would be good. I don't see why this test should not work for any
interface. I expect there are a lot of 10/100/1000 interfaces which
could run this test.

Thanks
      Andrew
