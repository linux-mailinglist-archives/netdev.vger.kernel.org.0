Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066DE5F7C39
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 19:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiJGR2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 13:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiJGR2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 13:28:35 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B5ECA89B;
        Fri,  7 Oct 2022 10:28:31 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1665163709; bh=yWWstJ0SxaiWCJ8yChG5yXzzTd8E+OEk2k17cMD7mTk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ni9bjdb2lOBzjWg5bkIRVl0/gKyrMjH8L5J3acubVv3okw75RWwz9hnqYNlgTgXEv
         Suorg0BCQFLYRWDSKyDVR5SRmXmgt/nsxbMPgoQyVaf7ARP5NW/G+ofmX05XSNg2OC
         HDoflgzMRWYFSAeluVH3Qnxz7jBrRKS4Yi2cTOTTCSKxuSmzZYFK4XwzyZeU7RCYV/
         NE7cIpy/EmprBughiCigylajlUPVUsI0BxpWC4/7YMrO2rZXCudeFJpRRo09GV5sPM
         GcyUPj9jVE8pugnlpteHKWz3n62wC9l296uTZFBOhmXwcvzlJ1euQ9sC2CaoZfkciq
         j30VVJOaEbKZQ==
To:     Kees Cook <keescook@chromium.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] ath9k: Remove -Warray-bounds exception
In-Reply-To: <20221006192054.1742982-1-keescook@chromium.org>
References: <20221006192054.1742982-1-keescook@chromium.org>
Date:   Fri, 07 Oct 2022 19:28:29 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87r0zjczlu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> GCC-12 emits false positive -Warray-bounds warnings with
> CONFIG_UBSAN_SHIFT (-fsanitize=3Dshift). This is fixed in GCC 13[1],
> and there is top-level Makefile logic to remove -Warray-bounds for
> known-bad GCC versions staring with commit f0be87c42cbd ("gcc-12: disable
> '-Warray-bounds' universally for now").
>
> Remove the local work-around.
>
> [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D105679
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
