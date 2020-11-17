Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9132B6F97
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731439AbgKQUGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731414AbgKQUGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:06:50 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B9AC0617A6
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 12:06:50 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id o9so31218013ejg.1
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 12:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Gs7R2ev+GdvZkSQzyJKlOzGhV1YIG/geSIkcbosi9pE=;
        b=SFN5xJOiz2XcXHz3OFDRYlyYwt7CLXtwyLFD9t/jgtx2R4I6SqUtSNFKGyVnXuNP3U
         mqJcSQRqIIPqMLfz8gIHoCGG0tBdBJGnrB58UfgFMLDfjxL/YttrUPW5EPsXEnw/zOBl
         3S3svsw6LdCWPwOj3gf5VEHkJ+Atbmee4/EYugZy1ZBHF3kcuYaazFkTGRyqw5csgJiP
         NFL1SllAnbKorUOgYYcKvrZBKeoq4j2QqNPHn5n2xyIdiLtcpsOQEuATGUlMa85IETnY
         IrQToDk/aJKuP6ZTx5lZqjKKY4iUKkFisE/WkNxFpf82J9gn5Tz43OJqIgEKkJZxDvj1
         5qtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Gs7R2ev+GdvZkSQzyJKlOzGhV1YIG/geSIkcbosi9pE=;
        b=S/rUKQrw47LyTxjpm/bI0NASMBxUAE0M7YJNbxORt/wwQA2AMkriMI06fonlRy2gdC
         NRNrmFubFkhmI61zt8OzfEQS9IqljdL8wyKdPk1A4jN1Hd+jQ4v/M268iOC4/CSdi83J
         Ida1zsfpfArDcZ8DvCmlRrn2jS2rrfivE1d8ljD+khDfKiqFTajMPyC4stDn7KQ1TZvF
         fEOl9un26lIEFPY0toGFLicz543O8Y+IGDGcnJvoKvQFbGt4HyckN3F9ghUj5NJwUyeA
         j5smoR0/cJArO29gAwvQ7Sfin76kTJqvAmUl25IPO1zkaB4577iYu6eP7zSQygch448Y
         DLvw==
X-Gm-Message-State: AOAM5326rJnlWbmH5t1CyDx/HwxNITn/q+xEn+bTjL1AN/MteVUqyh1J
        3rt4zecjIKpp46vGQtkRaPCmUw==
X-Google-Smtp-Source: ABdhPJyw0TAxMlvDFPbO5r0vaRxG3Do/B02IFkrtB4Ds+fgy9DAGN4O9NkmbIQXxlPyRpdRAKA0hZQ==
X-Received: by 2002:a17:906:ee2:: with SMTP id x2mr10069840eji.326.1605643609131;
        Tue, 17 Nov 2020 12:06:49 -0800 (PST)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id f18sm12345754edt.32.2020.11.17.12.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 12:06:48 -0800 (PST)
Date:   Tue, 17 Nov 2020 21:06:47 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] nfp: tls: Fix unreachable code issue
Message-ID: <20201117200646.GA10136@netronome.com>
References: <20201117171347.GA27231@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117171347.GA27231@embeddedor>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 11:13:47AM -0600, Gustavo A. R. Silva wrote:
> Fix the following unreachable code issue:
> 
>    drivers/net/ethernet/netronome/nfp/crypto/tls.c: In function 'nfp_net_tls_add':
>    include/linux/compiler_attributes.h:208:41: warning: statement will never be executed [-Wswitch-unreachable]
>      208 | # define fallthrough                    __attribute__((__fallthrough__))
>          |                                         ^~~~~~~~~~~~~
>    drivers/net/ethernet/netronome/nfp/crypto/tls.c:299:3: note: in expansion of macro 'fallthrough'
>      299 |   fallthrough;
>          |   ^~~~~~~~~~~
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Simon Horman <simon.horman@netronome.com>
