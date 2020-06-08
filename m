Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC4A1F22B7
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgFHXKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:10:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40060 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728622AbgFHXKU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:10:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QccbgltLJCfAgVUwMQmeSMxlQc+uzwYiULSTxOorvsE=; b=MWNedarFrzhh6rTSmgnC73VY3b
        3glzi9Unuvrj+vqJIlvwQeb29eCyezvC5cDWWghOuTIdP6VDDNGrjYXgRn2yWM2+oS9nTFvsOsjnf
        C2o8F3pGA3yW1u7sqGwyw1yOHUJEcbFz6HTQX1OT/afLERaPZccsMDmqskE3xIbSfX1o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jiQuF-004ROT-KA; Tue, 09 Jun 2020 01:10:15 +0200
Date:   Tue, 9 Jun 2020 01:10:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, lorenzo.bianconi@redhat.com,
        brouer@redhat.com
Subject: Re: [PATCH net] net: mvneta: do not redirect frames during
 reconfiguration
Message-ID: <20200608231015.GH1022955@lunn.ch>
References: <fd076dae0536d823e136ab4c114346602e02b6d7.1591653494.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd076dae0536d823e136ab4c114346602e02b6d7.1591653494.git.lorenzo@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 12:02:39AM +0200, Lorenzo Bianconi wrote:
> Disable frames injection in mvneta_xdp_xmit routine during hw
> re-configuration in order to avoid hardware hangs

Hi Lorenzo

Why does mvneta_tx() also not need the same protection?

    Andrew
