Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4779512F
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 00:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbfHSWy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 18:54:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43310 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728014AbfHSWy1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 18:54:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NdrnjgrahYESqLJFFvBWO65ixubaBOtmFXh1UYBUR6M=; b=1Rm8Vqe1AePi4GbhZutVJ4u0h4
        SYsEUy3WfuHhjLmtLiOAxbydMwfHJjrxnYVaBKGFNXlSg2ejVG6TVB6y/TCR4d9VQeTXavYGs5/Ar
        yvrLGVIrjDPKyWPpfGKT+aUKLpyQuTV0maXlU/bghFCycoQTTnjxc5S2wKSONZZadFiM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hzqXe-00024v-Ua; Tue, 20 Aug 2019 00:54:22 +0200
Date:   Tue, 20 Aug 2019 00:54:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marco Hartmann <marco.hartmann@nxp.com>
Cc:     Andy Duan <fugang.duan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [PATCH net-next 0/1] net: fec: add C45 MDIO read/write support
Message-ID: <20190819225422.GD29991@lunn.ch>
References: <1566234659-7164-1-git-send-email-marco.hartmann@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566234659-7164-1-git-send-email-marco.hartmann@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 05:11:14PM +0000, Marco Hartmann wrote:
> As of yet, the Fast Ethernet Controller (FEC) driver only supports Clause 22
> conform MDIO transactions. IEEE 802.3ae Clause 45 defines a modified MDIO
> protocol that uses a two staged access model in order to increase the address
> space.
> 
> This patch adds support for Clause 45 conform MDIO read and write operations to
> the FEC driver.

Hi Marco

Do all versions of the FEC hardware support C45? Or do we need to make
use of the quirk support in this driver to just enable it for some
revisions of FEC?

Thanks
	Andrew
