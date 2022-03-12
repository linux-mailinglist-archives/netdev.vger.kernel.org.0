Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2695E4D6FAA
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 16:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbiCLPQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 10:16:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiCLPQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 10:16:33 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3438188A32
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 07:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FZa2Jl7HsJOS7FvUjUTQrD4L4PXwJaI48LitM3KcPUQ=; b=m2T8v8l01vWy6FCWBnLsZli/Yk
        2dkIeX+HS+ELdbBZMoT9U9ooUESIf1qVVN1y9ASod8o16pVcWd8QkcEkB5Z/0+Vdvl4buCPg2yph5
        41lqwtGy9QzlV/mX9iDkal50rfXtrTGNFXxJt97oT5kIGX9mLKIbYXzHE8T4vC/COYB8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nT3Sl-00ASas-EB; Sat, 12 Mar 2022 16:15:23 +0100
Date:   Sat, 12 Mar 2022 16:15:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Cancemi <kurt@x64architecture.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH v2 net] net: phy: marvell: Fix invalid comparison in the
 resume and suspend functions.
Message-ID: <Yiy5C1A0p2YHKlc8@lunn.ch>
References: <20220312002016.60416-1-kurt@x64architecture.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220312002016.60416-1-kurt@x64architecture.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 07:20:19PM -0500, Kurt Cancemi wrote:
> This bug resulted in only the current mode being resumed and suspended when
> the PHY supported both fiber and copper modes and when the PHY only supported
> copper mode the fiber mode would incorrectly be attempted to be resumed and
> suspended.
> 
> Fixes: 3758be3dc162 ("Marvell phy: add functions to suspend and resume both interfaces: fiber and copper links.")
> Signed-off-by: Kurt Cancemi <kurt@x64architecture.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
