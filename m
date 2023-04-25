Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB46E6EE4DD
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 17:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbjDYPiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 11:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233959AbjDYPip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 11:38:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF076CC39;
        Tue, 25 Apr 2023 08:38:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A563625B2;
        Tue, 25 Apr 2023 15:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D0BC433EF;
        Tue, 25 Apr 2023 15:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682437123;
        bh=vT2ctdarV+29c2RVxncwRb2R02GQQfX40TXp5B+gZds=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZHVzhAmIh3NxezUn1x3PZtgG2gVM/Y3wbHRPaR/XluM4QN4x+pGsLn5kqymU//TgF
         s0WblkuUm26H1uuQkWFrZb4RcaD7bClDE262jJJJQhjck5xw6WNcy3STIUuWSSyw1C
         UkCnBm9jMO8TBknRqdfbo1fQcl6zMJJDdF1Zy3EfTCN9mMyLBYZ5o+pui0ZRBkKcoL
         mOIxqxjxZYNfH7uU3Wa2JhGMouVuMuAoNILv8AnLEUVHfcNLFrIKnMgVCkXQRdWDZH
         N0a0GSfj/7pQJHbBP7trzl51s2F5ts1nj5gbUDzy0awAYQBddQOk6GxETdrgOnurJC
         Kg5XK+YpA8GJg==
Date:   Tue, 25 Apr 2023 08:38:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     cchoux <chou.cosmo@gmail.com>
Cc:     sam@mendozajonas.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cosmo.chou@quantatw.com
Subject: Re: [PATCH] net/ncsi: clear Tx enable mode when handling a Config
 required AEN
Message-ID: <20230425083842.65873403@kernel.org>
In-Reply-To: <20230425133014.1203602-1-chou.cosmo@gmail.com>
References: <20230425133014.1203602-1-chou.cosmo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Apr 2023 21:30:14 +0800 cchoux wrote:
> Clear the channel Tx enable flag before reconfiguring the channel
> when handling a Configuration Required AEN. To avoid misjudging that
> the channel Tx has been enabled, which results in the Enable Channel
> Network Tx command not being sent during channel reconfiguration.
> 
> Signed-off-by: cchoux <chou.cosmo@gmail.com>

Please add a Fixes tag pointing to the commit which introduced 
the problem.

Please use your legal name like you would for signing a legal document
(all UTF-8 characters are allowed).

-- 
pw-bot: cr
