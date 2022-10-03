Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F595F39F2
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 01:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiJCXkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 19:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiJCXkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 19:40:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5188EE92;
        Mon,  3 Oct 2022 16:39:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3703B61070;
        Mon,  3 Oct 2022 23:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03ACEC433C1;
        Mon,  3 Oct 2022 23:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664840398;
        bh=BdDmn/tBMHEUzOzeye2K3yXjRAgX2JNv9LtWU1Qkbp0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oHJ73VvMhk7vjRqEQcCk2XsIxXOLivpiq/DI2xh+kvyJncFxLnCOMLyQCSeYVusuh
         uU6Hin6NkmdgT0mz/gEWQrQGuYjl6n/gPfZpKn5sMfJd/rlDsu4tj3u8KzmvVlerbr
         6C8UhDXmnySKmqPcmKIJpyFsVRBUNkw+2yrPiOqQLpg7tbm5Iwj6loAxRTC/aP0GmL
         dxdiWgcYH8jR63UDgwFv/b0ibpXWfXC3/TLhMTUMujRAFpZ0QmmpjTnzA1rtUWPwoy
         iJH3+Ynao4ON7/tdX2qcQFoN4u35CINrjeRnWIyIBuJBf/WHHzknsOXYstg+3eU0zx
         Lsj7eTNy7IUjQ==
Date:   Mon, 3 Oct 2022 16:39:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     davem@davemloft.net, decui@microsoft.com, edumazet@google.com,
        error27@gmail.com, haiyangz@microsoft.com, kys@microsoft.com,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, pabeni@redhat.com, sthemmin@microsoft.com,
        trix@redhat.com, wei.liu@kernel.org
Subject: Re: [PATCH v2] net: mana: Fix return type of mana_start_xmit
Message-ID: <20221003163956.080534f0@kernel.org>
In-Reply-To: <20220929181411.61331-1-nhuck@google.com>
References: <20220919182832.158c0ea2@kernel.org>
        <20220929181411.61331-1-nhuck@google.com>
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

On Thu, 29 Sep 2022 11:14:11 -0700 Nathan Huckleberry wrote:
>  include/net/mana/mana.h                       | 2 +-

This file does not exist in the net-next tree :S
Perhaps it was created when RDMA support was added?
Anyway, repost in a couple of weeks, it should all be straightened out
after the merge window.
