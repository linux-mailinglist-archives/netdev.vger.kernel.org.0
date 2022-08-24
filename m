Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA65459F4D6
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 10:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbiHXINW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 04:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiHXINU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 04:13:20 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B4785AB1
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 01:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=oTq07V003KzxNCAie9Kc46/rOvfeMo6S/VJe26eOfvI=;
        t=1661328800; x=1662538400; b=CocAwMazTKmsCyk+7ufS/mSclrMf2l/wcUH5S4v2gDihZlP
        cX0is8z0xScJLom6tjB9v0U2IAIh0AmsBwtx8rnF1AvsZ+efM+7fnX7jziye5dM5+zNXQfIVi8l4X
        L+zzlEv6EGIU4gL0rPr1V1xngc0MFL522Tb8v2LFmNp6PnrHmSTz36bFH+2nRX/v0llFuTMOZfIiK
        0JYITtbZufnGA3hadJa26gj5tXyTRW15EcYt3nX/VKjiETpwl2pomagSzSjXavBS4axUsjVxk/Xcx
        fRMRYpEqIWF2utolauwXn5HHq7261NfkunWN1xHRq24HLBP42p1XIcP9icR8MSNg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oQlVj-00G7ic-1k;
        Wed, 24 Aug 2022 10:13:15 +0200
Message-ID: <5a278f36dfa9ad0b1a9ecbc04ec1f049a66628c6.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 1/6] netlink: add support for ext_ack missing
 attributes
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz
Date:   Wed, 24 Aug 2022 10:13:14 +0200
In-Reply-To: <a3dabe052337a85e1f54d6119bda0c6414325edc.camel@sipsolutions.net>
References: <20220824045024.1107161-1-kuba@kernel.org>
         <20220824045024.1107161-2-kuba@kernel.org>
         <a3dabe052337a85e1f54d6119bda0c6414325edc.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
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

On Wed, 2022-08-24 at 10:09 +0200, Johannes Berg wrote:
>  and you don't need GENL_REQ_ATTR_CHECK() at all,
> you just pass NULL to the second argument of NL_REQ_ATTR_CHECK().
>=20

However, given that it takes fewer arguments since we can use the info
pointer, it might still be worthwhile having it, but at least it'd
collapse down to a direct call to NL_REQ_ATTR_CHECK().

johannes
