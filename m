Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63E24F5CAA
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiDFLq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiDFLqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:46:43 -0400
X-Greylist: delayed 623 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 06 Apr 2022 01:35:51 PDT
Received: from smtpservice.6wind.com (unknown [185.13.181.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D913D595FF6;
        Wed,  6 Apr 2022 01:35:49 -0700 (PDT)
Received: from 6wind.com (unknown [10.17.250.37])
        by smtpservice.6wind.com (Postfix) with ESMTP id DDB706000E;
        Wed,  6 Apr 2022 10:18:14 +0200 (CEST)
Date:   Wed, 6 Apr 2022 10:18:14 +0200
From:   Olivier Matz <olivier.matz@6wind.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org,
        Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        intel-wired-lan@osuosl.org
Subject: Re: [PATCH net 0/2] ixgbe: fix promiscuous mode on VF
Message-ID: <Yk1MxlsbGi810tgb@arsenic.home>
References: <20220325140250.21663-1-olivier.matz@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325140250.21663-1-olivier.matz@6wind.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Mar 25, 2022 at 03:02:48PM +0100, Olivier Matz wrote:
> These 2 patches fix issues related to the promiscuous mode on VF.
> 
> Comments are welcome,
> Olivier
> 
> Cc: stable@vger.kernel.org
> Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> 
> Olivier Matz (2):
>   ixgbe: fix bcast packets Rx on VF after promisc removal
>   ixgbe: fix unexpected VLAN Rx in promisc mode on VF
> 
>  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Sorry, the intel-wired-lan mailing list was not CC'ed initially.

Please let me know if I need to resend the patchset.

Thanks,
Olivier
