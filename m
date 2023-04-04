Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A45A76D65B6
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 16:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjDDOsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 10:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjDDOs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 10:48:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DF930C5
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 07:48:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CCC96200D
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 14:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A724C433D2;
        Tue,  4 Apr 2023 14:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680619707;
        bh=ECw3dLThsz8aGHXnxQaUhXY0MOQr3WE8OFmgk9okYvc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aAUmYQv1gijbfNZPZHHTcbBNAUsJtoalF+Gox7bdkrvPHE4sr3hUzQlSqFkxnKKDA
         bxuwI10ymZlUre7Cq4R0mpWWxLKUj2D6MYpCNAWyiAmExo9wfwp3WiFnX2P4z1AYF9
         Zr37q2Ht783t6z84LklybZMOOiqdCgOBXc9UQSr7CLXsB82YiT/fGxRKmL5trnzAGB
         8Pf5NXeLRO7bDR88ziYgzTfaWht0eUwLDEERKmE5/8Vz9iWsrZXg/Q9ydT3p2a1T9p
         Ozeg+YN0OmSvdDoXQqizCHCvIc3jqk7ALy7ccSzxgb8BKVYqqdZWdU19U4TWY7PWuc
         sIRLnGa34/LNQ==
Date:   Tue, 4 Apr 2023 07:48:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        drivers@pensando.io, leon@kernel.org, jiri@resnulli.us
Subject: Re: [PATCH v8 net-next 07/14] pds_core: add FW update feature to
 devlink
Message-ID: <20230404074826.21aadbcb@kernel.org>
In-Reply-To: <6e775522-db04-f187-1f40-c7ecb1b8e5a6@amd.com>
References: <20230330234628.14627-1-shannon.nelson@amd.com>
        <20230330234628.14627-8-shannon.nelson@amd.com>
        <20230331220908.2a2fa0bc@kernel.org>
        <6e775522-db04-f187-1f40-c7ecb1b8e5a6@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Apr 2023 12:49:28 -0700 Shannon Nelson wrote:
> > My memory is hazy but I think you needed similar functionality in ionic
> > and deferred implementing proper uAPI for it? And now we have another
> > driver with the same problem?  
> 
> I don't believe we discussed bank selection for ionic, but did in a 
> follow up discussion from the original posting of this driver back in 
> November [1].  This expanded into a much large thing that no one has 
> gotten around to working on yet.  At this point we simply are installing 
> the new FW and waiting for a reboot to make it live, which I don't 
> remember causing any controversy in ionic.
> 
> In the ionic case, we did have a short discussion about nomenclature for 
> select and enable, and reworked the timeout status notification.  This 
> code uses those same methods.

Alright.

[sorry for late response, this verbose email got stuck in my outbox :S]
