Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B57538732
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 20:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241725AbiE3SUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 14:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240338AbiE3SUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 14:20:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A9DA30A1;
        Mon, 30 May 2022 11:20:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABCDF60A53;
        Mon, 30 May 2022 18:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69F6C385B8;
        Mon, 30 May 2022 18:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653934842;
        bh=Hc3v6vdkkxDNH9P1ieO6s1ciu8KhYr8gtAxQLKPMimw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XT441zRAvC/1owmtuGoqO6WhidhsFdKIOSl/NUSDeR9Nnwo49A/AFx2yXKeqSGZaZ
         l+OHT58o+mv4nGNzIgfCXXPUDXpQi5nWCl8ORKVgG3Pml0Y9dPchWBVw4lFe5ERz7A
         WKuNyDgyjVQo8HknhY9xUZxW+T0MkpnntiW7EO4OO0+jA7Dx7Ey1YELb40My5wJUrI
         lxfAupAdGJJUk2Geqs+64zElJAnh9LDEnZrUZ6FAAZw5Dw40aoVVZIQG/GOCZgf0YG
         l0mBY/aArdY6hkH5JoG/jyFti9BV/c674o3qycEgOYv+/kyFhDzx8Y9m5RlpVbt7rf
         mDqnU/2szUyng==
Date:   Mon, 30 May 2022 11:20:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] xen/netback: do some code cleanup
Message-ID: <20220530112040.43871e04@kernel.org>
In-Reply-To: <20220530114103.20657-1-jgross@suse.com>
References: <20220530114103.20657-1-jgross@suse.com>
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

On Mon, 30 May 2022 13:41:03 +0200 Juergen Gross wrote:
> Remove some unused macros and functions, make local functions static.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>

# Form letter - net-next is closed

We have already sent the networking pull request for 5.19
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.19-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
