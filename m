Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0F867942F
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 10:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbjAXJ13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 04:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbjAXJ1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 04:27:22 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6291555C;
        Tue, 24 Jan 2023 01:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=ctJgpO7IHWdhLMWOxSQ2U3kHoPMeDR9uKIVG3QAMmmo=;
        t=1674552411; x=1675762011; b=p/k36Bg3qtlMpMFCZItuebK3VOK9aR9zGAF+LOqAz+QR03h
        Wbpmkt72SYJgcTip/BCxAq/Fhdd0aHIDR+nbuBbdkjUem5AiraSWQbzGPGmgRBlQhypyw1ATMHuWU
        NivarzGPmydDIT1JlDmurT8nYlop2pzzjVleQ/YKVoHLvUsGYFUbera9/n20liAGVB9hnd90VsW35
        qIVtFZvMW2BHc2LUeXCUGdLYPNfpXHWFIghK5lHBldgLX0KrB8BpKHEFbQlNaWlKosaRkiZRbZPxJ
        03SkTXpwVdSmUNwNLH0Wwyl7Da5UOKzYyMT1oeYs4Gv7kCtn8Lb+dpDUHt9z6P7A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pKFZi-00AoMW-31;
        Tue, 24 Jan 2023 10:26:43 +0100
Message-ID: <758384602b93da0f242ee5d82847a1b4ab102b91.camel@sipsolutions.net>
Subject: Re: [PATCH next] wifi: nl80211: emit CMD_START_AP on multicast
 group when an AP is started
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alvin =?UTF-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Alvin =?UTF-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Tue, 24 Jan 2023 10:26:41 +0100
In-Reply-To: <20230121130717.l5ynezk4rug7fypb@bang-olufsen.dk>
References: <20221209152836.1667196-1-alvin@pqrs.dk>
         <c7eac35785bf672b3b9da45c41baa4149a632daa.camel@sipsolutions.net>
         <20230121130717.l5ynezk4rug7fypb@bang-olufsen.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
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

Hi,

> > Seems like you should include the link ID or something?
>=20
> Thanks for your review, you are quite right. I didn't give much thought
> to MLO as I am not too familiar with it. Is something like the below
> what you are looking for?

Yes, that looks good.

> Speaking of which: I drew inspiration from nl80211_send_ap_stopped()
> which see also doesn't include the link ID. Would you like me to include
> a second patch in v2 which adds the link ID to that function along the
> same lines?

Maybe have that as a separate patch, but yeah, good idea - thanks for
looking!

johannes
