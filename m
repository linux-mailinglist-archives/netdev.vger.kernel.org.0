Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8785746C1
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbiGNIab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235162AbiGNIa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:30:29 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0602F3D58B;
        Thu, 14 Jul 2022 01:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=IshCjafs3BxP3VlmCy62POvK6iARkBDn8iSIA1YuRQ8=;
        t=1657787424; x=1658997024; b=hpPlSn6gTtUxDag7y8R5dZJk01G79Y92eFDrDBEfjEvCUqO
        VuZq9fyCQgZzDvLogqRNAcqxQKIPZ4QDiKh4Yco44pJsChoHDkLYUVtwGuhkKCJu8W81wdCrKNMuJ
        2xKbEJKNAaHCnYEYnMc/Xfz86QQ9j5ZNiJUp7nN5sUzaQo8Xvg4vbmNBPaUn3gMFaUCcoozAZhpYT
        G7O6wRIivYb29RI7yJ5k09Z9wI6YT+eFv28PgwEdj6IdLq61WG/mczMRERrfJJoQXQd08+me+0ocA
        SW2/wBW+K/ePBl/RDM8cUKvyZeNosxGOi0vHPtMRAtDs1hInYubjw++CW4g7FvNg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oBuEm-00FYZ3-N1;
        Thu, 14 Jul 2022 10:30:20 +0200
Message-ID: <3ac3c91120a128f66ca3806294f6a783e0f1131f.camel@sipsolutions.net>
Subject: Re: [PATCH 00/76] wifi: more MLO work
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arend Van Spriel <aspriel@gmail.com>,
        linux-wireless@vger.kernel.org, kvalo@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Date:   Thu, 14 Jul 2022 10:30:19 +0200
In-Reply-To: <e9ecb9c8-cb5b-d727-38d6-ef5a0bf81cef@gmail.com>
References: <20220713094502.163926-1-johannes@sipsolutions.net>
         <e9ecb9c8-cb5b-d727-38d6-ef5a0bf81cef@gmail.com>
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

On Thu, 2022-07-14 at 10:26 +0200, Arend Van Spriel wrote:
>=20
> Just for my own patch submit process. What is the reason I am seeing the=
=20
> "wifi:" prefix being used with patches on linux-wireless list? Is there=
=20
> other wireless tech used, eg. "bt:" or so?
>=20

Well, we had a discussion with Jakub, and he kind of indicated that he'd
like to see a bit more generic prefixes to clarify things.

We've kind of been early adopters to try it out and see what it looks
like, he hasn't pushed it and wanted to have a discussion (e.g. at LPC
or netdevconf) about it first, but it kind of makes sense since not
everyone can know all the different drivers and components.

johannes
