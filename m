Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAFCC2C89B9
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 17:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgK3QjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 11:39:21 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:33875 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728670AbgK3QjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 11:39:20 -0500
Received: by mail-io1-f68.google.com with SMTP id d7so3577383iok.1;
        Mon, 30 Nov 2020 08:38:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tFYu+zcPVaijJyMJm5EUKsYsvWv061fpjh0clpgn5vA=;
        b=a6yEhklVNxGdEvn697Qn0gETYsfkQuW3OomXwYGuRQCRUJgDtZ5liBqrbJRQTAyQLs
         Mepj9siQMWhmSnKFEdFN+gYOYuJvZGpoWPe9l4EWkOyPAIz5Z/+fdEMqQoWMKQMCgEgo
         xtoQQ1L1iVayaET8dgPOKEbS/zco3uboRlTtY4cGdEYUpyAoP4/BsSQRJPNHjMH6nhG2
         8RbVJfP/d7iazXTOoxA32pvhFythtoZmljasjnuZqjnQViQk5ZlVDePq9oMP80pXHvkX
         lWLEKtz6lvKMmBIfobVCuA8Egbdr5vpVkaM36SFhHUq3NTCOJrCKFsY6DDzU2Xjcc+G7
         Rqeg==
X-Gm-Message-State: AOAM533d0ycgkU7GDp/bv1VN4U4FrfiP8MKSD/8/JTvtYwFiQlB/jIER
        bNhSFiragOeSLJfLrYNyO38exiLY9Q==
X-Google-Smtp-Source: ABdhPJwO8/AKHHQtotzeksDXX1wp3u3t+G5jA46XRQZErHhLBCCcrUV6i188c/xtoojwacdGbzMMXA==
X-Received: by 2002:a6b:b514:: with SMTP id e20mr17078716iof.105.1606754313679;
        Mon, 30 Nov 2020 08:38:33 -0800 (PST)
Received: from xps15 ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id u11sm8273653iol.51.2020.11.30.08.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 08:38:32 -0800 (PST)
Received: (nullmailer pid 2592217 invoked by uid 1000);
        Mon, 30 Nov 2020 16:38:29 -0000
Date:   Mon, 30 Nov 2020 09:38:29 -0700
From:   Rob Herring <robh@kernel.org>
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc:     linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        robh+dt@kernel.org, davem@davemloft.net, ioana.ciornei@nxp.com,
        Ionut-robert Aron <ionut-robert.aron@nxp.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, corbet@lwn.net, leoyang.li@nxp.com,
        linux-arm-kernel@lists.infradead.org, kuba@kernel.org
Subject: Re: [PATCH v4] dt-bindings: misc: convert fsl,qoriq-mc from txt to
 YAML
Message-ID: <20201130163829.GA2590579@robh.at.kernel.org>
References: <20201123090035.15734-1-laurentiu.tudor@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123090035.15734-1-laurentiu.tudor@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 11:00:35 +0200, Laurentiu Tudor wrote:
> From: Ionut-robert Aron <ionut-robert.aron@nxp.com>
> 
> Convert fsl,qoriq-mc to YAML in order to automate the verification
> process of dts files. In addition, update MAINTAINERS accordingly
> and, while at it, add some missing files.
> 
> Signed-off-by: Ionut-robert Aron <ionut-robert.aron@nxp.com>
> [laurentiu.tudor@nxp.com: update MINTAINERS, updates & fixes in schema]
> Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
> ---
> Changes in v4:
>  - use $ref to point to fsl,qoriq-mc-dpmac binding
> 
> Changes in v3:
>  - dropped duplicated "fsl,qoriq-mc-dpmac" schema and replaced with
>    reference to it
>  - fixed a dt_binding_check warning
> 
> Changes in v2:
>  - fixed errors reported by yamllint
>  - dropped multiple unnecessary quotes
>  - used schema instead of text in description
>  - added constraints on dpmac reg property
> 
>  .../devicetree/bindings/misc/fsl,qoriq-mc.txt | 196 ------------------
>  .../bindings/misc/fsl,qoriq-mc.yaml           | 186 +++++++++++++++++
>  .../ethernet/freescale/dpaa2/overview.rst     |   5 +-
>  MAINTAINERS                                   |   4 +-
>  4 files changed, 193 insertions(+), 198 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
>  create mode 100644 Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml
> 

As there's a dependency on fsl,qoriq-mc-dpmac, this needs to go via 
netdev tree.

Reviewed-by: Rob Herring <robh@kernel.org>
