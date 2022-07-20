Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEE457B08E
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 07:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235201AbiGTFua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 01:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiGTFu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 01:50:29 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C75B47B94;
        Tue, 19 Jul 2022 22:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=+qLfk60txktshM7fOydevMibyPjNFKqz9X4NNvfiDbg=;
        t=1658296228; x=1659505828; b=HUB8GRelZ/y2BN17hNP/z8oi3WB07lnAiTY6kxeor1wCg/A
        HqtEVEzZ5U/2TFEOMirgfF52TZRW4SyZ4ubh6La6LEh8ryoPR3rsqd0NJSgnPGZCDrbXXAKXgzlWP
        k2gS/dxSqQpP2VFwuDach0xw5AK6LcmlgVOpcmssnSqmEveYjks0fhb5ZnGUz9CFxQNeTR3YMuoDw
        b1Q/n9Wo4c/YlmSFFfcozlz+yd1nzR3qnEr0cqKNJUlggaJV9iSG5Dfq27rq04ATnwVeOEjQjtgML
        SAUjehgSekDHSggrxAOJTuwcWfyUK3oaUM2EXJjiAnuSMgRnx243TkUvuVVmXK7g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oE2b0-003LG4-20;
        Wed, 20 Jul 2022 07:50:07 +0200
Message-ID: <ff30252059ae6a7a74c135f9fa9525d379f9e74a.camel@sipsolutions.net>
Subject: Re: [PATCH AUTOSEL 5.4 06/16] wifi: mac80211: do not wake queues on
 a vif that is being stopped
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ben Greear <greearb@candelatech.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Wed, 20 Jul 2022 07:50:04 +0200
In-Reply-To: <b43cfde3-7f33-9153-42ca-9e1ecf409d2a@candelatech.com>
References: <20220720011730.1025099-1-sashal@kernel.org>
         <20220720011730.1025099-6-sashal@kernel.org>
         <b43cfde3-7f33-9153-42ca-9e1ecf409d2a@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-07-19 at 18:58 -0700, Ben Greear wrote:
> I think this one had a regression and needs another init-lock-early patch=
 to keep from causing
> problems?
>=20

Yes, for now we should drop it from all stable trees. We'll re-assess
the situation later if it's needed there or not, I guess.

johannes
