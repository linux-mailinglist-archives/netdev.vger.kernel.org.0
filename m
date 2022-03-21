Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F404E2784
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 14:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347854AbiCUNcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 09:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347852AbiCUNcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 09:32:39 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF9A39813;
        Mon, 21 Mar 2022 06:31:10 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1647869468; bh=binKQXnygUeDIwX85AeWniJcFHJbbpE5qFWskAw4UEA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=FGmkdVLCp4kjXzO/AhH5ezD7Y/9s+M5P9+NISWPTjdGHWK2bzXQNvo6slsgkrZmcq
         dRh+jcOZhweKWLHzee4L7r5ZlOslGWPWNqZOcd6CqsYglIgs4TaouRyIp7C4sJT23Y
         JA6JxiUQmTBixY7egzwckMpp8ljYpxn9Olt2Hqmuss8evmwTTi+qFf23EgMPSM00bH
         7uQyZm3DI39v34DoO5cGxCB8SE0vS3PteQC5SqsfyGeVeWATYATjk2I8O0l+v/we1N
         itmuWnkfvKJDGeLCDXQoH0elMdqAELbBlStxZw18Sf33xQ2BpmKhCZ7oWn8k57j6jg
         EERbjsnMmmn8A==
To:     trix@redhat.com, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: Re: [PATCH] ath9k: initialize arrays at compile time
In-Reply-To: <20220320152028.2263518-1-trix@redhat.com>
References: <20220320152028.2263518-1-trix@redhat.com>
Date:   Mon, 21 Mar 2022 14:31:08 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87ee2va0v7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

trix@redhat.com writes:

> From: Tom Rix <trix@redhat.com>
>
> Early clearing of arrays with
> memset(array, 0, size);
> is equivilent to initializing the array in its decl with
> array[size] = { 0 };
>
> Since compile time is preferred over runtime,
> convert the memsets to initializations.
>
> Signed-off-by: Tom Rix <trix@redhat.com>

Cf the discussion in the replies, please resubmit with empty
initialisers ({}), and fix up the commit message.

-Toke
