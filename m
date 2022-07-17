Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5E75777EE
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 21:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbiGQTWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 15:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbiGQTWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 15:22:36 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79B0DF19
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 12:22:35 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id q5so7334017plr.11
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 12:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7qUQ1dQ3R3rBtHjVOtWgVDDCz1mNVOxh7nfvZkFWUP8=;
        b=VpvHen2TmxlnQvb+AJmcxnfCew837R+ZWJ/J3k0uxCKEiazQ4jghlVyN2KsB/1Y/XB
         LWmjbXG5PCEVT2+zXcPt8DyprcNNFFGFRBmzFTj4M8ItO4k36Zcr0mj0zt9nIUVpUEnW
         xP81Iy5YDpkEYKjNBR3UV44IC9h0dccFvR+GK6hg1/IMkLK9NhRgOSxIARhjHpzM56Rf
         syeL7IAD1GFED6F+avwmsrQH+G4eNMCagfWYOXxla+3dNW95CPVziJxyF1oM/JUrOpwx
         HO1RwW0DRFo7lkNItYqEG8YKtKjRgVYSDCM5DFHBMvHx98COcWxtkC5cx+w/2lFYVJ3B
         CjHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7qUQ1dQ3R3rBtHjVOtWgVDDCz1mNVOxh7nfvZkFWUP8=;
        b=GJWPdlCegXx8Ot9TrmU7sYqqTQTCRy2UBrhahW6MTVuiJtmr1HNDwiy9oQ+wnd4WW8
         jk6OzO5mc2tdpBJ1eUWd2Ki4cIGni3fHu7KFZluWhTn2IT3vsr2YLledHb3GagslZlsF
         SJJArDY/KAnAc3awpzHHulWbR6IJoH36wJrKHpknbTuVVlFY9Jk+9hylJlaL3upu08AP
         GTZxUPzQZPK8FpLbow/qk874lODUyOA+uo9ucX4vbdtRFNgJDbWS+WiJ0khUDBWoH1LL
         99/sl8dlISRNNuuJmPFs8zBSUNTU0r6vIwuvn2IVedjKUqEQpz/i2pL0+2+ZjT4V6Hm5
         vHCg==
X-Gm-Message-State: AJIora8IBVAUz3v/FtGozjnF+SIE54sEtvMFg7i4WJFpvD/qIVoo1Iq6
        QTpODN1f5Zdyg3cIU1elmi0=
X-Google-Smtp-Source: AGRyM1uoMMb9u4Rb92vnW9gvF5tEiC7cpICeXDLum9xwbuiWUd6bf6OcYwL6I2NfKt7KB3KBHZlxhQ==
X-Received: by 2002:a17:902:ecc7:b0:16c:46ef:94b6 with SMTP id a7-20020a170902ecc700b0016c46ef94b6mr24402707plh.139.1658085755174;
        Sun, 17 Jul 2022 12:22:35 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5? ([2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5])
        by smtp.gmail.com with ESMTPSA id e9-20020a170902784900b0016bea2a0a8dsm7566335pln.91.2022.07.17.12.22.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 12:22:34 -0700 (PDT)
Message-ID: <fa8435dc-aa41-a475-f275-57c1ee9480ca@gmail.com>
Date:   Sun, 17 Jul 2022 12:22:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 11/15] docs: net: dsa: delete port_mdb_dump
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-12-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220716185344.1212091-12-vladimir.oltean@nxp.com>
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
> This was deleted in 2017, stop documenting it.
> 
> Fixes: dc0cbff3ff9f ("net: dsa: Remove redundant MDB dump support")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
