Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A16321C9DF
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 16:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgGLOrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 10:47:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59252 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728786AbgGLOrQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 10:47:16 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1judG2-004kSz-Tp; Sun, 12 Jul 2020 16:47:10 +0200
Date:   Sun, 12 Jul 2020 16:47:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v2 net] net: fec: fix hardware time stamping by external
 devices
Message-ID: <20200712144710.GC1110701@lunn.ch>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200711120842.2631-1-sorganov@gmail.com>
 <20200711231937.wu2zrm5spn7a6u2o@skbuf>
 <87wo387r8n.fsf@osv.gnss.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo387r8n.fsf@osv.gnss.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I did as you suggested:
> 
> [pretty]
>         fixes = Fixes: %h (\"%s\")
> [alias]
> 	fixes = show --no-patch --pretty='Fixes: %h (\"%s\")'
> 
> And that's what it gave me. Dunno, maybe its Git version that is
> responsible?

[core]
        abbrev = 12

	Andrew
