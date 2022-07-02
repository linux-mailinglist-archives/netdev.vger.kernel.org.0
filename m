Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59575642B1
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 22:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiGBUPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 16:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiGBUPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 16:15:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB98DF05
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 13:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=NVgdpZhZ1AKU/jhxyeoHHPIXemCjpLC/bmiDH7JEu5w=; b=fpgHh1/nh61PKWMP2ITDbyFUej
        CiiBpNiWyWqTn3+8WJqstg7qPkY7Aj8FWDXsNZXQiCyBBVQvCmM0A1US8IpolSyFAwa98Vf0A86id
        eFI9dJOhLV6W0OfyiJwovGnfBzK7us5c8E5f6m51rUfluPIQpo62LxHwFwimtlPQ808c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o7jWs-0093CJ-14; Sat, 02 Jul 2022 22:15:46 +0200
Date:   Sat, 2 Jul 2022 22:15:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net v2 3/3] docs: netdev: add a cheat sheet for the rules
Message-ID: <YsCncghuQ4u41cfb@lunn.ch>
References: <20220702031209.790535-1-kuba@kernel.org>
 <20220702031209.790535-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220702031209.790535-4-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 08:12:09PM -0700, Jakub Kicinski wrote:
> Summarize the rules we see broken most often and which may
> be less familiar to kernel devs who are used to working outside
> of netdev.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
