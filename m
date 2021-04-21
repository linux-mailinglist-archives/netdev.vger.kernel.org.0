Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C233674BE
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 23:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245749AbhDUVTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 17:19:55 -0400
Received: from mail-oi1-f175.google.com ([209.85.167.175]:38462 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240805AbhDUVTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 17:19:53 -0400
Received: by mail-oi1-f175.google.com with SMTP id d25so6277737oij.5;
        Wed, 21 Apr 2021 14:19:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/zCIIFL1GCBgRmLE1MQYC8dpYz/9OyAnNShFhPOZZ4s=;
        b=ndmixSfrha8rF8kkWV1iaCd2EIXboP+AGVciAdNPzE7pheRlt9Y9c6XKVY3fKV92LB
         NLfQRYrdmcecnjzh8pJnBBB3lsvHXOz4PoR9Vrv0ltC0d0lev6awJv6muRyV7IhONDl+
         30nGTyOPHvAja8RFC/nRw9ahD8CeVYym0gD92L0h/a2I24BDZ06YUaQaLKoJ3+j3ytCi
         JhMWHkSoh0zjNHxUYpIQwxzgFKvqfYR8E/Qmz6n2Yyko+GCmMj0J0BCxZeN3/1m6M4Vb
         Pfr2yhIjwnr0TuA60xDTwW8wcZy7WCvoZ/AQ7lOjeaGW/QjFrFRWt3NjJOzg3mb0upPb
         KI2A==
X-Gm-Message-State: AOAM530a9Wc9GkIWLG8bVtW1JmvIQZd1wtQs50PbE0jbY7Y/vmpcKLQu
        w1n36KbrevkwGCvzap+KgFCF4jSC8g==
X-Google-Smtp-Source: ABdhPJyjoWEzjl9qveDytM3botwyCf+n/PmFgLRlcEgYx6IDU0UzqnFaGinghjGAzmRkrdgFAO9y/g==
X-Received: by 2002:aca:408b:: with SMTP id n133mr8194678oia.13.1619039959996;
        Wed, 21 Apr 2021 14:19:19 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id w23sm153439otl.60.2021.04.21.14.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 14:19:19 -0700 (PDT)
Received: (nullmailer pid 1637631 invoked by uid 1000);
        Wed, 21 Apr 2021 21:19:17 -0000
Date:   Wed, 21 Apr 2021 16:19:17 -0500
From:   Rob Herring <robh@kernel.org>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Greg Ungerer <gerg@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@kernel.org>
Subject: Re: [PATCH] dt-bindings: net: mediatek: support MT7621 SoC
Message-ID: <20210421211917.GA1637579@robh.at.kernel.org>
References: <20210419034253.21322-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210419034253.21322-1-ilya.lipnitskiy@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Apr 2021 20:42:53 -0700, Ilya Lipnitskiy wrote:
> Add missing binding documentation for SoC support that has been in place
> since v5.1
> 
> Fixes: 889bcbdeee57 ("net: ethernet: mediatek: support MT7621 SoC ethernet hardware")
> Cc: Bjørn Mork <bjorn@mork.no>
> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/mediatek-net.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
