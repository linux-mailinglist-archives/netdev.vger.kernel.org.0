Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCF534258E
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 19:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhCSS64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 14:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbhCSS6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 14:58:24 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95568C06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 11:58:23 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id l18so3776399edc.9
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 11:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=xN+kBSGQGx4nIrJj9FQmN0QsYcZ3ZQsCoKGBWPkVXvk=;
        b=AHn/OLawhRvpIp55VZjM6FGrKBU3kOHlF7Ly016LZGSdWS2yWXE8BFtRIyoovBHbsq
         LMHcpjc7GRzRuQdzwCNvKheUqmUGHOt8zylmd4dCwds030mX9UyAjuq+xIQqOsqIAV0u
         PYuAJslnYDuAGeewsGkzFd3Zd10xbRe8gylKY7EhsXXVLCYWcrBx+UVCDEjx4BUTFMmE
         eXtykWdPnfZrnPFwraO3cCaqwUDw/965PDG3cW50L7rCQ0e4Xg6bYUj2ydQGOqx1JdD3
         QZjl06taFO8knSJRaG6G/LtFxRhx4cUJJ12JQeBec1+vmF4q9NB3LwkFVa4BrtPUxJWS
         FpXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=xN+kBSGQGx4nIrJj9FQmN0QsYcZ3ZQsCoKGBWPkVXvk=;
        b=F1RpNpK64ZgwrnGUPq5wx7snY+87Gg5MMyR23Io4lvXS5D2Ylq3vg34lTx2XJj4PUt
         FL6zhETeF6ZzfBDfCIXN1Y+FQuavwPu/DmQmcNL1ltxJBYf1/fyncxy+eCCEOSoOBsOF
         sO6c8AVOq5sVp4lEBjH5I+eFqIbSLJThLBD2XEN9sTK9eNELodSILmlTaMeVUPVDMise
         VL21Kag/D3UWl5AENK6xDqddit/gwuNjiA50gtauqJNexonwPJ6VRGlEDRKFYhHWTVYC
         mGOkLc6TYzF+E0+jyLAqSaT/SwQ6b9JLA+x4i8+5qaigGmgXeUI5Xc5CKstZalQP7qE/
         rRlA==
X-Gm-Message-State: AOAM531Q2mtQxFG3i1mnF6eZKs2keS+L1fcnx3m9yJnOKe8bUosNUD/O
        SudwPTAUh1CSCuO0zzhSCeM=
X-Google-Smtp-Source: ABdhPJyLoXOxXL0rzopXe6ksx7HGyRjtgSs62VDJ6+9s/r/QaC/OAtnFOwOE87ISXgm90t/UQt7hAw==
X-Received: by 2002:aa7:cf95:: with SMTP id z21mr11217532edx.76.1616180302404;
        Fri, 19 Mar 2021 11:58:22 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id f19sm4596655edu.12.2021.03.19.11.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 11:58:21 -0700 (PDT)
Date:   Fri, 19 Mar 2021 20:58:20 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: cosmetic fix
Message-ID: <20210319185820.h5afsvzm4fqfsezm@skbuf>
References: <20210319143149.823-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210319143149.823-1-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 03:31:49PM +0100, Marek Behún wrote:
> We know that the `lane == MV88E6393X_PORT0_LANE`, so we can pass `lane`
> to mv88e6390_serdes_read() instead of MV88E6393X_PORT0_LANE.
> 
> All other occurances in this function are using the `lane` variable.
> 
> It seems I forgot to change it at this one place after refactoring.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> Fixes: de776d0d316f7 ("net: dsa: mv88e6xxx: add support for ...")
> ---

Either do the Fixes tag according to the documented convention:
git show de776d0d316f7 --pretty=fixes

Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")

or even better, drop it.
