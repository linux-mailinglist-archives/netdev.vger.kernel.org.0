Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF4126A1E7
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 11:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgIOJRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 05:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgIOJRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 05:17:41 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C149C061788
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 02:17:40 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z4so2501405wrr.4
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 02:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=g0wq4OHsivPgwum0m30tDMm3Sc6rVYhxpSv4ZsJufv8=;
        b=dErZGht+HzEj0U9/qfEKQtaMKHVk5i+ARgVuQZcAf1y9KhpfbKbE3ExreRZyHgcYmX
         KMYpI3Y1ODYDHRPqc9W7AeEO6lTIykU87K01SpzoIYlEkERbsJIMW4hLvIh15OYxuL2e
         1qkPt02UWZddIpIuP5CsJyXGIkYFO5FqwZb62XxaOACzwgRUlv0YKUeqrHmlzB8nseGv
         x1LF6INQseSD6coRriwDJHPkCSk4kLc6qhkkd+ytfqq59hS1HGHp75hKhrInIXCnH4/V
         Plb5qHTwT7ctG84/fmT6GFcWegtSzxQPn1z+gGtX8W6CoLCkvajTDJ+T1RIZzof66JK+
         NPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=g0wq4OHsivPgwum0m30tDMm3Sc6rVYhxpSv4ZsJufv8=;
        b=F4Bt4On0sdG7KcwoJB3VPfuX6i9pNtepdlvMerW9lvweLLEN8dg/jBf4089Y2RbwKS
         CNDWboaABPw8syEyazW7rpw9dgmB3uzG0VpOkjBFVz2ILPAy3y6X9Pu64Zrh4THRs3Tk
         51lq1XihVKpfXOOOOJa7aNdbADHLdW/7oN9u9lctbBMXaiCFD53olGwQ1snMw9hZHKUa
         kmwm+f5UTDdoVvHFMkl50PxhsCu10djJtNsBqYGmwR5or3n0cyjBJbvneXIonEe0aNV4
         ZCsRNduOy4M/qyH7EmXfiEtTy9MGv3Sw8Ro4ahE1WlFqnDSTLlvRPdovBXk/sDEgEuHV
         aBHA==
X-Gm-Message-State: AOAM53247CG9WRjhpnJcfkbUGkJCvHmubMxd49rOn6Cpymy971DUZNuL
        FO9rxMM4QVtyqZiv52sibxtT4g==
X-Google-Smtp-Source: ABdhPJyy9VnkjIcFnV/PSTOwOko71sntBrgkcbhdTsqW+bMsdETC13nFxjtIMkVxGcJ2W1gnJx7QnA==
X-Received: by 2002:a5d:6cb0:: with SMTP id a16mr19556925wra.88.1600161459533;
        Tue, 15 Sep 2020 02:17:39 -0700 (PDT)
Received: from dell ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id x2sm25233289wrl.13.2020.09.15.02.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 02:17:38 -0700 (PDT)
Date:   Tue, 15 Sep 2020 10:17:37 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codeaurora.org>
Subject: Re: [PATCH 06/29] wil6210: Fix a couple of formatting issues in
 'wil6210_debugfs_init'
Message-ID: <20200915091737.GC4678@dell>
References: <20200910065431.657636-7-lee.jones@linaro.org>
 <20200912063455.C3FA3C433CA@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200912063455.C3FA3C433CA@smtp.codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Sep 2020, Kalle Valo wrote:

> Lee Jones <lee.jones@linaro.org> wrote:
> 
> > Kerneldoc expects attributes/parameters to be in '@*.: ' format and
> > gets confused if the variable does not follow the type/attribute
> > definitions.
> > 
> > Fixes the following W=1 kernel build warning(s):
> > 
> >  drivers/net/wireless/ath/wil6210/debugfs.c:456: warning: Function parameter or member 'wil' not described in 'wil6210_debugfs_init_offset'
> >  drivers/net/wireless/ath/wil6210/debugfs.c:456: warning: Function parameter or member 'dbg' not described in 'wil6210_debugfs_init_offset'
> >  drivers/net/wireless/ath/wil6210/debugfs.c:456: warning: Function parameter or member 'base' not described in 'wil6210_debugfs_init_offset'
> >  drivers/net/wireless/ath/wil6210/debugfs.c:456: warning: Function parameter or member 'tbl' not described in 'wil6210_debugfs_init_offset'
> > 
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: wil6210@qti.qualcomm.com
> > Cc: netdev@vger.kernel.org
> > Reviewed-by: Maya Erez <merez@codeaurora.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Aren't these also applied already? Please don't resend already applied
> patches.

Not at the time I rebased them.

> 8 patches set to Rejected.
> 
> 11766845 [06/29] wil6210: Fix a couple of formatting issues in 'wil6210_debugfs_init'
> 11766747 [16/29] wil6210: wmi: Fix formatting and demote non-conforming function headers
> 11766827 [17/29] wil6210: interrupt: Demote comment header which is clearly not kernel-doc
> 11766825 [18/29] wil6210: txrx: Demote obvious abuse of kernel-doc
> 11766823 [19/29] wil6210: txrx_edma: Demote comments which are clearly not kernel-doc
> 11766821 [20/29] wil6210: pmc: Demote a few nonconformant kernel-doc function headers
> 11766819 [21/29] wil6210: wil_platform: Demote kernel-doc header to standard comment block
> 11766817 [22/29] wil6210: wmi: Correct misnamed function parameter 'ptr_'

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
