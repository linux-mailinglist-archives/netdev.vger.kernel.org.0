Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0D786330
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 15:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733147AbfHHNc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 09:32:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44254 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732909AbfHHNcX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 09:32:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GHo/6QReMThwQvyBgODim8yuFC35rBgqhlgJLF2q8Q4=; b=oTFysx+mCgXvRtdsg5J4CTTGW9
        HLBr7jV26zYbqX3l5R1W+PwgvvBWC+pzrJ3PQPhNUQyC24TlfZZebDOLgNBcbMNYiq6arqFiIqBnb
        RIZABxEu3b7a9BLjmVbOsv1luWS1rqlniXD45/u4PrYAH1Ue6Z0VevzULWXe6kCo64n8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hviWX-0002zd-D4; Thu, 08 Aug 2019 15:32:09 +0200
Date:   Thu, 8 Aug 2019 15:32:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tao Ren <taoren@fb.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        William Kennington <wak@google.com>,
        Joel Stanley <joel@jms.id.au>
Subject: Re: [PATCH net-next] net/ncsi: allow to customize BMC MAC Address
 offset
Message-ID: <20190808133209.GB32706@lunn.ch>
References: <20190807002118.164360-1-taoren@fb.com>
 <20190807112518.644a21a2@cakuba.netronome.com>
 <20190807184143.GE26047@lunn.ch>
 <806a76a8-229a-7f24-33c7-2cf2094f3436@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <806a76a8-229a-7f24-33c7-2cf2094f3436@fb.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Let me prepare patch v2 using device tree. I'm not sure if standard
> "mac-address" fits this situation because all we need is an offset
> (integer) and BMC MAC is calculated by adding the offset to NIC's
> MAC address. Anyways, let me work out v2 patch we can discuss more
> then.

Hi Tao

I don't know BMC terminology. By NICs MAC address, you are referring
to the hosts MAC address? The MAC address the big CPU is using for its
interface?  Where does this NIC get its MAC address from? If the BMCs
bootloader has access to it, it can set the mac-address property in
the device tree.

    Andrew
