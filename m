Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 527A14172F
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 23:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407196AbfFKVwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 17:52:10 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36382 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407165AbfFKVwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 17:52:10 -0400
Received: by mail-qt1-f196.google.com with SMTP id p15so9051643qtl.3;
        Tue, 11 Jun 2019 14:52:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3r12qJQBXAuvMT4EwoDNzavCtWYu4iRZchiufeeQkDA=;
        b=N7kMZvLZcnBioe2//xcL1M1JtXeItOjpk+32oiPYYvkR1qcTd8UG3720klZffMZBVW
         eyCbW5s0iv5N+NraXN/IN3BJxaIMxc5tD2DFHd2X8SHfKmssIE8hY2/48dLuk9AONPwl
         +vQPd24NdiaUnvbfOJ1z0Mdu6wJRieu0Ae6ixAM/+cYB3EHfmA2DRG9U1P9K2kwiCObH
         ZbUmt7uPESam5rwEesdww1EqU8q3NLU9UBJbijf6GSsd5H1gVveVzTj/Vxqj0H1UQA6p
         +DneHyADuSaCtUPer4V7U3sk/Bj8h1IK8r+0Sn3r/PB1k0+cK+1DN9TjGyfHQRXOj5DX
         xzOQ==
X-Gm-Message-State: APjAAAUT3z3mCAFpflqGv0xig2ygoqF3bYTqnhEBuiVo1h0Q7rzpDE2A
        MX7p6W7I272U4AFCh9nyone67ic=
X-Google-Smtp-Source: APXvYqwYg7O90+eWMBJqzuTqXctWOHI40/oJ0GPlNFDUVF6CgMDfl7e03c/8RDgTcCt1Q9vjJvfAkA==
X-Received: by 2002:a0c:b997:: with SMTP id v23mr62799346qvf.128.1560289929520;
        Tue, 11 Jun 2019 14:52:09 -0700 (PDT)
Received: from localhost ([64.188.179.199])
        by smtp.gmail.com with ESMTPSA id j26sm8645067qtj.70.2019.06.11.14.52.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 14:52:09 -0700 (PDT)
Date:   Tue, 11 Jun 2019 15:52:06 -0600
From:   Rob Herring <robh@kernel.org>
To:     megous@megous.com
Cc:     linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Ondrej Jirman <megous@megous.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH v6 4/6] dt-bindings: display: hdmi-connector: Support DDC
 bus enable
Message-ID: <20190611215206.GA17759@bogus>
References: <20190527162237.18495-1-megous@megous.com>
 <20190527162237.18495-5-megous@megous.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527162237.18495-5-megous@megous.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 May 2019 18:22:35 +0200, megous@megous.com wrote:
> From: Ondrej Jirman <megous@megous.com>
> 
> Some Allwinner SoC using boards (Orange Pi 3 for example) need to enable
> on-board voltage shifting logic for the DDC bus using a gpio to be able
> to access DDC bus. Use ddc-en-gpios property on the hdmi-connector to
> model this.
> 
> Add binding documentation for optional ddc-en-gpios property.
> 
> Signed-off-by: Ondrej Jirman <megous@megous.com>
> ---
>  .../devicetree/bindings/display/connector/hdmi-connector.txt     | 1 +
>  1 file changed, 1 insertion(+)
> 

Please add Acked-by/Reviewed-by tags when posting new versions. However,
there's no need to repost patches *only* to add the tags. The upstream
maintainer will do that for acks received on the version they apply.

If a tag was not added on purpose, please state why and what changed.
