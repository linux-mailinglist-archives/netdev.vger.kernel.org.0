Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631A1577708
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 17:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbiGQPW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 11:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbiGQPW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 11:22:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE51613F59
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 08:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=SCYiM8U8tnXQZCNHBO/HPc/YSBSvr/aSwJIyYlO7lSk=; b=lG/uRUYVcsI95I4wGnxyRDSepx
        u+MLKonCl+isWuEg8cfS4nLVf1tRNC4g9c0mjuszMrg6uu46J9s2c2q42carRGYQIwcYk2fln3mwv
        uDTe1de2JrSh4CDVbXtCRsG+Yd6C3K40/94E78j/rJYF/UPRhV6Oeq78lrzv8wA0mZmM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oD66C-00Acyd-Pr; Sun, 17 Jul 2022 17:22:24 +0200
Date:   Sun, 17 Jul 2022 17:22:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net 03/15] docs: net: dsa: rename tag_protocol to
 get_tag_protocol
Message-ID: <YtQpMJA+kTIYIUFq@lunn.ch>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-4-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220716185344.1212091-4-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 09:53:32PM +0300, Vladimir Oltean wrote:
> Since the blamed commit, the enum was turned into a function pointer and
> also renamed. Update the documentation.
> 
> Fixes: 7b314362a234 ("net: dsa: Allow the DSA driver to indicate the tag protocol")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  Documentation/networking/dsa/dsa.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
> index c04cb4c95b64..f49996e97363 100644
> --- a/Documentation/networking/dsa/dsa.rst
> +++ b/Documentation/networking/dsa/dsa.rst
> @@ -593,8 +593,8 @@ driver may free the data structures associated with the ``dsa_switch``.
>  Switch configuration
>  --------------------
>  
> -- ``tag_protocol``: this is to indicate what kind of tagging protocol is supported,
> -  should be a valid value from the ``dsa_tag_protocol`` enum
> +- ``get_tag_protocol``: this is to indicate what kind of tagging protocol is
> +  supported, should be a valid value from the ``dsa_tag_protocol`` enum

Maybe 'supported' is the wrong word here. It actually returns what is
currently being used. For devices which support multiple tag
protocols, you won't get a list back of supported protocols...

	   Andrew
