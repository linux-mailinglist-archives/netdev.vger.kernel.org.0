Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723202B5A74
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 08:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgKQHnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 02:43:06 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35381 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgKQHnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 02:43:05 -0500
Received: by mail-wm1-f65.google.com with SMTP id w24so2288794wmi.0;
        Mon, 16 Nov 2020 23:43:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oExuX2nPRUSZWCSdhqK8NxiNZJd+yxDbz9expD12f3M=;
        b=ghjQ74GRiRAXWh0dbXyPpGbajVxhGsXuuiplp3LPW21SzqPnKIranVRYB1lvBuqInB
         9nvV2CFGTp6s1x91x/sdihesquLKARsihEtotMMB1YqRWEOoKGkMd3VatSe8bNSMDZIc
         m+0rDlvrZBVrRnxGyF1KEzMUYtNffcnn6lNAWcoZ0ql7xFw46kkGPbUq8u66XTmxwNco
         bgZv2FdW0ay8nYytq/5aXHdnJZf+CBaXSYJs+fcBCTVBHDvRImPqFckkmztys1kt0S62
         c/0r+B1Fz/zWHSx/H1/VpJWePRUxJK0O49ODYe42Cn9ALbQBItj1AmcYZqrvrESnL1TD
         OxSQ==
X-Gm-Message-State: AOAM5314uYNBXQ801a0UEl82IJlP0AnKaltV6G0Nib6rgQnNiYiovksy
        mSayPB3yi/ixhJo253ky1Vw=
X-Google-Smtp-Source: ABdhPJxcnC6sO/BNZsI5NeOShjqX9i4uiWmUL3qMzRG3WfK8VeDKoqFmlMidJJfFt7rjcQXccIBrOA==
X-Received: by 2002:a05:600c:2949:: with SMTP id n9mr2732488wmd.29.1605598981991;
        Mon, 16 Nov 2020 23:43:01 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id m3sm22344531wrv.6.2020.11.16.23.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 23:43:01 -0800 (PST)
Date:   Tue, 17 Nov 2020 08:42:59 +0100
From:   "krzk@kernel.org" <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon@samsung.com>
Cc:     Krzysztof Opasiak <k.opasiak@samsung.com>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 3/3] nfc: s3fwrn5: Change the error code
Message-ID: <20201117074259.GE3436@kozik-lap>
References: <CGME20201117011850epcms2p568af074144630cd0f02b3a7f7eff8d1a@epcms2p5>
 <20201117011850epcms2p568af074144630cd0f02b3a7f7eff8d1a@epcms2p5>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201117011850epcms2p568af074144630cd0f02b3a7f7eff8d1a@epcms2p5>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 10:18:50AM +0900, Bongsu Jeon wrote:
> ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  drivers/nfc/s3fwrn5/s3fwrn5.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

I already reviewed it.

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
