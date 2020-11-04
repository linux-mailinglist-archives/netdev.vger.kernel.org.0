Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB272A66FD
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbgKDPCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 10:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729457AbgKDPCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 10:02:31 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D86C061A4A
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 07:02:30 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id n15so22435996wrq.2
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 07:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=81Mse8odwUjQV3SNBNj2FsfywF1tiGHXXotMmkJJHW8=;
        b=viu93AOy3xtt5np4teMRKK5RPXVY7zCBVt08ueo21/+WVlsHH70Z64yvEcxmtX5YwV
         9qaHmBWMiZ2blH0/yYvcbYcd7kRyeomNmUC0/MWqdH1h9ymN1jk8giecgbFKCTM8DnyR
         c3NQKnRjTWmpEKK99YkBJY0PtxIM1HvndhXd5Qq7bl+FkG6RVV4cR2xk7LvjOsj3A0ip
         vfDFnrM3/8X4hDASMfEwQqm5lQ2TwiNGgho550Komc9sHUccGxKIYQ/eSvyO29FHuKhG
         OWKi4TsBd/zSNLPg8pNtJLSlnRltMUYBxgG0o9PGqibuU5clN/EA+Z8ELNUcPiw42g8Y
         y8dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=81Mse8odwUjQV3SNBNj2FsfywF1tiGHXXotMmkJJHW8=;
        b=ev4TupQJgRPwFBjh0uiKzuILUxM2/mKI4TU4rTYwsFUyV2Znu0onyffe4TgFRavxTM
         Y3i/x8KuCv3mnfh4VgWf4po2/IJAbXHP6LHACX/7MFDGwLbtrGff3iNtluM3gW2QmlWU
         QYioZXKXmh5e3Vh2Mn5ubZoKVefb61WdBCzGzxC4x+1B3L5k1N2+Tp0xyikFsFj/TapM
         kQ6qNkveJ949xddn1UQ9hmDTdBNBYi+qiiCgXCcTtV9tsPRo5TomKKFdGp4O5HRZ8jUK
         cSRpjx62RgoRF8q41rKE2Pb5snnBXehV+A9GsnDhk3LqyBN35J2gzgOFHddCN0JoAWdF
         TMXg==
X-Gm-Message-State: AOAM531ZfmP+NwHt7vLAaqdA6hsBNu8sY8NFE8FnDtz6okF12WqZAISm
        S0PA71V9k+Xkc43FTI/75jacqg==
X-Google-Smtp-Source: ABdhPJypYAAZ7r+4LPnSUtyaXe3ShiyXwgc/fbQKuIg+5Gcf9mk0rjcUcvq7eb3IcNddiOLJo1uetg==
X-Received: by 2002:adf:a554:: with SMTP id j20mr7457254wrb.182.1604502149602;
        Wed, 04 Nov 2020 07:02:29 -0800 (PST)
Received: from dell ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id u3sm6755809wme.0.2020.11.04.07.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 07:02:28 -0800 (PST)
Date:   Wed, 4 Nov 2020 15:02:26 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 06/12] net: ethernet: ti: am65-cpsw-qos: Demote
 non-conformant function header
Message-ID: <20201104150226.GK4488@dell>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
 <20201104090610.1446616-7-lee.jones@linaro.org>
 <20201104133354.GA933237@lunn.ch>
 <20201104142835.GD4488@dell>
 <20201104143838.GD1213539@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201104143838.GD1213539@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 04 Nov 2020, Andrew Lunn wrote:

> On Wed, Nov 04, 2020 at 02:28:35PM +0000, Lee Jones wrote:
> > On Wed, 04 Nov 2020, Andrew Lunn wrote:
> > 
> > > On Wed, Nov 04, 2020 at 09:06:04AM +0000, Lee Jones wrote:
> > > > Fixes the following W=1 kernel build warning(s):
> > > > 
> > > >  drivers/net/ethernet/ti/am65-cpsw-qos.c:364: warning: Function parameter or member 'ndev' not described in 'am65_cpsw_timer_set'
> > > >  drivers/net/ethernet/ti/am65-cpsw-qos.c:364: warning: Function parameter or member 'est_new' not described in 'am65_cpsw_timer_set'
> > > > 
> > > > Cc: "David S. Miller" <davem@davemloft.net>
> > > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > > Cc: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> > > > Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> > > > Cc: netdev@vger.kernel.org
> > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > 
> > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > > 
> > > I _think_ these have got missed so far in the various cleanup passes
> > > because of missing COMPILE_TEST. I've been adding that as part of
> > > fixing these warnings. When your respin, could you add that as well?
> > 
> > Yes, no problem.
> > 
> > Just for this symbol?
> 
> Hi Lee
> 
> I've not look at the Kbuild, but ideally so that all TI drivers get
> built when COMPILE_TEST is true.
> 
> And this probably needs to happen for any patch i added a Reviewed-by:
> because i missed them as well. I'm using COMPILE_TEST but just for arm
> and x86, where as i guess you are using more randconfig builds, or
> less popular architectures?

I'm doing 'allmodconfig' builds for; arm, arm64, mips, ppc and x86.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
