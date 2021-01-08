Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2C72EEBE5
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 04:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbhAHDgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 22:36:49 -0500
Received: from mail-il1-f181.google.com ([209.85.166.181]:34868 "EHLO
        mail-il1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbhAHDgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 22:36:49 -0500
Received: by mail-il1-f181.google.com with SMTP id 14so7713303ilq.2;
        Thu, 07 Jan 2021 19:36:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L5RsEhHIEnoduj49ItA7CuoltgRpIkBnN6psA9/IyD4=;
        b=LO5Cyt0t5wcqiw5AH5acMGn5C5jy9zX3Kbm51viLGn3layvc/uvNfWXziuNegz2Hrm
         kNQL9cV0ueGNiNNvjn1DkDM2t47oxoWF7T7rzI0d8QYnxHV0f6SbxPnjVA6klV6iJDH9
         eQaJcMD6vY89fJ3pOzsmQtDHjYKfCr2hnv+OynXDBCnRvXOH14WwxXxLWX0HNrAOdVSj
         ch07VVjEH5j9+9azPOvznrl8y2OQqh1Aii/BRi2Qojg44h2Cx4bbqlJjf70hlCgeKWza
         NwAX+7fF/ESaEFPM7Oky5yG3cTufHG4UonpLE6Ao17Don+yumx3v6/mSnTwfib3f1PSU
         O8Iw==
X-Gm-Message-State: AOAM532auz9fJT+rmZ8eH9znAq9RYLJV5CRLvqQJoKxPulJ0itaHGou7
        +qKrQ2Zr1x+zI0hpgFWxleGYaezyiw==
X-Google-Smtp-Source: ABdhPJycfHHYZHRUyp0vLgUZFW4qiE/lIjY4wycUDsNApdn7ZJSnPQAgr2zGEFT6IVisjC/wjwU6CQ==
X-Received: by 2002:a05:6e02:1786:: with SMTP id y6mr1902102ilu.74.1610076967883;
        Thu, 07 Jan 2021 19:36:07 -0800 (PST)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id 15sm5912531ilx.84.2021.01.07.19.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 19:36:07 -0800 (PST)
Received: (nullmailer pid 1838925 invoked by uid 1000);
        Fri, 08 Jan 2021 03:36:05 -0000
Date:   Thu, 7 Jan 2021 20:36:05 -0700
From:   Rob Herring <robh@kernel.org>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 1/5] dt-bindings: net: renesas,etheravb: Add r8a779a0
 support
Message-ID: <20210108033605.GA1838803@robh.at.kernel.org>
References: <20201227130407.10991-1-wsa+renesas@sang-engineering.com>
 <20201227130407.10991-2-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201227130407.10991-2-wsa+renesas@sang-engineering.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 27 Dec 2020 14:04:02 +0100, Wolfram Sang wrote:
> Document the compatible value for the RAVB block in the Renesas R-Car
> V3U (R8A779A0) SoC. This variant has no stream buffer, so we only need
> to add the new compatible.
> 
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> ---
>  Documentation/devicetree/bindings/net/renesas,etheravb.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
