Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 876C31076FD
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 19:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKVSI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 13:08:57 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:49088 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbfKVSI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 13:08:56 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iYD6N-0002B1-Et; Fri, 22 Nov 2019 18:52:15 +0100
Message-ID: <175edd72f0cd3bc4d2c0dbd42a4570c7fb47b8fd.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211_hwsim: set the maximum EIRP output power for
 5GHz
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ramon Fontes <ramonreisfontes@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        kvalo@codeaurora.org, davem@davemloft.net
Date:   Fri, 22 Nov 2019 18:52:12 +0100
In-Reply-To: <CAK8U23aL7UDgko4Z2EkQ9r4muBTjNOCq-Erb9h2TFRnxdOmtWg@mail.gmail.com> (sfid-20191122_151928_905345_8C817F08)
References: <20191108152013.13418-1-ramonreisfontes@gmail.com>
         <fe198371577479c1e00a80e9cae6f577ab39ce8e.camel@sipsolutions.net>
         <CAK8U23amVqf-6YoiPoyk5_za3dhVb4FJmBDvmA2xv2sD43DhQA@mail.gmail.com>
         <7d43bbc0dfeb040d3e0468155858c4cbe50c0de2.camel@sipsolutions.net>
         <CAK8U23aL7UDgko4Z2EkQ9r4muBTjNOCq-Erb9h2TFRnxdOmtWg@mail.gmail.com>
         (sfid-20191122_151928_905345_8C817F08)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-11-22 at 11:19 -0300, Ramon Fontes wrote:
> > Right, so the commit log should say that it should be incremented to
> > allow regdb to work, rather than worry about ETSI specifics?
> > 
> > Or maybe this limit should just be removed entirely?
> 
> Hmm.. not sure. Perhaps we should add only one more information:
> 
> ETSI has been set the maximum EIRP output power to 36 dBm (4000 mW)
> Source: https://www.etsi.org/deliver/etsi_en/302500_302599/302502/01.02.01_60/en_302502v010201p.pdf
> 
> + The new maximum EIRP output power also allows regdb to work
> correctly when txpower is greater than 20 dBm.
> 
> Since there is no standard defining greater txpower, in my opinion we
> should keep the maximum value. What do you think?

It just feels to me like if the only restriction in the driver is
regulatory, we shouldn't have it in the driver. That's what we have the
regulatory database for.

If there's some other (physical?) restriction in the driver, sure, maybe
it should have one there, but for pure regulatory I'm not sure I see it.

That's why the pointer here to ETSI feels so strange to me.

> Do I need to submit a new patch?

I'll need to see if we can remove it, but if we can I'll do that, and
otherwise I can just commit your patch but with a changed commit
message.

Note that I just sent my final pull request for the current kernel, so
this'll probably have to wait some time.

johannes

