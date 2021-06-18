Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAA33AD008
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 18:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbhFRQKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 12:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234134AbhFRQKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 12:10:11 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29959C0617A8
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 09:07:56 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id x19so4913896pln.2
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 09:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D3UjhCbXjW6+10/ciZOO7iL2BxCnT+x63RbItCm3JdE=;
        b=L7YgMww35m9BXf/f8gX4vlzmPJR7h4+nXWRRwV5Z3qrTIqTKqJ9JL3/BgCT4hH2qt2
         7a8pkbfRA0C0OSmI6Hfg1RpJaXINarJVSQyub33BEBmk1qC03SLiCH2kTN6Gro9+8XUE
         G4euw49UYrs0AfcxjoQhBz9uN4bTmP7pWS0Co=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D3UjhCbXjW6+10/ciZOO7iL2BxCnT+x63RbItCm3JdE=;
        b=L9y/fTlR2kcHKrEUjTEKROA5rxzaMaeTFlQn+bAKUCU5vdWj+HFb2ve1WOgTFs77/e
         kIzncpW0lSscQQNGg82G+NYmK1/5DgNv0EqgVzG2bdltrE66yhYg4/uqrZmYQI/oP35G
         DoppTJRI7dYNKhkN/gTwc5HBpzf+OVOKvHX1sCkffr4CUh6K2ZBw8L0LaIbXODzXYGLY
         1Bp2weAhHb8r5ghEClM9cHeo9VBWTX+Vuz38e0opINWZUo5Iy/TT2l725lOyOJFw0J3d
         1msOJPL6rb+mvV3lPRXGVYtjcmynfhX36JC93Pu4CeYVqDP8QyofZBRniAisf3hzw0ZM
         gQSA==
X-Gm-Message-State: AOAM532EdvOqULfkKIUJDOUfN5KR3i4csz2g2z8TVWmt+y/gObN0K823
        2nrn0WrCcvnvtzidaCf9JXMOlAsdgy4RGQ1a
X-Google-Smtp-Source: ABdhPJz/J12oar04LQE8/xPXFeCmbR2zOK4frsk+xQwCmDnRjY/LSWuew6361kLwtgi3Ie89IjZx5g==
X-Received: by 2002:a17:90b:4b04:: with SMTP id lx4mr23142320pjb.54.1624032475713;
        Fri, 18 Jun 2021 09:07:55 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x20sm8085195pfu.205.2021.06.18.09.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 09:07:55 -0700 (PDT)
Date:   Fri, 18 Jun 2021 09:07:54 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        sgoutham@marvell.com, hkelam@marvell.com, gakula@marvell.com
Subject: Re: [net-next PATCH 1/5] octeontx2-af: cn10k: Bandwidth profiles
 config support
Message-ID: <202106180903.E89363BB@keescook>
References: <1623756871-12524-1-git-send-email-sbhatta@marvell.com>
 <1623756871-12524-2-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623756871-12524-2-git-send-email-sbhatta@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 05:04:27PM +0530, Subbaraya Sundeep wrote:
> [...]
> @@ -885,6 +906,9 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
>  			else if (req->ctype == NIX_AQ_CTYPE_MCE)
>  				memcpy(&rsp->mce, ctx,
>  				       sizeof(struct nix_rx_mce_s));
> +			else if (req->ctype == NIX_AQ_CTYPE_BANDPROF)
> +				memcpy(&rsp->prof, ctx,
> +				       sizeof(struct nix_bandprof_s));

rsp->prof is u64 not struct nix_bandprof_s, so the compiler thinks this
memcpy() is overflowing the "prof" field.

Can you please fix this up?

-- 
Kees Cook
