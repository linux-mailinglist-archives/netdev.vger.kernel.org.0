Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F292B8A4E
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 04:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgKSDGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 22:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgKSDGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 22:06:54 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C7DC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:06:52 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id x15so2172188pll.2
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N0ISk/kjGtT3d84oiK/CN0kQ5d6lv1Hp42xqTBqw4Os=;
        b=VS4iaoV1wtp2QBP46pJxCzs2nLMGpYpVmUIxh3fQOCDzUE0/f+tK9WVkvhOSC6gPSA
         M2y1zAAzxBynYy3PkDtE8nxyeKr6FF5yUHbJI479I+BPD+MOBt5fko0dFrtVDb/Z/HJu
         2ICutjFQ421625dVQMRp75rDEOax1/7Wo7Ji4ZXUnZa5daEGAzBB0a4gzJE6LCE8KR/z
         9dnNPssJt1ioh1bORkYVW34q0r1AGNn09md5ZeFEoX+TXi7/JYYSimQS9/HWwpzygHSm
         mI/w8sMLAHZTx4JDDA8AD4TEyobBfdMHvqbS8NiNMEELYWZSAnsYbtaTIkFzxVVrJLdp
         0OEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N0ISk/kjGtT3d84oiK/CN0kQ5d6lv1Hp42xqTBqw4Os=;
        b=Q/oYlMfrq7Ho5+rUFrH+7K+cmMt0cLVaYkzosU2h/1AsE8+YSHU07ZdCaYssB2wz5o
         0wT/FrEUV9+fgE0PUpONI0px8ShcLlsVL48K2cFUSenm/vYmqATPEcenljIOSpDxOsfo
         xrgt68+czMEIwjSjY1NlN8MGQQ9WA70uQsjOJ+uuySOr8Y+SuMCDporqsm9gEsOfuroF
         lUC7a0ABnTyIZ1XUms29RNbY2sDqIPNxNzhweReHFao6Wxx0EO2UlkQXfqre2UFgOZs4
         IH7ud+oOnrfWL5lYjTMRzZZtQyjx55rphoOrGbgYNXYSj4ESnKeAFSYqN5fmlSyYQyaf
         RJqg==
X-Gm-Message-State: AOAM531U1/YquubEB6w+nVoKuB+7lBSh1K/ljdYLqJcqPJARYpVnCFi0
        ekXu2tM6ZFbt8m+ueGmBocU=
X-Google-Smtp-Source: ABdhPJzsnbs5yVEJZ3FaXTFsYKesmOpxL7rhDR+9l4jwFpzJuXWsXQlnfN5e7CEMpd8gyEyN3+rL3w==
X-Received: by 2002:a17:902:7088:b029:d6:8072:9ce1 with SMTP id z8-20020a1709027088b02900d680729ce1mr7454710plk.11.1605755212387;
        Wed, 18 Nov 2020 19:06:52 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a24sm26552232pfl.174.2020.11.18.19.06.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 19:06:51 -0800 (PST)
Subject: Re: [PATCH 01/11] net: dsa: microchip: ksz8795: remove unused
 last_port variable
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, davem@davemloft.net, kernel@pengutronix.de,
        matthias.schiffer@ew.tq-group.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-2-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c14dbd5d-6c2e-c32b-c420-ccf0cbb7148c@gmail.com>
Date:   Wed, 18 Nov 2020 19:06:50 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118220357.22292-2-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2020 2:03 PM, Michael Grzeschik wrote:
> The variable last_port is not used anywhere, this patch removes it.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
