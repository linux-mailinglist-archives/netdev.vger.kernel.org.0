Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCAC4E88E0
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 18:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbiC0Qh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 12:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236028AbiC0Qh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 12:37:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA0A13E96;
        Sun, 27 Mar 2022 09:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JIVqtxCJDVeBunF7KdVfHl+RFjGtIKI6GS5Jv6hlUcY=; b=dbLcwthnp2NRcNT73GTaGxkxV5
        m52Vtw/ZQ0TOmvcRZHEVLMSUgh5muLGU54ZkZj5ekNQg1M6JR+KVq3lF6xcsUPjQjbC2KU6SRcjXY
        A1soixNqJpI3Fp8X4YyHFV7/XlHgCFXRVKCQl2P7W+pE0J94sYHoID//GNeJnwQwdkL4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nYVri-00Cu5e-3e; Sun, 27 Mar 2022 18:35:42 +0200
Date:   Sun, 27 Mar 2022 18:35:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        corbet@lwn.net, bpf@vger.kernel.org, linux-doc@vger.kernel.org,
        f.fainelli@gmail.com
Subject: Re: [PATCH net 04/13] docs: netdev: turn the net-next closed into a
 Warning
Message-ID: <YkCSXj9aBldNk392@lunn.ch>
References: <20220327025400.2481365-1-kuba@kernel.org>
 <20220327025400.2481365-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220327025400.2481365-5-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 26, 2022 at 07:53:51PM -0700, Jakub Kicinski wrote:
> Use the sphinx Warning box to make the net-next being closed
> stand out more.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/networking/netdev-FAQ.rst | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
> index 0bff899f286f..c1683ed1faca 100644
> --- a/Documentation/networking/netdev-FAQ.rst
> +++ b/Documentation/networking/netdev-FAQ.rst
> @@ -73,8 +73,9 @@ relating to vX.Y
>  An announcement indicating when ``net-next`` has been closed is usually
>  sent to netdev, but knowing the above, you can predict that in advance.
>  
> -IMPORTANT: Do not send new ``net-next`` content to netdev during the
> -period during which ``net-next`` tree is closed.
> +.. warning::
> +  Do not send new ``net-next`` content to netdev during the
> +  period during which ``net-next`` tree is closed.
>  
>  Shortly after the two weeks have passed (and vX.Y-rc1 is released), the
>  tree for ``net-next`` reopens to collect content for the next (vX.Y+1)

Maybe somewhere around here mention that RFC patches can be posted
while net-next is closed? It is something we keep telling people, so
probably should be a FAQ item.

      Andrew
