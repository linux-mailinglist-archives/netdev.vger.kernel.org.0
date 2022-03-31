Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9594EDD62
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 17:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239189AbiCaPlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 11:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241237AbiCaPj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 11:39:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FE42414E9
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 08:35:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BD9761B11
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 15:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E2FC340ED;
        Thu, 31 Mar 2022 15:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648740887;
        bh=l4bZu9cMqY1LZsVtirI5Y0LKTNtTBjXrw+JwNjreLQ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MoBXOAI+FclP3bzRdEtf87x8eqVJzd6B7Vp3dIZlRHFTJ/v5CCCFQdDnnHNYGjMzD
         OljCqxLPuvbY6GCWYxYBmLHPXT8ftb+DfYh20LODmzlaR+UoNPF3K/8yF6dk3TLrEd
         YKgdcsvVQ35SDgvkCW1jVxKRE59hiQ9vLDkOi1vx35RD7CUwBJo1YBNzmOswgfe3jS
         jrIu7dkPVkMStE/Mvv6kXpiyFXqPEfS0v49SqYbDkMTk4kPsHLyZPUt/t1v80TfdU/
         +KyldsgiayjBToeCVWVT12LcbxCzHL7YGIrmCqe7GOr0/TAVBD7qVeZccq1XtLquI3
         dgouapGcKQLrA==
Date:   Thu, 31 Mar 2022 08:34:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: Could you update the
 http://vger.kernel.org/~davem/net-next.html url?
Message-ID: <20220331083446.1d833d78@kernel.org>
In-Reply-To: <3097539.1648715523@warthog.procyon.org.uk>
References: <3097539.1648715523@warthog.procyon.org.uk>
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

On Thu, 31 Mar 2022 09:32:03 +0100 David Howells wrote:
> In Documentation/networking/netdev-FAQ.rst it mentions:
> 
>     If you aren't subscribed to netdev and/or are simply unsure if
>     ``net-next`` has re-opened yet, simply check the ``net-next`` git
>     repository link above for any new networking-related commits.  You may
>     also check the following website for the current status:
> 
>       http://vger.kernel.org/~davem/net-next.html
> 
> but the URL no longer points anywhere useful.  Could you update that?

It should display an image of a door sign saying "open" or "closed".
What do you see?
