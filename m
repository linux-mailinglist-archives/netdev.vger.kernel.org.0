Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EEA2DD87B
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbgLQSf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:35:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:39400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727368AbgLQSf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 13:35:59 -0500
Date:   Thu, 17 Dec 2020 10:35:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608230118;
        bh=LGhVrFTaXwYgvhalPQ0cqXO6yPW4ZzqcxrJG0+nwx9w=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=TCNm/R1HgAANTflWPRxRlntr1/vLevn5fm91ldY8/LBj8wa7HxvdlQ+6lhjzfZOlV
         iU/OzFrhgqFb1wKukGt/6pqOgUVBOIsDcCplmlh6O4uVERyi7Xa3n2Xao95yKWOu7j
         Tt/i9SnurDaJiq2INCvOY+tJzHIzoqu/2h7+nhk0qCqeSit7M0UdK0jjeSpTOJ7Uj1
         3KlReTu+BuRynabmV/jyMAH2i4xLRX/v64/1t291lryexw/9TZ9FAuoTpUYYFsFbaR
         UEk2ycFfNjDU7gG9Lpypj3DwExCMyJOyIh6I54o5AAoNnE0vINtks/v0Z2S1Khwk5I
         8/i2vSuA2MWLA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net] docs: netdev-FAQ: add missing underlines to
 questions
Message-ID: <20201217103517.6ac75a97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ccd6e8b9f1d87b683a0759e8954d03310cb0c09f.1608052699.git.baruch@tkos.co.il>
References: <ccd6e8b9f1d87b683a0759e8954d03310cb0c09f.1608052699.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 19:18:19 +0200 Baruch Siach wrote:
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  Documentation/networking/netdev-FAQ.rst | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
> index 4b9ed5874d5a..4ef90fe26640 100644
> --- a/Documentation/networking/netdev-FAQ.rst
> +++ b/Documentation/networking/netdev-FAQ.rst
> @@ -82,6 +82,7 @@ focus for ``net`` is on stabilization and bug fixes.
>  Finally, the vX.Y gets released, and the whole cycle starts over.
>  
>  Q: So where are we now in this cycle?
> +-------------------------------------
>  
>  Load the mainline (Linus) page here:
>  
> @@ -108,6 +109,7 @@ with.
>  Q: I sent a patch and I'm wondering what happened to it?
>  --------------------------------------------------------
>  Q: How can I tell whether it got merged?
> +----------------------------------------

I think this and the following fixes should be folded into a single
line (unless it's possible in RST for header to span multiple lines):

I sent a patch and I'm wondering what happened to it - how can I tell whether it got merged?
--------------------------------------------------------------------------------------------

To be honest I think we can also drop the Q: and A: prefixes now that
we're using RST.

And perhaps we can add an index of questions at the beginning of the
the file?
