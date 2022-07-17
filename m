Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D32577767
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbiGQQ7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbiGQQ7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:59:36 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87334266E
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:59:35 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id q5-20020a17090a304500b001efcc885cc4so10530832pjl.4
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8DoLFfWDTjRtsJLo22CES5o3W+Dnjen7vJRkvvgmLc0=;
        b=GDOpqh793kX6Iw0aFG0H9s93vKfiZcShoi/oymjBfCYCV0FMCBGJZKKSjQ+voe0XmR
         BNTTG2R6yzrPsJTWe0EUp9tt+VHcJxeTVGuHzNeFutsTfpmKUHKWN9D8Tyja6qliVIBw
         Pw+WHClvlttRUxmcYxoY5/hsugMP2dahuOXnf8ZrdbatOri3yiNVfa90yvFx4E6ICucg
         4hwTjFR0G68+fxCg+SpJc41X9/Px1ugq6DWlNFLHhwnR6ykU/16ytup5CBXyNIolgMJX
         89VKTTgCpMHMHedAVWqU2ZSLzNPsX3hVWRnBkAyL++UhFChf77dlrfnXx59+zF2N3SXt
         XdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8DoLFfWDTjRtsJLo22CES5o3W+Dnjen7vJRkvvgmLc0=;
        b=43QINISOyLP812B5pdqFYXHhNtks2LJt8USLhTPFH4N9UgR3YSdxkDOeXWUg6pNYh4
         Byo5TowjV8FUTBYGT+hI0lR+js7A1Kfke98gbeyT0Gb8DU3iOeC9pas/jo6G0ORkALM2
         IKE9um4KQV/SKz77sW8rW0ZvgJyT2hwOlM47WFJmLEfOuUOlDEOyiQOZvDtj+184O6CD
         +/GjsERE6aHgrT7Bv65rsNpF1fwdwlIYV6wbP0aWnR+g+efMzJRzK0zhz3MOwNYmU9mP
         i270I1oCHmpZcrhKkUvfCrZpbZqNc7QAVnzlnB8D+nkuFiPMiTICB72WDU6fYuQ+FCqJ
         yl0Q==
X-Gm-Message-State: AJIora+y9Ud/9Yvb4+7dV66ZLqVOHnrc7TsvHO4nWnHQQYB2q39QWjrF
        RWZh9cnFqGIlIT3+kwj1zWY=
X-Google-Smtp-Source: AGRyM1vSOpkJhp7eapZq+dZrTAQBgRvph/clZclD/duOWb9Gqt+iWqHx/O5ksa12Om6XzHf7EAlLsA==
X-Received: by 2002:a17:90a:6c46:b0:1f1:b72f:ce26 with SMTP id x64-20020a17090a6c4600b001f1b72fce26mr4548289pjj.190.1658077175017;
        Sun, 17 Jul 2022 09:59:35 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5? ([2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5])
        by smtp.gmail.com with ESMTPSA id j10-20020a170902690a00b0016a17da4ad4sm7448401plk.39.2022.07.17.09.59.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 09:59:34 -0700 (PDT)
Message-ID: <f8d86bdd-b97a-0dbe-c3bf-93c85b05cdde@gmail.com>
Date:   Sun, 17 Jul 2022 09:59:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 08/15] docs: net: dsa: document port_fast_age
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-9-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220716185344.1212091-9-vladimir.oltean@nxp.com>
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
> The provided information about FDB flushing is not really up to date.
> The DSA core automatically calls port_fast_age() when necessary, and
> drivers should just implement that rather than hooking it to
> port_bridge_leave, port_stp_state_set and others.
> 
> Fixes: 732f794c1baf ("net: dsa: add port fast ageing")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
