Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1F4288FC2
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390186AbgJIRNv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 9 Oct 2020 13:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732874AbgJIRNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:13:48 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C3AC0613D2;
        Fri,  9 Oct 2020 10:13:48 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQvxV-002OkW-Bw; Fri, 09 Oct 2020 19:13:33 +0200
Date:   Fri, 09 Oct 2020 19:13:31 +0200
In-Reply-To: <20201009170202.103512-1-a.nogikh@gmail.com> (sfid-20201009_190209_250951_9651A9CD)
References: <20201009170202.103512-1-a.nogikh@gmail.com> (sfid-20201009_190209_250951_9651A9CD)
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH v2 0/3] [PATCH v2 0/3] [PATCH v2 0/3] net, mac80211, kernel: enable KCOV remote coverage collection for 802.11 frame handling
To:     Aleksandr Nogikh <a.nogikh@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, akpm@linux-foundation.org
CC:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        nogikh@google.com
From:   Johannes Berg <johannes@sipsolutions.net>
Message-ID: <C4BF5679-74E6-4F2E-839B-A95D88699DBF@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9 October 2020 19:01:59 CEST, Aleksandr Nogikh <a.nogikh@gmail.com> wrote:

>This patch series conflicts with another proposed patch
>http://lkml.kernel.org/r/223901affc7bd759b2d6995c2dbfbdd0a29bc88a.1602248029.git.andreyknvl@google.com
>One of these patches needs to be rebased once the other one is merged.


Maybe that other patch shouldn't do things that way though, and add new API (which the existing one could call with some kind of "all contexts" argument) instead, so it's only necessary to specify the context (mask?) where its actually needed (the few places in usb or e whatever)? 

Surely that would also look less tedious in the mac80211 code, for example.

And if you ever fix the nesting issue you'd have fewer places to modify again.

johannes
-- 
Sent from my phone. 
