Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A981632E0A
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiKUUiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiKUUh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:37:59 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FAD22B271
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:37:58 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id p18so8891876qkg.2
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9jQfc6oIShNsh6Bh68GNySUE//+4B5UuccmQ302rf5g=;
        b=D2KtyDTLamWp2p9la0fxxejBJLo/EhioN3vizGGFZfEauDimZ+vm51GJxCD9KR8MRR
         VFHsFgw9ie7EuO9cP9pEcgmfUOo/y1A1RQA6Zk6aNv4oX5g6xL6OFq6q6gLUExWgyg0V
         +3inhrQ/pmdwVeJkm/ilk7FfI9evVuM2QoAfcrOPfDTN1c7kxFj5Kp2a91fZvwvO/utV
         mtusTA6cHjmZd991Ey3LYWKboRVQqVdXLkZpSZNYXLrLT54AsN2C+yTY0lLslapLh9PM
         G4u5pyvtJX5yIebipl2Exc4PqhiC6cFA3snythCDXBqJFWcqIi9sTWPRXXG9kw9Io+P7
         fUdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9jQfc6oIShNsh6Bh68GNySUE//+4B5UuccmQ302rf5g=;
        b=QjaWpctrrRB79OL821qw79P2NekuCj49up7mnbGH6KSoQW3laMh3EYNW1OiniTw5yL
         RbOcONDtf9aEtFTXvdvi3m/EEyIhBkPx+coVZmCmYi95Mqc4BNg3Y3JBELTeFD4lS7QD
         8TUfWP311TtOhtkMXhDdRQqrJq4JqX2uZVBXfnYbnW75KplM0khs//yAhf+AeiX8KiDU
         ACkiWLD21NxFya8gOc3Lsp/mMZKiOCNlQ6NK0bmtJxS/XfTw6jcTbse+dSSQuXPsBbiP
         o0gKsmeMZIjUpKRQ0z1RPaia1OCLJwEwzK7aAHSlznoHCfwpe4lMxctB/xujDici+Lk0
         JHVw==
X-Gm-Message-State: ANoB5pmOYfQzskFRqQqdnHJIMWeS9RAtjw9RDR03HC9qklPsmTKc31N4
        lmfZfbiqrBG65BEBE6+ttHweFpjhMsw=
X-Google-Smtp-Source: AA0mqf6yxlaaPq/u8bxws7ymDvJyDDWeDnMvoPicenIRFiRbGDLXKUKj5j8vRnRKUsZ+IWInCFcaYQ==
X-Received: by 2002:a37:e20d:0:b0:6fa:8e8e:1ee5 with SMTP id g13-20020a37e20d000000b006fa8e8e1ee5mr17743023qki.45.1669063077695;
        Mon, 21 Nov 2022 12:37:57 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k21-20020ac86055000000b003a50c9993e1sm7122132qtm.16.2022.11.21.12.37.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 12:37:57 -0800 (PST)
Message-ID: <d6823c85-958d-fe60-7ea1-82ccfc174735@gmail.com>
Date:   Mon, 21 Nov 2022 12:37:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 15/17] net: dsa: move definitions from dsa_priv.h
 to slave.c
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
 <20221121135555.1227271-16-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221121135555.1227271-16-vladimir.oltean@nxp.com>
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
> There are some definitions in dsa_priv.h which are only used from
> slave.c. So move them to slave.c.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

