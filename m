Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A6C6D7139
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 02:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbjDEAYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 20:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjDEAYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 20:24:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEF349C6
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 17:24:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CDF76399F
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 00:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793F2C433D2;
        Wed,  5 Apr 2023 00:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680654245;
        bh=1M6cvLW0Xd/QG7c/z+xe00ry1BpvxevACez2MPuh+jM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F3Kxt6iNKdbueN4CosmmptKKb7bg2/KttdEdJcvYvg3SVxJDkNrxF4HsWavjDQOjj
         1ZGwfSHzUPsTCqnIublhv4DSonximWwuZvUAai192m9UDkASto/SLBwKe4jtqpebkE
         jfUPyk+oiZMLN1K1O+W/fPzcCIq9pqszHtTp37nnFuEKa5m3XL9xreIgavWe6Isf3O
         ljjJqYmZ/1RSn7f7dERWXc6aq7uyfdxFN6Qd82efQK3U2DR23bCoTYRvzhasQtZyKW
         8+Bmh6QKALNJVvNEV7w/V/CKOXEZFWwBNsdxGf+TXv/vPpx70inDkuc6hlUAHOecSB
         AGYLdX8yqVfyQ==
Date:   Tue, 4 Apr 2023 17:24:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever <cel@kernel.org>
Cc:     pabeni@redhat.com, edumazet@google.com, borisp@nvidia.com,
        netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev,
        john.haxby@oracle.com
Subject: Re: [PATCH v8 3/4] net/handshake: Add Kunit tests for the handshake
 consumer API
Message-ID: <20230404172404.335cac5c@kernel.org>
In-Reply-To: <168054757552.2138.13089316455964656033.stgit@klimt.1015granger.net>
References: <168054723583.2138.14337249041719295106.stgit@klimt.1015granger.net>
        <168054757552.2138.13089316455964656033.stgit@klimt.1015granger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 03 Apr 2023 14:46:15 -0400 Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> These verify the API contracts and help exercise lifetime rules for
> consumer sockets and handshake_req structures.

Does it build with allmodconfig for you?

error: the following would cause module name conflict:
  lib/kunit/kunit-test.ko
  net/handshake/kunit-test.ko
