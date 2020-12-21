Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36AA2E00C3
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 20:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgLUTKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 14:10:43 -0500
Received: from mail-ot1-f44.google.com ([209.85.210.44]:41447 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgLUTKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 14:10:43 -0500
Received: by mail-ot1-f44.google.com with SMTP id x13so9754237oto.8;
        Mon, 21 Dec 2020 11:10:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uflh9aWjQjUACrrKIUHZ3D3HKPpGYANwFYyzpKEZfWY=;
        b=DmVtfkiteN6nlc0GbKA62bC2xrkzpwKWxepXCj17DF0kM7vmkfw7Tq1vGeLc8ZGuDX
         Uy7xGdA7vJbLBbOAdx/ib10eBgrYrSijOGSlnq5ubcfn9M/KlusNaS/+QQJEsixbXfy4
         R4wPrOhG1rhJx6sboTwcaqSTFlY3VyYqJfthWYxsqsn/Sfz/Imk1inXGYTL/Rm2Hh3fA
         onGQR91ttJIgyOfNzfWsPOZML+K9dxC3GuQQ3dIgf8zHjcXhibJ6q1wiER7H5uUr4ObQ
         1ny73XxFi1OVZfJGJ37Az7ZDZX2/7ObffENP4HOz1pngCUHdImJbT5oY/7AgyPj3UQ1h
         BhOw==
X-Gm-Message-State: AOAM5318f1TzSc3tHlX1eI8Y9Oc/77MJGNdIryiiCKw5pzLnUfQYTaxT
        p4K+dxYEe2xmJR+Vc5444Q==
X-Google-Smtp-Source: ABdhPJzk4N4FCaqCFlvX2+gDoZw1/MJMc70ppfBohNwet6wD2y4cn4zQDHGrY/ujUT2i4VWOyBryqA==
X-Received: by 2002:a05:6830:164d:: with SMTP id h13mr11021407otr.337.1608577801901;
        Mon, 21 Dec 2020 11:10:01 -0800 (PST)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id r10sm3879398oom.2.2020.12.21.11.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 11:10:00 -0800 (PST)
Received: (nullmailer pid 380370 invoked by uid 1000);
        Mon, 21 Dec 2020 19:09:56 -0000
Date:   Mon, 21 Dec 2020 12:09:56 -0700
From:   Rob Herring <robh@kernel.org>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Vinod Koul <vkoul@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Min Guo <min.guo@mediatek.com>,
        David Airlie <airlied@linux.ie>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-mediatek@lists.infradead.org,
        dri-devel@lists.freedesktop.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v4 02/11] dt-bindings: net: btusb: change reference file
 name
Message-ID: <20201221190956.GA380319@robh.at.kernel.org>
References: <20201216093012.24406-1-chunfeng.yun@mediatek.com>
 <20201216093012.24406-2-chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216093012.24406-2-chunfeng.yun@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 17:30:03 +0800, Chunfeng Yun wrote:
> Due to usb-device.txt is converted into usb-device.yaml,
> so modify reference file names at the same time.
> 
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
> ---
> v2~v4: no changes
> ---
>  Documentation/devicetree/bindings/net/btusb.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
