Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABAF4E2F9F
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351996AbiCUSIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 14:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345172AbiCUSHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:07:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F24D1717B7
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 11:06:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E658EB818DF
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 18:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF49C340E8;
        Mon, 21 Mar 2022 18:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647885983;
        bh=yK3ckp48ur2ukB/gTQd10l4/BWfFYv4xjg8IpwaljkA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vwgw6IRw0BmxwPDl0la68hfUkRuaxP0Bx2FsuaLLDV2nq86yjqBcvYaY3JpejZnlK
         PFUaEl24x3XonvqAGK7H/PNSYNBKntu6AWmF4CcGwjB+2Fa2kkf0pTlAWjHeJRdswZ
         sxZ9WVffRAxXitYbVGsBIvm8sOX6Yolsakmyf84KyzF4i27rmgyryV8y8vvVrKC311
         SOYkUNSKGvVQXkNDuweIcr7jG7ELOvJbTY0fG9OSY3KtUJgKG9Ool9JGxKVzJjLJ5t
         X8ZKYFevqaN4MtKzxzSAYZaAxlAi+hCTVR3XxPwT0VpLbEyT5g2xzVngkrQmgQEnlk
         RpmpCirVRpZ5A==
Date:   Mon, 21 Mar 2022 11:06:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        schultz.hans@gmail.com, razor@blackwall.org, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 0/2] selftests: forwarding: Locked bridge port
 fixes
Message-ID: <20220321110620.68253beb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <Yji7s4qjjEy/SSXx@shredder>
References: <20220321175102.978020-1-idosch@nvidia.com>
        <Yji7s4qjjEy/SSXx@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Mar 2022 19:53:55 +0200 Ido Schimmel wrote:
> On Mon, Mar 21, 2022 at 07:51:00PM +0200, Ido Schimmel wrote:
> > Two fixes for the locked bridge port selftest.  
> 
> Jakub, I'm aware that net-next is closed, but these are fixes for code
> in net-next. If you prefer, I can resubmit later this week after you
> merge master to net.

That's perfectly fine, I guess saying "net-next is closed" wasn't
very accurate on my side. It's still open for fixes.
