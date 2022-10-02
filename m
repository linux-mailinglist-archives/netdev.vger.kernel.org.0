Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7625F2581
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 23:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiJBVmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 17:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiJBVmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 17:42:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FB41C124
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 14:42:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E63A660DEA
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 21:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1EAC433D6;
        Sun,  2 Oct 2022 21:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664746923;
        bh=IXmMubczJN6rs+A4XVJuRJjUwk8deXEQvx/WQTjyoak=;
        h=Date:From:To:Cc:Subject:From;
        b=ZTisASFhDajJsU6UzIPPqzc6nEi0aWOtpbxOGgL0PGAxSm9cDSyJ+Xw47h4xBlL9+
         QmAJ9sfwxnF11xGyH+HigQGIAEWe1NThLnGjD2vk+2Sma4MmNip/CwqBBBUP9Ch7hZ
         cKqjdCxT5/93fAySUHcry+AM2+zEusYx+dJ6L1G9f7I+szAgjFOOsnlKLD6cdsRYdL
         w9JY3rjmT7ICnTBOlTEHGqJcjYfdtxHgWBze/DKjaPHuXrZj1h73IAL6lJdy9tUsYX
         JPmq6EXVsLMw/zjMFhXZbrJbxx8zovAo6YWd9VldihP7TdRt+oH8hy+KwQhPL873r+
         zEpQkTNHGyqXA==
Date:   Sun, 2 Oct 2022 14:42:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: net-next is CLOSED
Message-ID: <20221002144202.38dcd284@kernel.org>
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

Hi!

Linus has tagged v6.0, so please defer posting new features,
re-factoring etc. until the 6.1 merge window is over.


BTW we're always open to feedback about the process, if you think
the merge window closure is counter-productive - please LMK.
I asked around some time ago and the answers ranged from
"don't care" to "closures are useful".
