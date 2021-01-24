Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECED30194F
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 04:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbhAXDHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 22:07:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:60144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbhAXDHT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 22:07:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B3D722CF6;
        Sun, 24 Jan 2021 03:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611457598;
        bh=jWrohCNq7EFZZjUZjaLN/6uqfVgTj32IIiD46EaKQac=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a+GO5pU8TN+OB4KA3QRF+wVoTlnA1+gCLjEb+BROfpQuB30Ld6mRCXVvJeERfBH0v
         s+b2573xpaFTNVOuqEIu27Cb971SuOY3pSOqCgh5adhVHIuQNaIXO/Ety8wIvD7VpH
         ib7bk/C7IRRjFd0DZ/FwVe9GLMf31jBUwUtHQAcGqJ4QkBhLWj4pZLXhgZk2r12CE5
         hSWYh0UoWKwZ/xF0Nl1dPBaMpTWoN1u9QUGRHohAZzEqCA6fHvZBjgOQPvYCZ6MX/8
         Ymk0XmArt3pXP0kfm5ZYnNxCGhaFsQmoMCVfhAFhYcOyP03bcXHFkozO65kYNUP5Sn
         GoKripXw6XfhA==
Date:   Sat, 23 Jan 2021 19:06:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>, tobias@waldekranz.com
Subject: Re: [PATCH] dsa: mv88e6xxx: Make global2 support mandatory
Message-ID: <20210123190637.42dad133@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210123205148.545214-1-andrew@lunn.ch>
References: <20210123205148.545214-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Jan 2021 21:51:48 +0100 Andrew Lunn wrote:
> Early generations of the mv88e6xxx did not have the global 2
> registers. In order to keep the driver slim, it was decided to make
> the code for these registers optional. Over time, more generations of
> switches have been added, always supporting global 2 and adding more
> and more registers. No effort has been made to keep these additional
> registers also optional to slim the driver down when used for older
> generations. Optional global 2 now just gives additional development
> and maintenance burden for no real gain.
> 
> Make global 2 support always compiled in.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

FWIW doesn't seem to apply to net-next.
