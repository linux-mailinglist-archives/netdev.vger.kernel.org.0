Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E8C373650
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 10:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbhEEIek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 04:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbhEEIej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 04:34:39 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AD2C061574
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 01:33:42 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4FZqjw2PDhzQjjH;
        Wed,  5 May 2021 10:33:40 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1620203618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ldyIEM9S3rBLGYaGiOpt4m5tQk0mOAd/+4lmVBcFNHU=;
        b=USpMREweQoZlHlouX1JG3RRHzMl4Ckw+btngJhtzaSdphEHOVwy+FhPvpbSstTzR8HFeP2
        8xwTgw8Bb2Hf7PRwJaRB7V/GQY5byrs43LlbTw4qyvW2xJhvN9hfFpP+NPONRoTU7o96a6
        X2yQoEWDq+KoXL5XzV3egK8WX4HSSfs9pcKbMOwetsX1t5yQVhyKKNjBB42bbPbJTFAJ6N
        D0g9HfMtTEceXHOjsZF/aagi0JF5+iNl1HfM59/5mPr+7pDJT1RHzYZrIf5KeMVT7nx5FW
        2tbKvj35oDRhEstX3v2VRSWdKwvlNk/RHLBls/1Ss0TxFpguy6qQSWhTIHC9IA==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id nFIyf34tr-Q1; Wed,  5 May 2021 10:33:37 +0200 (CEST)
References: <cover.1619886883.git.aclaudi@redhat.com>
 <0d19dbb485632ecfbbc09e04e8151f7157e6960b.1619886883.git.aclaudi@redhat.com>
From:   Petr Machata <me@pmachata.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
Subject: Re: [PATCH iproute2 2/2] dcb: fix memory leak
In-reply-to: <0d19dbb485632ecfbbc09e04e8151f7157e6960b.1619886883.git.aclaudi@redhat.com>
Date:   Wed, 05 May 2021 10:33:34 +0200
Message-ID: <87a6p960m9.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.45 / 15.00 / 15.00
X-Rspamd-Queue-Id: 4D2C11821
X-Rspamd-UID: a92c9f
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Andrea Claudi <aclaudi@redhat.com> writes:

> main() dinamically allocates dcb, but when dcb_help() is called it
> returns without freeing it.
>
> Fix this using a goto, as it is already done in the same function.
>
> Fixes: 67033d1c1c8a ("Add skeleton of a new tool, dcb")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>

Thanks!

Reviewed-by: Petr Machata <me@pmachata.org>
