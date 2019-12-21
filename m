Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80A1712885B
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 10:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfLUJRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 04:17:46 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:41722 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfLUJRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 04:17:46 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iiatK-000CSE-Rm; Sat, 21 Dec 2019 10:17:42 +0100
Message-ID: <d907132a16e7bfcd253df088a1d5a1b317c32589.camel@sipsolutions.net>
Subject: Re: iwlwifi warnings in 5.5-rc1
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jens Axboe <axboe@kernel.dk>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Date:   Sat, 21 Dec 2019 10:17:41 +0100
In-Reply-To: <bac02c88-6107-7517-0114-e9c369f5fb41@kernel.dk> (sfid-20191221_015536_984743_DFB9DBBE)
References: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk>
         <9727368004ceef03f72d259b0779c2cf401432e1.camel@sipsolutions.net>
         <bac02c88-6107-7517-0114-e9c369f5fb41@kernel.dk>
         (sfid-20191221_015536_984743_DFB9DBBE)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-12-20 at 17:55 -0700, Jens Axboe wrote:
> On 12/11/19 1:36 AM, Johannes Berg wrote:
> > On Tue, 2019-12-10 at 13:46 -0700, Jens Axboe wrote:
> > > Hi,
> > > 
> > > Since the GRO issue got fixed, iwlwifi has worked fine for me.
> > > However, on every boot, I get some warnings:
> > > 
> > > ------------[ cut here ]------------
> > > STA b4:75:0e:99:1f:e0 AC 2 txq pending airtime underflow: 4294967088, 208
> > 
> > Yeah, we've seen a few reports of this.
> > 
> > I guess I kinda feel responsible for this since I merged the AQL work,
> > I'll take a look as soon as I can.
> 
> Still the case in -git, as of right now. Just following up on this to
> ensure that a patch is merged to fix this up.

It's in net/master, so from my POV it's on the way :)

johannes

