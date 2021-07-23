Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270FA3D4280
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 23:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhGWVSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 17:18:12 -0400
Received: from mail-io1-f51.google.com ([209.85.166.51]:44832 "EHLO
        mail-io1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbhGWVSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 17:18:10 -0400
Received: by mail-io1-f51.google.com with SMTP id l18so4194569ioh.11;
        Fri, 23 Jul 2021 14:58:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rn0D9YZmS4dIDgwz9LM0MRw67SMXWydvFAqo/h3XxAo=;
        b=toPa08c0BW+Q2uMbAWldlstIIGsn9i9cuHY+hFy1qfM5mKoAZkj0kck8jatO1Xfq4R
         /s3uwoq3KFhKEYljjEcpGvU9KxU5P/IPmbOEYFaLfMnfbn9gpjUcCQVWauK5GbkfYRDF
         nSjgOfjWDuuPXeVVI6b02V6AaKTYluUs4SoLCyD1PpBTosg6mY7xfAuFefwd3CsD9jGx
         J4LAqum6sS+BZ3d/jsiwcKG/BBPJLZ6AZX8ZTrEFWSMnoGlOvYXa9RQhQ2wUlL3DEyIb
         cfP2lXiy1UUiw3E7DJqyblH50qdWMzHLPw9H7zIp6ANpzVbnK2DZqOj2hxmg/DDzjHk+
         CIpA==
X-Gm-Message-State: AOAM533gFfgsr3Wv4tF7TZOinbGByCAyxNHwMF69mjwDMHHcugVjWOZQ
        GAXv3Anwbee9d2zJgYpstg==
X-Google-Smtp-Source: ABdhPJxGJE4Wklmx1ER1d4Hgaz7zeN3q1caED/CmWtADyXgg7rqD+OmKyt2TmoqDEL8YVeChFWkiiw==
X-Received: by 2002:a6b:f813:: with SMTP id o19mr5353976ioh.49.1627077522624;
        Fri, 23 Jul 2021 14:58:42 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id l11sm19553084ios.8.2021.07.23.14.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 14:58:42 -0700 (PDT)
Received: (nullmailer pid 2666846 invoked by uid 1000);
        Fri, 23 Jul 2021 21:58:39 -0000
Date:   Fri, 23 Jul 2021 15:58:39 -0600
From:   Rob Herring <robh@kernel.org>
To:     Maxime Ripard <maxime@cerno.tech>
Cc:     Rob Herring <robh+dt@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-sunxi@googlegroups.com,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Chen-Yu Tsai <wens@csie.org>
Subject: Re: [PATCH 27/54] dt-bindings: net: wireless: Convert ESP ESP8089
 binding to a schema
Message-ID: <20210723215839.GA2666790@robh.at.kernel.org>
References: <20210721140424.725744-1-maxime@cerno.tech>
 <20210721140424.725744-28-maxime@cerno.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721140424.725744-28-maxime@cerno.tech>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Jul 2021 16:03:57 +0200, Maxime Ripard wrote:
> The ESP8089 Wireless Chip is supported by Linux (through an out-of-tree
> driver) thanks to its device tree binding.
> 
> Now that we have the DT validation in place, let's convert the device
> tree bindings for that driver over to a YAML schema.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: de Goede <hdegoede@redhat.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Maxime Ripard <maxime@cerno.tech>
> ---
>  .../bindings/net/wireless/esp,esp8089.txt     | 30 -------------
>  .../bindings/net/wireless/esp,esp8089.yaml    | 43 +++++++++++++++++++
>  2 files changed, 43 insertions(+), 30 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/wireless/esp,esp8089.txt
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/esp,esp8089.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
