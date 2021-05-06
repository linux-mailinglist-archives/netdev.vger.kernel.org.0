Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E26375CB0
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 23:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhEFVOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 17:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhEFVOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 17:14:46 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABD1C061574;
        Thu,  6 May 2021 14:13:47 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lelJR-0059iY-CI; Thu, 06 May 2021 23:13:37 +0200
Message-ID: <285a8ab279d5ac6caa6e44d808ec2b0ae134bc1e.camel@sipsolutions.net>
Subject: Re: [PATCH v1] mac80211_hwsim: add concurrent channels scanning
 support over virtio
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Weilun Du <wdu@google.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@android.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 06 May 2021 23:13:36 +0200
In-Reply-To: <CAD-gUuCt5ugOyo-9Ge5omTgNJu26OORZFEZ2tSnQEiNLZN9ZyA@mail.gmail.com> (sfid-20210506_231208_394097_2355C230)
References: <20210506180530.3418576-1-wdu@google.com>
         <cc2f068d6c82d12de920b19270c6f42dfcabfd11.camel@sipsolutions.net>
         <CAD-gUuCt5ugOyo-9Ge5omTgNJu26OORZFEZ2tSnQEiNLZN9ZyA@mail.gmail.com>
         (sfid-20210506_231208_394097_2355C230)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-05-06 at 14:11 -0700, Weilun Du wrote:
> On Thu, May 6, 2021 at 11:19 AM Johannes Berg <johannes@sipsolutions.net> wrote:
> > 
> > On Thu, 2021-05-06 at 11:05 -0700, Weilun Du wrote:
> > > This fixed the crash when setting channels to 2 or more when
> > > communicating over virtio.
> > 
> > Interesting, I thought I was probably the only user of virtio? :)
> > 
> > johannes
> > 
> Hi Johannes,
> Actually, Android Emulator uses mac80211_hwsim for wifi simulation
> over virtio and it's working. This patch fixed the crash when we set
> channels=2 to speed up scanning. I am trying to see if it makes sense
> to upstream this patch since it's not Android-specific. Thanks!
> 
Oh sure, I'll take a look and will probably apply it for the next cycle,
haven't done an in-depth review. I was just surprised somebody actually
*used* the virtio thing :-)

Does that mean virt_wifi isn't used anymore by the Android emulator?
Maybe then we should remove that again, it had some obscure bugs that
syzkaller found? Not that I mind it being around much, but ...

johannes

