Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6634D29F389
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 18:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgJ2Rom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 13:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgJ2Rol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 13:44:41 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668B4C0613CF;
        Thu, 29 Oct 2020 10:44:41 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kYByQ-00EvGg-BZ; Thu, 29 Oct 2020 18:44:30 +0100
Message-ID: <40e7ef15f3ffd32567c1dd74edae982c53b0fb06.camel@sipsolutions.net>
Subject: Re: [PATCH v5 3/3] mac80211: add KCOV remote annotations to
 incoming frame processing
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Aleksandr Nogikh <aleksandrnogikh@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>
Date:   Thu, 29 Oct 2020 18:44:13 +0100
In-Reply-To: <20201029173620.2121359-4-aleksandrnogikh@gmail.com> (sfid-20201029_183700_438226_5535E485)
References: <20201029173620.2121359-1-aleksandrnogikh@gmail.com>
         <20201029173620.2121359-4-aleksandrnogikh@gmail.com>
         (sfid-20201029_183700_438226_5535E485)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-29 at 17:36 +0000, Aleksandr Nogikh wrote:
> From: Aleksandr Nogikh <nogikh@google.com>
> 
> Add KCOV remote annotations to ieee80211_iface_work() and
> ieee80211_rx_list(). This will enable coverage-guided fuzzing of
> mac80211 code that processes incoming 802.11 frames.

I have no idea how we'll get this merged - Jakub, do you want to take
the whole series? Or is somebody else responsible for the core kcov
part?

In any case,

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

