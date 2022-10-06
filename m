Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1465F6A12
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 16:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiJFOzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 10:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiJFOzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 10:55:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F4456BAF;
        Thu,  6 Oct 2022 07:55:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF596619F1;
        Thu,  6 Oct 2022 14:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE9BC433D7;
        Thu,  6 Oct 2022 14:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665068139;
        bh=dLq5D/qgv/59SSQ/s6M3hGdW2DjTG1Phn12fm/hQkvo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BxAKOWXkC4Ih2F8J5m0tQ+hGphMmNxA7EaBGSjs5IkdiRtsaimxZzvH3iswYQ3vrJ
         iMMgkb/2qtIIUKFqSa5XnpvYVcjKXar48s2KAeIqtNJDdQ9IGS5ezWNCLNqG3dRXqN
         H986NosHRXXeOqyzCa3NWw4TxCsmM8ZRIczIUlGbatsE1tWuThy/UQE6oCYO1DUx/U
         Y5tA1Bs0YGPo8zd8RrvY4Ak3ZqNkVUPLwJXvmxa2+TI21TXneIDoPjgrLU59axmgSj
         r+8ihPlzkMjzOZflr8EUgqKrzLkQkqWU7qIpQ6+oUrZtdhzTh1BbYhZrs8/hGrqNyC
         9JVK1/n+9AZ6Q==
Date:   Thu, 6 Oct 2022 07:55:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, stephen@networkplumber.org, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v2 3/7] net: add basic C code generators for
 Netlink
Message-ID: <20221006075537.0a3b2bb2@kernel.org>
In-Reply-To: <20221006125109.GE3328@localhost.localdomain>
References: <20220930023418.1346263-1-kuba@kernel.org>
        <20220930023418.1346263-4-kuba@kernel.org>
        <20221006125109.GE3328@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Oct 2022 14:51:09 +0200 Guillaume Nault wrote:
> > v2: - use /* */ comments instead of //  
> 
> Probably not a very interesting feedback, but there
> are still many comments generated in the // style.

It's slightly unclear to me what our policy on comments is now.
I can fix all up - the motivation for the change in v2 was that
in uAPI apparently its completely forbidden to use anything that's 
not ANSI C :S

Gotta keep that compatibility with the all important Borland compiler
or something?
