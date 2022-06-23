Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F845558889
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 21:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiFWTTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 15:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiFWTSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 15:18:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F0AC3E90;
        Thu, 23 Jun 2022 11:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=NV3fzrvLUTeIsatJ8ynzmADBs8FW3qodOLoqKRksmx8=; b=36QFTjRIYmPHNLwBxEGQFDrnkF
        uo64DOdpm3IOCba5T8ogDGf4EmxCI7KDRDH30zJsUlr3hvStXshfS3NlPptM22myzC4yG5VpALAzm
        Gw7u7f7ylVoDo7rBOkm6NuZJ/PyPdRfv52J3acTf4hnxQeLSh3hNBWAnVhpd1YYRnzTY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o4RV4-007zf6-8p; Thu, 23 Jun 2022 20:24:18 +0200
Date:   Thu, 23 Jun 2022 20:24:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        hkallweit1@gmail.com
Subject: Re: [PATCH v3 0/2] net: dp83822: fix interrupt floods
Message-ID: <YrSv0hcay5cnJNY9@lunn.ch>
References: <YqzAKguRaxr74oXh@lunn.ch>
 <20220623134645.1858361-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623134645.1858361-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 03:46:43PM +0200, Enguerrand de Ribaucourt wrote:
> The false carrier and RX error counters, once half full, produce interrupt
> floods. Since we do not use these counters, these interrupts should be disabled.
> 
> v2: added Fixes: and patchset description 0/2
> v3: Fixed Fixes: commit format
> 
> In-Reply-To: YqzAKguRaxr74oXh@lunn.ch
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")

It is maybe only part of the netdev FAQ, but it states there, don't
post new versions of the patches in less than 24 hours. You need to
give people time to review the changes and make comments.

It is correct to append a Reviewed-by, but it should only be to the
patch which was actually reviewed. So please add my Reviewed-by to
just patch 1/2. The Fixes should also be on each individual patch, not
the 0/X patch, since that often gets lost in the noise.

    Andrew


