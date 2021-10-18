Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A1F43283D
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 22:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbhJRUSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 16:18:39 -0400
Received: from mail-ot1-f43.google.com ([209.85.210.43]:37748 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbhJRUSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 16:18:38 -0400
Received: by mail-ot1-f43.google.com with SMTP id b4-20020a9d7544000000b00552ab826e3aso631025otl.4;
        Mon, 18 Oct 2021 13:16:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jptfUaShWTuogSEDU6xrh6g/MGaGug7Rn8xTsr2ObHg=;
        b=l2upkC8SXub9nfZtSanalJvBqQ5fStailWAGYxgk35PMlH7hxunazIZ9QN47dVjF1n
         63va02oRguML5Avo9tRaxBoFQjigKzCu86Cm/8V1eS7GGL6BWzyimwY2uri2fPUWkn7w
         080jtl3sFUt9mZ0GUMpCrwQPB0Ao6AvfdZeuAxmx82wlsth5jG9dyXV01YoOXjUCnYiK
         LOEbrLSbcmpZt1fzIcD+v0uuuuk5ppZWopGmBrBlwBod8bi0m9NEmbmDcFYogfPdM337
         PDLN0pvitozr4oDfgKGBw471aZHFSgzWD1MwWKKLsej7DYD+vY2I2XotAjCOzS1nSY6/
         2Zcw==
X-Gm-Message-State: AOAM530b23RxaEHYMlQY5YgvGtp0pfiYBxomtzrPI8nFyWLkanK/BoSr
        f3Ax07Mu3JJ3i1PqCrKyUw==
X-Google-Smtp-Source: ABdhPJwZVR7sNE1a23Y3WTywrwDae6LfqkZH0ZVAI45fwEQEjuOA5qSzJJsot745VepVLXjmGQHnTw==
X-Received: by 2002:a9d:448:: with SMTP id 66mr1775226otc.136.1634588186828;
        Mon, 18 Oct 2021 13:16:26 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id q15sm3198677otm.15.2021.10.18.13.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 13:16:26 -0700 (PDT)
Received: (nullmailer pid 2882307 invoked by uid 1000);
        Mon, 18 Oct 2021 20:16:25 -0000
Date:   Mon, 18 Oct 2021 15:16:25 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Charles Gorand <charles.gorand@effinnov.com>,
        "David S. Miller" <davem@davemloft.net>, None@robh.at.kernel.org,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Mark Greer <mgreer@animalcreek.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        linux-nfc@lists.01.org
Subject: Re: [PATCH v2 2/8] dt-bindings: nfc: nxp,nci: document NXP PN547
 binding
Message-ID: <YW3WGZvuZ/DpnrvP@robh.at.kernel.org>
References: <20211011073934.34340-1-krzysztof.kozlowski@canonical.com>
 <20211011073934.34340-3-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011073934.34340-3-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Oct 2021 09:39:28 +0200, Krzysztof Kozlowski wrote:
> NXP PN547 NFC controller seems to be compatible with the NXP NCI and
> there already DTS files using two compatibles.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 

Applied, thanks!
