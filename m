Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98EE867A1B9
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 19:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbjAXSu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 13:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjAXSu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 13:50:57 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2F42BF13;
        Tue, 24 Jan 2023 10:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=xN/Cv0sQAMc6PLOAhQPMq8OgRAcTTs9/pRuDmXbTX1w=;
        t=1674586256; x=1675795856; b=j+cpZAl114md1zTfaP/bJPF+Rl182tUEkcthv+6S69PROlY
        r2BF70q3/2wQEYMKTywbv45529aflPqhH9+CvGWUsYbeFSg9xhM8JWioDHqkQzDWtRxh8IYC39Dc0
        HzRoDRlihXykx8lXDHvRb/Y2QtpTuZt9h3Ju8KG/BcrGftTJLbk+fvRKPVDggzVJtzu5AX4eJczCT
        POiM80uZdHjiWVvvZgJ7K3OODEwV4T3bYmx3djYhf28o4AQslHh4BYyDJDccVfq7b+kDfr278ZCLV
        yx3dct0bg7GFpq8H/4wIs/XnBPYZlBTx5C1yy4Yh5XYfUNK7L3To33st964QclIg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pKONV-00Az2W-0i;
        Tue, 24 Jan 2023 19:50:41 +0100
Message-ID: <7d1730862ef79be47f85fc0afd334cda9c3700d5.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v4 5/8] net: fou: regenerate the uAPI from the
 spec
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh@kernel.org, stephen@networkplumber.org,
        ecree.xilinx@gmail.com, sdf@google.com, f.fainelli@gmail.com,
        fw@strlen.de, linux-doc@vger.kernel.org, razor@blackwall.org,
        nicolas.dichtel@6wind.com
Date:   Tue, 24 Jan 2023 19:50:40 +0100
In-Reply-To: <a16382e3-b66f-0a57-2482-72afd00cdabe@intel.com>
References: <20230120175041.342573-1-kuba@kernel.org>
         <20230120175041.342573-6-kuba@kernel.org>
         <a16382e3-b66f-0a57-2482-72afd00cdabe@intel.com>
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

On Tue, 2023-01-24 at 18:49 +0100, Alexander Lobakin wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Fri, 20 Jan 2023 09:50:38 -0800
>=20
> > Regenerate the FOU uAPI header from the YAML spec.
> >=20
> > The flags now come before attributes which use them,
> > and the comments for type disappear (coders should look
> > at the spec instead).
>=20
> Sorry I missed the whole history of this topic. Wanted to ask: if we can
> generate these headers and even C files, why ship the generated with the
> source code and not generate them during building? Or it's slow and/or
> requires some software etc.?
>=20

Currently it requires python 3 (3.6+, I'd think?).

Python is currently not documented as a build requirement in
Documentation/process/changes.rst afaict.

johannes
