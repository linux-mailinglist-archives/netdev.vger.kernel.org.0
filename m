Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223ED1A8D30
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 23:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633632AbgDNVEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 17:04:01 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43257 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2633589AbgDNVCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 17:02:21 -0400
Received: by mail-ot1-f66.google.com with SMTP id g14so1170735otg.10;
        Tue, 14 Apr 2020 14:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9MY/dlKLTuZil2riiVa0/9Eb/2zBtz5HqkHealjLMWs=;
        b=T51FbA6ftj/Hfoje5hSGAL015T1DIIeHfM6T3BPYazymT6bem55aEHxQzAkbBIkQ9s
         iCrwXkJZg2joMX3Ftrdks02rVdhg0m6afZ6tzyxYxGU5nI649SgZuO/6Xic1gUS5W94O
         HVtvb0HP0KArgdEh4p1DMTopXQFr5Yx0ZeDZHJWKmwEBlSP7EqHuybewUp/Q0XtxNNbB
         /y4qrT/9yrWK2bPxRyKFonNuZmMLDMBhLCYMatd3R+1TQbL8ygzCCYU41dBx3YoiJqRV
         rWYNTtFpNVKnop1PINVweFWqwMIFRW4e2IjOA4c3bzUF7jC5PXIvnvCVobYGOSzofUjU
         MPTQ==
X-Gm-Message-State: AGi0PuY4NfYAlxzUX269ruac54WoqL3zi5HN8c3QuSAUiKDujFoXvfgE
        9bFJYSNcEUYYGgOllY9Log==
X-Google-Smtp-Source: APiQypLZU+zH1H3PmR7mpM0KydZcPZZRdURdwW0Z0j09EtkFyflB/iPfFy/cR2DtAw2h0lMojnFh7Q==
X-Received: by 2002:a05:6830:1305:: with SMTP id p5mr18706002otq.345.1586898140783;
        Tue, 14 Apr 2020 14:02:20 -0700 (PDT)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id a3sm5793648oti.27.2020.04.14.14.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 14:02:19 -0700 (PDT)
Received: (nullmailer pid 4807 invoked by uid 1000);
        Tue, 14 Apr 2020 21:02:18 -0000
Date:   Tue, 14 Apr 2020 16:02:18 -0500
From:   Rob Herring <robh@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Matthias Brugger <mbrugger@suse.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 24/33] docs: dt: fix a broken reference for a file
 converted to json
Message-ID: <20200414210218.GA4755@bogus>
References: <cover.1586881715.git.mchehab+huawei@kernel.org>
 <9b1603e254d39c9607bfedefeedaafd2c44aeb19.1586881715.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b1603e254d39c9607bfedefeedaafd2c44aeb19.1586881715.git.mchehab+huawei@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Apr 2020 18:48:50 +0200, Mauro Carvalho Chehab wrote:
> Changeset 32ced09d7903 ("dt-bindings: serial: Convert slave-device bindings to json-schema")
> moved a binding to json and updated the links.
> 
> Yet, one link was not changed, due to a merge conflict.
> 
> Update this one too.
> 
> Fixes: 32ced09d7903 ("dt-bindings: serial: Convert slave-device bindings to json-schema")
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Applied, thanks.

Rob
