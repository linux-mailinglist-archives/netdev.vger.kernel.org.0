Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C813D11A5F1
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 09:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfLKIgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 03:36:33 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:46342 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfLKIgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 03:36:33 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iexTy-003VSa-Bd; Wed, 11 Dec 2019 09:36:30 +0100
Message-ID: <9727368004ceef03f72d259b0779c2cf401432e1.camel@sipsolutions.net>
Subject: Re: iwlwifi warnings in 5.5-rc1
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jens Axboe <axboe@kernel.dk>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Date:   Wed, 11 Dec 2019 09:36:29 +0100
In-Reply-To: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk> (sfid-20191210_214627_221076_8C5C32D1)
References: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk>
         (sfid-20191210_214627_221076_8C5C32D1)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-12-10 at 13:46 -0700, Jens Axboe wrote:
> Hi,
> 
> Since the GRO issue got fixed, iwlwifi has worked fine for me.
> However, on every boot, I get some warnings:
> 
> ------------[ cut here ]------------
> STA b4:75:0e:99:1f:e0 AC 2 txq pending airtime underflow: 4294967088, 208

Yeah, we've seen a few reports of this.

I guess I kinda feel responsible for this since I merged the AQL work,
I'll take a look as soon as I can.

johannes

