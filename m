Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC74F686538
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 12:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbjBALSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 06:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbjBALSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 06:18:02 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D9F93AA5;
        Wed,  1 Feb 2023 03:18:02 -0800 (PST)
Date:   Wed, 1 Feb 2023 12:17:58 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc:     "leon@kernel.org" <leon@kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "fw@strlen.de" <fw@strlen.de>, "joe@perches.com" <joe@perches.com>,
        "kadlec@netfilter.org" <kadlec@netfilter.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH v2] netfilter: conntrack: remote a return value of the
 'seq_print_acct' function.
Message-ID: <Y9pKZkEzkqypHdB2@salvia>
References: <Y86Lji5prQEAxKLi@unreal>
 <20230123143202.1785569-1-Ilia.Gavrilov@infotecs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230123143202.1785569-1-Ilia.Gavrilov@infotecs.ru>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 02:31:54PM +0000, Gavrilov Ilia wrote:
> The static 'seq_print_acct' function always returns 0.
> 
> Change the return value to 'void' and remove unnecessary checks.
> 
> Found by InfoTeCS on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.

Applied, thanks
