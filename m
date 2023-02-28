Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C956A512B
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 03:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjB1C2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 21:28:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjB1C2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 21:28:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53037AD2F;
        Mon, 27 Feb 2023 18:28:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01D8EB80DBA;
        Tue, 28 Feb 2023 02:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457A7C433D2;
        Tue, 28 Feb 2023 02:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677551281;
        bh=6zoo61Dd2gg6AdVxouDpWeKtKpIQnukTEcoBizZHxMg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m71IIWLVVOp17fvXn45xnup3k1dJiZd4EE6DGSaGjdtEe9FGbQLf0XllAkQctk+ur
         DSm5G15Pc1ijWe7+6ztQqls6t3egS+qF6AqAyoRXIqluViOwT7O+lrWvyzECVrAk9D
         AMs0UGBdbdeaAUjzoMe5D1gkWTIebVNnQfKgIRGSLDhXWXKpo3b8J8Pr76kug5FVKX
         nyWbdH3z5LAeHX9rTiAPyb7hqnySP+LlJeQn+XizhC3c1/HQEnCSa5LaFWaA9iRp0L
         VvHSkZDZUW6IRLLV0/ZwHLUoZhCVPxbsq3iPE344v0wWKQlrPji1+EoItW6R1VqZJ7
         GFGhC6GbSeocw==
Date:   Mon, 27 Feb 2023 18:28:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shigeru Yoshida <syoshida@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+b563d33852b893653a9e@syzkaller.appspotmail.com
Subject: Re: [PATCH net] net: caif: Fix use-after-free in
 cfusbl_device_notify()
Message-ID: <20230227182800.02ddf83f@kernel.org>
In-Reply-To: <20230225182820.4048336-1-syoshida@redhat.com>
References: <20230225182820.4048336-1-syoshida@redhat.com>
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

On Sun, 26 Feb 2023 03:28:20 +0900 Shigeru Yoshida wrote:
> syzbot reported use-after-free in cfusbl_device_notify() [1].  This
> causes a stack trace like below:

Please repost with the correct fixes tag, presumably:

Fixes: 7ad65bf68d70 ("caif: Add support for CAIF over CDC NCM USB interface")

Please make sure you CC the authors of that commit.
