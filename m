Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310464749C1
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 18:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhLNRic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 12:38:32 -0500
Received: from mail-ot1-f43.google.com ([209.85.210.43]:40682 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhLNRia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 12:38:30 -0500
Received: by mail-ot1-f43.google.com with SMTP id v15-20020a9d604f000000b0056cdb373b82so21695363otj.7;
        Tue, 14 Dec 2021 09:38:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T+wvpVWDdsGpJBe6gIqFrAVl31VdvDh0Jr2/KDBVPwc=;
        b=pz1Y5L1Wjx/Es9A2CggGVwGZHKYx7nlKwnIdzGl1+dZ81DOrTeIzHyrmnz4dHYb6jm
         nZUz7zdlH4Pw3G/fDzjPPYJebT4qZjd7W5TA6l758q/ew2Dz9EK5r5MqpCyUdilDnYBu
         arx6ze5j7CtnJsg1LmJbzFAvd651OqNl4x9FijckEQDdMh3kLNooMBtkZIP0SRVs5oSh
         vy0YDlX6Lt3o0vxDRW/Wkm5t4xkBFwlv6p+jSWzKMhJe7KyclosPh8UH2DOFDnQJC3fw
         VbtCJHgiWAi0jYoQkWIaqnUqK4chw9dEWkJ9mdNkc03ugrkOYOfqQNmmR4VXnVipdAjj
         +ZHg==
X-Gm-Message-State: AOAM532MN7AVwzxG7furzfcbAa4TkhSX/gm1gAZNsxK05IgQlHnBm0ua
        9548kofHBbzP0lFkcen+HqwmmTT0fg==
X-Google-Smtp-Source: ABdhPJzxIBvR+HWF/N1VRKgTGmrzoX7oVPEv+bwOOH8ny+QgsYNdvWRVBbssClGxRtLzizxNLKfqVA==
X-Received: by 2002:a05:6830:410a:: with SMTP id w10mr5384642ott.55.1639503509337;
        Tue, 14 Dec 2021 09:38:29 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id w71sm98513oiw.6.2021.12.14.09.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 09:38:28 -0800 (PST)
Received: (nullmailer pid 3605724 invoked by uid 1000);
        Tue, 14 Dec 2021 17:38:27 -0000
Date:   Tue, 14 Dec 2021 11:38:27 -0600
From:   Rob Herring <robh@kernel.org>
To:     Joseph CHANG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, joseph_chang@davicom.com.tw,
        Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4, 1/2] yaml: Add dm9051 SPI network yaml file
Message-ID: <YbjWkzwjzMN0OVWp@robh.at.kernel.org>
References: <20211212104604.20334-1-josright123@gmail.com>
 <20211212104604.20334-2-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211212104604.20334-2-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Dec 2021 18:46:03 +0800, Joseph CHANG wrote:
> This is a new yaml base data file for configure davicom dm9051 with
> device tree
> 
> Signed-off-by: Joseph CHANG <josright123@gmail.com>
> ---
>  .../bindings/net/davicom,dm9051.yaml          | 62 +++++++++++++++++++
>  1 file changed, 62 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
