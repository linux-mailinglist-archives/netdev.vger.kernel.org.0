Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3561A632E09
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiKUUhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKUUhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:37:31 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0D72600
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:37:30 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id x21so8919970qkj.0
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VSTFZDWXdFJDvhUzZRFjlklMEnXTs9XTlAZMMTw9ssE=;
        b=MH2gPNTFMyVi9i0qMAvl7NJ20HqHqt4X2FhiTIEWXv1TUFmfKSGFUZKbl/kv/8viep
         5LmX1OU7RLBxH1ffbwAabRjpYr4ObPIQcGGixUsqPcoovjbzKxoXWu52m2N7JXDX7xl4
         HKceDmscbP9Hny6XzvZ86eeavjwv2vNv0BT4GyK1gBoYmaMJYzuVroWWyiNs0U6ZkEk1
         +VBOGZFkPt/i1jkZfeyk2b+b3dlT6kevS2QnjtBWp8UHtf8U6X7f+Ltsm/EU4DOT/Slf
         yTGw44ZvZdNzEoS7c7H5Lc2jycbpsOyyPnvjyTqniRGiwRILGsm64YhLB2Q7Rt6dsbe5
         Iwkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VSTFZDWXdFJDvhUzZRFjlklMEnXTs9XTlAZMMTw9ssE=;
        b=hIG8dqmRanFkf1wFxclJON5aiO8YzRpPNYwQIqcuhgUqCE9fDEjML818QXH9/0S4S8
         VZ/s6Uix4KphHFyWnbgonh0tNCb6kXL1LMGKrceJCei8B9m7guvlWA5TgvrlexQBSSh7
         eEIW+PX+6zlwxssCkf/cL3lwTFv0AHn6rHFlsmmWsLhYUICIcpFReVmqUzUG1LL6jYO1
         ygbymaSBpJHIscdntN534tPYSU6GkauGvEnLso5uYQDcWWTDdJWoSg8Ff34nngZnyvgR
         BungbxUJDMRe1nLkzurEwN8nuF54b31ufjJJpy+JeCFqg5QGTlhNzPC7eLPNOnTxG0wa
         PC/g==
X-Gm-Message-State: ANoB5pnVs0y654x2n65+luxiRNjIk8IkNXC+/rDTTm+qNMzw0YCTRlMm
        9jYYKQ5E++UB56kVWGFNPdc=
X-Google-Smtp-Source: AA0mqf5yz+Ny1PZaZzze0VnwgJgqP2NmJdxWBZ++eG2NGLbgRpXHPsfmtSvtoC1n/Qu2L9EsCyRnGA==
X-Received: by 2002:ae9:e509:0:b0:6f5:5aa7:c772 with SMTP id w9-20020ae9e509000000b006f55aa7c772mr3752312qkf.97.1669063049508;
        Mon, 21 Nov 2022 12:37:29 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h4-20020a05620a400400b006eeb3165565sm9006086qko.80.2022.11.21.12.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 12:37:28 -0800 (PST)
Message-ID: <cb6b6dca-eac4-174c-ea38-d3a5c97bf6e9@gmail.com>
Date:   Mon, 21 Nov 2022 12:37:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 14/17] net: dsa: rename dsa2.c back into dsa.c
 and create its header
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
 <20221121135555.1227271-15-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221121135555.1227271-15-vladimir.oltean@nxp.com>
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
> The previous change moved the code into the larger file (dsa2.c) to
> minimize the delta. Rename that now to dsa.c, and create dsa.h, where
> all related definitions from dsa_priv.h go.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

