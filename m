Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561FC22E5CA
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 08:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgG0GV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 02:21:57 -0400
Received: from mga07.intel.com ([134.134.136.100]:37586 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbgG0GV5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 02:21:57 -0400
IronPort-SDR: 0Ek+KIbq5VNBLFkrkP4TSNYuarAV7OVUt6zIgUohyidJnq+1PQKCe++WqGafowKL01+Q2Hf9Jv
 XX9vnYT5euBA==
X-IronPort-AV: E=McAfee;i="6000,8403,9694"; a="215510351"
X-IronPort-AV: E=Sophos;i="5.75,401,1589266800"; 
   d="scan'208";a="215510351"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2020 23:21:56 -0700
IronPort-SDR: NVYS3ldD8YM0bctiebfnIS/AO0CV+wbOruJ/aZ4lYoLxZjs71eSbjqEcgZclf2L/35UWp4+KZQ
 C31Jc0BjZFXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,401,1589266800"; 
   d="scan'208";a="312103645"
Received: from bfarkas-mobl.ger.corp.intel.com ([10.249.254.210])
  by fmsmga004.fm.intel.com with ESMTP; 26 Jul 2020 23:21:53 -0700
Message-ID: <8c5eadd1b400cf749a6ece07fedd7ce2a877bcdb.camel@intel.com>
Subject: Re: [RFC PATCH] iwlwifi: yoyo: don't print failure if debug
 firmware is missing
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Kalle Valo <kvalo@codeaurora.org>, Wolfram Sang <wsa@kernel.org>
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 27 Jul 2020 09:21:52 +0300
In-Reply-To: <87y2n6404y.fsf@codeaurora.org>
References: <20200625165210.14904-1-wsa@kernel.org>
         <20200726152642.GA913@ninjato> <87y2n6404y.fsf@codeaurora.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-07-26 at 21:11 +0300, Kalle Valo wrote:
> Wolfram Sang <wsa@kernel.org> writes:
> 
> > On Thu, Jun 25, 2020 at 06:52:10PM +0200, Wolfram Sang wrote:
> > > Missing this firmware is not fatal, my wifi card still works. Even more,
> > > I couldn't find any documentation what it is or where to get it. So, I
> > > don't think the users should be notified if it is missing. If you browse
> > > the net, you see the message is present is in quite some logs. Better
> > > remove it.
> > > 
> > > Signed-off-by: Wolfram Sang <wsa@kernel.org>
> > > ---
> > 
> > Any input on this? Or people I should add to CC?
> 
> This was discussed on another thread:
> 
> https://lkml.kernel.org/r/87mu3magfp.fsf@tynnyri.adurom.net
> 
> Unless Intel folks object I'm planning to take this to
> wireless-drivers-next.

Yes, please, just go ahead and take it.  I have the same change in our
internal tree, but I didn't have the time to send it out due to my
vacations (from which I'm now back).

--
Cheers,
Luca.

