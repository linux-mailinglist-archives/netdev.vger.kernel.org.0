Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A3226C674
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 19:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbgIPRud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 13:50:33 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36772 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727552AbgIPRtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 13:49:06 -0400
Received: by mail-wm1-f68.google.com with SMTP id z9so3940882wmk.1;
        Wed, 16 Sep 2020 10:48:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9YduFabkaAz51UI756numtXbvX9M9QxKpDfQ0I1NJKI=;
        b=gmmBuO/LxKkUV0a6H1DwGn8wC8eQVSludYcEeEoxVWkKhrZgcFI/mf6qsUz04bq1j3
         beIRlm5JYDkYkq0y0ChKoJHYR0ApRt58+Cd+xQXqhrg6eUArXdD6d3t44TII3nGN2daa
         hnY39I1D1qyUqRCX/CtUqeaoqcx53dyj+onWY6UIiY0sUBaXt2yJVB7QqnVtf38rRVii
         swwM1L1QN0FbDkulVXTontLQafOpTXvJU+JJpXK0F7aP9PU9IBhArXm0GFCe1aZI3ZeG
         71a7mMZbQMRKPmFH48GM4MsFDtCpbg9BV00e5qFnwRsohJoBjW2MuymTfSTSE5RZ5tew
         k0rA==
X-Gm-Message-State: AOAM533X3WFG7oLOjjDpoldYZLysxNVm3BF34T/SgTNorLfqdqIGJ7Nu
        8EqyRltrCDHOeDiSTJBjgtc=
X-Google-Smtp-Source: ABdhPJyO/sEeRuiNIVE/sPTGt/TEZkcbizXPspGpU49mJITjkoAMu1miylOrL2A27nAiAcaaihq7hg==
X-Received: by 2002:a1c:4943:: with SMTP id w64mr5751806wma.62.1600278534553;
        Wed, 16 Sep 2020 10:48:54 -0700 (PDT)
Received: from kozik-lap ([194.230.155.191])
        by smtp.googlemail.com with ESMTPSA id q18sm33240468wre.78.2020.09.16.10.48.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Sep 2020 10:48:53 -0700 (PDT)
Date:   Wed, 16 Sep 2020 19:48:51 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>, Kukjin Kim <kgene@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: s3c: Bring back notes from removed debug-macro.S
Message-ID: <20200916174851.GA23474@kozik-lap>
References: <20200911143343.498-1-krzk@kernel.org>
 <20200911143343.498-3-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200911143343.498-3-krzk@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 04:33:43PM +0200, Krzysztof Kozlowski wrote:
> Documentation references notes from a removed debug-macro.S file so
> bring the contents here.
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  arch/arm/mach-s3c/s3c64xx.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Applied.

Best regards,
Krzysztof

