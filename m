Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EADD3DC111
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 00:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbhG3W2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 18:28:24 -0400
Received: from mail-il1-f170.google.com ([209.85.166.170]:38565 "EHLO
        mail-il1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbhG3W2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 18:28:21 -0400
Received: by mail-il1-f170.google.com with SMTP id h18so10913598ilc.5;
        Fri, 30 Jul 2021 15:28:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=iRrLbfbqIS5aTyIlMg3Ddsn2aOpsLg2suPETUyCuhso=;
        b=IiKJWRvYWnnNN2+YhVv19HPWGZSKC34dL6aKynVrcph6dxqNOHZwPxZH9pi+RX8MUz
         8kcpG24N7KY4OG9PJO90VHVo4SkBGd2le3bZJ6lxuesNb47JfPmFlWjJ0kPlMu5H5r2v
         8vSXl+qsP6LKbnZP4aO58NlHGEcBRxGNVYagyhSI8Yi6074t+Jx6HtfRiaymqK6fgg/Y
         Vlzxm9J1bBp2RTMiXBajmGOopSeb1XOoN8SU0cCTP23Lu5L7jv5tvfiU8+za70ezUrtC
         o2vezfmOUF1Ql4BoqtwxawfqSZr33b2QQ1H2HUvrOFq4XSBjxznKFv3FEv+YmiI/xNh5
         1yfA==
X-Gm-Message-State: AOAM533px7zstcl2sL4611bbMCBpUcYOb4csJQLlamSnsBRHSWrK+rC3
        w4TY1omniUzzrcSt1fGenQ==
X-Google-Smtp-Source: ABdhPJwlmKihwwXcD9Z4ajEH9RFsMbk1wE/qDHxqpqyY95ye8bwCTuw8fNL1ePMNWAQGTXnZRs0YIA==
X-Received: by 2002:a92:7f03:: with SMTP id a3mr3431717ild.254.1627684095214;
        Fri, 30 Jul 2021 15:28:15 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id k9sm870727ioq.55.2021.07.30.15.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 15:28:14 -0700 (PDT)
Received: (nullmailer pid 3442797 invoked by uid 1000);
        Fri, 30 Jul 2021 22:28:10 -0000
From:   Rob Herring <robh@kernel.org>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>
In-Reply-To: <20210730171646.2406-1-dariobin@libero.it>
References: <20210730171646.2406-1-dariobin@libero.it>
Subject: Re: [PATCH v3] dt-bindings: net: can: c_can: convert to json-schema
Date:   Fri, 30 Jul 2021 16:28:10 -0600
Message-Id: <1627684090.574176.3442796.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Jul 2021 19:16:46 +0200, Dario Binacchi wrote:
> Convert the Bosch C_CAN/D_CAN controller device tree binding
> documentation to json-schema.
> 
> Document missing properties.
> Remove "ti,hwmods" as it is no longer used in TI dts.
> Make "clocks" required as it is used in all dts.
> Correct nodename in the example.
> 
> Signed-off-by: Dario Binacchi <dariobin@libero.it>
> 
> ---
> 
> Changes in v3:
>  - Add type (phandle-array) and size (maxItems: 2) to syscon-raminit
>    property.
> 
> Changes in v2:
>  - Drop Documentation references.
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
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/can/bosch,c_can.example.dt.yaml: can@0: syscon-raminit: [[4294967295, 1604, 1]] is too short
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
\ndoc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1511753

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

