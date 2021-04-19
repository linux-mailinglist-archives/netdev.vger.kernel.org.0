Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C70363E69
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 11:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238530AbhDSJU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 05:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbhDSJU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 05:20:26 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A972C06174A;
        Mon, 19 Apr 2021 02:19:56 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lYQ4A-00Di8H-EB; Mon, 19 Apr 2021 11:19:38 +0200
Message-ID: <12e0173e43391fa70b9c199c31522b44a42ca03a.camel@sipsolutions.net>
Subject: Re: iwlwifi: Microcode SW error
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Gon Solo <gonsolo@gmail.com>, luciano.coelho@intel.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 19 Apr 2021 11:19:37 +0200
In-Reply-To: <20210419090800.GA52493@limone.gonsolo.de> (sfid-20210419_110849_136392_956DD8A0)
References: <20210419090800.GA52493@limone.gonsolo.de>
         (sfid-20210419_110849_136392_956DD8A0)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-04-19 at 11:08 +0200, Gon Solo wrote:
> 
> [Apr19 10:50] iwlwifi 0000:02:00.0: Queue 10 is active on fifo 1 and stuck for 10000 ms. SW [40, 93] HW [40, 93] FH TRB=0x0c010a037
> [  +0,001244] iwlwifi 0000:02:00.0: Microcode SW error detected.  Restarting 0x2000000.
> 
> The rest of the message is at the end of this message.
> The kernel version is "Linux Limone 5.12.0-051200rc7-lowlatency" from https://kernel.ubuntu.com/~kernel-ppa/mainline.
> The relevant output of lspci is:
> 02:00.0 Network controller: Intel Corporation Wireless 7260 (rev 73)
> 
> I would be glad to provide additional details if somebody is interested
> to fix this bug.
> 
> Regards,
> Andreas
> 
> [[Apr19 10:50] iwlwifi 0000:02:00.0: Queue 10 is active on fifo 1 and stuck for 10000 ms. SW [40, 93] HW [40, 93] FH TRB=0x0c010a037
> [  +0,001244] iwlwifi 0000:02:00.0: Microcode SW error detected.  Restarting 0x2000000.
> [  +0,000160] iwlwifi 0000:02:00.0: Start IWL Error Log Dump:
> [  +0,000004] iwlwifi 0000:02:00.0: Status: 0x00000040, count: 6
> [  +0,000005] iwlwifi 0000:02:00.0: Loaded firmware version: 17.3216344376.0 7260-17.ucode
> [  +0,000005] iwlwifi 0000:02:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN       

Do you use MFP?

Could be related to

https://patchwork.kernel.org/project/linux-wireless/patch/20210416134702.ef8486a64293.If0a9025b39c71bb91b11dd6ac45547aba682df34@changeid/

I saw similar issues internally without that fix.

johannes

