Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1B843DC666
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 16:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbhGaOtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 10:49:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55246 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233273AbhGaOtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Jul 2021 10:49:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4wIE3UAedvU0X5OL046mu4GRUy2Zi6vswLl1mtaMiEc=; b=cOsp/c4Q+6nzxmoFHR3qNh9Zj6
        u5Mfu0eYrrGLfxB+nrPWIZDqS+2aEYmva+fPotWSwdxuyPeFxNJvq5NkFKwnN4llv68kUn3qk6Dpl
        A5AJMRSE/TFu0OVRLNCWKOnLQJZy5MOGnA8L46B5NO6Yds5n0nc/khjCoGEzEUOkcT3c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m9qIn-00Fcgo-GD; Sat, 31 Jul 2021 16:49:25 +0200
Date:   Sat, 31 Jul 2021 16:49:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net] docs: operstates: document IF_OPER_TESTING
Message-ID: <YQVi9et1Ew7ICCiG@lunn.ch>
References: <20210731144052.1000147-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210731144052.1000147-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 31, 2021 at 07:40:52AM -0700, Jakub Kicinski wrote:
> IF_OPER_TESTING is in fact used today.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
