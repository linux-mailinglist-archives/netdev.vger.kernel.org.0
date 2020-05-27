Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9B81E3B09
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 09:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387709AbgE0HyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 03:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387566AbgE0HyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 03:54:24 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AF8C061A0F;
        Wed, 27 May 2020 00:54:24 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jdqtC-003xsS-AB; Wed, 27 May 2020 09:54:14 +0200
Message-ID: <0131b3dbcb2f97b6a76ad5be0c50f26e11af1c5a.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211_hwsim: report the WIPHY_FLAG_SUPPORTS_5_10_MHZ
 capability
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ramon Fontes <ramonreisfontes@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        kvalo@codeaurora.org, davem@davemloft.net
Date:   Wed, 27 May 2020 09:54:13 +0200
In-Reply-To: <CAK8U23ZaUhoPVdWo-fkFpg4pGOcQQrk7oSbs9z1XPVE3cR_Jow@mail.gmail.com> (sfid-20200526_133629_197342_B46A5EA6)
References: <20200515164640.97276-1-ramonreisfontes@gmail.com>
         <ab7cac9c73dc8ef956a1719dc090167bcfc24b63.camel@sipsolutions.net>
         <CAK8U23ZaUhoPVdWo-fkFpg4pGOcQQrk7oSbs9z1XPVE3cR_Jow@mail.gmail.com>
         (sfid-20200526_133629_197342_B46A5EA6)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-05-26 at 08:36 -0300, Ramon Fontes wrote:
> > Not sure this is enough? How about wmediumd, for example?
> 
> It works with wmediumd too. At least I was able to enable 5 / 10MHz
> via iw with 5.9GHz

Yeah, but wmediumd won't know that it's not 20 MHz, I guess :-)

> > And also, 5/10 MHz has many more channels inbetween the normal ones, no?
> > Shouldn't those also be added?
> 
> Tested with 5855MHz - 5925MHz

Yeah, but which channels? I believe with 10 MHz you can also use channel
175, for example, which doesn't exist in 20 MHz channelization.

Anyway, I've applied it now, we can fix more later.

johannes

