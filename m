Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93DDD3D506A
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 00:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhGYVo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 17:44:58 -0400
Received: from mail-il1-f176.google.com ([209.85.166.176]:46878 "EHLO
        mail-il1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhGYVo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 17:44:58 -0400
Received: by mail-il1-f176.google.com with SMTP id r5so7073099ilc.13;
        Sun, 25 Jul 2021 15:25:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=bfV54EGNX7QM/avi9Ym1d5XEwwIaFGu3hKWgMFw+twQ=;
        b=gZe54hPqzph4r30Q0cIEo1vXzkOTWHC27EJWSZbgc+FGHjGTExbdEPljWOd6e/bjM0
         JUC6wEVGd2/T/buvgeYty/J9YO+p34y8WrLRcDT5JwUvenMlIb7KrH8djT/dW1x4/VY5
         QnzEcjDf/s5tkQtHKO0lEE9PBvMW0TP7laVYmd5yMCpBgAsI8yMcdg5xDVE8DE3lSUCD
         KliTpGPpPQK304JdCZOymG/LNRfgNeH35v5/b5kxcjip1PTfnMYAkU1zEZH1oXgZ+A2u
         ePFDANbD0vI9HsuNVYY1N+jslxEXm6V0aGp7zIX6fbOThfhi0Fd2h2Ve2A/FXNuIIrac
         dUgQ==
X-Gm-Message-State: AOAM532riRgOwvRllczRid51FGEvAOrQnBC3lxEggJCJtEkiCPLPR/AO
        7bTI4v4qklJUD4ldWdqJYA==
X-Google-Smtp-Source: ABdhPJz7sehIjKPVRRXQU9jNngs6H+dktG1OrVWvfczvtxRlLnL3r7Of8U6SBHj7BPK7/630fo8wCg==
X-Received: by 2002:a92:d305:: with SMTP id x5mr11113322ila.150.1627251926708;
        Sun, 25 Jul 2021 15:25:26 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id l12sm3532731ilg.2.2021.07.25.15.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 15:25:26 -0700 (PDT)
Received: (nullmailer pid 2960747 invoked by uid 1000);
        Sun, 25 Jul 2021 22:25:22 -0000
From:   Rob Herring <robh@kernel.org>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
In-Reply-To: <20210725160318.9312-2-dariobin@libero.it>
References: <20210725160318.9312-1-dariobin@libero.it> <20210725160318.9312-2-dariobin@libero.it>
Subject: Re: [PATCH 2/2] dt-bindings: net: can: c_can: convert to json-schema
Date:   Sun, 25 Jul 2021 16:25:22 -0600
Message-Id: <1627251922.224313.2960746.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 25 Jul 2021 18:03:18 +0200, Dario Binacchi wrote:
> Convert the Bosch C_CAN/D_CAN controller device tree binding
> documentation to json-schema.
> 
> Document missing properties.
> Remove "ti,hwmods" as it is no longer used in TI dts.
> Make "clocks" required as it is used in all dts.
> Correct nodename in the example.
> 
> Signed-off-by: Dario Binacchi <dariobin@libero.it>
> ---
> 
>  .../bindings/net/can/bosch,c_can.yaml         | 85 +++++++++++++++++++
>  .../devicetree/bindings/net/can/c_can.txt     | 65 --------------
>  2 files changed, 85 insertions(+), 65 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/can/c_can.txt
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:

\ndoc reference errors (make refcheckdocs):
Documentation/devicetree/bindings/net/can/bosch,c_can.yaml: Documentation/devicetree/bindings/soc/ti/sci-pm-domain.txt
Documentation/devicetree/bindings/net/can/bosch,c_can.yaml: Documentation/devicetree/bindings/clock/ti,sci-clk.txt

See https://patchwork.ozlabs.org/patch/1509610

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

