Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39973EF3EA
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 22:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236594AbhHQUWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 16:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235806AbhHQUWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 16:22:43 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97765C0611BE;
        Tue, 17 Aug 2021 13:21:44 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id d11so36974eja.8;
        Tue, 17 Aug 2021 13:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XaaGF88w29zZ2HuLM3UdMK4CiOo1QtnD4rb3xe86sRk=;
        b=CYfhzeNfGNRGovN0mTdsFysv4R643Vgd636cpygw+on9VbmaZ6jx1UUCAt3Yd9EIYs
         FqLVU7Zb1FcTMiNfOoRC8ymL9yIwfFpBztsHYgaKxRAkJRwG0PmsKvQgSnWxaMcdz5d8
         Kr8ejFF1UCJftgGT8B8NXKbDRTfd9AxXDTYEfuEMfXABuOM7cvAlnzWRZokr4hQuVK97
         t29vWl0yJL6o0cX7NVF3hfQFEk8sazYLEmLoegBHiXMeampNVMoe1zKl5FyU66MN7z5g
         XChkuJFYQyqPBiGkqLhBKA0fsywmcybI7j2juF2Be5Uy6Z4uw3aDOqZr7YFCwP1TzCUx
         prsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XaaGF88w29zZ2HuLM3UdMK4CiOo1QtnD4rb3xe86sRk=;
        b=ddf4vHHXlLIO6AWG92PNlDradWTvdD0IXI10oHi6rr2uXdPIC/RxPh+zaSvTgixcfb
         j09HOVptQuPyNRkFzo7PevVJlJkkOW12+wltflfTNSnj9PM28URItxQ+PFVQkMU4Yg9X
         ZY/A/U6VD5hIZeoPvdIQLQS/lfqDfoB2cBC/U/1KamhIdg/XhrI1H+3dad5g2Hr0R1d1
         gMGP255g9m5G8++KuHXAe6mYigPDwKsIH2vJpzzo0pDoBRKFVnIgW8gE1a2g/Wq6ZI7r
         IdXAKegzlosCf/1yYV+XeF26NN9B/Cxfxg1hCdheyLNOLCZ+hkxCjEZtgHUzILiomX9A
         kA+A==
X-Gm-Message-State: AOAM53334Dg4NHhmuJ4l/o/roQQI9zxpaa1U4dnwvt9SDAAGvybZE7LL
        2MdhFga36281tB4usNXiO/A=
X-Google-Smtp-Source: ABdhPJxcK0r5Ivg4E9ad4dmOh22hwIKaihsZd6lXE9T35spwqTlTnXZ4p4jqL5XnU6ObmX/as7VDUA==
X-Received: by 2002:a17:906:6011:: with SMTP id o17mr5692956ejj.157.1629231703136;
        Tue, 17 Aug 2021 13:21:43 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id w11sm1426151edc.5.2021.08.17.13.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 13:21:42 -0700 (PDT)
Date:   Tue, 17 Aug 2021 23:21:41 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: Re: [PATCH] net: dsa: lantiq_gswip: Add 200ms assert delay
Message-ID: <20210817202141.xddw5c7mypodnqlk@skbuf>
References: <20210817193207.1038598-1-olek2@wp.pl>
 <20210817194448.tyg723667ql4kjvu@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817194448.tyg723667ql4kjvu@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 10:44:48PM +0300, Vladimir Oltean wrote:
> On Tue, Aug 17, 2021 at 09:32:07PM +0200, Aleksander Jan Bajkowski wrote:
> > The delay is especially needed by the xRX300 and xRX330 SoCs. Without
> > this patch, some phys are sometimes not properly detected.
> > 
> > Fixes: a09d042b086202735c4ed64 ("net: dsa: lantiq: allow to use all GPHYs on xRX300 and xRX330")
> > Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> > Tested-by: Aleksander Jan Bajkowski <olek2@wp.pl> # tested on DWR966, HH5A
> > ---
> 
> Generally the convention is:
> 
> From: Patch Author <patch.author@email.com>
> 
> Commit description
> 
> Signed-off-by: Patch Author <patch.author@email.com>
> Signed-off-by: Patch Carrier 1 <patch.carrier1@email.com>
> Signed-off-by: Patch Carrier 2 <patch.carrier2@email.com>
> Signed-off-by: Patch Carrier 3 <patch.carrier3@email.com>
> Signed-off-by: Patch Submitter <patch.submitter@email.com>
> 
> This patch is clearly not following this model for more than one reason.

Let's not even talk about the kilometer-long commit sha1sum.
This is not even my pet peeve, if this patch gets merged as-is you'll
get an email titled "linux-next: Fixes tag needs some work in the net tree"
(google it if you want examples).

Stick this in your ~/.gitconfig and thank me later:

[core]
	abbrev = 12
[pretty]
	fixes = Fixes: %h (\"%s\")

Now run:

git show a09d042b086202735c4ed64 --pretty=fixes
Fixes: a09d042b0862 ("net: dsa: lantiq: allow to use all GPHYs on xRX300 and xRX330")

Voila!
