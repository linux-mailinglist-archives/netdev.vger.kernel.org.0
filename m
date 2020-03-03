Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8FA17719E
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 09:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgCCIz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 03:55:26 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:60330 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726661AbgCCIz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 03:55:26 -0500
X-Greylist: delayed 1463 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Mar 2020 03:55:25 EST
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <luca@coelho.fi>)
        id 1j92wh-0003yi-5b; Tue, 03 Mar 2020 10:30:37 +0200
Message-ID: <c2de2c8548d47945d4d3708c6b1c6a992d9e8cc3.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Kalle Valo <kvalo@codeaurora.org>, Leho Kraav <leho@kraav.com>
Cc:     "Jan Alexander Steffens (heftig)" <jan.steffens@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <871rqauhbp.fsf@tynnyri.adurom.net>
References: <20191224051639.6904-1-jan.steffens@gmail.com>
         <20200221121135.GA9056@papaya> <871rqauhbp.fsf@tynnyri.adurom.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Date:   Tue, 03 Mar 2020 10:17:07 +0200
User-Agent: Evolution 3.34.1-4 
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        TVD_RCVD_IP,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.2
Subject: Re: [PATCH] iwlwifi: pcie: restore support for Killer Qu C0 NICs
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-03-03 at 07:40 +0200, Kalle Valo wrote:
> Leho Kraav <leho@kraav.com> writes:
> 
> > On Tue, Dec 24, 2019 at 06:16:39AM +0100, Jan Alexander Steffens (heftig) wrote:
> > > Commit 809805a820c6 ("iwlwifi: pcie: move some cfg mangling from
> > > trans_pcie_alloc to probe") refactored the cfg mangling. Unfortunately,
> > > in this process the lines which picked the right cfg for Killer Qu C0
> > > NICs after C0 detection were lost. These lines were added by commit
> > > b9500577d361 ("iwlwifi: pcie: handle switching killer Qu B0 NICs to
> > > C0").
> > > 
> > > I suspect this is more of the "merge damage" which commit 7cded5658329
> > > ("iwlwifi: pcie: fix merge damage on making QnJ exclusive") talks about.
> > > 
> > > Restore the missing lines so the driver loads the right firmware for
> > > these NICs.
> > 
> > This seems real, as upgrading 5.5.0 -> 5.5.5 just broke my iwlwifi on XPS 7390.
> > How come?
> 
> Luca, should I apply this to wireless-drivers?
> 
> https://patchwork.kernel.org/patch/11309095/

Yes, please take it to wireless-drivers.  I've reassigned it to you.

But please note that this will conflict with another patch that is
already in v5.6-rc* that introduced this code again in a different way:

https://patchwork.kernel.org/patch/11318849/

--
Cheers,
Luca.

