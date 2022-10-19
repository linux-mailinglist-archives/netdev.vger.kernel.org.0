Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9D8603AF4
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 09:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiJSHwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 03:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiJSHwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 03:52:07 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA815F93
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 00:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=tsxPOLuEfWGUspaxw/MONHvYblq3nA/nrxv5lVBDvh4=;
        t=1666165926; x=1667375526; b=IDD4JAIOKX2VPJfbAUfuyKOTF4WEjJPMOeHsoCuv9SpAt37
        MaqiKWN6cyraxNFPxb6e4f3jYTgUsZaQ9GcmscbV2/8uh+lx3MSfQtbWSSNENc78JJ+udu72YHUGf
        v7Fchh/fDlLeD2yIMzXpg7FQvox/riOm0Mw/BXKu7FIZD5+EeGWNGfjBBDpeGS1QB9DBNvmlk/h3X
        /MCrzmGjpELqDarg1wrreFtVjguwAmZ1jZz0kOPFhlRAvkcCEqEMf8T7CNFmXxrG3iXZNPJxrXj6q
        OPqx7iG1FK29kVOIabb4kqgR6oa0gefKBGS2GlFbACVSCWyNasvFadNfB4RlC9zg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ol3rr-00B171-28;
        Wed, 19 Oct 2022 09:51:59 +0200
Message-ID: <1c55b81b6b5a6d2ed2eb1affd15f3c7e31951db2.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 02/13] genetlink: move the private fields in
 struct genl_family
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de
Date:   Wed, 19 Oct 2022 09:51:58 +0200
In-Reply-To: <20221018230728.1039524-3-kuba@kernel.org>
References: <20221018230728.1039524-1-kuba@kernel.org>
         <20221018230728.1039524-3-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
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

On Tue, 2022-10-18 at 16:07 -0700, Jakub Kicinski wrote:
> Move the private fields down to form a "private section".
> Use the kdoc "private:" label comment thing to hide them
> from the main kdoc comment.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> I did this cleanup to add more private fields but ended up
> not needing them. Still I think the commit makes sense?
>=20

Agree.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes
