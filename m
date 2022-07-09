Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8476356C67E
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 05:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiGIDl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 23:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGIDl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 23:41:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B7B820D9;
        Fri,  8 Jul 2022 20:41:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51EF46273C;
        Sat,  9 Jul 2022 03:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4410BC341C0;
        Sat,  9 Jul 2022 03:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657338114;
        bh=JFaD4EhWcIg0SjtZJljxbEn4FacUlXxE34nZHrfBjrg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kKiqxNcJLXQlr63Of5uWK6Xq3IpBPkknAcTRstoLKIfD+2ufUhWNixIA40Gr+4Zs+
         7J/OM/coxOD1ZLa4p9QXjByCBbVyIsySgE7O98sIJz1MyQQ3kfljq2qOh6VgJ4l73z
         QoqlVLxbC5nJqlrhkJBA9RC2EftBT6R5siKeKVUSHBFfB2SH3aEImhR9bHDh3Jv4rz
         8I/JEFcx++gdpuWPc6z/PN4bF/r//kHfBJHUrLqPlJEf2qnZl9slgISsp2B/ZVyxp5
         8s/klcKnAvSMOQqXUiOFmlDEW0APXlqzkv/6Ww2uBgEWV16YCXwKs6IybBxgVpL8fQ
         zQedhzJRckqgA==
Date:   Fri, 8 Jul 2022 20:41:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, razor@blackwall.org,
        Long Xin <lxin@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/2] bond: add mac filter option for
 balance-xor
Message-ID: <20220708204153.0a4ce4ab@kernel.org>
In-Reply-To: <1755bbaad9c3792ce22b8fa4906bb6051968f29e.1657302266.git.jtoppins@redhat.com>
References: <1755bbaad9c3792ce22b8fa4906bb6051968f29e.1657302266.git.jtoppins@redhat.com>
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

On Fri,  8 Jul 2022 14:41:56 -0400 Jonathan Toppins wrote:
> Implement a MAC filter that prevents duplicate frame delivery when
> handling BUM traffic. This attempts to partially replicate OvS SLB
> Bonding[1] like functionality without requiring significant change
> in the Linux bridging code.

You can't post the user space patches in the same series, patchwork
will think they are supposed to be applied to the same tree. Post them
separately please, they'll land on the list next to each other if you
send them at the same time, that's good enough.

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#how-do-i-post-corresponding-changes-to-user-space-components
