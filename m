Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC315960A5
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 18:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236661AbiHPQ4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 12:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiHPQ4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 12:56:02 -0400
X-Greylist: delayed 599 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 16 Aug 2022 09:56:01 PDT
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7027A53E;
        Tue, 16 Aug 2022 09:56:01 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1660667963; bh=Cpep50bBsl3EKKvdNAywi37Bu/EoeXf5XyFEV+YxBmM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=BvMCqMuOoppf4gCJsutQ36g28L+WKA1kqc+jgarufGgnIanrX09diiBBXeMxsZy91
         bmtgSlcHA9jR98EXbyQNpOl0dYhlu3Zez+kpND8UWuF+FB9E/yXCCKRYUDvB7n37iO
         D4tnxYMVlkFD/cYWlvBpbHKR4VutKv9ikIXV4STqr/iajvBpvSSpp9Be+LWgA1dk5t
         8Cxr30H+2sAx5Bv6itV9X7N+TnjspFEqFdil03J+I9m4V0QlEKXoT241qcdwvyFHi8
         i2Aq02YGZoNSr+pJNa4u8Zcbx3sux6EHE5S9+XD6tppT8uC7lIgiDairONwq9b0sgb
         E9WY7qMCs1auA==
To:     Jilin Yuan <yuanjilin@cdjrlc.com>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: Re: [PATCH] wifi: ath9k: fix repeated words in comments
In-Reply-To: <20220709123724.46525-1-yuanjilin@cdjrlc.com>
References: <20220709123724.46525-1-yuanjilin@cdjrlc.com>
Date:   Tue, 16 Aug 2022 18:39:23 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87y1vouoqs.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> writes:

>  Delete the redundant word 'the'.
>  Delete the redundant word 'to'.
>
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
