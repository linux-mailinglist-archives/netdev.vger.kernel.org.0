Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685195777F6
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 21:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiGQT03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 15:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiGQT02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 15:26:28 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FF712AE3
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 12:26:28 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id v4-20020a17090abb8400b001ef966652a3so16258403pjr.4
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 12:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZEHL5x59k3STP76heD9dTfyIJeBM/pJ0shLFS98WGIs=;
        b=FmLXGPy+bVJv3+jWzSc4KFaq+l1ZlOKnOPlrRbl5rsoCWMVYHNCv6ZpKLtJnxQQ5vv
         rQ8uRz23C7cRWC8rnmZxGtGrP4uLHdMjh7dpbmHjuKzlx4DXlxXBQJfS4mHvCZR6IDIJ
         PVu3c0IC1XGLQXDaxtytQzYts1fGpxRzkaQk66R75Awa9YiRibpqMOF6USgJH+W9pxuF
         Po/NbEEWiq0St/W67eGLOLq89T57atfmgJ/9TfQcVB3/Xj5Uw23VCGZYyznBlShsGQNs
         ZLb2guw65gQfLbe4X839p0prCyhIED9nDjdI0FlCMOVJ0MN/x0jzldEXSw/FuZSsBcHq
         7F4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZEHL5x59k3STP76heD9dTfyIJeBM/pJ0shLFS98WGIs=;
        b=5C+kJgnxYZpoIpmLtDai8o+/hAz0shm/mL8nb9vfyEbmvBr15OPp0EZvbuVc/+Fog6
         ozYIiK912nd7DzGyznB5zYBXpUOSXtST6z20iPc6eeoaFeH7WvDYksJxlKjOcw9xkvzJ
         /jG00lQ1zRPs4wFd3XvA44UxxuTi0qlXvNNzaNmCAzKp5ZksAwWnvkMuokjRxPrMq6nA
         dbHBz7+ngLQ+pO2IqeFeoHMAffuIyxBxULZxnNYX/bVzabya6o95R+rbNPZRD6iOSWWg
         31zZxmeL6A2zLbz4JsfSOV75nW50WC11rNhl7azqF1nXMJ8u6ktqeRqQerabJyDLVOvO
         Vx7w==
X-Gm-Message-State: AJIora8kUMB+qQHhustrpZt53MRIvFqX2yU5COAUSWhlzqY6AZ3+sj8X
        OBU09d+nASHY0JOmLWCk+i8=
X-Google-Smtp-Source: AGRyM1vtDFw5LZNEQk3RC9FJJ+24j/CwHha2uA315959x2dRXk/PmpFo4moxT9hR+aCdob7904MhnQ==
X-Received: by 2002:a17:90a:760f:b0:1ef:8343:61d8 with SMTP id s15-20020a17090a760f00b001ef834361d8mr35396426pjk.114.1658085987639;
        Sun, 17 Jul 2022 12:26:27 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5? ([2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5])
        by smtp.gmail.com with ESMTPSA id b1-20020a170902d50100b0016c78aaae7fsm7714471plg.23.2022.07.17.12.26.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 12:26:27 -0700 (PDT)
Message-ID: <a78bb7e3-9756-e777-4e75-684a6d51bc01@gmail.com>
Date:   Sun, 17 Jul 2022 12:26:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 12/15] docs: net: dsa: add a section for address
 databases
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-13-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220716185344.1212091-13-vladimir.oltean@nxp.com>
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



On 7/16/2022 11:53 AM, Vladimir Oltean wrote:
> The given definition for what VID 0 represents in the current
> port_fdb_add and port_mdb_add is blatantly wrong. Delete it and explain
> the concepts surrounding DSA's understanding of FDB isolation.
> 
> Fixes: c26933639b54 ("net: dsa: request drivers to perform FDB isolation")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
