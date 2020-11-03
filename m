Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978E92A5A7B
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 00:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbgKCXWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 18:22:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727979AbgKCXWS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 18:22:18 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F987223AB;
        Tue,  3 Nov 2020 23:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604445737;
        bh=rEwNUBVg4bRKBlr6zYlyT5a4T9zbk1fvmqPXtp8dV/0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hxcxYKkzMhjIjRAIoTcl2qhAIIlN04AB3GchMQDuavb3JulSJ/b78Aantx3V2w1Cq
         /9O6BamexeUJnZvgKFv0Ix6yoUkew2TMa0CYsqTssqRpvyAQUQ6vNkRFoHud1dgn/P
         Az6WpjH6DO2KHOz2GmnSWPMDUEoa7hBJXvdlI0Ac=
Date:   Tue, 3 Nov 2020 15:22:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next v7 0/5] net: hdlc_fr: Improve fr_rx and add
 support for any Ethertype
Message-ID: <20201103152216.36ed8495@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201031181043.805329-1-xie.he.0141@gmail.com>
References: <20201031181043.805329-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 11:10:38 -0700 Xie He wrote:
> The main purpose of this series is the last patch. The previous 4 patches
> are just code clean-ups so that the last patch will not make the code too
> messy. The patches must be applied in sequence.
> 
> The receiving code of this driver doesn't support arbitrary Ethertype
> values. It only recognizes a few known Ethertypes when receiving and drops
> skbs with other Ethertypes.
> 
> However, the standard document RFC 2427 allows Frame Relay to support any
> Ethertype values. This series adds support for this.

Applied, but going forward please limit any refactoring and extensions
to the HDLC code. I thought you are actually using it. If that's not
the case let's leave the code be, it's likely going to be removed in 
a few years time.
