Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCDA5573D06
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 21:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbiGMTMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 15:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbiGMTMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 15:12:38 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8F727CC7;
        Wed, 13 Jul 2022 12:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=MOnltM8g/QAlhbRYqgnEV/Shd2v2MiLOkDq22UX+qME=;
        t=1657739557; x=1658949157; b=QkA0LieIdrFuWwQWNSq2QkrWQVtL9RZtwLbZicSo9xMUKyV
        XcaV2sV5prwNOuQRcnI/ZfVj326uuW9MAFRIOl6ycNlXpFiDc1ojmbD9EQIgst+rCsngQJqKEsdyF
        Ys7AZRbNnN9wJXGefoUvH1r7s/fvc3VhBle3GARkWtL5qrCiHfO4cFLME4uEOuMmOahfhBa9ZAvE4
        Ib/USzN7uNGi+wMDXCsDdgmYvzjg/hycl60esNmDOisGVyG9TJqFzZDuE6xWk9+gz6Y+HN1K7eGkI
        KK5YxGUpdLfSlI7iplMJOLQzxTCrig3mXl1sPcbCf+cKREbvNPRdG+I2f3oTi8rQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oBhmj-00Er7e-Oc;
        Wed, 13 Jul 2022 21:12:33 +0200
Message-ID: <3307350fd07843cbc17a9dd62331b733845ee5dc.camel@sipsolutions.net>
Subject: Re: pull-request: wireless-next-2022-07-13
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date:   Wed, 13 Jul 2022 21:12:32 +0200
In-Reply-To: <20220713115349.1703bb92@kernel.org>
References: <20220713071932.20538-1-johannes@sipsolutions.net>
         <20220713115349.1703bb92@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
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

On Wed, 2022-07-13 at 11:53 -0700, Jakub Kicinski wrote:
> On Wed, 13 Jul 2022 09:19:31 +0200 Johannes Berg wrote:
> > Hi,
> >=20
> > And another one, for next! This one's big, due to the first
> > parts of multi-link operation (MLO) support - though that's
> > not nearly done yet (have probably about as many patches as
> > here already in the pipeline again).
> >=20
> > Please pull and let me know if there's any problem.
>=20
> Dave already pulled (I haven't seen the pw-bot reply, let's see whether
> it will reply if I just flip the state back to "Under review" now).
>=20
> Please take a gander at the new warnings in:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220713071932.20538=
-1-johannes@sipsolutions.net/
> to make sure they are expected.
>=20
Eh, sorry. Both the new ones should be fixed, though the hwsim one
probably should get a bit more work.

johannes
