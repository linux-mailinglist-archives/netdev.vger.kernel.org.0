Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7F0558F10
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 05:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiFXD0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 23:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiFXD0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 23:26:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A04562BD1
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 20:26:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA12D62071
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 03:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E940EC3411D;
        Fri, 24 Jun 2022 03:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656041164;
        bh=bN/8lOhpgq2Z2d/gHJUJiDE7qE9Y1Tkj9M7vrz/1af8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V0h52rPvc/A6MZuaOog27K+qKydo/wcZ4y25ncQGOx0CNrIQ6Z0gBv+VM0GgnH+92
         c444rXzPUk9RpxoR7wfYuIEmfIgzLac/m9W1wwn4HCexecpEjQsNvfLlT8iLz+lRvk
         Vc8mB77TyIESIRARD2Z09mF6Z28EnyxO9wTbQgnxot+62DvAHBPoZjzhfcOWCnJQNA
         aiFhFMcYH5jKJp+idH3WZRQPxdC20MUQcsPEG59YBAtkLnNdlcdaYS1OxNJ3MggcYi
         YqPhVE+dZvK7bGo0PNDrHFWK6IDON/D3GJDBsOh0E0Igtih1V2Jxv2nEsyLM1Rxyk0
         sQ1VpMY3RBM3g==
Date:   Thu, 23 Jun 2022 20:26:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksey Shumnik <ashumnik9@gmail.com>
Cc:     netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, xeb@mail.ru
Subject: Re: [PATCH] net/ipv4/ip_gre.c net/ipv6/ip6_gre.c: ip and gre header
 are recorded twice
Message-ID: <20220623202602.650ed2e6@kernel.org>
In-Reply-To: <CAJGXZLiNo=G=5889sPyiCZVjRf65Ygov3=DWFgKmay+Dy3wCYw@mail.gmail.com>
References: <CAJGXZLi_QCZ+4dHv8qtGeyEjdkP3wjoXge_b-zTZ0sgUcEZ8zw@mail.gmail.com>
        <20220622171929.77078c4d@kernel.org>
        <CAJGXZLiNo=G=5889sPyiCZVjRf65Ygov3=DWFgKmay+Dy3wCYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jun 2022 16:51:31 +0300 Aleksey Shumnik wrote:
> > What socket type is the ping you have using?  
> 
> I use SOCK_DGRAM

Strange.

> > The patch looks strangely mangled, it's white space damaged and refers
> > to a net/inv6 which does not exist.
> >
> > Could you regenerate your changes using git? git commit / format-patch
> > / send-email ?  
> 
> Thanks a lot for the answer!
> I want to find out, the creation of gre and ip header twice, is it a
> feature or a bug?

I can't think why that'd be a feature. Could add this case to selftests
to show how to repro and catch regressions?

> I did everything according to the instructions, hope everything is
> correct this time.

Nope, still mangled.
