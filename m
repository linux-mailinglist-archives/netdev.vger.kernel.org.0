Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E33C4EEDEA
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 15:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346246AbiDANPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 09:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346242AbiDANPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 09:15:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018113E5FA
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 06:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IA0LVA8FTQELpIe/DyqxtDjMuVJ+I2d67aXJAHWdGEM=; b=DyK45Ice9BCTgg77Az39Zi4rtw
        ORsMST/tPGD70Ox+QkOYM0WKDqUUZlWzI6W7G5R0Olb8HsBUNOhg5x+jP4clp+Dhov1qmonY+JrO4
        vWPXI9qTUdKy2CmtxQbsJRBLEEWOhA2IaryOHwsuRFMJopv7IdMMHsBRcMdZH89W27G4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1naH5j-00Dfui-EH; Fri, 01 Apr 2022 15:13:27 +0200
Date:   Fri, 1 Apr 2022 15:13:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ian Wienand <iwienand@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net/ethernet : set default assignment identifier to
 NET_NAME_ENUM
Message-ID: <Ykb6d3EvC2ZvRXMV@lunn.ch>
References: <20220401063430.1189533-1-iwienand@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401063430.1189533-1-iwienand@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 01, 2022 at 05:34:30PM +1100, Ian Wienand wrote:
> As noted in the original commit 685343fc3ba6 ("net: add
> name_assign_type netdev attribute")
> 
>   ... when the kernel has given the interface a name using global
>   device enumeration based on order of discovery (ethX, wlanY, etc)
>   ... are labelled NET_NAME_ENUM.
> 
> That describes this case, so set the default for the devices here to
> NET_NAME_ENUM to better help userspace tools to know if they might
> like to rename them.

Hi Ian

Is this potentially an ABI change, and we will get surprises when
interfaces which were not previously renamed now are? It would be nice
to see some justification this is actually safe to do.

   Andrew
