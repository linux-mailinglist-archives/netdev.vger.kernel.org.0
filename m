Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8571E35CFD4
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 19:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244569AbhDLRv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 13:51:56 -0400
Received: from mail-ot1-f47.google.com ([209.85.210.47]:35555 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238145AbhDLRvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 13:51:55 -0400
Received: by mail-ot1-f47.google.com with SMTP id v24-20020a9d69d80000b02901b9aec33371so13635072oto.2;
        Mon, 12 Apr 2021 10:51:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ea0wwblc4jIaUkhNsCQ47PE+8gSD1cmdNSdI/VVXgz4=;
        b=M5cSKXn6xFv1MGOOg2Ok/TvmkvWZm9c5oust5OgN1YVre34g70qhlZiYR78p8gCOrT
         7f3Qfqu5J1pvMzZuXo+7KtLDG4xvxuH5YDhCQdSwVLOIuWxAV1+6Cl86JYsFSJEMukVp
         DETnz/RE02wBJuUuHW52eKyS3YOrqnIXXFMX2fbKOY2irofjTeOsvOW3Yu2ppGmThaE+
         VyDBpZf6vUlf9Qyd4ee8GMPC1eUe2D7QxX4GTkgYtJ+wKqEJ8NynJWW8HaQoXuDO90u5
         jxDqxqSvQEU/bu0f2kq7L8Lzxb6eWkJrGkmLdDhCK3Ag9LojkfqIvXhP+qNV+fiH6Kdr
         fVwA==
X-Gm-Message-State: AOAM530w+w1HfVf7Nb/eav6AwZ1NByalVSkpqMjOFc1NvAldofryLO65
        h52n0VjGeCtu3zTIiEwLYg==
X-Google-Smtp-Source: ABdhPJwKbxwTVUrZdMdU9k0p+Wsk4lVs9GvzycQRqjvxXm32f7UEUb2pz9nQfnBVTu6enLeSzHeDVw==
X-Received: by 2002:a9d:4911:: with SMTP id e17mr3767679otf.38.1618249896643;
        Mon, 12 Apr 2021 10:51:36 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id h23sm2748216ots.0.2021.04.12.10.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 10:51:35 -0700 (PDT)
Received: (nullmailer pid 4110980 invoked by uid 1000);
        Mon, 12 Apr 2021 17:51:34 -0000
Date:   Mon, 12 Apr 2021 12:51:34 -0500
From:   Rob Herring <robh@kernel.org>
To:     Aswath Govindraju <a-govindraju@ti.com>
Cc:     Vignesh Raghavendra <vigneshr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Sriram Dash <sriram.dash@samsung.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org
Subject: Re: [PATCH 3/4] dt-bindings: net: can: Document transceiver
 implementation as phy
Message-ID: <20210412175134.GA4109207@robh.at.kernel.org>
References: <20210409134056.18740-1-a-govindraju@ti.com>
 <20210409134056.18740-4-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409134056.18740-4-a-govindraju@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 07:10:53PM +0530, Aswath Govindraju wrote:
> From: Faiz Abbas <faiz_abbas@ti.com>
> 
> Some transceivers need a configuration step (for example, pulling the
> standby or enable lines) for them to start sending messages. The
> transceiver can be implemented as a phy with the configuration done in the
> phy driver. The bit rate limitation can the be obtained by the driver using
> the phy node.
> 
> Document the above implementation in the bosch mcan bindings
> 
> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
> ---
>  Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> index 798fa5fb7bb2..2c01899b1a3e 100644
> --- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> +++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> @@ -109,6 +109,12 @@ properties:
>    can-transceiver:
>      $ref: can-transceiver.yaml#
>  
> +  phys:
> +    minItems: 1

maxItems: 1

> +
> +  phy-names:
> +    const: can_transceiver

Kind of a pointless name. You don't really need a name if there's a 
single entry.

> +
>  required:
>    - compatible
>    - reg
> -- 
> 2.17.1
> 
