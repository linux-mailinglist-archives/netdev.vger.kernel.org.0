Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63AD85BD94B
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiITBU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiITBU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:20:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2854F3B9
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 18:20:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FEF2B8197C
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABE1C433D6;
        Tue, 20 Sep 2022 01:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663636854;
        bh=l6DwE8ZHpEiAYC0CldgjsnYuiIu2fCd187S6VVQztqg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EKntulz78hq7GvtjD8DlZn2Ksp2tQRBh3huzsc/e1kU6Sdn48ExCqXdkengnUGeFF
         Yr1zQ+RoaZtJVsIIHhpNZ3f3+HArPdyZ1lqPecLignpbxujpKHWrMH611TzLTaR4Gf
         IKhsvcDoHLt1Exf5RSgNqdI6DDgJcmR88jGIzMZIJW1niMlTaNRSv03UkkBy8f+pcp
         ZIhAkH2eCRCLqHe2J6NBp0wQamzqXMBkCAXMGO14Zq4e7FJSGzoLOLQYl7BayCZyS1
         jUkgwmVoPfT7Gz2JK70sZpIVD1Xw68nI5a1z/NWQKQbq3sr5P24F2CWy+oUQMGhYnn
         3Ze9OVA9p6tDw==
Date:   Mon, 19 Sep 2022 18:20:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     pablo@netfilter.org, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/3] wireguard patches for 6.0-rc6
Message-ID: <20220919182053.2936e7e4@kernel.org>
In-Reply-To: <20220916143740.831881-1-Jason@zx2c4.com>
References: <20220916143740.831881-1-Jason@zx2c4.com>
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

On Fri, 16 Sep 2022 15:37:37 +0100 Jason A. Donenfeld wrote:
> Sorry we didn't get a chance to talk at Plumbers. I saw some of you very
> briefly in passing but never had the opportunity to chat. Next time, I
> hope.

Indeed!

> Please pull the following fixes:

You say pull but you mean apply, right?
