Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2F96E2E26
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 03:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjDOBS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 21:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjDOBSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 21:18:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0389165B3
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 18:18:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9340F62A16
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 01:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6CDC433EF;
        Sat, 15 Apr 2023 01:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681521532;
        bh=5lRHhrFBrL7fBCKy3k8QlDC3vcG3ilSmtvM0VPBhSPg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Kzz271grPwJQK5gAd5frdH9dYiZKRvTeyQKWhKCEzkCgKNKJWBipzWiWdbQZ4TC5t
         /ILTyq37GsLi4D/c67MI5ssC1t6qiydBK9cKLFRh1ckYVUiYyGnzApwOfT0kGU3HPB
         sGDR2CEAbAxXMvcQL+odCah2vjrtFYDnTXQuC3JDDMYgLYxs+4qcT2l9GyjpOWLje2
         6U2ow9cDtIATgcSPPB4yiqFfaZsifm9ChploVOA7R2BPWLKm8zRfgoiMCCtcO7yVcn
         KjTI1Rj03Kv8aoVl1FBRDKqkkQHn7cWcMSnRsYcHyvY8cBiw0FprstWMSG6LzAVjpX
         ClR3eM7qvENwA==
Date:   Fri, 14 Apr 2023 18:18:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] ice: document RDMA devlink parameters
Message-ID: <20230414181850.74279da4@kernel.org>
In-Reply-To: <20230414162614.571861-1-jacob.e.keller@intel.com>
References: <20230414162614.571861-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 09:26:14 -0700 Jacob Keller wrote:
> Commit e523af4ee560 ("net/ice: Add support for enable_iwarp and enable_roce
> devlink param") added support for the enable_roce and enable_iwarp
> parameters in the ice driver. It didn't document these parameters in the
> ice devlink documentation file. Add this documentation, including a note
> about the mutual exclusion between the two modes.

Thanks! We do need an ack from Tony if we're supposed to take 
this directly, tho. FWIW in case Tony takes it in - it should 
go towards net.
