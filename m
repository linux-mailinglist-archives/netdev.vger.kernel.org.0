Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5216666479
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 21:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239563AbjAKUFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 15:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239601AbjAKUFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 15:05:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BA844C4C
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 12:01:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5845A61DEA
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 20:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823B9C433F0;
        Wed, 11 Jan 2023 20:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673467305;
        bh=k6o4rGki1ykT0BZIZuKNDnKUaozyi9eBYJymVD77iwk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FfeaKkZQDrcW0csRz6DZVEcy7IJLbvGFpSN5mGDvgDZ/uxVsWjYYmY2VVv3KxVHRr
         X4dGJaWxQmIt7pEXJXA7XhYIvhtnqQzuYlddfkZNOgTnMZr4V0Q9BTUFdBb+SQdD6M
         SO3EO2CWl+idEeKmVx/RIrVXfzGIeGZL88hqAg97AZp2p6zUjwhA088SgXaWkYYUL8
         T17UwH4sAFbspfnpNNsBTGfzfwh9cYMV096RUAOQTTKXUK8hD625Ysa2EmKAyG7DvK
         0FoQZFptljRz0vVYdH7MaBZQCSC3Q0ybIeEPIhmUHb3f0qhVF4i6viODEDy6oEouRP
         Yi+RPzYvtzQ5g==
Date:   Wed, 11 Jan 2023 12:01:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 2/2] ice: Add check for kzalloc
Message-ID: <20230111120144.48ecac23@kernel.org>
In-Reply-To: <46ee9dd9-4895-80a2-a846-6444a72a15c2@intel.com>
References: <20230109225358.3478060-1-anthony.l.nguyen@intel.com>
        <20230109225358.3478060-3-anthony.l.nguyen@intel.com>
        <20230110182607.3a41ab85@kernel.org>
        <46ee9dd9-4895-80a2-a846-6444a72a15c2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 11:31:55 -0800 Tony Nguyen wrote:
> Hi Jakub,
> 
> Thanks for the suggestion/improvement. This won't be here much longer as 
> we will be converting to use the kernel infrastructure [1] soon, but 
> will keep this in mind for the future.
> 
> This was mainly to ensure the existing implementations got 
> corrected/could be backported.

Ack, to be clear - I did not mean to request a follow up.
Only to suggest a better way of dealing with the error path 
for future code.
