Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09C6398424
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 10:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbhFBIbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 04:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbhFBIbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 04:31:33 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF833C061756;
        Wed,  2 Jun 2021 01:29:48 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1loMG3-000y0y-35; Wed, 02 Jun 2021 10:29:47 +0200
Message-ID: <17fd0311eb8b51e6d23fce8b7eb23e3d2581cf54.camel@sipsolutions.net>
Subject: Re: [RFC 3/4] wwan: add interface creation support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>
Date:   Wed, 02 Jun 2021 10:29:46 +0200
In-Reply-To: <CAMZdPi8Ca3YRaVWGL6Fjd7yfowQcX2V2RYNDNm-2kQdEZ-Z1Bw@mail.gmail.com> (sfid-20210602_084330_147805_0A84556F)
References: <20210601080538.71036-1-johannes@sipsolutions.net>
         <20210601100320.7d39e9c33a18.I0474861dad426152ac7e7afddfd7fe3ce70870e4@changeid>
         <CAMZdPi-ZaH8WWKfhfKzy0OKpUtNAiCUfekh9R1de5awFP-ed=A@mail.gmail.com>
         <0555025c6d7a88f4f3dcdd6704612ed8ba33b175.camel@sipsolutions.net>
         <CAMZdPi8Ca3YRaVWGL6Fjd7yfowQcX2V2RYNDNm-2kQdEZ-Z1Bw@mail.gmail.com>
         (sfid-20210602_084330_147805_0A84556F)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-06-02 at 08:52 +0200, Loic Poulain wrote:
> 
> OK no prob ;-), are you going to resubmit something or do you want I
> take care of this?

I just respun a v2, but I'm still not able to test any of this (I'm in a
completely different group than Chetan, just have been helping/advising
them, so I don't even have their HW).

So if you want to take over at some point and are able to test it, I'd
much appreciate it.

johannes

