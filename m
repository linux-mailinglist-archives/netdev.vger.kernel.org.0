Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1A33F09C9
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 19:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbhHRRC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 13:02:28 -0400
Received: from mail-oi1-f180.google.com ([209.85.167.180]:44771 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhHRRC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 13:02:27 -0400
Received: by mail-oi1-f180.google.com with SMTP id w6so4229723oiv.11;
        Wed, 18 Aug 2021 10:01:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qzFdWlL9ixGRwe7w2gPRPbgsjvz1+2IiusGbjz1NlWE=;
        b=cx9Z2T0VIFKdIqfCq14cjxhD+Gu3QE62BPXQYRMOPrlIysdjUtnUVRBLu4ovIgJrub
         5mztdKcI5qK1M+ECBFt+GrblN1gNZwlNdBpiHFP8vqdVLYTjCeS+os+VYcXn54hIn1eG
         ZeQIn2SmN2WXRQjkxdQZRhh+66gGGBIowzTxL8d//n4yXnfanTmmH1mP7qkz+LtYyLeH
         fmfzHhwnB6C/RxAUsPxFGA9+B0cfMlc1Gp/rxibkpT0juQoFxCKzENXyLDVKCuA9f44m
         y6BO7LVp8cEHdoJdSTor9B12JnSeVsVcCCJkJzNsWcq81oSi+X9dJn3Vh5Pf6zN+CXN7
         TcsQ==
X-Gm-Message-State: AOAM533+0R6/axSxCep1twjWaWW/2Zm0eFZrZCoj8qypmuabIR1nAY8i
        O7gqT8Ta+/jUa1IxuMzAZw==
X-Google-Smtp-Source: ABdhPJzS/VJBkUH+Uv+iu8PSMfXEu48NDIjKysxz34KuD6RPGccqbjCCrDUB6AthCeujBAOJdSDXVw==
X-Received: by 2002:a05:6808:200b:: with SMTP id q11mr8023956oiw.75.1629306112020;
        Wed, 18 Aug 2021 10:01:52 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id c24sm114284otf.71.2021.08.18.10.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 10:01:51 -0700 (PDT)
Received: (nullmailer pid 2759956 invoked by uid 1000);
        Wed, 18 Aug 2021 17:01:50 -0000
Date:   Wed, 18 Aug 2021 12:01:50 -0500
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-kernel@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        kernel@pengutronix.de
Subject: Re: [PATCH v3 1/3] dt-bindings: can-controller: add support for
 termination-gpios
Message-ID: <YR08/hgpZaZsWznk@robh.at.kernel.org>
References: <20210818071232.20585-1-o.rempel@pengutronix.de>
 <20210818071232.20585-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818071232.20585-2-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Aug 2021 09:12:30 +0200, Oleksij Rempel wrote:
> Some boards provide GPIO controllable termination resistor. Provide
> binding to make use of it.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../devicetree/bindings/net/can/can-controller.yaml      | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
