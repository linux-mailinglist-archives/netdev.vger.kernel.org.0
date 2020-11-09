Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16672AC817
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 23:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730040AbgKIWLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 17:11:10 -0500
Received: from mail-oo1-f68.google.com ([209.85.161.68]:37100 "EHLO
        mail-oo1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729247AbgKIWLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 17:11:09 -0500
Received: by mail-oo1-f68.google.com with SMTP id x5so1766423ooi.4;
        Mon, 09 Nov 2020 14:11:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tHsQKqje+5SSSlblxDfRlRnDl/CnwOY9m4Ekj3B6MZ4=;
        b=P3AvaOk6BM6le7EBGq6SUgYUK4ltI1LHL8lf7y8j70JQ+tZZBcMtq2I5fIyw7HopGX
         U18qZF5Tz6q7O0CNw7hB+Kt49AbUeu4+cT3ADTwbzcsW5po3QHhriBHkTceVr2QOaLO8
         Yr4rdp04nJGje/Q7BLB6HNTaD/R/9VubQhxWSIuCgJKr3kdcU25ki9kl8snhGcXP6XRW
         ej9O4pxBja+zbuzeD+Amh43tDVwQG+E4zLqEqca+rlwxUfs0jxJTP+qxDQLlcjobBMPK
         dZglVstdv4ThVbKN4qC6ajYz8L08MbUbQWjBkaLwPeALQAN/c4Lve11aMXxK2gxAsAE8
         HPjw==
X-Gm-Message-State: AOAM530Cepa8vVZna4zB5a7Df+XslJ1FMVjqlppE/xX7FZxcddTGl012
        Wfja3XWhpxwmdC/AoaMr/Q==
X-Google-Smtp-Source: ABdhPJxZyTP1ZiN3mZ/6w5swgtWDmTaAwMXb7VFdiEbOAmrWb3IDVkYsELX1q0VNiyfw5GQrBarfQA==
X-Received: by 2002:a4a:9644:: with SMTP id r4mr11611906ooi.12.1604959867554;
        Mon, 09 Nov 2020 14:11:07 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id y15sm2813684otq.79.2020.11.09.14.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 14:11:06 -0800 (PST)
Received: (nullmailer pid 1846191 invoked by uid 1000);
        Mon, 09 Nov 2020 22:11:06 -0000
Date:   Mon, 9 Nov 2020 16:11:06 -0600
From:   Rob Herring <robh@kernel.org>
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc:     linux-doc@vger.kernel.org,
        Ionut-robert Aron <ionut-robert.aron@nxp.com>,
        linux-kernel@vger.kernel.org, corbet@lwn.net, davem@davemloft.net,
        ioana.ciornei@nxp.com, robh+dt@kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, leoyang.li@nxp.com, linuxppc-dev@lists.ozlabs.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/2] dt-bindings: misc: convert fsl, dpaa2-console
 from txt to YAML
Message-ID: <20201109221106.GA1846114@bogus>
References: <20201109104635.21116-1-laurentiu.tudor@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109104635.21116-1-laurentiu.tudor@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 09 Nov 2020 12:46:34 +0200, Laurentiu Tudor wrote:
> From: Ionut-robert Aron <ionut-robert.aron@nxp.com>
> 
> Convert fsl,dpaa2-console to YAML in order to automate the
> verification process of dts files.
> 
> Signed-off-by: Ionut-robert Aron <ionut-robert.aron@nxp.com>
> Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
> ---
> Changes in v2:
>  - add missing additionalProperties
> 
>  .../bindings/misc/fsl,dpaa2-console.txt       | 11 --------
>  .../bindings/misc/fsl,dpaa2-console.yaml      | 25 +++++++++++++++++++
>  2 files changed, 25 insertions(+), 11 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/misc/fsl,dpaa2-console.txt
>  create mode 100644 Documentation/devicetree/bindings/misc/fsl,dpaa2-console.yaml
> 

Applied, thanks!
