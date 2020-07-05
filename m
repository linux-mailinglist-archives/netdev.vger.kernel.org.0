Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A7A21505E
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 01:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgGEX10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 19:27:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:56328 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728019AbgGEX10 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 19:27:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 01B5CAE47;
        Sun,  5 Jul 2020 23:27:26 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 79D8D602E3; Mon,  6 Jul 2020 01:27:25 +0200 (CEST)
Date:   Mon, 6 Jul 2020 01:27:25 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH ethtool v4 0/6] ethtool(1) cable test support
Message-ID: <20200705232725.34epywsb7do6xzie@lion.mk-sys.cz>
References: <20200701010743.730606-1-andrew@lunn.ch>
 <20200705004447.ook7vkzffa5ejb2v@lion.mk-sys.cz>
 <20200705182533.GA886548@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200705182533.GA886548@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 05, 2020 at 08:25:33PM +0200, Andrew Lunn wrote:
> > Hello Andrew,
> > 
> > could you please test this update of netlink/desc-ethtool.c on top of
> > your series? The userspace messages look as expected but I'm not sure if
> > I have a device with cable test support available to test pretty
> > printing of kernel messages. (And even if I do, I almost certainly won't
> > have physical access to it.)
> 
> Tested-by: Andrew Lunn <andrew@lunn.ch>

Thank you,
Michal
