Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1774E1BD8
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 14:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245148AbiCTNXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 09:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239999AbiCTNXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 09:23:22 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC143D1CE
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 06:21:58 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id r190-20020a1c2bc7000000b0038a1013241dso7100358wmr.1
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 06:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CiwhGRNrXz4QNizMa/oAhqtF2xiNgjqkYli9zHg8NMo=;
        b=ooINi4qmadEwMMSSbUh9xuE2GUMZdFzpXR1++zh7EgKuDr1/NmJNrR7aEgX9YEYnqR
         j/C7WHJwAEaroHujPrPBwHaVKiGIbu1nwhw6Bvq+dEbjefo+cmS41dhKhkQ7W2enDIcn
         FwsFB9BzT3mLwMM+/x6ZL3laea9/DI7YnSRRxUERp8zMouKs6KjyFAF0jRCtuQjp1GFb
         NzO6gACyZQm+mAnPo/n3gilRevnFb/8ycSHL5qutcWmYhYgL/Hn1gcm7GD7dGf2KMLkg
         14giC/KDFp/is73wLuzsjr6B2mi5ks2+ehWaq7GJRiCaKi+k83jrzVLsf4GEDI/JshXs
         kKcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CiwhGRNrXz4QNizMa/oAhqtF2xiNgjqkYli9zHg8NMo=;
        b=gtldYnZ1s8Ztq1HEI1LJMEuLn3+DB+jSD0NAKsZAWkbHL9cfPyQI69e01a2ogxtyKy
         o3Cjj0UzpDoy3kunQ9aj8Km1n3mx8bAO7U3ii+k2bsdLoTDPgcS4/lLKNa9/y5cs+r+q
         rOrOi+6h4YZY9WVYSVPfX+n3y673UZJATKzBB1ld/oRv/+ZJKohdecsjSn55Tl2r+2Cl
         N8LkrLLoiLvSkmev05M1TYtjbz9KaXWBjrkn2v17We70CDUKW0NCARNqgNz/kfxxyRbW
         FmJrgkWMdy+wIvcGD1MtjFs+igYewuxt/7hab1ECDtIhRe0r2BYpF+YtMNmRIuCDw/8I
         OpJQ==
X-Gm-Message-State: AOAM5317mOt5rYWbflQgGty6eSrDio2jY71SeyHWXUKD88mXOvGEZaft
        hE32Te01lZhV5VU98hekOgqL2Q==
X-Google-Smtp-Source: ABdhPJwpvkdAY6cBXr3dOsU2mQlSFPo8+WDyEP4JRfxs73L2obnJJNJLtCZo6KY0b0mYyHj82adJdg==
X-Received: by 2002:a7b:c2aa:0:b0:389:891f:1fd1 with SMTP id c10-20020a7bc2aa000000b00389891f1fd1mr23391259wmk.138.1647782517417;
        Sun, 20 Mar 2022 06:21:57 -0700 (PDT)
Received: from [192.168.0.69] (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id l9-20020a5d6d89000000b00203d62072c4sm11795831wrs.43.2022.03.20.06.21.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Mar 2022 06:21:56 -0700 (PDT)
Message-ID: <c8f31312-5356-704e-1f55-89c9f5888238@linaro.org>
Date:   Sun, 20 Mar 2022 13:21:55 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 2/2] wcn36xx: Implement tx_rate reporting
Content-Language: en-US
To:     Edmond Gagnon <egagnon@squareup.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Benjamin Li <benl@squareup.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220318195804.4169686-1-egagnon@squareup.com>
 <20220318195804.4169686-3-egagnon@squareup.com>
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
In-Reply-To: <20220318195804.4169686-3-egagnon@squareup.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/03/2022 19:58, Edmond Gagnon wrote:
> +	INIT_DELAYED_WORK(&wcn->get_stats_work, wcn36xx_get_stats_work);

Instead of forking a worker and polling we could add the relevant SMD 
command to

static int wcn36xx_smd_tx_compl_ind(struct wcn36xx *wcn, void *buf, 
size_t len)
{
     wcn36xx_smd_get_stats(wcn, 0xSomeMask);
}

That way we only ever ask for and report a new TX data rate when we know 
a TX event - and hence a potential TX data-rate update - has taken place.

---
bod

