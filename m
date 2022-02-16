Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2DB4B94B3
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 00:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiBPXru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 18:47:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbiBPXrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 18:47:49 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F32246371
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 15:47:36 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 139so3478003pge.1
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 15:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lmUYwh8XVkwgvIRpyGWIjOL8HREfhGMGa7VN0bWpjGA=;
        b=D7xcmYxYHPHJNTQxwiTFBT2eGKQ1ghij6zM6mTN5EzWo9VLD/VGdUDejAnVc5HPljD
         Y1pHC3gFo/FxWtS8b8EJjtV/Qo8mo7TKLLbwdomHT6HFOLB3i7IOdGvWpJqTtuKfXW+t
         uCsASYDmfpo4byQxQedU0mcqAvWJOTJGp+0p2VfLMuH7R4810PhMDIVC15NAF5pb7UEr
         eN474LlRGD+cVf2am0sMmqQirrwxafzkgSeJPlhPpV/VYxs9acaeO13x7aSMED5bru/1
         rOpxX3JDcSH1qg9Hpz7fumOSFpxwiGObkz85n2y41ASjz/O44gXx8zoDK6iBWQ8KUCUM
         69Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lmUYwh8XVkwgvIRpyGWIjOL8HREfhGMGa7VN0bWpjGA=;
        b=6liB7MXy+pHt8HZ2fr+UlHzIzCa5oGryIELtY/wJgGhjbuMuH178O11Dhoswkx48YP
         6+YQQyFl5yigCZ/ObiErels8XN2F8cjYlNBVCpt3l3sLCRByRRTFgseqLusXg7tFg6K7
         gmEaSnxCB1nFgkPk5GU4Qza58hXrI9TbR1jTMVi0DCyr87ZZu225TBDL5PJiM5Ld54eL
         3YY1UVFR5XkiX+22BkzmLEtP3QMo97DTgrIuR6U7ilqGw/hAKR4iDyKbRV/nmQey/ywt
         C0hJDc98CN58QqB2pBdf89QV4bYSN3W6C/90M2Ap4cxu6+lDNUdMc0/uODrHblKD8wYq
         8ZwA==
X-Gm-Message-State: AOAM531EIBHD0gO+dp+oUFe4Gco97Bk35RCL7A/Yf3MyX9JtQFHQusAG
        jGKGJykj4APFaHln8XiN8to=
X-Google-Smtp-Source: ABdhPJwEnQCDHY9YHsUIYoeef6LMzSZKZLriXUYtaIbt/X6SueIN7nHwCanRz5etmHQkNDN4JModkw==
X-Received: by 2002:a63:d44:0:b0:36c:644e:791c with SMTP id 4-20020a630d44000000b0036c644e791cmr266744pgn.417.1645055255722;
        Wed, 16 Feb 2022 15:47:35 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x1sm5953886pga.40.2022.02.16.15.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 15:47:35 -0800 (PST)
Subject: Re: [PATCH net-next] net: dsa: delete unused exported symbols for
 ethtool PHY stats
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220216193726.2926320-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0eba0ef8-c8b8-7216-2f92-fd32117a24b2@gmail.com>
Date:   Wed, 16 Feb 2022 15:47:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220216193726.2926320-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/22 11:37 AM, Vladimir Oltean wrote:
> Introduced in commit cf963573039a ("net: dsa: Allow providing PHY
> statistics from CPU port"), it appears these were never used.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
