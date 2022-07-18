Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9B4578CF6
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 23:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236016AbiGRVij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 17:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236252AbiGRVi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 17:38:26 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E67F332EEE;
        Mon, 18 Jul 2022 14:38:10 -0700 (PDT)
Date:   Mon, 18 Jul 2022 23:38:02 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Justin Stitt <justinstitt@google.com>
Cc:     nathan@kernel.org, coreteam@netfilter.org, davem@davemloft.net,
        edumazet@google.com, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, ndesaulniers@google.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pabeni@redhat.com, trix@redhat.com
Subject: Re: [PATCH v2] netfilter: xt_TPROXY: remove pr_debug invocations
Message-ID: <YtXSuqVZ7160Kyls@salvia>
References: <Ys3DwnYiF9eDwr2T@dev-arch.thelio-3990X>
 <20220712204900.660569-1-justinstitt@google.com>
 <CAFhGd8p2o45-mw50=4dPxmpKe5kZf2t_p=vpy7T5vZt3VUkYiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFhGd8p2o45-mw50=4dPxmpKe5kZf2t_p=vpy7T5vZt3VUkYiA@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 10:43:17AM -0700, Justin Stitt wrote:
> Any chance a maintainer could take a look at this patch? I am trying
> to get it through this cycle and we are so close to enabling the
> -Wformat option for Clang. There's only a handful of patches remaining
> until the patch enabling this warning can be sent!

I'll place this into nf-next, thanks.
