Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16A85F7764
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 16:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfKKPJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 10:09:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34020 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbfKKPJL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 10:09:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vxrkrUDyrz11I4gx+eGfMQ1xL8H/llUsPL/s5BDo/50=; b=e6WV/qL0EFasuZBBnPQZJaEaYn
        lK5g2mwmAMjo/7N/BATPo+bo6+uw8iHL1yrUugVB3DlRPWEeHi3h8oNMzYNx2BReweqo30O8GWBfi
        1gg0Hs1IR2Er+NssZlMOPKQ7dGolBpnotq4amFNHi30ElARfVngpr8TDxccQTJmYhvKo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUBJT-0002mX-AX; Mon, 11 Nov 2019 16:09:07 +0100
Date:   Mon, 11 Nov 2019 16:09:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     ilias.apalodimas@linaro.org, brouer@redhat.com,
        netdev <netdev@vger.kernel.org>
Subject: Re: Regression in mvneta with XDP patches
Message-ID: <20191111150907.GD1105@lunn.ch>
References: <20191111134615.GA8153@lunn.ch>
 <20191111143725.GB4197@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111143725.GB4197@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> looking at the dts, could you please confirm mvneta is using hw or sw buffer manager
> on this board? Moreover are you using DSA as well?

So my reply to Ilias answered the first question. And yes, i'm using
DSA. But that should not matter, mvneta is just receiving frames which
happen to have an extra header after the two MAC addresses.

       Andrew
