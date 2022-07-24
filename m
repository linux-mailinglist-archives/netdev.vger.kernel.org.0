Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E1157F5B5
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 17:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbiGXPWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 11:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiGXPWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 11:22:07 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAA811C07;
        Sun, 24 Jul 2022 08:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=RG/BJ3Nv9HakG4zVWqCXWL3uZp6IBIbE/vdVZRgFNzw=;
        t=1658676126; x=1659885726; b=hyxJq9tjqYBSUs+yl2lXhjEasadf4QDDhUQtDVBgBTsOCXy
        dXAS1NdbzZAH8t2GUlNLJhRhD49LM6qQYr6ikt7VEwb372PnhXfEw2eIErL3/1g/NmcQS7A1MmBoj
        M7sI/c7TKKmGWAVMuqOX0QISRHvCSzFTYdLMvn4EDRAsr7qLMVn4yGnhfPIrpN9AlVZXuznPdF7KL
        MRGo6/1aZIACWmI+uYVqBv6MGHPydotxxqBIszWJT+2aLy/cMHaEc5ZyPntvis9Hxxu9S7XG2Yi0g
        ypD4kw1ai5Re/1SorP2ClE+MC/OBt+Q4GXVXOTKFomMo1MmltlwK5AiDCvwoP4Gg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oFdQP-006zmj-2a;
        Sun, 24 Jul 2022 17:21:45 +0200
Message-ID: <4f8ab262d98ba2a4d0e106e127c171e75b52ad47.camel@sipsolutions.net>
Subject: Re: [PATCH] docs: driver-api: firmware: add driver firmware
 guidelines. (v3)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Dave Airlie <airlied@gmail.com>, torvalds@linux-foundation.org,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        gregkh@linuxfoundation.org, Daniel Vetter <daniel@ffwll.ch>,
        mcgrof@kernel.org
Cc:     linux-kernel@vger.kernel.org, dri-devel@lists.sf.net,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-media@vger.kernel.org,
        linux-block@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Harry Wentland <harry.wentland@amd.com>
Date:   Sun, 24 Jul 2022 17:21:43 +0200
In-Reply-To: <20220721044352.3110507-1-airlied@gmail.com>
References: <20220721044352.3110507-1-airlied@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
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

On Thu, 2022-07-21 at 14:43 +1000, Dave Airlie wrote:
>=20
> +Users switching to a newer kernel should *not* have to install newer
> +firmware files to keep their hardware working. At the same time updated
> +firmware files must not cause any regressions for users of older kernel
> +releases.

That seems sane, and certainly something we've done in wireless in the
past.

> +* Firmware files shall be designed in a way that it allows checking for
> +  firmware ABI version changes. It is recommended that firmware files be
> +  versioned with at least a major/minor version. It is suggested that
> +  the firmware files in linux-firmware be named with some device
> +  specific name, and just the major version. The firmware version should
> +  be stored in the firmware header, or as an exception, as part of the
> +  firmware file name,

Eh, I went to write a whole paragraph here and then read it again ...
Maybe this should say "[t]he _full_ firmware version", to contrast with
the previous sentence mentioning the "major version".

>  in order to let the driver detact any non-ABI

typo - 'detect'

> +  fixes/changes. The firmware files in linux-firmware should be
> +  overwritten with the newest compatible major version.
>=20

That's also a bit confusing IMHO - did that mean "minor version"? Or
something? I mean ... if you overwrite a file that has the major version
in the filename then by definition it is the same major version?

> +  This means no major version bumps without the kernel retaining
> +  backwards compatibility for the older major versions.

Strictly reading this might require aeons of support for firmware
version, if you have a release cadence of them like every 6 weeks for a
new _major_ version (yes, because APIs change), then that's rather
harsh. In practice we've often done this, but I think some reasonable
cut-off could/should be there, such as dropping support after a
reasonably long time frame (say a year?)

Often though that's less a question of "does it still work" and rather
one of "do I still support that" and the answer for the latter is
obviously "no" much quicker than the former.

johannes
