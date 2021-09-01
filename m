Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A11E3FDAD2
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 15:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245556AbhIAMfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 08:35:10 -0400
Received: from mail-ot1-f51.google.com ([209.85.210.51]:41701 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245170AbhIAMeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 08:34:01 -0400
Received: by mail-ot1-f51.google.com with SMTP id o16-20020a9d2210000000b0051b1e56c98fso3215029ota.8;
        Wed, 01 Sep 2021 05:33:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/u1UTUm6/9J9YNElFXJAQnfOvJ98lHs3dQxW1vvuCNI=;
        b=q3FUe0ILWKcAgg0QTQ7Ee+O3/bjf+peFc2fFjLFXp0dRCLbakhNGoqtmJsOtRZjrN1
         Jw62LhADlaOG2zqx/6OzV9qjcW9FJ2yW4jaTWsx80yLSZiIfHJf6zwtzJJp/QSpRwTcu
         yXQN7sld89AORS2HzWAFs3w2OdSbKQ1YRB4IbGKgwQrcank22unWsn1miDKwRr6suPQ4
         jmnTyGdax8AWbZQ9t9RDRepZMo+jXfMo6xaY/y4jajUAZ96aMK25klXqGUG9lpovc0Jy
         F4DuahToGGhVIHVwBAKgR18NWhjqax3Or0y5RcHIvnn2t9JtPxQ/546eV5IK/5Ifj0xF
         VZxg==
X-Gm-Message-State: AOAM533U4nu0JHvUnPN7Ndh8dHsEtoNiff8J4hCEYAehiOWEnFHcVvTJ
        px66yPcXqLO+9Xy65gu7yw==
X-Google-Smtp-Source: ABdhPJyI4GTYunmwPgcSHkW1JmAd16WpTjBYxwf6KQGfJ44H9KAbB4/7ola2MSMBhJfbrCPbcm4Y5g==
X-Received: by 2002:a9d:5f07:: with SMTP id f7mr28629161oti.183.1630499584225;
        Wed, 01 Sep 2021 05:33:04 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id t21sm4504193otl.67.2021.09.01.05.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 05:33:03 -0700 (PDT)
Received: (nullmailer pid 1951229 invoked by uid 1000);
        Wed, 01 Sep 2021 12:33:02 -0000
Date:   Wed, 1 Sep 2021 07:33:02 -0500
From:   Rob Herring <robh@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     devicetree@vger.kernel.org, robh+dt@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, andrew@lunn.ch, michal.simek@xilinx.com,
        davem@davemloft.net
Subject: Re: [PATCH net-next v2 2/3] dt-bindings: net: Add tsnep Ethernet
 controller
Message-ID: <YS9y/lZU8gMOh5Kn@robh.at.kernel.org>
References: <20210831193425.26193-1-gerhard@engleder-embedded.com>
 <20210831193425.26193-3-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210831193425.26193-3-gerhard@engleder-embedded.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Aug 2021 21:34:24 +0200, Gerhard Engleder wrote:
> The TSN endpoint Ethernet MAC is a FPGA based network device for
> real-time communication.
> 
> It is integrated as normal Ethernet controller with
> ethernet-controller.yaml and mdio.yaml.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  .../bindings/net/engleder,tsnep.yaml          | 78 +++++++++++++++++++
>  1 file changed, 78 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/engleder,tsnep.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
