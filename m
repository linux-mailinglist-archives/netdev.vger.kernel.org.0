Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45A0D6E37A
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 11:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfGSJbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 05:31:40 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41604 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfGSJbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 05:31:40 -0400
Received: by mail-lf1-f68.google.com with SMTP id 62so16394707lfa.8
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 02:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=By7J6Ek1LpU9WXnfTM3TzV8zMVb06NB+DuQro2Ib0n4=;
        b=S3zV3jWkivnFOV2YNWvQ5KMrY9Hkg7qwkrqAuq62/ewY2tZT18vY8JxDW588j/EMMc
         VxXYtc0c+pzbIs7CLVyTEFhFi9TK6Q5/h1IxJQdZRpAMLVAvRMgCAtMqTJ+9hhZ/dZjH
         4VoPIgdv/VcOnrjOIUkyAX+dDb67ZKX3URdKwF1o30a+CJGA4jiykmzpjlXxjfca1bAA
         a/zfXJGeCe5wNqfzSpSlUxjg12os/pJUlnhLuNkhmXRN3xxSxbmBwNvcuQFNDyiHq78v
         F63HQVkQ4TeEYVQ02W92TajdWyjxLZy2Pbg2kl7hhIS/NPEnfoHrz4aKeLQPY98GSr40
         6Nfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=By7J6Ek1LpU9WXnfTM3TzV8zMVb06NB+DuQro2Ib0n4=;
        b=UhXuD0As41/cH4msEmKzNk2rBu5fyA6dhmKO+EG40fkiaIjnIdkymjn9NM1cgeI7sG
         JCUQ0GFuEdauLiYOwct7k0yQbBD7yRTkDx5TF708t+1i54hW706uC7/97WCreXCMpYNS
         QlXl+HbK6uGLpWGbP4arkkKkzIsKAqSN50+KqzPDFzQDcfG+U6KcjQz9Zg+UAd+6HEt9
         DoSwGtbg4HmdMPcU2aPibPVFwb+H14PcBVcbiRLvb4I4XGfkmq/kE60Mm5jY22AchzMz
         Z/hufGT/hXUDQjE4WX11C4YqIxmm7QdiiQxW8Zo83Jdony+b2jjdKvbqOEqfprBIVAip
         2LDg==
X-Gm-Message-State: APjAAAWNzx8hgZpqQJ9g8/SDvxGInQ99uy+eoYyG13+zuCOd8pGrCEDa
        tbMPcT76TSSGoXCIp84gFVXnGw==
X-Google-Smtp-Source: APXvYqzFNhQ1C+ObP3q6fexhlWw2GlVsxxZn8IDrRqcrJVED1FxFdaKt5E6eEA9Gz91toW4LWv2UpA==
X-Received: by 2002:a19:6557:: with SMTP id c23mr9969655lfj.12.1563528698345;
        Fri, 19 Jul 2019 02:31:38 -0700 (PDT)
Received: from centauri (ua-83-226-229-61.bbcust.telenor.se. [83.226.229.61])
        by smtp.gmail.com with ESMTPSA id b25sm4377431lfq.11.2019.07.19.02.31.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 02:31:37 -0700 (PDT)
Date:   Fri, 19 Jul 2019 11:31:35 +0200
From:   Niklas Cassel <niklas.cassel@linaro.org>
To:     xiaofeis <xiaofeis@codeaurora.org>
Cc:     davem@davemloft.net, vkoul@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@linaro.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, xiazha@codeaurora.org
Subject: Re: [PATCH] qca8k: enable port flow control
Message-ID: <20190719093135.GA22605@centauri>
References: <1563504791-43398-1-git-send-email-xiaofeis@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563504791-43398-1-git-send-email-xiaofeis@codeaurora.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 19, 2019 at 10:53:11AM +0800, xiaofeis wrote:
> Set phy device advertising to enable MAC flow control.
> 
> Change-Id: Ibf0f554b072fc73136ec9f7ffb90c20b25a4faae
> Signed-off-by: Xiaofei Shen <xiaofeis@codeaurora.org>
> ---
>  drivers/net/dsa/qca8k.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index d93be14..95ac081 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1,7 +1,7 @@
>  /*
>   * Copyright (C) 2009 Felix Fietkau <nbd@nbd.name>
>   * Copyright (C) 2011-2012 Gabor Juhos <juhosg@openwrt.org>
> - * Copyright (c) 2015, The Linux Foundation. All rights reserved.
> + * Copyright (c) 2015, 2019, The Linux Foundation. All rights reserved.
>   * Copyright (c) 2016 John Crispin <john@phrozen.org>
>   *
>   * This program is free software; you can redistribute it and/or modify
> @@ -800,6 +800,8 @@
>  	qca8k_port_set_status(priv, port, 1);
>  	priv->port_sts[port].enabled = 1;
>  
> +	phy->advertising |= (ADVERTISED_Pause | ADVERTISED_Asym_Pause);

Drop the unnecessary parentheses.

Question for DSA maintainers: shouldn't this be implemented in the
dsa_switch_ops phylink_validate callback, like it's done for other
dsa drivers?


Kind regards,
Niklas

> +
>  	return 0;
>  }
>  
> -- 
> 1.9.1
> 
