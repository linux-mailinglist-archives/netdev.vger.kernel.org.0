Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13EC5A8653
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 21:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiHaTBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 15:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbiHaTBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 15:01:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0FDA3D21;
        Wed, 31 Aug 2022 12:01:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8912B8229E;
        Wed, 31 Aug 2022 19:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E59C433C1;
        Wed, 31 Aug 2022 19:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661972470;
        bh=LUaBA/4C31nHwrvwIUWMxHhuvJt/HjUER3lbjrAuo60=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qBMZxXQkFd/O9K0eifHZ09pIJ/x3NYqS/8v7VuzQWELvs1+W0+KST5PwOHuh9ph42
         yZH/V7zCamObVWHbiS3iFdXFooojrV4FFy/26zcBcmU6l+lNMUIy3Whhedwz+ejLLv
         LvoxmGFvkOdjwz2BkCg0KmwxsxJVMX4trDF077w/b3db8hqFRXMKnIBCsyd74Auq10
         3yKHIGWmFTPhsVfPYXXI7AQcI1zWUsKn65SnIY+tmNb+An0iMagAHgltLmbItRTkqS
         rdPIb7TlUFmuIAQORiXb6UpbOaSxwYR5FC1EhuYiK+XxU45rHTcWaCiI96DCbUzUWp
         Zlv+So3eieKug==
Date:   Wed, 31 Aug 2022 14:01:03 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] uapi: net/ipv4: Use __DECLARE_FLEX_ARRAY() helper
Message-ID: <Yw+v7yUxS896r2cd@work>
References: <Yw5H3E3a6mmpuTeT@work>
 <202208311116.62D0CD477@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202208311116.62D0CD477@keescook>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 11:17:31AM -0700, Kees Cook wrote:
> >  struct ip_msfilter {
> > -	union {
> > -		struct {
> > -			__be32		imsf_multiaddr_aux;
> > -			__be32		imsf_interface_aux;
> > -			__u32		imsf_fmode_aux;
> > -			__u32		imsf_numsrc_aux;
> > +	struct {
> 
> I don't think this internal anonymous struct is needed any more?

yes, aaargh... copy/paste error D:

I'll respin right away.

Thanks!
--
Gustavo
