Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61104AEF0F
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 11:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbiBIKPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 05:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiBIKPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 05:15:44 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D712E088F9B;
        Wed,  9 Feb 2022 02:12:06 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id ADBE7601BF;
        Wed,  9 Feb 2022 11:08:30 +0100 (CET)
Date:   Wed, 9 Feb 2022 11:08:37 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] selftests: netfilter: fix exit value for
 nft_concat_range
Message-ID: <YgOSpXdxuZ07zJH4@salvia>
References: <20220209082551.894541-1-liuhangbin@gmail.com>
 <20220209105735.5cefed1d@elisabeth>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220209105735.5cefed1d@elisabeth>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 10:57:35AM +0100, Stefano Brivio wrote:
> On Wed,  9 Feb 2022 16:25:51 +0800
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> > When the nft_concat_range test failed, it exit 1 in the code
> > specifically.
> > 
> > But when part of, or all of the test passed, it will failed the
> > [ ${passed} -eq 0 ] check and thus exit with 1, which is the same
> > exit value with failure result. Fix it by exit 0 when passed is not 0.
> 
> Oops, right, thanks for fixing this!
>  
> > Fixes: 611973c1e06f ("selftests: netfilter: Introduce tests for sets with range concatenation")
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

Applied, thanks
