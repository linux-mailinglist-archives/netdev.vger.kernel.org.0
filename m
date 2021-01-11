Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F29A2F2098
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 21:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403775AbhAKUTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 15:19:50 -0500
Received: from mail-ot1-f53.google.com ([209.85.210.53]:44997 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbhAKUTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 15:19:49 -0500
Received: by mail-ot1-f53.google.com with SMTP id r9so72137otk.11;
        Mon, 11 Jan 2021 12:19:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pTEei5dEH4PIxEjKAqNLnrxtbUQjm4MMQetV6yQHoxM=;
        b=RjNhxSeIN+QMrR+xZIA+sW1aKl0K0tjCUg76bkLKG5f4igq+68Z73mTA16nDoMQh6B
         jA1Sr/8wFXLSV92lBvo2UW9Sf01WP4ibQOlySCMG8RYog0FDjw15Zaha0bPr5zcwC4kO
         UYgO6Fu36i8uqdVQAczNpk+8HZfOq8Y1n2L9Khmj8zVEvtM7Di9H66MFQ5BNBLT8eEpB
         Vrez6YmNVJ/F81ldb6sC8X5fWqk0GfCbSBjljl/2hGFS9QHZ6C7i+GF1vkASINc7LIwp
         oXw+Q23DgyHgOpE5gbSPYGirGa6d1Pjasb55w2tnLhl4r7VY/oF7LDqBoPiXv5NFW3jK
         l26w==
X-Gm-Message-State: AOAM531HMtJ8OpyFSN0+pewSC5aq84wOghirzwCSsHrax7o5pcnfn+AC
        sHrBabpXN/47LOqRJV1SHA==
X-Google-Smtp-Source: ABdhPJwMDa3KC54DsO8d/vRfsonWoX8KtCx0u5h1FM26jRCL419mEPoBhNmuAB1SyKxxBhZPyn5V/A==
X-Received: by 2002:a9d:372:: with SMTP id 105mr603176otv.118.1610396348992;
        Mon, 11 Jan 2021 12:19:08 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id 69sm165562otc.76.2021.01.11.12.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 12:19:08 -0800 (PST)
Received: (nullmailer pid 2999631 invoked by uid 1000);
        Mon, 11 Jan 2021 20:19:07 -0000
Date:   Mon, 11 Jan 2021 14:19:07 -0600
From:   Rob Herring <robh@kernel.org>
To:     Adam Ford <aford173@gmail.com>
Cc:     aford@beaconembedded.com, linux-renesas-soc@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        devicetree@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 1/4] dt-bindings: net: renesas,etheravb: Add additional
 clocks
Message-ID: <20210111201906.GA2999597@robh.at.kernel.org>
References: <20201228213121.2331449-1-aford173@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228213121.2331449-1-aford173@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Dec 2020 15:31:17 -0600, Adam Ford wrote:
> The AVB driver assumes there is an external clock, but it could
> be driven by an external clock.  In order to enable a programmable
> clock, it needs to be added to the clocks list and enabled in the
> driver.  Since there currently only one clock, there is no
> clock-names list either.
> 
> Update bindings to add the additional optional clock, and explicitly
> name both of them.
> 
> Signed-off-by: Adam Ford <aford173@gmail.com>
> ---
>  .../devicetree/bindings/net/renesas,etheravb.yaml     | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
