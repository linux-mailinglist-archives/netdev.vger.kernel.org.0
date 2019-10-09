Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E221D074C
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 08:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729699AbfJIGhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 02:37:03 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:60184 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727677AbfJIGhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 02:37:03 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iI5ak-0005fu-03; Wed, 09 Oct 2019 08:36:58 +0200
Message-ID: <5fa6cece698e96345dd8cdc19ebb645ec9f6da73.camel@sipsolutions.net>
Subject: Re: pull-request: mac80211 2019-10-08
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date:   Wed, 09 Oct 2019 08:36:57 +0200
In-Reply-To: <20191008195520.33532bbe@cakuba.netronome.com> (sfid-20191009_045539_879003_33E33FCD)
References: <20191008123111.4019-1-johannes@sipsolutions.net>
         <20191008195520.33532bbe@cakuba.netronome.com>
         (sfid-20191009_045539_879003_33E33FCD)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> Pulled into net. Let me know if did it wrong :)

Oops, didn't know it was your "turn" again, guess I haven't been reading
netdev enough.

Looks good, but I didn't think this could possibly go wrong :)

> FWIW there was this little complaint from checkpatch:
[...]
> WARNING: Duplicate signature
> #14: 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Hmm, yeah, so ... I was actually not sure about that and I guess it
slipped by. Most of the time, I've been editing it out, but what happens
is this:

 1) I send a patch to our internal tree, to fix up some things. Unless
    it's really urgent, I don't necessarily post it externally at the
    same time. This obviously has my S-o-b.
 2) Luca goes through our internal tree and sends out the patches to the
    list, adding his S-o-b.
 3) For the patches to the stack, I apply them, and git-am adds my S-o-b
    again because it's not the last.

So now we have

S-o-b: Johannes
S-o-b: Luca
S-o-b: Johannes

If I edit it just to be "S-o-b: Johannes", then it looks strange because
I've applied a patch from the list and dropped an S-o-b. It's still my
code, and Luca doesn't normally have to make any changes to it, but ...
This is what I've normally been doing I think, but it always felt a bit
weird because then it's not the patch I actually applied, it's like I
pretend the whole process described above never happened.

If I edit and remove my first S-o-b then it's weird because the Author
isn't the first S-o-b, making it look like I didn't sign it off when I
authored it?

If I edit and remove the last S-o-b, how did it end up in my tree?

So basically my first S-o-b is certifying (a) or maybe occasionally (b)
under the DCO, while Luca's and my second are certifying (c) (and maybe
occasionally also (a) or (b) if any changes were made.)


Is there any convention on this that I could adhere to? :)

johannes

