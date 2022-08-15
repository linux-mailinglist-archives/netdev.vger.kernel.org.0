Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41DA4594984
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 02:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348215AbiHOXMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 19:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245445AbiHOXLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 19:11:39 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF5343302;
        Mon, 15 Aug 2022 13:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=P0Mf7KfQM6gt6rgy9Mbr36+OPTT8y9WgA4HSJYQ9vxU=;
        t=1660593631; x=1661803231; b=NBS49Jv+9S0tK9/6ekYgZY1a9rm+0/xmQXV4s68LYrcQuyH
        JZGG36nErvgWzlvpfei99wNufHlkXT2Loi/4o882z+vpHkHvZ7m4C3u/2FHX59br7wAOYDqyZkvmv
        g9Oca8EVhoaLxHI8bLjFoTEQRQXkQ4VYADl/8aAnCWswB8Lo2k+1/ZF+Zfg7d33IaQxewdEkXTrWk
        jgncC8obemmTXX1Q/+3bIPU46Mc9fOUkg/D1Yt0UoY9fw3ux0SV0mgVgxFX6jvOsgOwUGWMSxrOEY
        cGWGPkYwAY7fuy1fcLjn4xo3VYm5ypTTi75uY5LW8DfyxYxsa9RftFeXR3/cXYZw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oNgFx-008ocr-00;
        Mon, 15 Aug 2022 22:00:13 +0200
Message-ID: <f5b5873629afa110e66e92b4bf717e8acee21fcb.camel@sipsolutions.net>
Subject: Re: [RFC net-next 3/4] ynl: add a sample python library
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, jiri@resnulli.us, dsahern@kernel.org, fw@strlen.de,
        linux-doc@vger.kernel.org
Date:   Mon, 15 Aug 2022 22:00:11 +0200
In-Reply-To: <20220812155308.520831bb@kernel.org>
References: <20220811022304.583300-1-kuba@kernel.org>
         <20220811022304.583300-4-kuba@kernel.org>
         <20220811130906.198b091d@hermes.local> <20220812155308.520831bb@kernel.org>
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

On Fri, 2022-08-12 at 15:53 -0700, Jakub Kicinski wrote:
> On Thu, 11 Aug 2022 13:09:06 -0700 Stephen Hemminger wrote:
> > Looks interesting, you might want to consider running your code
> > through some of the existing Python checkers such as flake8 and pylint.
> > If you want this to be generally available in repos, best to follow the=
 language conventions
> >=20
> > For example flake8 noticed:
> >  $ flake8 --max-line-length=3D120 ./tools/net/ynl/samples/ynl.py=20
> > ./tools/net/ynl/samples/ynl.py:251:55: F821 undefined name 'file_name'
>=20
> Thanks! I'll make sure to check flake8 (pylint is too noisy for me :()

FWIW, I've come to really believe in also adding type annotations (and
checking them with mypy, of course, I even use --strict), which has
helped even my smaller projects a lot. YMMV, but it might be something
to look into.

johannes
