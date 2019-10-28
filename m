Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84F31E7020
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 12:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfJ1LI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 07:08:29 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:39680 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfJ1LI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 07:08:28 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iP2si-0001fM-5v; Mon, 28 Oct 2019 12:08:16 +0100
Message-ID: <c062695f8d05a4c36a6d69f421b05208ac51fd2c.camel@sipsolutions.net>
Subject: Re: pull-request: mac80211-next 2019-07-31
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        John Crispin <john@phrozen.org>
Date:   Mon, 28 Oct 2019 12:08:15 +0100
In-Reply-To: <CAK8P3a2BiDYXR-x_RyAOLZL_dL6m49JMy13U5VQ_gp9MbLfGGA@mail.gmail.com>
References: <20190731155057.23035-1-johannes@sipsolutions.net>
         <CAK8P3a10Gz_aDaOKBDtoPyaUc-OuCmn2buY4+GHHdWERnU+jrg@mail.gmail.com>
         <2f64367daad256b1f1999797786763fa8091faa1.camel@sipsolutions.net>
         <CAK8P3a2BiDYXR-x_RyAOLZL_dL6m49JMy13U5VQ_gp9MbLfGGA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-10-28 at 11:53 +0100, Arnd Bergmann wrote:
> 
> > Why do you say 32-bit btw, it should be *bigger* on 64-bit, but I didn't
> > see this ... hmm.
> 
> That is correct. For historic reasons, both the total amount of stack space
> per thread and the warning limit on 64 bit are twice the amount that we
> have on 32-bit kernels, so even though the problem is more serious on
> 64-bit architectures, we do not see a warning about it because we remain
> well under the warning limit.

Hmm, but I have:

CONFIG_FRAME_WARN=1024

in my compilation?

Maybe I do in fact have merging of the storage space, and you don't? I
see another copy of it that shouldn't be merged ("bss_elems"), but ...

Hmm.

johannes

