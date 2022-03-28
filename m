Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB92E4E9DA9
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 19:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244615AbiC1RkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 13:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244612AbiC1RkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 13:40:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43933252B9;
        Mon, 28 Mar 2022 10:38:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1091B81135;
        Mon, 28 Mar 2022 17:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C96CC340F0;
        Mon, 28 Mar 2022 17:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648489120;
        bh=pUsauhumcZqTUGcfMft78YCm8q0XAhTYHrQVpLqLt3A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=upBzjP44XT6seAgMy8V6c0hwiUwDw2SMcRknpV715lOh+PsUeaUqvcl7EqdBNBvTF
         3U2AywHaK4FpZ8PpnA5SX+Ee3CrmOk7qtR5CdqqMy+vql5vSJxno03yb2xHj+PAOyR
         JWv7ZdoBLQ8qlY1KrHswCMY4Ql11qg0MwoPC1sLY668WTzHrDo5nDkByXSEC49nFZV
         qoXCrcb7cukyqHO7ZqK02JIqf9c15KtfQ6nOaFChu/P8HFb2boWpMBUyvR/VwPiJ8d
         nf5Ixsr45onMfAxYpMiYMSNaZnpHLvLKQ03fwYNEtiJuI7HW7LCpaWBFgIipxDHdHD
         CjEel1z4JgvXQ==
Date:   Mon, 28 Mar 2022 10:38:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        corbet@lwn.net, bpf@vger.kernel.org, linux-doc@vger.kernel.org,
        f.fainelli@gmail.com
Subject: Re: [PATCH net 03/13] docs: netdev: move the patch marking section
 up
Message-ID: <20220328103839.602a0d43@kernel.org>
In-Reply-To: <YkCQs2kKE0CIzmC2@lunn.ch>
References: <20220327025400.2481365-1-kuba@kernel.org>
        <20220327025400.2481365-4-kuba@kernel.org>
        <YkCQs2kKE0CIzmC2@lunn.ch>
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

On Sun, 27 Mar 2022 18:28:35 +0200 Andrew Lunn wrote:
> > +How do I indicate which tree (net vs. net-next) my patch should be in?
> > +----------------------------------------------------------------------
> > +To help maintainers and CI bots you should explicitly mark which tree
> > +your patch is targeting. Assuming that you use git, use the prefix
> > +flag::
> > +
> > +  git format-patch --subject-prefix='PATCH net-next' start..finish
> > +
> > +Use ``net`` instead of ``net-next`` (always lower case) in the above for
> > +bug-fix ``net`` content.  If you don't use git, then note the only magic
> > +in the above is just the subject text of the outgoing e-mail, and you
> > +can manually change it yourself with whatever MUA you are comfortable
> > +with.  
> 
> Maybe we should consider removing the 'If you don't use git...' text.
> 
> We want people to use git.
> 
> Anybody who can correctly format a patch and get it passed their MTU
> and mail system without it getting corrupted not using git should be
> able to figure out how to set the subject line correctly.

Sounds good to me.
