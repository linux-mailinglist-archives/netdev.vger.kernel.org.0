Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF431776E5
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 14:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbgCCNV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 08:21:58 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35171 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727753AbgCCNV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 08:21:58 -0500
Received: by mail-wr1-f68.google.com with SMTP id r7so4341840wro.2
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 05:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=004iwmdbvB3c49zXjrxdzcpw0aD2nTC7C1OaBnxuOmY=;
        b=TUXSASvjSfIBM9Dy9JTUzAEfJB9OZ7d4f4352t1W4X7UdGtsAc4AO2Z4nlFVYsuzkU
         swgqWAjr4xCh29U3sBI0gJvYntFxNwiVIBm0Q50W77rzpG++54yEVkoWjTCVoI/punOf
         4ImqxTXDc18CNHFDAn7/M5mEE8dIrGF8p0PmiMBmPBV2Xk68olsPg+7EKVoCeL7cfzJq
         FTWnbXnK37lGqiUL9AKBZaNTKoQOllxWYCIdA0WVqmua4hJGdHqaaGiFi/KyLbZLyPxr
         +RMLiMgqPuXcrUT+BrFqrfsNBBHXZFkOuUo8giIiI20XezZmmK6nviRN6otczLRss85e
         dx6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=004iwmdbvB3c49zXjrxdzcpw0aD2nTC7C1OaBnxuOmY=;
        b=C1p/4Gs5oVayQCt0cgYb2cPxjbA4gMAf6+lhuwcWw87hNbGePk4zSFOzxDh0ij+/GA
         +2yJhAHczIlGq3c/IeAOdRlLRJCYF2xQYSWJjNeNCJ1QCbWWLUIRpxM7LNsGTXxyKKmD
         tDfm0/5CHCIR0WWtbevoB6sb/ATSrMK0ZuO3tnoFKtDjwvurs47+HrHxpxgfskxwDbi0
         9Z24E6Cvosva53D8gI+ptHYCybfVKiW8P7GJ4TYpWCh+bZX59DK2YdRgv2Mn5t1/Qz+V
         1UcDr8dVXHrXmMHE3NWKYUmbXwv8GiHk6gCouguLox6lsIKXqIpKKQyMU7LXOl5TCEp7
         ut6g==
X-Gm-Message-State: ANhLgQ1SyEvENK1ftGrnX1gy6wAYT7nJuifmPMzbi5Fu8gJ1YqQUNmKP
        bxEpu9H95s2FKFwDFAK5o3dkAg==
X-Google-Smtp-Source: ADFU+vuhVfHNSWjry1JDUO/1jMvW5w7fMYDPNyLeHxuYRm/PEphlQ2Pg2nHC1t+lxNFcWAiY8xzchQ==
X-Received: by 2002:a5d:6881:: with SMTP id h1mr5370250wru.236.1583241714002;
        Tue, 03 Mar 2020 05:21:54 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id z13sm4551944wrw.88.2020.03.03.05.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 05:21:53 -0800 (PST)
Date:   Tue, 3 Mar 2020 14:21:52 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "mlxsw@mellanox.com David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: mlxfw: Replace zero-length array with
 flexible-array member
Message-ID: <20200303132152.GI2178@nanopsycho>
References: <20200302210437.GA30285@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302210437.GA30285@embeddedor>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 02, 2020 at 10:04:37PM CET, gustavo@embeddedor.com wrote:
>The current codebase makes use of the zero-length array language
>extension to the C90 standard, but the preferred mechanism to declare
>variable-length types such as these ones is a flexible array member[1][2],
>introduced in C99:
>
>struct foo {
>        int stuff;
>        struct boo array[];
>};
>
>By making use of the mechanism above, we will get a compiler warning
>in case the flexible array does not occur last in the structure, which
>will help us prevent some kind of undefined behavior bugs from being
>inadvertently introduced[3] to the codebase from now on.
>
>Also, notice that, dynamic memory allocations won't be affected by
>this change:
>
>"Flexible array members have incomplete type, and so the sizeof operator
>may not be applied. As a quirk of the original implementation of
>zero-length arrays, sizeof evaluates to zero."[1]
>
>This issue was found with the help of Coccinelle.
>
>[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
>[2] https://github.com/KSPP/linux/issues/21
>[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>
>Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
