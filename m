Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A76500A03
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 11:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241342AbiDNJkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 05:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiDNJkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 05:40:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6076F4B7;
        Thu, 14 Apr 2022 02:37:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4334561CAB;
        Thu, 14 Apr 2022 09:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E33C385A5;
        Thu, 14 Apr 2022 09:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649929077;
        bh=6f2Gh2D/BBGsLckHTbJXAaHIeaELvJTaaKPlpBlXXMM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fl9e/KRWXdNyIUt/RhqzwYuUGi4p3tZFhJgg0pmv7mHQWJEZd5G2V7fL7kxmNnrVD
         NKmbsHJei5Q/ceZNhebxFpKpBiC2i4ro2ewJr/WcNopkLZ4RRLI49oWjZF08yQjE99
         1tTOfXOkn9r1LBVxwJdE9Kck+6vgwCMe1sn0UJU9OCe29+hnGpoZka2f9dftoqvjD0
         stjzRPMBYxE8xGnwuPguIaz5srkwwACUoQ5bXpn1tmg0A2bc0kiJYA8AwVpotBvXM7
         HF5BM5h33Z+BPhibJR4yHRf+uHH/CDgzFZgFtpy4hothPe5wRkMnV5pY9vBqpmANd7
         RlF7m+6kO553Q==
Date:   Thu, 14 Apr 2022 11:37:50 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     krzk@kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linma@zju.edu.cn
Subject: Re: [PATCH 0/3] Fix double free bugs and UAF bug in nfcmrvl module
Message-ID: <20220414113750.046e7a77@kernel.org>
In-Reply-To: <cover.1649913521.git.duoming@zju.edu.cn>
References: <cover.1649913521.git.duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Apr 2022 13:31:19 +0800 Duoming Zhou wrote:
> We add lock and check in fw_dnld_over() and nfcmrvl_fw_dnld_start(),
> in order to synchronize among different threads that operate on
> firmware.

All the patches must have the same version in the tag.

Also you are CCing a number of people who likely have no interest 
in NFC patches.

Please improve your postings, I've been silently dropping a lot of your
patches because you keep posting them in unusual ways and patchwork is
unable to group them properly :(
