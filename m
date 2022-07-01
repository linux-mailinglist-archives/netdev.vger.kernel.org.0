Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF46562D03
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 09:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbiGAHsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 03:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235578AbiGAHsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 03:48:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7236EE86;
        Fri,  1 Jul 2022 00:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=h2ZOn+dCZfyggMWCkIPXgrYmuhMv5KH6IhCtBthTteA=; b=FcfuFR+AfwlESM+okzWsug+jCn
        /ey4a3A8ISRFlanmCKPesHUzhH4bVaofW4NUc+q7lwrKrj8xMxJPcak2H3sh9B5ZYW1qxVlsGuEy/
        LPPaAdqfIvUbWGTuZLUbdapkJrsTEnpMLe7CwVmOLdpLB80uCtBg5d7jwLNLVZt8/DRE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o7BOA-008uh7-ON; Fri, 01 Jul 2022 09:48:30 +0200
Date:   Fri, 1 Jul 2022 09:48:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, linux-doc@vger.kernel.org
Subject: Re: [PATCH net 1/3] docs: netdev: document that patch series length
 limit
Message-ID: <Yr6mziKdr/rmuTjt@lunn.ch>
References: <20220630174607.629408-1-kuba@kernel.org>
 <20220630174607.629408-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630174607.629408-2-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 10:46:05AM -0700, Jakub Kicinski wrote:
> We had been asking people to avoid massive patch series but it does
> not appear in the FAQ.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/process/maintainer-netdev.rst | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/process/maintainer-netdev.rst b/Documentation/process/maintainer-netdev.rst
> index c456b5225d66..862b6508fc22 100644
> --- a/Documentation/process/maintainer-netdev.rst
> +++ b/Documentation/process/maintainer-netdev.rst
> @@ -136,6 +136,14 @@ it to the maintainer to figure out what is the most recent and current
>  version that should be applied. If there is any doubt, the maintainer
>  will reply and ask what should be done.
>  
> +How do I divide my work into patches?
> +-------------------------------------
> +
> +Put yourself in the shoes of the reviewer. Each patch is read separately
> +and therefore should constitute a comprehensible step towards your stated
> +goal. Avoid sending series longer than 15 patches, they clog review queue
> +and increase mailing list traffic when re-posted.
> +

Hi Jakub

I think a key concept is, big patch series takes longer to review, so
needs a bigger junk of time allocated to it, so often gets differed
until late. As a result, it will take longer to merge. A small series
can be reviewed in a short time, so Maintainers just do it, allowing
for quicker merging.

    Andrew
