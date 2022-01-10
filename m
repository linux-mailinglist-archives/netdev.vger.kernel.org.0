Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26F748936C
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 09:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240961AbiAJIdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 03:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240779AbiAJIc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 03:32:29 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7762C06175A;
        Mon, 10 Jan 2022 00:32:28 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id q8so25122994wra.12;
        Mon, 10 Jan 2022 00:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=yFitxr4LUHEFQN8u7AKlHp0fvIKgsL3O7SmilxAJ8Oc=;
        b=CXOEf99IK1mY3GLkw9GNvYdr52AtX0sZMVWOs/Eiq9CczPEXduaMo0vlZ2qoyix+ph
         0HwVXJdikHrXDcBaY1MKHpxOOxeLw09kQyeVsbCcZt43PJ1XSK5Pet1Z8ozgKmVpm7sk
         jimUATnPEcup3fkeXwB2FdnZne6nKMCJUTp4OufurHBJwmziB0TTFfY3NDFByIepaT3V
         RdrCOpAGT00LFFkJYvKdIpevYNUxJtZgGBAWnWyolq7+p1gfZL6jXrlj4MaNtWnKrOXr
         eO41HoxSseMHTJBHd+r2UFovE99zVb3HOKjTpYYaNYcj8FO6+mTmGYs+6TXCVzJ5rkmY
         UH6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=yFitxr4LUHEFQN8u7AKlHp0fvIKgsL3O7SmilxAJ8Oc=;
        b=gPButolWsR64gs1xodEXX/Oqnxk8NxxvvQnJ+95DpspyLZEdcWuihfXKF2pOLK20bd
         xAcP1gHg25P7UhA9VouS6jCF45YELvBjlfbaNC8sN1RWorkjFF9WXDbGc7+qZ0FCF1p6
         FJ6MPHQprx0HISR1PpqBOxNCmBEEVeJ6LQ+AxcrZjhtkI9ym0weWVCCVEyhCIP22fjOc
         31Z74FlbxVKzJgz5WzrvyyIJGwNk7jtGLleiieCfiHAzyE8sGTNZteOgsvOkaLiTGm+b
         W2+0ihCRN3Z2uUWBzKaAf2e4lHJUbrvcufLZTtIiuIQRkM2Od/MuxF/5esuE+pOIDTI2
         kSRQ==
X-Gm-Message-State: AOAM530oJHIvlthgETE8Ls1Vp6ORp3r3b6+Jf2AR79WtxZteELfm9EH1
        KfcJCj2yOMSXvEaIDEOxNMyoLNm/LRQ=
X-Google-Smtp-Source: ABdhPJxH9vwRdImfYpgveDGSsQDl1xCE7+/AHH07mUQMvxC03h6+c+jz8nziUVPvFgWhNlvookMM2A==
X-Received: by 2002:a5d:650f:: with SMTP id x15mr62949067wru.57.1641803547569;
        Mon, 10 Jan 2022 00:32:27 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id y4sm6192515wrd.50.2022.01.10.00.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 00:32:27 -0800 (PST)
Date:   Mon, 10 Jan 2022 09:32:24 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     conleylee@foxmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] sun4i-emac: replace magic number with marcos
Message-ID: <YdvvGAzD7KQlxBZo@Red>
References: <tencent_58B12979F0BFDB1520949A6DB536ED15940A@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_58B12979F0BFDB1520949A6DB536ED15940A@qq.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, Jan 10, 2022 at 03:23:07PM +0800, conleylee@foxmail.com a écrit :
> From: conley <conleylee@foxmail.com>
> 
> - sun4i-emac.h: add register related marcos
> - sun4i-emac.c: replace magic number with marco
> 
> *** BLURB HERE ***
> 
> conley (2):
>   sun4i-emac.h: add register related marcos
>   sun4i-emac.c: replace magic number with macro
> 
>  drivers/net/ethernet/allwinner/sun4i-emac.c | 26 ++++++++++-----------
>  drivers/net/ethernet/allwinner/sun4i-emac.h | 18 ++++++++++++++
>  2 files changed, 31 insertions(+), 13 deletions(-)
> 

Hello

The from should be your real name.
You miss commit message.
The subject should be "net: allwinner: xxxx" or "net: ethernet: sun4i-emac: xxxx"
You did a typo marcos/macros
If you add a changelog, either put it in cover letter or below "---" in patch along git stats (changelog should not be part of commit message).

I think both patch should be merged.

Regards
