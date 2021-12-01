Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD721465917
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 23:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbhLAW1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 17:27:37 -0500
Received: from mail-ot1-f42.google.com ([209.85.210.42]:42591 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353551AbhLAW1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 17:27:36 -0500
Received: by mail-ot1-f42.google.com with SMTP id 47-20020a9d0332000000b005798ac20d72so37287090otv.9;
        Wed, 01 Dec 2021 14:24:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YMEIBGJAt4C+NZ+YEQcZm8sKEGbxD7TTp5853lRilDE=;
        b=GV99qEE0DG09Ow7U1VtrGbr0UuO9k09RmkNcvRYpeRb1j2VgYrUZjmJRKXLxTDp0gT
         IU44N5bqZV06mLeJnsrbhCHEnWxTaAQoraGT5JzcGncPM+RiXVlZ1aA3DFqaDzUsMk6Z
         LnrXnG3j17j951cO/yxNFrPrn2pYf6P8ioBdBm19r7bRbs1PGpgX4SkSLjhn7modrQnX
         DGR+fMwrLnPWVMrd2jBwwq8/F9aFn2DL10HDJ0pjOeYgemykSjtv1a763gVTkSLsrsN+
         MV0gGykLWf2DOkLOUoqJmNTETqG7ftqaJ9tkd5K09HzXMQsw94UtXFcQ6QBr8RI8wnUA
         G2YA==
X-Gm-Message-State: AOAM533v2vBrcf5ZOehXEhek576b/cwIYuBfJcN/yPVjlFcK3E32OVSX
        8KCeqp+8QqcuLKrIEYMouesGTXBxMA==
X-Google-Smtp-Source: ABdhPJwfyTuwv9Kh9gX2c6/xPis+92CU25FMnVusimcOSGyD8P/fxKQzZhHSs+5uAseYmQUM3ik4Tw==
X-Received: by 2002:a9d:5604:: with SMTP id e4mr8461253oti.249.1638397454396;
        Wed, 01 Dec 2021 14:24:14 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id bb7sm446450oob.14.2021.12.01.14.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 14:24:13 -0800 (PST)
Received: (nullmailer pid 2860950 invoked by uid 1000);
        Wed, 01 Dec 2021 22:24:12 -0000
Date:   Wed, 1 Dec 2021 16:24:12 -0600
From:   Rob Herring <robh@kernel.org>
To:     David Heidelberg <david@ixit.cz>
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        ~okias/devicetree@lists.sr.ht,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: ethernet-controller: add 2.5G and 10G
 speeds
Message-ID: <Yaf2DCBaIVJZxuzK@robh.at.kernel.org>
References: <20211124202046.81136-1-david@ixit.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124202046.81136-1-david@ixit.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 21:20:46 +0100, David Heidelberg wrote:
> Both are already used by HW and drivers inside Linux.
> 
> Fix warnings as:
> arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dt.yaml: ethernet@0,2: fixed-link:speed:0:0: 2500 is not one of [10, 100, 1000]
>         From schema: Documentation/devicetree/bindings/net/ethernet-controller.yaml
> 
> Signed-off-by: David Heidelberg <david@ixit.cz>
> ---
>  .../devicetree/bindings/net/ethernet-controller.yaml          | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Applied, thanks!
