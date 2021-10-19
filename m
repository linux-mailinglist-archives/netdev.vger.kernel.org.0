Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD714340AE
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 23:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhJSVmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 17:42:09 -0400
Received: from mail-ot1-f48.google.com ([209.85.210.48]:41645 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhJSVmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 17:42:09 -0400
Received: by mail-ot1-f48.google.com with SMTP id v2-20020a05683018c200b0054e3acddd91so3690342ote.8;
        Tue, 19 Oct 2021 14:39:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sKNbAmszLsQhFT7DFncEwajZs0JtulmAZhcXAEilTy8=;
        b=fkVlHXn6A8tHvWilj7MTv8t8qkckzLryKEwAMCqtJycfHGQH60kvyoOEoF3sDMa8nx
         qqKzwpR4nIYXcQJ49mM4zBkxDj7fFMrnMqXHRsyjX5NeaMrUKDYvqZMB69o0AaDF4Khd
         V6DGXQtGQc7I2ncV7+8Sbz9Or4Y1M//EBNPzJQI6Jby+xVOpNxCySAS1uju22aPrEKb+
         UZbR6EhohZ26vz0NqkYPIIE6S5SwXuYiP/IlxospKeMLScUN7S/I3ITjqzcam8EDejCd
         W4J6s6i2GH1N69H+W0yDsdu0EeLtqCwloWbfWsS4nQuKNE0poXeJRgUPMp6Z81/tRpM8
         GnWg==
X-Gm-Message-State: AOAM531rW/eEZplH+IyoS5J2sYUvA/PdaIekYJ7niqgGJm6VagtqVaiy
        V4ht204MyERhEXIuuEFCCA==
X-Google-Smtp-Source: ABdhPJzNM/V1GkO10wBoHVN8fdVxQS1rZrUnsyPZm07zkS4nFXr5zlcBNOs8/rjBJxOBn91wzmGCKQ==
X-Received: by 2002:a05:6830:1e11:: with SMTP id s17mr7530141otr.100.1634679595660;
        Tue, 19 Oct 2021 14:39:55 -0700 (PDT)
Received: from robh.at.kernel.org (rrcs-67-78-118-34.sw.biz.rr.com. [67.78.118.34])
        by smtp.gmail.com with ESMTPSA id n187sm48942oif.52.2021.10.19.14.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 14:39:55 -0700 (PDT)
Received: (nullmailer pid 886061 invoked by uid 1000);
        Tue, 19 Oct 2021 21:39:54 -0000
Date:   Tue, 19 Oct 2021 16:39:54 -0500
From:   Rob Herring <robh@kernel.org>
To:     David Heidelberg <david@ixit.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, ~okias/devicetree@lists.sr.ht,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: marvell-bluetooth: Convert txt
 bindings to yaml
Message-ID: <YW87KoSkFnn2Anw2@robh.at.kernel.org>
References: <20211009104716.46162-1-david@ixit.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211009104716.46162-1-david@ixit.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 09 Oct 2021 12:47:16 +0200, David Heidelberg wrote:
> Convert documentation for The Marvell Avastar 88W8897 into YAML syntax.
> 
> Signed-off-by: David Heidelberg <david@ixit.cz>
> ---
>  .../bindings/net/marvell-bluetooth.txt        | 25 ---------------
>  .../bindings/net/marvell-bluetooth.yaml       | 31 +++++++++++++++++++
>  2 files changed, 31 insertions(+), 25 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/marvell-bluetooth.txt
>  create mode 100644 Documentation/devicetree/bindings/net/marvell-bluetooth.yaml
> 

Applied, thanks!
