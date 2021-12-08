Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6078746DDD9
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 22:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239908AbhLHVv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 16:51:29 -0500
Received: from mail-ot1-f43.google.com ([209.85.210.43]:38860 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhLHVv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 16:51:29 -0500
Received: by mail-ot1-f43.google.com with SMTP id n104-20020a9d2071000000b005799790cf0bso4173190ota.5;
        Wed, 08 Dec 2021 13:47:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FK6NLkYsXYzVWavBH6FdB/DSPPa4O6452weS5ZS0xKA=;
        b=8HXdffnhuwknNS75Wfs6xsVbEK7g5DAgeW1nXtjl5ZeFOubKDvzZ0O15cUz5AWPUE+
         ixgaK+4s5BPXPNBRGXTJZvB3yk6QCPvClNki5JypbjeFzZ4+r0zNXRll2zNeZWkry7AK
         blkq5hjziklvrlT2L6d7vCFgr1iWUPTBFmdpgPjQIgpfjVdjhxSWSkG+UuCsScGxYrZ+
         6nHjc68Cj2o2LsDutVzltJgg/+JuR86k6S1BQL2qgP+0RpNmD68rdKJ+5WCGk4zFyYvc
         FZWrmDNsS2w9hPIoanU9OpYOgvmilALj4szvAx19gcDPO8IMF44ijoLSwjKIFX1Szk/x
         Xihg==
X-Gm-Message-State: AOAM531MEz+yRoQBt8fTgWfiI7cFFboKPVcSohGcLOCrT8AUfU9YpUJs
        C7KoMcksYOe5Jzt/YTpuqQ==
X-Google-Smtp-Source: ABdhPJybH2RDELVfvKhf9agwU/QxWINJc+35X8VC1k55HZGA1ZFkdCZjm4iYwa3eYiL+p/GGc47wNg==
X-Received: by 2002:a05:6830:3195:: with SMTP id p21mr1870171ots.56.1639000076364;
        Wed, 08 Dec 2021 13:47:56 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id d6sm665039otb.4.2021.12.08.13.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 13:47:56 -0800 (PST)
Received: (nullmailer pid 460873 invoked by uid 1000);
        Wed, 08 Dec 2021 21:47:55 -0000
Date:   Wed, 8 Dec 2021 15:47:55 -0600
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 2/2] dt-bindings: net: Convert SYSTEMPORT to YAML
Message-ID: <YbEoC3e709/feQc4@robh.at.kernel.org>
References: <20211208202801.3706929-1-f.fainelli@gmail.com>
 <20211208202801.3706929-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208202801.3706929-3-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 08 Dec 2021 12:28:01 -0800, Florian Fainelli wrote:
> Convert the Broadcom SYSTEMPORT Ethernet controller Device Tree binding
> to YAML.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../bindings/net/brcm,systemport.txt          | 38 --------
>  .../bindings/net/brcm,systemport.yaml         | 88 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  3 files changed, 89 insertions(+), 38 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/brcm,systemport.txt
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,systemport.yaml
> 

Applied, thanks!
