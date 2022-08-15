Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C565947EE
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 02:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353816AbiHOXi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 19:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353985AbiHOXhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 19:37:08 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065A0832D8;
        Mon, 15 Aug 2022 13:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=W1EwoW4aLsJ8eRJWgTs4Iw//7V30NdpKRriq+XMMUr4=;
        t=1660594184; x=1661803784; b=BcwSF/VQ5aRnKBY7SNNTsP9tbkdfzrSIxUbQvmYtPcR5Tns
        8c2EKyjW4i5PaV7zsAINgpMyeRxxdQx9rafjfw+INY3DSH2XCTK1yD7MnTuz5ol2OUrrROvivO+uo
        IcS1Pf4aankPm3Yt92SxPTMGd2PkgwLE00rOSgRKR333ME5ObndZdu6flglYj2rurLR3rLGzK8KC4
        7O2SOAuRLnTf8dWumDL37HfXYi9mhYIFISkc5s7NkPKL7lzLZJYXfr+YnWKBb1+IcoCiTl0LtqAXl
        wAY+Q0XmR5tfJw5Xy/KrF55Ea8KzgdP7v8RpPCy1OoX74Wi0OqGLccTJ3BdHMOzA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oNgOw-008olc-2W;
        Mon, 15 Aug 2022 22:09:30 +0200
Message-ID: <273db0bc09c0e074a8875679e5e07ea047b61c27.camel@sipsolutions.net>
Subject: Re: [RFC net-next 1/4] ynl: add intro docs for the concept
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Cc:     sdf@google.com, jacob.e.keller@intel.com, vadfed@fb.com,
        jiri@resnulli.us, dsahern@kernel.org, stephen@networkplumber.org,
        fw@strlen.de, linux-doc@vger.kernel.org
Date:   Mon, 15 Aug 2022 22:09:29 +0200
In-Reply-To: <20220811022304.583300-2-kuba@kernel.org>
References: <20220811022304.583300-1-kuba@kernel.org>
         <20220811022304.583300-2-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-08-10 at 19:23 -0700, Jakub Kicinski wrote:
>=20
> +Note that attribute spaces do not themselves nest, nested attributes ref=
er to their internal
> +space via a ``nested-attributes`` property, so the YAML spec does not re=
semble the format
> +of the netlink messages directly.

I find this a bit ... confusing.

I think reading the other patch I know what you mean, but if I think of
this I think more of the policy declarations than the message itself,
and there we do refer to another policy?

Maybe reword a bit and say

   Note that attribute spaces do not themselves nest, nested attributes
   refer to their internal space via a ``nested-attributes`` property
   (the name of another or the same attribute space).

or something?

johannes
