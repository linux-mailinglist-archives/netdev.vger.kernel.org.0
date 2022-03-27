Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B84F4E88DB
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 18:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236039AbiC0Qag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 12:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236028AbiC0Qaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 12:30:35 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7851120AC;
        Sun, 27 Mar 2022 09:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=r8ugo9cIQwH74OLJMoSLkZZbBVAk6G/YwHzpXPj4M/A=; b=xKTHUzlt2u+ReO4qBywWT+CEvG
        GIhO1tkvcRJ7w/Ao563360iwsj3ro8bRuR/31WoNjmX4QR4Dt7ksHTENbxBhAdzYzkBCqlJlGUjse
        ZqxYlPmxfiwB00GVIw7OhbEtPqUs9Qekms5ZHFAO0jaqWANA2bT+w9SvuguZbgXbF2lo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nYVkp-00Cu1b-Oj; Sun, 27 Mar 2022 18:28:35 +0200
Date:   Sun, 27 Mar 2022 18:28:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        corbet@lwn.net, bpf@vger.kernel.org, linux-doc@vger.kernel.org,
        f.fainelli@gmail.com
Subject: Re: [PATCH net 03/13] docs: netdev: move the patch marking section up
Message-ID: <YkCQs2kKE0CIzmC2@lunn.ch>
References: <20220327025400.2481365-1-kuba@kernel.org>
 <20220327025400.2481365-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220327025400.2481365-4-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +How do I indicate which tree (net vs. net-next) my patch should be in?
> +----------------------------------------------------------------------
> +To help maintainers and CI bots you should explicitly mark which tree
> +your patch is targeting. Assuming that you use git, use the prefix
> +flag::
> +
> +  git format-patch --subject-prefix='PATCH net-next' start..finish
> +
> +Use ``net`` instead of ``net-next`` (always lower case) in the above for
> +bug-fix ``net`` content.  If you don't use git, then note the only magic
> +in the above is just the subject text of the outgoing e-mail, and you
> +can manually change it yourself with whatever MUA you are comfortable
> +with.

Maybe we should consider removing the 'If you don't use git...' text.

We want people to use git.

Anybody who can correctly format a patch and get it passed their MTU
and mail system without it getting corrupted not using git should be
able to figure out how to set the subject line correctly.

	Andrew
