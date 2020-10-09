Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A212886C5
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 12:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387604AbgJIKWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 06:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgJIKWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 06:22:16 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A425C0613D2;
        Fri,  9 Oct 2020 03:22:16 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQpX9-002Cl9-OR; Fri, 09 Oct 2020 12:21:55 +0200
Message-ID: <4a58caee3b6b8975f4ff632bf6d2a6673788157d.camel@sipsolutions.net>
Subject: Re: [PATCH net 000/117] net: avoid to remove module when its
 debugfs is being used
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     Nicolai Stange <nstange@suse.de>,
        David Laight <David.Laight@aculab.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "wil6210@qti.qualcomm.com" <wil6210@qti.qualcomm.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
Date:   Fri, 09 Oct 2020 12:21:54 +0200
In-Reply-To: <CAMArcTUdGPH5a0RTUiNoLvuQtdnXHOCwStJ+gp_noaNEzgSA1Q@mail.gmail.com> (sfid-20201009_121527_238342_F5A29EF9)
References: <20201008155048.17679-1-ap420073@gmail.com>
         <1cbb69d83188424e99b2d2482848ae64@AcuMS.aculab.com>
         <62f6c2bd11ed8b25c1cd4462ebc6db870adc4229.camel@sipsolutions.net>
         <87v9fkgf4i.fsf@suse.de>
         <fd8aaf06b53f32eae7b5bdcec2f3ea9e1f419b1d.camel@sipsolutions.net>
         <CAMArcTUdGPH5a0RTUiNoLvuQtdnXHOCwStJ+gp_noaNEzgSA1Q@mail.gmail.com>
         (sfid-20201009_121527_238342_F5A29EF9)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-09 at 19:15 +0900, Taehee Yoo wrote:
> 
> Okay, as you mentioned earlier in 001/117 patch thread,
> I will squash patches into per-driver/subsystem then send them as v2.

Give me a bit. I think I figured out a less intrusive way that at least
means we don't have to do it if the fops doesn't have ->release(), which
is the vast majority.

johannes

