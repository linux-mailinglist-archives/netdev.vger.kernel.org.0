Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6815F744F
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 08:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiJGGoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 02:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJGGof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 02:44:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDF292
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 23:44:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EBDA61B66
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 06:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EB3C433C1;
        Fri,  7 Oct 2022 06:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665125071;
        bh=p0uvZMFF7tKgJGPh/q/4NTijhujEdgSvWA2Rf0wh25c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U5uPj2+3ODAKTkYoRd76kLNxlmgAJMox3PcAsD8VXRl9PqgO53LnVPpHJOY/rGo8u
         P1REDe0s6SvQxYHAlTp71271jpRjPhc1XuFJV1wyMGnKH5eVlRC4KLqdiMdSlGx31L
         MW5EWYUFP8hh6FPYQLJfbcNtFm91hvtWjF3QAJLDLyjKETkAnStYfcJqj3X8sc+PZo
         QKrq7zGlCsXCa/s3NTHiKywQ5tHDQQMBAMT9XIpXcnwm4ir0b6cNVwDv2wq0K173FY
         4qj8zF6XCF43ebvXyq6iqESgs5TlidtlLgHrDo37sf4i/Esgsbo1R1Qu1UExv1vHwU
         MZIAo2Eeb5iiw==
Date:   Fri, 7 Oct 2022 09:44:27 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: netdev development stats for 6.1?
Message-ID: <Yz/KyyT/oLsy4lK5@unreal>
References: <20221004212721.069dd189@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221004212721.069dd189@kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_20,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 04, 2022 at 09:27:21PM -0700, Jakub Kicinski wrote:
> Hi!
> 
> For a while now I had been curious if we can squeeze any interesting
> stats from the ML traffic. In particular I was curious "who is helping",
> who is reviewing the most patches (but based on the emails sent not just
> review tags).
> 
> I quickly wrote a script to scan emails sent to netdev since 5.19 was
> tagged (~14k) and count any message which has subject starting with
> '[' as a patch and anything else as a comment/review. It's not very
> scientific but the result for the most part matches my expectations.
> 
> A disclaimer first - this methodology puts me ahead because I send
> a lot of emails. Most of them are not reviews, so ignore me.
> 
> Second question to address upfront is whether publishing stats is
> useful or mostly risks people treating participation as a competition
> and trying to game the system? Hard to say, but if even a single person
> can point to these stats to help justify more time spent reviewing to
> their management - it's worth it.
> 
> That said feedback is very welcome, public or private.

I think that it is right initiative which will make netdev community
stronger and wider.

As for the feedback, which express my personal view as an outsider in netdev.

I think that more clear goals for that statistics can help to purify
which tables are actually needed as I'm sure that not all are needed.

My goals are:
1. See that load spreads more equity. It will indirectly cause to spread
of the knowledge. The most active reviewers are the most knowledgeable
developers too.
2. Push companies to participate in code maintenance (review) and not
only enjoy from free rides.

Thanks
