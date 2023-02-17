Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE11569A7E9
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 10:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjBQJNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 04:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjBQJNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 04:13:13 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FAC5ECA1;
        Fri, 17 Feb 2023 01:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=hqUqKW3DTAmnMoKK1bmm4heT/VVSVJKlzajCXDTW/V8=;
        t=1676625192; x=1677834792; b=KTibQPsdU4jqxyskxFWA7yhjzqFB1Mv2V//3YW8UH8cRGwb
        1L+U3a4fbCPBqlTcfeow2qIlgN38T6WKNLquqwvs8ZHVCivfP4yllntkBSu5uMwwrVdsQmDAQcWLt
        zINdCR3iT3a14eX3VNPsA8YmOm9y6G9+fgJqMeOoX+fJU0Jv5m+LKU1Ex0stebBt7ckPy4uPw0KdN
        8wqHCNFJ5cWJjyVypt9ljrKYzqg31tZhhkrLcyYV6zZnmuMOS6A7atm8LEYrQYsBlpfOmCtzsQelG
        l1vUt8K0sp8VWntNU3McLYdPkXE9oQi417vml6ralLyVX7A9r5GliHOPxE7SXkiQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pSwnl-00Ewio-2c;
        Fri, 17 Feb 2023 10:13:09 +0100
Message-ID: <e98a38890bb680c21a6d51c8a03589d1481b4e29.camel@sipsolutions.net>
Subject: Re: [PATCH v7 1/4] mac80211_hwsim: add PMSR capability support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jaewan Kim <jaewan@google.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@android.com, adelva@google.com
Date:   Fri, 17 Feb 2023 10:13:08 +0100
In-Reply-To: <Y+8wHsznYorBS95n@kroah.com>
References: <20230207085400.2232544-1-jaewan@google.com>
         <20230207085400.2232544-2-jaewan@google.com>
         <6ad6708b124b50ff9ea64771b31d09e9168bfa17.camel@sipsolutions.net>
         <CABZjns42zm8Xi-BU0pvT3edNHuJZoh-xshgUk3Oc=nMbxbiY8w@mail.gmail.com>
         <Y+8wHsznYorBS95n@kroah.com>
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

On Fri, 2023-02-17 at 08:43 +0100, Greg KH wrote:
> On Fri, Feb 17, 2023 at 02:11:38PM +0900, Jaewan Kim wrote:
> > BTW,  can I expect you to review my changes for further patchsets?
> > I sometimes get conflicting opinions (e.g. line limits)
>=20
> Sorry, I was the one that said "you can use 100 columns", if that's not
> ok in the networking subsystem yet, that was my fault as it's been that
> way in other parts of the kernel tree for a while.
>=20

Hah. Maybe that's my mistake then, I was still at "use 80 columns where
it's simple, and more if it would look worse" ...

I don't really mind the longer lines that much personally :)

johannes
