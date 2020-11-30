Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560452C8B65
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 18:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387630AbgK3Rin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 12:38:43 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:40836 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgK3Rim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 12:38:42 -0500
Received: by mail-io1-f68.google.com with SMTP id r9so12635001ioo.7;
        Mon, 30 Nov 2020 09:38:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CerhPbui13FpoNb9exSHqzyCHaCrXMui37OolaLymdI=;
        b=VSZQJ0ftd+cf3qTlsHfB2zLffYcUS7CjeVh2U61sBeD0hPZ2hlOp9I5OsgIpkWefoZ
         EC8eldkz9xP9VH1XZSaWYDg+pqr/yWxvMZhVkSKGRg7upIptx4kOg/c8kwSHTO20AR8G
         ckBVjMNr/sLlhEWHwnFsDQDzMCHgBpov6X8CUYXJ4zSZVGCGaCNeavVQ/lkPLuVOeaPG
         BcyOoji9UMEjXYsecuddl4klkml0SsiBTzGpNaj8L3EzoeZTb60IFZY3SQseo+cI79ED
         a+CYhoYXIl0oOlCE4KnznuJo7y5B4jjJhwPl+BnHxDsFk6zPT2r7E3sVR/RrV6HktqLo
         Dmzw==
X-Gm-Message-State: AOAM530a0Td8OE1ooT5o6qYmdlVw6bbsWC9MFzWX0dzXSWqWevNZVGzD
        HYNxTlXYQTM/UVEqncaf3g==
X-Google-Smtp-Source: ABdhPJypUuXxZGps6TUoa95Rtjj/XPIIiHpxIqJRHsDJJ6Ot8Q0BJDrdM/QZlzr/20MMDG2qqUjIHA==
X-Received: by 2002:a6b:d61a:: with SMTP id w26mr16910378ioa.117.1606757875758;
        Mon, 30 Nov 2020 09:37:55 -0800 (PST)
Received: from xps15 ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id f29sm9898312ilg.3.2020.11.30.09.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 09:37:54 -0800 (PST)
Received: (nullmailer pid 2685982 invoked by uid 1000);
        Mon, 30 Nov 2020 17:37:52 -0000
Date:   Mon, 30 Nov 2020 10:37:52 -0700
From:   Rob Herring <robh@kernel.org>
To:     Bongsu jeon <bongsu.jeon2@gmail.com>
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>, linux-nfc@lists.01.org,
        krzk@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/4] dt-bindings: net: nfc: s3fwrn5: Support
 a UART interface
Message-ID: <20201130173752.GB2684526@robh.at.kernel.org>
References: <1606737627-29485-1-git-send-email-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606737627-29485-1-git-send-email-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 21:00:27 +0900, Bongsu jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Since S3FWRN82 NFC Chip, The UART interface can be used.
> S3FWRN82 supports I2C and UART interface.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
> 
> Changes in v2:
>  -change the compatible name.
>  -change the const to enum for compatible.
>  -change the node name to nfc.
> 
>  .../bindings/net/nfc/samsung,s3fwrn5.yaml          | 32 ++++++++++++++++++++--
>  1 file changed, 29 insertions(+), 3 deletions(-)
> 


My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:
./Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml:17:9: [warning] wrong indentation: expected 10 but found 8 (indentation)

dtschema/dtc warnings/errors:


See https://patchwork.ozlabs.org/patch/1408172

The base for the patch is generally the last rc1. Any dependencies
should be noted.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

