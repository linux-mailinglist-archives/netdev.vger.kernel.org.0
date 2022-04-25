Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6EA50EB37
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 23:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245719AbiDYVT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 17:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243355AbiDYVT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 17:19:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808CF1BE97;
        Mon, 25 Apr 2022 14:16:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 195A261446;
        Mon, 25 Apr 2022 21:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C828DC385A7;
        Mon, 25 Apr 2022 21:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650921380;
        bh=hYLOMTe1/Z2MH6N3yk6aVKeMHTDRSg9Z2C4T2OGqECc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=hwaE9jDaUpBkOfLikisxRqEQgrwvFHBLfDX94LCe6d9c+B89thcG5+fzwWzRgnd4F
         UqUXrmcbmYubtRf7FE8Jwkk5GeEGdqgd1W0d9M3Ortq26Qx+Pzo3/WPJEIVTC7WQXV
         UqJS35401jf9zTe5lsxkUy0T166bIgMuSSN7lwxzplqPNpJ/wNdQpLoMCC6TtgHccT
         M0cMO7eNzOkzlE9ZBqaO/uL2DyV2iLpQzQsHCdz5Ps55sIkShx2Z0vt3n4IP50CnBE
         Hd2GnEAYbJXgRkBeNmR+2LIgqx7mu2Vli7MtwrWAnKBbTjJt82hvzuQRfEDmUCGo1Y
         JC8dirsrUmtgw==
Date:   Mon, 25 Apr 2022 16:16:17 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Rich Felker <dalias@libc.org>, linux-ia64@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Chas Williams <3chas3@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Paul Mackerras <paulus@samba.org>,
        Matt Turner <mattst88@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        "David S . Miller" <davem@davemloft.net>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH 0/7] Remove unused SLOW_DOWN_IO
Message-ID: <20220425211617.GA1658400@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422104828.75c726d0@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 10:48:28AM -0700, Jakub Kicinski wrote:
> On Fri, 15 Apr 2022 14:08:10 -0500 Bjorn Helgaas wrote:
> > From: Bjorn Helgaas <bhelgaas@google.com>
> > 
> > Only alpha, ia64, powerpc, and sh define SLOW_DOWN_IO, and there are no
> > actual uses of it.  The few references to it are in situations that are
> > themselves unused.  Remove them all.
> > 
> > It should be safe to apply these independently and in any order.  The only
> > place SLOW_DOWN_IO is used at all is the lmc_var.h definition of DELAY,
> > which is itself never used.
> 
> Hi Bojrn! Would you mind reposting just patches 1 and 3 for networking?
> LMC got removed in net-next (commit a5b116a0fa90 ("net: wan: remove the
> lanmedia (lmc) driver")) so the entire series fails to apply and therefore 
> defeats all of our patch handling scripts :S

Sure, coming up, with reduced cc: list.
