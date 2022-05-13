Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1BA5258D7
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 02:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359699AbiEMAEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 20:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234731AbiEMAEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 20:04:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF55128B692
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 17:04:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8A76B82BCF
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 00:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21035C385B8;
        Fri, 13 May 2022 00:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652400273;
        bh=MenvGb9vzfcy+OcO7OKtNnY2VF7/AWUY/H9PQ6Z9P18=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WX9mmpzRvhvCXBSSIU6BqrEk4/+29AqN+bgEVTUS6MGSWWeP9L7OgYwacZsm9OsEi
         s1so8wPN34lTU48ONew5PqV/ioV5ry/HsIIYcHMGW09ujnNAXyiU+Q03sMO3J4Q+g1
         4d8NCXQF2XNGA358FTNBxsyU/V5SKobfEicTlWp0VCgThn5x2u4QWli3iyoZe+AM6/
         rCm9hd/5BPbEQSgQNoVcmyYFR41qqao+DClB53w1Z2Kzdj4O/HeJIYUAU2GWufG21j
         Lnu1TZtTqGMJm5HHAwIvNRrZdgiYHOCYezOIAMdQ/NKtTiL9IAGjMxiQ3N+zhbGCxH
         MxnycpJ3yCMtQ==
Date:   Thu, 12 May 2022 17:04:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v7 0/2] axienet NAPI improvements
Message-ID: <20220512170431.6b51fdd3@kernel.org>
In-Reply-To: <6f1c104d118c55b6903a0557ddba223d3e2843b1.camel@calian.com>
References: <20220512171853.4100193-1-robert.hancock@calian.com>
        <6f1c104d118c55b6903a0557ddba223d3e2843b1.camel@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 May 2022 23:00:02 +0000 Robert Hancock wrote:
> Looking at Patchwork and Lore, seems like this cover letter may not have made
> it to the list, though the two patches did? Can resend if it doesn't eventually
> show up..

I may be wrong but I think it's fine, the cover letter doesn't have
much extra info, lore will catch you quoting it here and thread that
with the patches.
