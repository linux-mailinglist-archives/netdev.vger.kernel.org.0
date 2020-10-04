Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15AA282B75
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 17:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgJDPdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 11:33:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42502 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgJDPdR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 11:33:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kP60h-0003Tn-NB; Sun, 04 Oct 2020 17:33:15 +0200
Date:   Sun, 4 Oct 2020 17:33:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Samanta Navarro <ferivoz@riseup.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] man: fix typos
Message-ID: <20201004153315.GE4183771@lunn.ch>
References: <20201004114259.nwnu3j4uuaryjvx4@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004114259.nwnu3j4uuaryjvx4@localhost>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 04, 2020 at 11:42:59AM +0000, Samanta Navarro wrote:
> ---
>  man/man8/ip-link.8.in   | 14 +++++++-------
>  man/man8/ip-neighbour.8 |  6 +++---
>  man/man8/tc-actions.8   |  2 +-
>  man/man8/tc-pie.8       |  4 ++--
>  4 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> index f451ecf..fbc45df 100644
> --- a/man/man8/ip-link.8.in
> +++ b/man/man8/ip-link.8.in
> @@ -392,7 +392,7 @@ packet the new device should accept.
>  .TP
>  .BI gso_max_segs " SEGMENTS "
>  specifies the recommended maximum number of a Generic Segment Offload
> -segments the new device should accept.
> +segment the new device should accept.

Hi Samanta

The original seems correct to me.

    Andrew
