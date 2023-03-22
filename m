Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5CB6C3F47
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 01:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjCVAq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 20:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjCVAqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 20:46:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F8651FB9;
        Tue, 21 Mar 2023 17:46:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B8AC61ECD;
        Wed, 22 Mar 2023 00:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BD8C433EF;
        Wed, 22 Mar 2023 00:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679445978;
        bh=EZOv3FyS2Mk7iV57erQPRa/WPtxQIHtbDDcO4bCDpHg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VhxzZIuhecG2+Zqrzl/u7g/NxztrBfn6DgxAgL2+x1qT0Lny9WPjdufXg2UDDRT5f
         KF3tQToXqUAwGn4Hex1waow4aP9xvW0556RYbWuWurbAbhelGEeUmzR8JWvve7SpfZ
         /QV1s/1cNGDReGC/Pro9rBfzYhkmTTKBqEwIvpgPWUkK4xMSO+xdXcTp9E9eIFKQQg
         YNkCoWGL/wDvnz/1h1M/gtfQMZlHzTe9hFzSLryV27O28dHUsCGX1Dcy4BDR8wB7d1
         yV9vaCqmbUH9kUA3hcXTqWO97Ygfa3EGRsi1mMr27rr9IxCwdCs4GGcNKko4h49d7V
         95jYoyHj+1Tfw==
Date:   Tue, 21 Mar 2023 17:46:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        <corbet@lwn.net>, <jesse.brandeburg@intel.com>,
        <pisa@cmp.felk.cvut.cz>, <mkl@pengutronix.de>,
        <linux-doc@vger.kernel.org>, <f.fainelli@gmail.com>,
        <stephen@networkplumber.org>
Subject: Re: [PATCH net-next v2] docs: networking: document NAPI
Message-ID: <20230321174616.1ca08ad3@kernel.org>
In-Reply-To: <b06df26a-2db7-ad8f-23ff-85a8f812a16f@intel.com>
References: <20230321050334.1036870-1-kuba@kernel.org>
        <b06df26a-2db7-ad8f-23ff-85a8f812a16f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Mar 2023 10:18:53 -0700 Tony Nguyen wrote:
> With ixgb removed, this should already be gone? Aside from the ixgb 
> portion...

Good catch, I generated it on top of net. We used to send docs to net.
Now that linux-next docs are rendered online it doesn't matter so
I'll rebase to net-next, avoid the conflict.
