Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FF5396DF2
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 09:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhFAHdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 03:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhFAHc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 03:32:59 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE59CC061574;
        Tue,  1 Jun 2021 00:31:15 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lnyrp-000UR1-9H; Tue, 01 Jun 2021 09:31:13 +0200
Message-ID: <3e0f8a6d02435f0bba0b47176e684e331b6a6459.camel@sipsolutions.net>
Subject: Re: [PATCH V3 15/16] net: iosm: net driver
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     "Kumar, M Chetan" <m.chetan.kumar@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        linuxwwan <linuxwwan@intel.com>, Dan Williams <dcbw@redhat.com>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Tue, 01 Jun 2021 09:31:12 +0200
In-Reply-To: <CAMZdPi9Tmz1oD3rcpg3RfrvjwWo8RuiinpmURJF6WpETyumAGg@mail.gmail.com> (sfid-20210527_133055_476133_D9F74328)
References: <20210520140158.10132-1-m.chetan.kumar@intel.com>
         <20210520140158.10132-16-m.chetan.kumar@intel.com>
         <CAMZdPi-Xs00vMq-im_wHnNE5XkhXU1-mOgrNbGnExPbHYAL-rw@mail.gmail.com>
         <90f93c17164a4d8299d17a02b1f15bfa@intel.com>
         <CAMZdPi_VbLcbVA34Bb3uBGDsDCkN0GjP4HmHUbX95PF9skwe2Q@mail.gmail.com>
         <c7d2dd39e82ada5aa4e4d6741865ecb1198959fe.camel@sipsolutions.net>
         <CAMZdPi99Un=AQeUMZUWzudubr2kR6=YciefdaXxYbhebSy+yVQ@mail.gmail.com>
         <c7b149f5f3014e02a0b94b11d957cfc73d675ad7.camel@sipsolutions.net>
         <CAMZdPi9Tmz1oD3rcpg3RfrvjwWo8RuiinpmURJF6WpETyumAGg@mail.gmail.com>
         (sfid-20210527_133055_476133_D9F74328)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Yes, or alternatively add an optional alloc_netdev() rtnl ops, e.g. in
> rtnl_create_link:


Yes, that works. It needs some more fiddling (we need 'data', not just
'tb') and it cannot be called 'alloc_netdev' (that's a macro!), but
yeah, otherwise works. I'll just call it alloc().

I'll send a few updated patches in a few minutes.

johannes

