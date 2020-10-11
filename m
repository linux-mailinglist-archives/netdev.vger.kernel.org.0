Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A4B28A716
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 13:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbgJKLJ2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 11 Oct 2020 07:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgJKLJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 07:09:27 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52235C0613CE;
        Sun, 11 Oct 2020 04:09:27 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kRZDw-003SpC-RF; Sun, 11 Oct 2020 13:09:09 +0200
Date:   Sun, 11 Oct 2020 13:09:07 +0200
In-Reply-To: <CAAeHK+y=YaVwU=vgf4Fph_WMLnKgzKEhyypVmsYbF1LnRPfJsg@mail.gmail.com> (sfid-20201011_123742_043414_6A73C31E)
References: <20201009170202.103512-1-a.nogikh@gmail.com> <C4BF5679-74E6-4F2E-839B-A95D88699DBF@sipsolutions.net> <CAAeHK+y=YaVwU=vgf4Fph_WMLnKgzKEhyypVmsYbF1LnRPfJsg@mail.gmail.com> (sfid-20201011_123742_043414_6A73C31E)
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH v2 0/3] [PATCH v2 0/3] [PATCH v2 0/3] net, mac80211, kernel: enable KCOV remote coverage collection for 802.11 frame handling
To:     Andrey Konovalov <andreyknvl@google.com>
CC:     Aleksandr Nogikh <a.nogikh@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Aleksandr Nogikh <nogikh@google.com>
From:   Johannes Berg <johannes@sipsolutions.net>
Message-ID: <5A216DB0-DB3A-4619-9546-A687549DB543@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11 October 2020 12:37:29 CEST, Andrey Konovalov <andreyknvl@google.com> wrote:
>I initially hesitated to do that, as it would multiply the number of
>kcov callbacks. But perhaps you're right and a clean API look
>outweighs the rest. I will do this in v3.


Yeah, OK, dunno. You can always make it an inline calling the "full" API so after compiling it's equivalent. But if course that still has the two APIs. It just seemed to the common case wouldn't worry really (have to) about these things, especially if you plan on changing it again later. 

johannes
-- 
Sent from my phone. 
