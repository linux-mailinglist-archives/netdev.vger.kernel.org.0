Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFAA212D04
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 21:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgGBTSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 15:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgGBTSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 15:18:50 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36EFC08C5DE
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 12:18:49 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id n5so25010186otj.1
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 12:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jRIEBzGgN4d7YlR7st1P/jWdFL9XQ3Vl0E8DBG5inJM=;
        b=uptIQwwuu7LLhQ5BebZnRucA4yx79hkX9MsCaNgPXHc+4sW6fYb8Ma0WG/QZ6fYDkL
         7CdXciQXPoZxefKXg1aZlVZGomC5VgFvYZCCemrYwiAPfqPIaUh79kgKi/RAkg9NRpIv
         AjNvVa2FLRKmfGQ/C+ofSk4ZhzxoQdi9jDHGlirho0fHOyp+rCJ0YlEl11rhG/0s5zrE
         QI0PanE9bioGWA7kRhJuQwMURFJnvxBrc6k43Qo+XGhB+BEYvu00QTsAmH7fhkF+ZWxZ
         XHkhl2rsZQPDiwm67Y1VvB0XPSN50TfH5XsIbY8Us3IK3Vsy6Qv0fkUNBNL1oMFKSuLj
         zn2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jRIEBzGgN4d7YlR7st1P/jWdFL9XQ3Vl0E8DBG5inJM=;
        b=r+cLMs664+yxcryxmGZJRAHrzuAPt4TB5KlHYsgXaA3IY5QtyVn2s2AApFfcvuNylT
         tVk6Om3QYSEgmgcSvPPK2VyQd7o6POtLwb2bqQHBZdvsZF1xGqPZncXVFvwumR7sxQq+
         TiQwJj+T3qyR7yP/amBkVy2pMZWMWQtHpTnqMqV6OV5GZfS8ef2ekDiHozg1efA2BBWS
         c0YH+I1DA1ftTdE2ntFx83i+2t46mAclix6GQD7KlLhmifGZ+R+WPPdEqC/z1mYaok48
         ZF+fL8Jj1oVC3oJL5kSQd7rO1QVfvqJcht3qTnLhIY/6T/iEzMJ9EaFg7dyOR5Bsx9Mo
         LBug==
X-Gm-Message-State: AOAM533wHOl0c7nukWodeKM9SaMS/horx+oRZA+dQdTfjeyTWEUmtXRI
        46dIKad8JpOPpCrrx0Cc3yyPHDcaXcOhp4o12gkioA==
X-Google-Smtp-Source: ABdhPJyE9o5qsn4mmfg/bTi/do0nytBCytI9l2XHtzasMOIfuZopADxFdFg4hQFCUv8pGK/sonqdb5SzWJU+UiPGXwM=
X-Received: by 2002:a9d:69c9:: with SMTP id v9mr28599024oto.66.1593717529169;
 Thu, 02 Jul 2020 12:18:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200702103001.233961-1-robert.marko@sartura.hr>
 <20200702103001.233961-5-robert.marko@sartura.hr> <20200702133842.GK730739@lunn.ch>
In-Reply-To: <20200702133842.GK730739@lunn.ch>
From:   Robert Marko <robert.marko@sartura.hr>
Date:   Thu, 2 Jul 2020 21:18:38 +0200
Message-ID: <CA+HBbNGcV0H4L4gzWOUs8GDkiMEOaGdeVhAbtfcT5-PGmVJjfA@mail.gmail.com>
Subject: Re: [net-next,PATCH 4/4] dt-bindings: mdio-ipq4019: add clock support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        robh+dt@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 3:38 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +  clock-frequency:
> > +    default: 100000000
>
> IEEE 802.3 says the default should be 2.5MHz. Some PHYs will go
> faster, but 100MHz seems unlikely!
This MDIO controller has an internal divider, by default its set for
100MHz clock.
In IPQ4019 MDIO clock is not controllable but in IPQ6018 etc it's controllable.
That is the only combination I have currently seen used by Qualcomm.
>
>      Andrew
