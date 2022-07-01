Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAD5563792
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 18:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiGAQQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 12:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiGAQQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 12:16:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCA73CA56;
        Fri,  1 Jul 2022 09:16:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81100B828C9;
        Fri,  1 Jul 2022 16:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A51C3411E;
        Fri,  1 Jul 2022 16:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656692200;
        bh=wsRq4vfipwsdIEeGcFEHU6IVSQk0SiLxtSKmEijxZ8I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TZOki9QekFl2tCGxBCqCyI1I8/yNs7RU8RbThxGU8ZPaSA0VLUscW7614OQlUw6q/
         77uiG8/4OgGJlBB4e33YeUdlrXlVj5f+er5kH7yhwgvEpdbaUEcfic/f0WjujErqgd
         KIneoymyV136+9Xska6PoFPiE1mCojV7YMmWr+zBLR7Q1KTNCYFXc/3cEN05FqBsDi
         W1AZzWi8J+B3x9g9IOshfXy63LKRI3eSSB5KDsHsCcPIqLhiXFvjBSz+xWxwQE/yOP
         rK6ZOuhDQodA9uCIB2FNOZMgZ03QY//AoEZ1CtPRedrkC88VDV3rXiUD++wa+VzEYp
         EijOheo5XX/7A==
Date:   Fri, 1 Jul 2022 09:16:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, linux-doc@vger.kernel.org
Subject: Re: [PATCH net 1/3] docs: netdev: document that patch series length
 limit
Message-ID: <20220701091638.631b60b0@kernel.org>
In-Reply-To: <Yr6mziKdr/rmuTjt@lunn.ch>
References: <20220630174607.629408-1-kuba@kernel.org>
        <20220630174607.629408-2-kuba@kernel.org>
        <Yr6mziKdr/rmuTjt@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 Jul 2022 09:48:30 +0200 Andrew Lunn wrote:
> > +Put yourself in the shoes of the reviewer. Each patch is read separately
> > +and therefore should constitute a comprehensible step towards your stated
> > +goal. Avoid sending series longer than 15 patches, they clog review queue
> > +and increase mailing list traffic when re-posted.
>
> I think a key concept is, big patch series takes longer to review, so
> needs a bigger junk of time allocated to it, so often gets differed
> until late. As a result, it will take longer to merge. A small series
> can be reviewed in a short time, so Maintainers just do it, allowing
> for quicker merging.

Good point, let me fold that in.
