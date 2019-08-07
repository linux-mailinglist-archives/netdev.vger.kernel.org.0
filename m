Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7AE843A2
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 07:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfHGFYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 01:24:12 -0400
Received: from mga04.intel.com ([192.55.52.120]:14267 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfHGFYM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 01:24:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 22:24:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,356,1559545200"; 
   d="scan'208";a="176853760"
Received: from kerdanow-mobl.ger.corp.intel.com ([10.252.3.167])
  by orsmga003.jf.intel.com with ESMTP; 06 Aug 2019 22:24:07 -0700
Message-ID: <a32af5800af19779eb5be8d7b2552de18bfac194.camel@intel.com>
Subject: Re: [PATCH -next] iwlwifi: dbg: work around clang bug by marking
 debug strings static
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Date:   Wed, 07 Aug 2019 08:24:06 +0300
In-Reply-To: <20190807051516.GA117639@archlinux-threadripper>
References: <20190712001708.170259-1-ndesaulniers@google.com>
         <874l31r88y.fsf@concordia.ellerman.id.au>
         <3a2b6d4f9356d54ab8e83fbf25ba9c5f50181f0d.camel@sipsolutions.net>
         <CAKwvOdmBeB1BezsGh=cK=U9m8goKzZnngDRzNM7B1voZfh8yWg@mail.gmail.com>
         <20190807051516.GA117639@archlinux-threadripper>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-08-06 at 22:15 -0700, Nathan Chancellor wrote:
> On Tue, Aug 06, 2019 at 03:37:42PM -0700, Nick Desaulniers wrote:
> > On Thu, Aug 1, 2019 at 12:11 AM Johannes Berg <johannes@sipsolutions.net> wrote:
> > > 
> > > > Luca, you said this was already fixed in your internal tree, and the fix
> > > > would appear soon in next, but I don't see anything in linux-next?
> > > 
> > > Luca is still on vacation, but I just sent out a version of the patch we
> > > had applied internally.
> > > 
> > > Also turns out it wasn't actually _fixed_, just _moved_, so those
> > > internal patches wouldn't have helped anyway.
> > 
> > Thanks for the report. Do you have a link?
> > I'll rebase my patch then.
> > -- 
> > Thanks,
> > ~Nick Desaulniers
> 
> Just for everyone else (since I commented on our issue tracker), this is
> now fixed in Linus's tree as of commit  1f6607250331 ("iwlwifi: dbg_ini:
> fix compile time assert build errors").

Yes, thanks Nathan! I was just digging for this patch to reply to you,
I'm still catching up with what happened during my vacations.

--
Cheers,
Luca.

