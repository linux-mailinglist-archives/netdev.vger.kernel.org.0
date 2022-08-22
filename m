Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C720C59C64C
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 20:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237462AbiHVS3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 14:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237428AbiHVS3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 14:29:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7FD491EB;
        Mon, 22 Aug 2022 11:29:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5A63612E1;
        Mon, 22 Aug 2022 18:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D120EC433D6;
        Mon, 22 Aug 2022 18:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661192945;
        bh=IMCeyXXrBOj3Ewl3VpH2R0sDkfVZJa75q1Lm8zm11k4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BtsuogQKT9YjKHgFv8Nw1oSmRPGHZFpicp2H8mmL133HuZ0Kd79lUZMRm1kxOQQib
         Q/kBNVKzvzfEI/LZz9C7LAK5BiTIE2u9rZkHNwBrQWqhfFNKwYg2MeBaOM+AAwbQB3
         7OnhnN2tO1dNqEHpyFd4v6Bqh6daPKQQyzqg56L58pn/XKYiXtPh1C3GkE0aL/FF7S
         kykjhhExKmhgPlsCWYza3FtGFAaV7AUWrqhDOpUNpxMVPU5iXc8dKYrcUTqlm5CZQH
         gddEmPwSYZKTknUOqxLX6uHsnzoBElhQAybjAyqcsGvwI9W4jijH+yg0BVX5lg4Ue5
         IO20dWRskZnGQ==
Date:   Mon, 22 Aug 2022 11:29:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Axel Rasmussen <axelrasmussen@google.com>
Cc:     Andrei Vagin <avagin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Kees Cook <keescook@chromium.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH] selftests: fix a couple missing .gitignore entries
Message-ID: <20220822112903.20ece35f@kernel.org>
In-Reply-To: <CAJHvVcgfdkrQSsoenyanjtuav9OK4w9YKVqinUiMrkvdgtB4sg@mail.gmail.com>
References: <20220819190558.477166-1-axelrasmussen@google.com>
        <20220819160752.777ef64b@kernel.org>
        <CAJHvVcgfdkrQSsoenyanjtuav9OK4w9YKVqinUiMrkvdgtB4sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Aug 2022 09:17:57 -0700 Axel Rasmussen wrote:
> > Could you make the io_uring test the first in the file?
> > That'd gets us closest to the alphabetical ordering (I know the file is
> > not ordered now, but we should start moving that way).  
> 
> It isn't that it's mostly ordered with a few exceptions, to me it
> looks entirely random. I don't mind moving the one I'm adding but, I'm
> not sure it gives much value given that.
> 
> Would folks object to just adding a second commit to this which sorts
> the file? Since this file isn't changed frequently, I would say the
> risk of annoying conflicts is pretty low.

It's a major source of conflicts for us, because everyone adds at 
the end but patches may come in via multiple trees and pull requests.

I'm not opposed to the sort tho, maybe it's best to rip the band-aid
off once and for all.
