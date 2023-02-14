Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022A769693F
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjBNQXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjBNQXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:23:07 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF2B93C3
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 08:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eEHiBC/5+Ij9Pp02K/xqZsa9khaDCAoavMTyLu+00cg=; b=TRdD84bdpwVAlLTi874t0bXadD
        PyERA/ovGeC6MY6ezGlYRenS8+TSsmt+QfD4/D8u2CFqbMnfCit/RPGg8DZjofxGiTr2amolxAqZ3
        9RADjrcc7v2IkWDY1DmT4KdVY+DLAWX38ua4TqELtw8u+JOyGzbTag+LJraC72uLpwKw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pRy58-004yK7-Gx; Tue, 14 Feb 2023 17:23:02 +0100
Date:   Tue, 14 Feb 2023 17:23:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v3] net: wangxun: Add the basic ethtool
 interfaces
Message-ID: <Y+u1ZrOabIBznhaV@lunn.ch>
References: <20230214091527.69943-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214091527.69943-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 05:15:27PM +0800, Mengyuan Lou wrote:
> Add the basic ethtool ops get_drvinfo and get_link for ngbe and txgbe.
> Ngbe implements get_link_ksettings, nway_reset and set_link_ksettings
> for free using phylib code.
> The code related to the physical interface is not yet fully implemented
> in txgbe using phylink code. So do not implement get_link_ksettings,
> nway_reset and set_link_ksettings in txgbe.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
