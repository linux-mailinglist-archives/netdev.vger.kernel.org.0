Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8D6D1347E5
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgAHQZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:25:26 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:33451 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbgAHQZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:25:24 -0500
Received: by mail-ot1-f65.google.com with SMTP id b18so4178936otp.0
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 08:25:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Yz35zFP2aSNw0+gIRfSaZMhcsEm+gudXf2tyLjffdvY=;
        b=nIs9Pg0nJfN+XDpsV1XbuY04VEgL8CoUSNLJR9iDreZ9hTsRizqLNQnbx8OoASZt+a
         j/YCo4l1yEkg+gRxTP63pD5XofXuau4upsly/sXcjm/0IPR/8FqEJ89dj/UHBk1d3Ho/
         DFjJDMqBIeP2yJB46aLWm7IdXibV+DyIbB8CJF8yLtPeQCooPm84ulaYtNkr6xvqKZwZ
         PQmyNGS4RNQz7EGkbCCRa3yvQmTTUWQI0kpdQMGLAcla0743LoojxbNZv+ZycnwLfV8o
         dXdncXId84221dBuR0/sOrjH9Ky56wJyC5G295alJQlD0otKZyJ5AHPF90qvwh6vRrCY
         CVFg==
X-Gm-Message-State: APjAAAUGL/qKlW8s2ztDuYDwapIU2nA23OKFaEGUcWacRv0QF7yZSoXv
        4vHmgeUkvbxAAZ7fIRwDZAGifuA=
X-Google-Smtp-Source: APXvYqwAAHK/YGLrrrTyxVVhip2M/1jZKAySRfH5F+BIZAxCRSETkCzWdGBkgIzXSCpE8iHNSOiXoQ==
X-Received: by 2002:a9d:7315:: with SMTP id e21mr4988878otk.255.1578500723448;
        Wed, 08 Jan 2020 08:25:23 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id n2sm1205789oia.58.2020.01.08.08.25.22
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 08:25:22 -0800 (PST)
Received: from rob (uid 1000)
        (envelope-from rob@rob-hp-laptop)
        id 220333
        by rob-hp-laptop (DragonFly Mail Agent v0.11);
        Wed, 08 Jan 2020 10:25:21 -0600
Date:   Wed, 8 Jan 2020 10:25:21 -0600
From:   Rob Herring <robh@kernel.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Andy Gross <agross@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 1/2] ath10k: Add optional qdss clk
Message-ID: <20200108162521.GA23484@bogus>
References: <20191223054855.3020665-1-bjorn.andersson@linaro.org>
 <20191223054855.3020665-2-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191223054855.3020665-2-bjorn.andersson@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Dec 2019 21:48:54 -0800, Bjorn Andersson wrote:
> The WiFi firmware found on sm8150 requires that the QDSS clock is
> ticking in order to operate, so add an optional clock to the binding to
> allow this to be specified in the sm8150 dts and add the clock to the
> list of clocks in the driver.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt | 2 +-
>  drivers/net/wireless/ath/ath10k/snoc.c                         | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
