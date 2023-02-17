Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841C969A7FF
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 10:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjBQJTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 04:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbjBQJTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 04:19:17 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B108D60FA2;
        Fri, 17 Feb 2023 01:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=F1g/l3/oWYnwT9X/GdjKaI7kD+J5MkjgsWD9aTMEKM0=;
        t=1676625556; x=1677835156; b=HeRn2Hs2cmttJBLUz+AHilbtXYUgWUsIuumy8RH9/PJPwQV
        4k5N2nc6fPkg07iQKDz1LmIewhnWI8B7sM6kVpFzabc7rj7XslvEnsUK4S647AwUuixjYTmyGghBV
        NIVxIAL4yP2Jt6WJK9NTiMmYFLosjE4NDOL2NABG7LG1efDsKiHVCuHcx+ygCaUAZf8qpX4nxbRDl
        pHoWuyunb1x4AY2xiiXUoYrgGA0Nuw7KVYXHqp1O4tCppD1Bl+ZCgAGpHR0QVKe/bmIh2tT5E1t91
        8eWvl0jCj/rcOcMUo3nYLBqdLxs6MtCL1MFYSBrIvGcVOCjwfjfhJx99FPjegQRA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pSwtf-00EwrM-05;
        Fri, 17 Feb 2023 10:19:15 +0100
Message-ID: <57ce7bea74f2b5f018db61b875b4b6fc203d03cb.camel@sipsolutions.net>
Subject: Re: [PATCH v7 1/4] mac80211_hwsim: add PMSR capability support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jaewan Kim <jaewan@google.com>
Cc:     gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com
Date:   Fri, 17 Feb 2023 10:19:14 +0100
In-Reply-To: <CABZjns42zm8Xi-BU0pvT3edNHuJZoh-xshgUk3Oc=nMbxbiY8w@mail.gmail.com>
References: <20230207085400.2232544-1-jaewan@google.com>
         <20230207085400.2232544-2-jaewan@google.com>
         <6ad6708b124b50ff9ea64771b31d09e9168bfa17.camel@sipsolutions.net>
         <CABZjns42zm8Xi-BU0pvT3edNHuJZoh-xshgUk3Oc=nMbxbiY8w@mail.gmail.com>
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

On Fri, 2023-02-17 at 14:11 +0900, Jaewan Kim wrote:
> >=20
> > > +static const struct nla_policy
> > > +hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1] =3D {
> >=20
> > This feels a bit iffy to have here, but I guess it's better that
> > defining new attributes for all this over and over again.
>=20
> I'm sorry but could you rephrase what you expect here?
> Are you suggesting to define new sets of HWSIM_PMSR_* enums
> instead of using existing enums NL80211_PMSR_*?

No, I was just drive-by commenting on this. Given all the options this
feels like it's probably the best one :-)

> BTW,  can I expect you to review my changes for further patchsets?
> I sometimes get conflicting opinions (e.g. line limits)

Sorry about that. See my other mail. I'm happy to accept it as it is.

> so it would be a great help if you take a look at my changes.
>=20

I'll be the one applying the patches, so yes.

johannes
