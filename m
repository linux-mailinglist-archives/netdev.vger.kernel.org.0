Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6FB5A25B0
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 12:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343496AbiHZKRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 06:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245503AbiHZKRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 06:17:48 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D660B9AFE7;
        Fri, 26 Aug 2022 03:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=6bO3Sm8244bnqhmvdiwfZbNIDbSUx/CS5F+pI3CMGKk=;
        t=1661509067; x=1662718667; b=vCIxOMKgfhy9vPEAfO5yl6q79c45imGv/xsKlNvhXUvxxTc
        DbF3UlMRTzoKFayLfw6+9oL7cBksdTehTapv4yhWgVPGmuFL1G3kcpQMkgtrSmsX8MB4II3LhgjJQ
        Lla17pM3eewEnG0JvMViafx8xzK0FLdyT4gWMFNEUxRL8XcdDjB8ozIWbkb+j76hAt2nnszswcp7n
        32sXDgLBqAo2Al5tU8SvT4MnLnHGhnq1UZQOWdAEjR3OLX+xetc9p2nTldNlap42+5/KrCDSSytB0
        7zPbjjehYii43Iuj71qNyFZbAlwtl8073fWGnrqq7ZrxSJR4ThgbdevcZd5619Xw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oRWPK-000CKp-0u;
        Fri, 26 Aug 2022 12:17:46 +0200
Message-ID: <4737c8968334711b5de4a280a1e164283219d72d.camel@sipsolutions.net>
Subject: Re: pull-request: wireless-next-2022-08-26
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 26 Aug 2022 12:17:45 +0200
In-Reply-To: <20220826094430.19793-1-johannes@sipsolutions.net>
References: <20220826094430.19793-1-johannes@sipsolutions.net>
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

On Fri, 2022-08-26 at 11:44 +0200, Johannes Berg wrote:
> Hi,
>=20
> And here's a one for net-next. Nothing major this time
> around either, MLO work continues of course, along with
> various other updates. Drivers are lagging behind a bit,
> but we'll have that sorted out too.
>=20
> Please pull and let me know if there's any problem.
>=20

Consider this withdrawn, I'll throw in the rtw88 warning fix at least.

johannes
