Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED25620B595
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 18:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgFZQEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 12:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgFZQEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 12:04:23 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D5EC03E979;
        Fri, 26 Jun 2020 09:04:22 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id t194so9854974wmt.4;
        Fri, 26 Jun 2020 09:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RKvVrW4+I8vfqAqgWj2YShWjcD2UoitOu6+ps0LkUIQ=;
        b=X8XrwDt6WdyXemRfpr8apowQqE+vGA5WW9dFQ8NprQ1t+zJzW6PbcVtB7Eqw5q+9lT
         RU1AmsL2inIwDmInItvdv8nHxpYBle1Sx0R9AxhYPFCkjekUPpo2vStOIYMx7S1QKpLW
         GfohvOz0sDkcK9LhZ0jSbo04O5qTcLwRv1Lm/l4OoSGah38wKaUvZkSasW5oCNCkU/IE
         0nPHn1AXWnBD9E/wmPwG26aaGic44z6CJtScghLQQE4nYfuQ+BKb47jRSJV5xxyABYhL
         NNeGv5NSAoyJX01OpVLJJvH2m6fqDO1f+VMktOdP6J443RdfGBd36pdNEM6CVz4ebmpS
         cUkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RKvVrW4+I8vfqAqgWj2YShWjcD2UoitOu6+ps0LkUIQ=;
        b=FonVpsI0J7oeMDR1mq630nwlpUYcGAoLoGl4G785++heY301wRAgXT9iEAP8atQsR1
         YSn/vbgLtknpKQc00UOA7hhsHw+uQ+fOhamZ/MrDklY23lSl5xhUtYKhtOafDTx7/IzK
         O2CRAodEdhFPJ1zSynK8AQLrmqQ4p9mn2z4ppHrgIL5NmfivQs1u3SIUR+/t33YxI0vm
         sZmwpDHdJzmaTNxRLx7eNv01qiFC8P71qrBnRH1x0tGpG5jHJvGHdjgtkUTiPcUwOtWT
         Lc5yDesq8NH/1cTCM53NHrQTjICmYn1a+B5gDAe4aiCiElr1kWPPcV1L8BHpvWp6ugVS
         xqRA==
X-Gm-Message-State: AOAM532N4xhI6ajdow3cnsBN4MWwkw2LWnkENfoCoaVTCwzKHy0LGe81
        aEZ57nQ0U+QqKgMEvCwsWhs=
X-Google-Smtp-Source: ABdhPJwVCn6U/QSTgaHgCJKk89BT46wmdSiqls6NjyD3vJnLCLnzOOeG9yYCS2m5rNvvmwQRY+dYOw==
X-Received: by 2002:a05:600c:2:: with SMTP id g2mr4103613wmc.176.1593187461630;
        Fri, 26 Jun 2020 09:04:21 -0700 (PDT)
Received: from [10.230.189.192] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r3sm6372771wmh.36.2020.06.26.09.04.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 09:04:20 -0700 (PDT)
Subject: Re: [PATCH 4/6] net: mdio: add a forward declaration for
 reset_control to mdio.h
To:     Bartosz Golaszewski <brgl@bgdev.pl>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
References: <20200626155325.7021-1-brgl@bgdev.pl>
 <20200626155325.7021-5-brgl@bgdev.pl>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e49f8c61-ed0e-fcad-1e5d-7e122d042bb4@gmail.com>
Date:   Fri, 26 Jun 2020 09:04:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200626155325.7021-5-brgl@bgdev.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/26/2020 8:53 AM, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> This header refers to struct reset_control but doesn't include any reset
> header. The structure definition is probably somehow indirectly pulled in
> since no warnings are reported but for the sake of correctness add the
> forward declaration for struct reset_control.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
