Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47DC23301B
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 12:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgG3KPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 06:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgG3KPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 06:15:11 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55374C061794;
        Thu, 30 Jul 2020 03:15:10 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id i19so14631741lfj.8;
        Thu, 30 Jul 2020 03:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=05CuB/jBx9heNKW8cLF7uBdkO4BnahdfB+vJ5sJPIxA=;
        b=HGw41Cp4dTMIGAiiNj7VzHg7msH9jX4YAeavktOJsxlfItpOGfTTE59jsA2BqaPBge
         /0xSAKPlJWOXciYutZUZo6OUW+SzmVZ26IzR4Y3PHNY6K3UUImP7rB9G1/8kR6rZdEPt
         O9MDmU4bp1y9IXRCmX2LmM9ZwE/qmsISAoC+NpvVjngqJbHuupB3eUA84ssj9vpRyTCs
         ZTiD2ifJsw0Qm2YOssPUVVTr2jGZMde9q19sfnc0lYRJ3bP0MAUf5lIr+U2azn3a9Eht
         vzBzqrk6esd8rr++Qn5gKRKQDtI172OCXz5SXlZFBNM2t2ysCCncTeKHtAYi7wMIZ/dX
         BKEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=05CuB/jBx9heNKW8cLF7uBdkO4BnahdfB+vJ5sJPIxA=;
        b=HkukjQyux1TmzhlDG9jRYwhUYNZXOriT8otueFJCKb510XDWStnkxU2I3nER8w3L31
         17ynkZeS3k5jRYLaaSu8M4i0KNL53gD7BMBP5IfLk6kwnYAVd9daaO8I4rAZ5o31ME2M
         OiYg5ZJu10UOXQMrvYzd4n9BuwvoLIySzyRKZbIaF5I7Q5MrmiQStQAkfJ4s/tOJLsAM
         J/64OPZKU/CQO58p1ieCDGI1TSFM/4fv3IFnrbDdbin51i9vEopbB1rlivH/HZkSIIyr
         +UcC6lTantyaOzAteGnch/iAJar4CnDA+9RDOFagSGkTVxuuxNxF3J/yauZ7xDnAf9Qt
         sF1g==
X-Gm-Message-State: AOAM530PMYUee3UH6bliRWQtv9mijOD2pECxrKc2JGVqKXPQ7BA7nR6g
        WCOox6YAGudYGKtqjgIj444=
X-Google-Smtp-Source: ABdhPJzEO31zmabM48xFaSWUe10ugtknUJjgHvxQSmVNbBb8BKy2hosJA52ElLVZYIHN6WkR3LB6XQ==
X-Received: by 2002:a05:6512:3182:: with SMTP id i2mr1287339lfe.103.1596104108845;
        Thu, 30 Jul 2020 03:15:08 -0700 (PDT)
Received: from curiosity ([5.188.167.236])
        by smtp.gmail.com with ESMTPSA id w19sm942979ljd.112.2020.07.30.03.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 03:15:07 -0700 (PDT)
Date:   Thu, 30 Jul 2020 13:20:23 +0300
From:   Sergey Matyukevich <geomatsi@gmail.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     imitsyanko@quantenna.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        mkarpenko@quantenna.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] qtnfmac: Missing platform_device_unregister() on
 error in qtnf_core_mac_alloc()
Message-ID: <20200730102023.GA2249@curiosity>
References: <20200730064910.37589-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730064910.37589-1-wanghai38@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Add the missing platform_device_unregister() before return from
> qtnf_core_mac_alloc() in the error handling case.
> 
> Fixes: 616f5701f4ab ("qtnfmac: assign each wiphy to its own virtual platform device")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  drivers/net/wireless/quantenna/qtnfmac/core.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
> index eea777f8acea..6aafff9d4231 100644
> --- a/drivers/net/wireless/quantenna/qtnfmac/core.c
> +++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
> @@ -446,8 +446,11 @@ static struct qtnf_wmac *qtnf_core_mac_alloc(struct qtnf_bus *bus,
>  	}
>  
>  	wiphy = qtnf_wiphy_allocate(bus, pdev);
> -	if (!wiphy)
> +	if (!wiphy) {
> +		if (pdev)
> +			platform_device_unregister(pdev);
>  		return ERR_PTR(-ENOMEM);
> +	}
>  
>  	mac = wiphy_priv(wiphy);

Reviewed-by: Sergey Matyukevich <geomatsi@gmail.com>

Thanks,
Sergey
