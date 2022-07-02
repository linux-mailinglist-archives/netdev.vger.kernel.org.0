Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 689035642B0
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 22:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiGBUPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 16:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiGBUPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 16:15:22 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CACDEEE
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 13:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5eUXBd9hXG6tl5/oJwWWX8AKSosON4AehStp/IXFM/k=; b=gw8GMTWlN+7qIiEcIWGlRNLIP6
        YVQL2qmpCSH2s5ashaX8AaRTcQBJpWhJEH8vS3sjDGMShaouejqKH+hLOYZ28jvHVqqO+58F/2tC3
        sPjGFTSG1IuBhHGXWxpHgBQIz75afzFrETeNW6w7dUwGxqYHQ2X6zj7OHf3Iqy24xl8w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o7jWP-0093Bl-VS; Sat, 02 Jul 2022 22:15:17 +0200
Date:   Sat, 2 Jul 2022 22:15:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net v2 2/3] docs: netdev: document reverse xmas tree
Message-ID: <YsCnVVNO9Hd/Flx3@lunn.ch>
References: <20220702031209.790535-1-kuba@kernel.org>
 <20220702031209.790535-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220702031209.790535-3-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 08:12:08PM -0700, Jakub Kicinski wrote:
> Similarly to the 15 patch rule the reverse xmas tree is not
> documented.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
