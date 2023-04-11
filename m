Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFCC86DE662
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 23:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjDKVVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 17:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjDKVVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 17:21:08 -0400
Received: from out-8.mta0.migadu.com (out-8.mta0.migadu.com [IPv6:2001:41d0:1004:224b::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D5610E3
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 14:21:04 -0700 (PDT)
Date:   Tue, 11 Apr 2023 14:20:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681248062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ix+xTKLRyryO0kML26qRvChiIo9OGMDZjWZ1lxLLx9Q=;
        b=fM9p+0inVptO2bEu5CpucNL5vQK7/2aItlM1bTjn8GGhPOx7fyzLhLE4ikio4htJhPuPQ4
        imHlHsAqctsfFG6HAYN7j42YljHLsC3kDz+1LTWayjxntXD9nDCUEMvQSI5o6Kd+Jbyrwh
        gHbZFLysyIHBZ5pATrD9ylRlhUFh8p8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Conor Dooley <conor@kernel.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Rafal Ozieblo <rafalo@cadence.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com
Subject: Re: [PATCH net] net: macb: fix a memory corruption in extended
 buffer descriptor mode
Message-ID: <ZDXPLtmzG0+3uZAV@P9FQF9L96D.corp.robot.car>
References: <20230407172402.103168-1-roman.gushchin@linux.dev>
 <ZDWk8vjvk7HO4I7o@P9FQF9L96D.corp.robot.car>
 <20230411-turbulent-caddie-de82cf1a0f8f@spud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411-turbulent-caddie-de82cf1a0f8f@spud>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 07:30:00PM +0100, Conor Dooley wrote:
> On Tue, Apr 11, 2023 at 11:20:34AM -0700, Roman Gushchin wrote:
> > Friendly ping.
> 
> Nicolas and Claudiu look after the macb stuff, it's a good idea to CC
> the people that get_maintainer.pl says are supporters of the code!

My fault, probably I was too happy to finally find it :)

> 
> > Also cc'ing Dave.
> 
> +CC Nicolas & Claudiu ;)

Thank you, appreciate it!
