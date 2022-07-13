Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED68572A3A
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 02:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiGMAZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 20:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiGMAZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 20:25:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2835CD3DD;
        Tue, 12 Jul 2022 17:25:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E59FB81C21;
        Wed, 13 Jul 2022 00:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A4CC3411C;
        Wed, 13 Jul 2022 00:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657671925;
        bh=1YNcoWIS2y1EJK6xuFFvvK029UyYEWCxaYb0oiKwI/8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=klxNbggvF4MOAuWRX4NIgpT9Ay/jnvrJ4elv2a0bMFOqyTbPqbEvOe0ttHeqyd1gM
         /aOQwj+HFqo9vHCv5ob1Scq8AM5zI/qQitHQITiPT9Tx/ktAopL9dmnGtJb8mfa46d
         W3TyllWUGmeKjcQtNN1Dp31p0911oO1DXvbMckXtObq+ueqF29YEmFPgYRfHYR8j0A
         CRAA2Pbg7S9N+HzYC+J9qAwhJQhUgn1ATRpILZnMFrnVAYtpb/D4nyjpHifhonjjv3
         22L6qwtZStcqNblkU7v+CtpWXPpQB+VQEkwpxbdZteB+eLpn1oLWL5mMrNPxmbD8m6
         XDNYruS5hJDYA==
Date:   Tue, 12 Jul 2022 17:25:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net v2 2/2] selftests/net: test nexthop without gw
Message-ID: <20220712172515.126dc119@kernel.org>
In-Reply-To: <Ys1JefI+co1IFda4@kroah.com>
References: <9fb5e3df069db50396799a250c4db761b1505dd3.camel@redhat.com>
        <20220712095545.10947-1-nicolas.dichtel@6wind.com>
        <20220712095545.10947-2-nicolas.dichtel@6wind.com>
        <Ys1JefI+co1IFda4@kroah.com>
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

On Tue, 12 Jul 2022 12:14:17 +0200 Greg KH wrote:
> On Tue, Jul 12, 2022 at 11:55:45AM +0200, Nicolas Dichtel wrote:
> > This test implement the scenario described in the previous patch.  
> 
> "previous patch" does not work well when things are committed to the
> kernel tree.  Please be descriptive.

And please don't resend your patches in reply to the previous version.
Add a lore link to the previous version in the commit message if you
want. In-reply-to breaks the review ordering for us :/
