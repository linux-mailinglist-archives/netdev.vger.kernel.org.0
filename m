Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AADF6EFF6E
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 04:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242131AbjD0Cq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 22:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbjD0Cq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 22:46:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A12B26BC
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 19:46:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FCA463A3F
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 02:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396A7C433EF;
        Thu, 27 Apr 2023 02:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682563585;
        bh=M1Kd7aHQUwTTcyEbRsGACt25xZGRn1jb3Q4esIiyEPs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SeCkq1bWlHaZQRVhChoh/ml2K9AgAYMArGfivNBMgAdSOigkmGEfmqxexn+wRIOqy
         KLpb/MGO/9ReC6WTUuMo6VmLFA/Qce1YmLTu5DWD+o56ImBJeg16kP6MbFUNXvvcDs
         zpBoM7H5c4Og4oMB8VHTkfHutQecRDWrh1xHGODvNbdtrwTXO6JEDllkMRS3P9mOhA
         50vpP2ERa1UTdIYjwBR+ASERwS1ZfA3Yk0q/Sd+XCwI9eb18EtTcW/UA2jlvT7OFjM
         IBf/c9zk/OomLt9RkKrIzs1Az/CjZdeC+e/hFWFmm3hZygO90SRjqw7gDAhRQUNEPn
         UMhQLMn+xhIyQ==
Date:   Wed, 26 Apr 2023 19:46:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Emil Tantilov <emil.s.tantilov@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        joshua.a.hay@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        willemb@google.com, decot@google.com, pabeni@redhat.com,
        edumazet@google.com, davem@davemloft.net, alan.brady@intel.com,
        madhu.chittim@intel.com, phani.r.burra@intel.com,
        shailendra.bhatnagar@intel.com, pavan.kumar.linga@intel.com,
        shannon.nelson@amd.com, simon.horman@corigine.com, leon@kernel.org
Subject: Re: [net-next v3 00/15] Introduce Intel IDPF driver
Message-ID: <20230426194623.5b922067@kernel.org>
In-Reply-To: <20230427020917.12029-1-emil.s.tantilov@intel.com>
References: <20230427020917.12029-1-emil.s.tantilov@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Apr 2023 19:09:02 -0700 Emil Tantilov wrote:
> This patch series introduces the Intel Infrastructure Data Path Function
> (IDPF) driver. It is used for both physical and virtual functions. Except
> for some of the device operations the rest of the functionality is the
> same for both PF and VF. IDPF uses virtchnl version2 opcodes and
> structures defined in the virtchnl2 header file which helps the driver
> to learn the capabilities and register offsets from the device
> Control Plane (CP) instead of assuming the default values.

This is not the right time to post patches, see below.

Please have Tony/Jesse take over posting of this code to the list
going forward. Intel has a history of putting upstream training on
the community, we're not going thru this again.


## Form letter - net-next-closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after May 8th.

RFC patches sent for review only are obviously welcome at any time.

See: https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#development-cycle
-- 
pw-bot: defer

