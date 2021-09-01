Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C973FDAC8
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 15:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343989AbhIAMez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 08:34:55 -0400
Received: from mail-oo1-f48.google.com ([209.85.161.48]:36858 "EHLO
        mail-oo1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343537AbhIAMdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 08:33:37 -0400
Received: by mail-oo1-f48.google.com with SMTP id y47-20020a4a9832000000b00290fb9f6d3fso775781ooi.3;
        Wed, 01 Sep 2021 05:32:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/FMRjwhTqQU9rdBOxpfUrkHcg0h3BiEjh3fzz1U3RD8=;
        b=i5q1wY4lMkewYMKojrG5orgogLELLDKNqzt6HT9IddTDPPK56VQfCKxzkIaO13iWWj
         9Hm6s2/AGd1t+wQ0QbyiPyDV8oYrQ8SHLnSqzH6zX3Y8+9WxlE6Mo90LbDYP035KKkoi
         w4TGDADa51eYpq4G6qBr78D3H9zcly/EgaJOf64S3uXOs4aU06dELHIShvnORBjes3Y+
         uwnU4rVdTU+oMuvJmC9tqy8qiJEsc7MLDqy/W9+rIOIzSPgAts4Ytce3D9weZ0PRXo+8
         gZ+QwKJBD2FQGzOPdM6k0GMKhiroBvjKRcA0U9bNUvIBMnXw5QOOmlIp2Dp/2cB6nhgP
         Jdjg==
X-Gm-Message-State: AOAM533K8KzqldJjc+IqCjBDbqZ41OUc2J/rnd9e2+licEBQjhKgyIzI
        YwSuyod40HqSMPSsY/YSqQ==
X-Google-Smtp-Source: ABdhPJwVceF7fb8XqR1vIEW0SQrrZSRBaGM2JNDj5Ex/Aabr9+5H1Pf0DprOulYD8zgVGc/X/N987A==
X-Received: by 2002:a4a:e4ce:: with SMTP id w14mr18783856oov.76.1630499560627;
        Wed, 01 Sep 2021 05:32:40 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id j8sm2026022ooc.21.2021.09.01.05.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 05:32:40 -0700 (PDT)
Received: (nullmailer pid 1950524 invoked by uid 1000);
        Wed, 01 Sep 2021 12:32:38 -0000
Date:   Wed, 1 Sep 2021 07:32:38 -0500
From:   Rob Herring <robh@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     michal.simek@xilinx.com, davem@davemloft.net,
        netdev@vger.kernel.org, andrew@lunn.ch, devicetree@vger.kernel.org,
        robh+dt@kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next v2 1/3] dt-bindings: Add vendor prefix for
 Engleder
Message-ID: <YS9y5qls6Z9wGJZj@robh.at.kernel.org>
References: <20210831193425.26193-1-gerhard@engleder-embedded.com>
 <20210831193425.26193-2-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210831193425.26193-2-gerhard@engleder-embedded.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Aug 2021 21:34:23 +0200, Gerhard Engleder wrote:
> Engleder develops FPGA based controllers for real-time communication.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
