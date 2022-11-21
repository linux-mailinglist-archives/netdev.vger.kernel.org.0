Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6762632E08
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiKUUgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiKUUgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:36:43 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8ED8DA4CA
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:36:42 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so15311347pjc.3
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Eah76lvYsPeNHMD8i11r9iqPmQNtRAGhGD0e1zU04jc=;
        b=CFw1fbcJOf5pTgkgN5NqBZqUrFq+Btc+FS+K/uQvoNIHPNSMNKfonuqx0U9ylX+FP9
         0HGTGUQWoKNDtiyjduEbzcd5WVDs5JhLNFRzVBFLqTGRQgoJCpv3/t09N3s2/HFxVsbg
         kgvampDmtUiFWLWtwAnjmYe8sR7GARd6H0j8vcJXRRmeCsbAYVR2HF8JOGpxMdJ5JL5S
         CZ+AuTqNLcAMHFbKAjHn90BrHzwuPEuNyFJyK/hT9PDzrfqJrZRY/gXqlFR0poFTMRUt
         qZW+QxLpvZRk1cyMtwrygtsymrLskp8L4qa9Y3o1z7a1mijJx2sEk9A77/C6IQoyNzVL
         zr8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Eah76lvYsPeNHMD8i11r9iqPmQNtRAGhGD0e1zU04jc=;
        b=ER9sPArifHT/CXVcfMAVOeNcgLIMWxx22c+VKZkrRZQRXYSTlS8Bo/YgiYXNHTsv8M
         j63nVNoOtZPDr4Thv/1bHyoCpXHqsvP/AAStnxa+wuZ5PzcExivn+yR7HH4WDPyMpvvf
         1geABPyA66d3CM9ZuplLrcSWerL4oA5vCGdh7jxXFL0l6DzZ/3hlgh3y4HRzTA/WYnr7
         Vbxk5CPIGfk11VTuFtcKVxnDSo3SQn0xntsfGfgM8fG+PPnLPlTO0yLHsS/q0DzhxRUH
         Mr7GqkWJW+aOimNOADyyXMRJdX4GM6q5Ki6RM/pn2AfhcVUEc8Lnc0OxRyUZYFwxDPgb
         qOnQ==
X-Gm-Message-State: ANoB5pnLO1wa9F03oYVlGcb9OnXCYWcWYXhRO0Nz5k/LTRgAr2NjHdvw
        uTNWyt7NUuI7rj38sU33pCA=
X-Google-Smtp-Source: AA0mqf6I7DSTT5mrSKi4mwgDoyYmZ7ytb8ognHx+bIOty71azc3mXBpFAt4AFLjKlFmoTQkp6oH3kA==
X-Received: by 2002:a17:90a:7e0d:b0:213:d630:f4af with SMTP id i13-20020a17090a7e0d00b00213d630f4afmr22303375pjl.77.1669063002120;
        Mon, 21 Nov 2022 12:36:42 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f4-20020a170902e98400b00188c5f0f9e9sm10120804plb.199.2022.11.21.12.36.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 12:36:41 -0800 (PST)
Message-ID: <5e86377a-c4bb-6c65-00bc-311d3998dec6@gmail.com>
Date:   Mon, 21 Nov 2022 12:36:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 13/17] net: dsa: merge dsa.c into dsa2.c
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
 <20221121135555.1227271-14-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221121135555.1227271-14-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/22 05:55, Vladimir Oltean wrote:
> There is no longer a meaningful distinction between what goes into
> dsa2.c and what goes into dsa.c. Merge the 2 into a single file.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

