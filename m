Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449B45EE580
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 21:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbiI1TYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 15:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234542AbiI1TX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 15:23:27 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFC5FA0CD
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 12:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=5kRQES51GWB6vCE6GW1HnR9MLQG1jthx7+279xcRF0c=;
        t=1664392903; x=1665602503; b=LEvJWYybAKejjOd7ECSuD4cU9ZegrdwNehWu5Gy67x7ZiMm
        R2SPHARCGPWhg6UpP47nuJnPMZbhNMHOC+lxE6qwCBglSM1YgSdVvBDR6HrME4ddtR11vTxlsSC+7
        VFWGj+OnecOHm009fkWC9JvfrLdBGkXxIH2GWmlOdlk1FEZ4yQANMuI+wGLaldCpCp4T2hXRVnOs5
        AbRCJwpEvoKKZUwyEE2inDpWqKao1Tu5ngTBWfOPntH9ND5vF8ink/LPIB12wGVk68zxw90INT15l
        7gWB737cCKlzlCeUQeDODvdAB4ng8kl4PwvTsu6RuQVglVgxVjl2mWOKY3y2/SeQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1odcbt-00AVQc-0H;
        Wed, 28 Sep 2022 21:20:45 +0200
Message-ID: <68862d82fe886c8c7e3992bb9b892a14f6225bf7.camel@sipsolutions.net>
Subject: Re: [PATCH net] genetlink: reject use of nlmsg_flags for new
 commands
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Guillaume Nault <gnault@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Date:   Wed, 28 Sep 2022 21:20:43 +0200
In-Reply-To: <20220928183515.1063481-1-kuba@kernel.org>
References: <20220928183515.1063481-1-kuba@kernel.org>
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

On Wed, 2022-09-28 at 11:35 -0700, Jakub Kicinski wrote:
> Commit 9c5d03d36251 ("genetlink: start to validate reserved header bytes"=
)
> introduced extra validation for genetlink headers. We had to gate it
> to only apply to new commands, to maintain bug-wards compatibility.
> Use this opportunity (before the new checks make it to Linus's tree)
> to add more conditions.
>=20
> Validate that Generic Netlink families do not use nlmsg_flags outside
> of the well-understood set.

Makes sense.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Thanks for doing this :)

johannes
