Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DDB2858B0
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 08:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgJGGbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 02:31:09 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54200 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726564AbgJGGbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 02:31:09 -0400
X-Greylist: delayed 1786 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Oct 2020 02:31:07 EDT
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=[192.168.100.69])
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kQ2Vk-002QAG-Oj; Wed, 07 Oct 2020 09:01:13 +0300
Message-ID: <27f10117a4f26d6f1f528d8e03fe753614dbef1a.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Kalle Valo <kvalo@codeaurora.org>, Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Wed, 07 Oct 2020 09:01:10 +0300
In-Reply-To: <87lfgjbzin.fsf@codeaurora.org>
References: <20200910065431.657636-1-lee.jones@linaro.org>
         <20201002090353.GS6148@dell> <87362rdhv2.fsf@codeaurora.org>
         <20201006065617.GX6148@dell> <87lfgjbzin.fsf@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        TVD_RCVD_IP autolearn=ham autolearn_force=no version=3.4.4
Subject: Re: [PATCH v2 00/29] [Set 1,2,3] Rid W=1 warnings in Wireless
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-10-06 at 10:10 +0300, Kalle Valo wrote:
> Lee Jones <lee.jones@linaro.org> writes:
> 
> > On Tue, 06 Oct 2020, Kalle Valo wrote:
> > 
> > > Lee Jones <lee.jones@linaro.org> writes:
> > > 
> > > > On Thu, 10 Sep 2020, Lee Jones wrote:
> > > > 
> > > > > This is a rebased/re-worked set of patches which have been
> > > > > previously posted to the mailing list(s).
> > > > > 
> > > > > This set is part of a larger effort attempting to clean-up W=1
> > > > > kernel builds, which are currently overwhelmingly riddled with
> > > > > niggly little warnings.
> > > > > 
> > > > > There are quite a few W=1 warnings in the Wireless.  My plan
> > > > > is to work through all of them over the next few weeks.
> > > > > Hopefully it won't be too long before drivers/net/wireless
> > > > > builds clean with W=1 enabled.
> > > > > 
> > > > > Lee Jones (29):
> > > > >   iwlwifi: dvm: Demote non-compliant kernel-doc headers
> > > > >   iwlwifi: rs: Demote non-compliant kernel-doc headers
> > > > >   iwlwifi: dvm: tx: Demote non-compliant kernel-doc headers
> > > > >   iwlwifi: dvm: lib: Demote non-compliant kernel-doc headers
> > > > >   iwlwifi: calib: Demote seemingly unintentional kerneldoc header
> > > > >   wil6210: Fix a couple of formatting issues in 'wil6210_debugfs_init'
> > > > >   iwlwifi: dvm: sta: Demote a bunch of nonconformant kernel-doc headers
> > > > >   iwlwifi: mvm: ops: Remove unused static struct 'iwl_mvm_debug_names'
> > > > >   iwlwifi: dvm: Demote a couple of nonconformant kernel-doc headers
> > > > >   iwlwifi: mvm: utils: Fix some doc-rot
> > > > >   iwlwifi: dvm: scan: Demote a few nonconformant kernel-doc headers
> > > > >   iwlwifi: dvm: rxon: Demote non-conformant kernel-doc headers
> > > > >   iwlwifi: mvm: tx: Demote misuse of kernel-doc headers
> > > > >   iwlwifi: dvm: devices: Fix function documentation formatting issues
> > > > >   iwlwifi: iwl-drv: Provide descriptions debugfs dentries
> > > > >   wil6210: wmi: Fix formatting and demote non-conforming function
> > > > >     headers
> > > > >   wil6210: interrupt: Demote comment header which is clearly not
> > > > >     kernel-doc
> > > > >   wil6210: txrx: Demote obvious abuse of kernel-doc
> > > > >   wil6210: txrx_edma: Demote comments which are clearly not kernel-doc
> > > > >   wil6210: pmc: Demote a few nonconformant kernel-doc function headers
> > > > >   wil6210: wil_platform: Demote kernel-doc header to standard comment
> > > > >     block
> > > > >   wil6210: wmi: Correct misnamed function parameter 'ptr_'
> > > > >   ath6kl: wmi: Remove unused variable 'rate'
> > > > >   ath9k: ar9002_initvals: Remove unused array
> > > > >     'ar9280PciePhy_clkreq_off_L1_9280'
> > > > >   ath9k: ar9001_initvals: Remove unused array 'ar5416Bank6_9100'
> > > > >   ath9k: ar5008_initvals: Remove unused table entirely
> > > > >   ath9k: ar5008_initvals: Move ar5416Bank{0,1,2,3,7} to where they are
> > > > >     used
> > > > >   brcmsmac: phytbl_lcn: Remove unused array 'dot11lcn_gain_tbl_rev1'
> > > > >   brcmsmac: phy_lcn: Remove unused variable
> > > > >     'lcnphy_rx_iqcomp_table_rev0'
> > > > 
> > > > What's happening with all of these iwlwifi patches?
> > > > 
> > > > Looks like they are still not applied.
> > > 
> > > Luca (CCed) takes iwlwifi patches to his iwlwifi tree.
> > 
> > Thanks Kalle.
> > 
> > Luca,
> > 
> >   Do you know why these patches have not been applied yet?  Do you
> > plan on applying them this week?  -rc1 is not due for release for
> > nearly 3 weeks now that Linus tagged an -rc8.
> 
> I can also take Lee's patches directly to wireless-drivers-next, if
> that's easier for Luca.

Hi,

Yes, please take these patches directly.  It simplifies things.

Thanks!

--
Cheers,
Luca.

