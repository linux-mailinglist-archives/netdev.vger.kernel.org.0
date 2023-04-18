Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394B16E5AB1
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 09:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbjDRHpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 03:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjDRHpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 03:45:39 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2433C44A5
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 00:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=WogcFvp4mRqXjsINLVowmD8QE6/8aw4sgjqy8o77dkE=;
        t=1681803936; x=1683013536; b=RWDW2a3U84/Wv0en5wnWejJICIpirOHcXZ2jH3jAf9+o8gq
        54C23MBieRfO7WSoH97otaD05N1bhbg3MFNJCtHyePWUbYVOT0dDdUJEARokm9LS3p98nD4uaevHI
        0gNb4Y4NGb2nDAhoLh97Vfyvv9SIpGm4oXK3FM5cjz+uBqcq91R5wY8pALIiFaMoMvHeOlZF5VsmR
        gb/u1FsVlsOiNRQBaQKcSd6gJefI9V5Dpb26yTT1g8mi9ptjAEQaJ6HuLNx7rkhf+FVB0l5bOMuIy
        UmJmZbQ/o/fO7Zc1Bi+ZMvy/no9SG8OalOXkUYNRbAjPQb1vJQdVQKXRnTILcNmg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pog1p-001X50-00;
        Tue, 18 Apr 2023 09:45:29 +0200
Message-ID: <2f6476dd1bbb11120ec633852781f6c4d00016cb.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 1/5] net: skbuff: hide wifi_acked when
 CONFIG_WIRELESS not set
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Tue, 18 Apr 2023 09:45:28 +0200
In-Reply-To: <20230417155350.337873-2-kuba@kernel.org>
References: <20230417155350.337873-1-kuba@kernel.org>
         <20230417155350.337873-2-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-04-17 at 08:53 -0700, Jakub Kicinski wrote:
> Datacenter kernel builds will very likely not include WIRELESS,
> so let them shave 2 bits off the skb by hiding the wifi fields.

:-)

You could make this be CONFIG_MAC80211 if you wanted to, but I don't
mind CONFIG_WIRELESS and honestly they're probably pretty much
equivalent because there aren't many non-mac80211 drivers.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

