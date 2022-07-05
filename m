Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F85D56779E
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 21:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbiGETSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 15:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbiGETSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 15:18:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BC51CFCA;
        Tue,  5 Jul 2022 12:18:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B806CCE1CE0;
        Tue,  5 Jul 2022 19:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35C0C341C7;
        Tue,  5 Jul 2022 19:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657048724;
        bh=dxxPBTrIr8LlmVOjm6ZVTeXFYsXW0IGM4q15HzqnaVA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kEtrnUxFrNsrHlNYiCq3VpUVneNB6uwXx2DwlyhYxtmlzdt2hwztLawpPk24rcrUa
         rMDQhRIVDaS8EKyTf3DA2MDTz/HsHszATeLRfmYYQXNtaK4GpGulpjxA57EzQaRSD/
         WFVrPiC5Aorb8fDjoqol4b4li6WPfI8op0PYt7BkWDwYXZ8f520uffojzDmEKJT4Ym
         Qob4STur2qvMfYGnjNi+hp6y57rsOngSKiMfiI0Y6ZlIKSicOIvWD+JPNbKlli73KW
         J5ATF9baWXIkBdP+uscUUJJsWQXuOZfETlzrqFwXgBL8zXXbKVarialepQG1UCPQlY
         AfqoRoKdJUj/w==
Date:   Tue, 5 Jul 2022 12:18:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/ipv4/ipv6: Use static array for name field
 in fib*_lookup_table event
Message-ID: <20220705121843.5377b447@kernel.org>
In-Reply-To: <20220705100041.01a8c184@rorschach.local.home>
References: <20220704091436.3705edbf@rorschach.local.home>
        <38135333-b277-1b1b-8346-1da2e1f114a7@gmail.com>
        <20220705100041.01a8c184@rorschach.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Jul 2022 10:00:41 -0400 Steven Rostedt wrote:
> On Mon, 4 Jul 2022 13:09:01 -0600
> David Ahern <dsahern@gmail.com> wrote:
> 
> > >  include/trace/events/fib.h  | 6 +++---
> > >  include/trace/events/fib6.h | 8 ++++----
> > >  2 files changed, 7 insertions(+), 7 deletions(-)
> > >     
> > 
> > Reviewed-by: David Ahern <dsahern@kernel.org>
> >   
> 
> Is everyone OK if I take this through my tree then?
> 
> I'm fine if it goes through net-next too.

Slight risk of conflicts there if someone decides to add another FIB
trace point, but seems unlikely so feel free to take it:

Acked-by: Jakub Kicinski <kuba@kernel.org>
