Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DC65777F7
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 21:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiGQT0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 15:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiGQT0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 15:26:50 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B859A12AE3
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 12:26:49 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id f11so7339795plr.4
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 12:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aQZ0dzIDpfrKUhSnd/FzG6ka0JbenBmuHetDRt+HNZY=;
        b=KGdrEfDSXmXvnsWmGxpQ6viopSYgshq4SduBiuJSPGxfWEEyY6PDDFhz24TSpo0Puz
         lg7YqNGESi8O8kWhztG5YNcSrxDwIKV2ktRhYqv4GRupdOFsXh7f4ltcvpZqfA7uaXWi
         IZHEgesN0DOh/XqYLrz+K1r8Pczs8aZ+ZrTXahFSqK6eTCnKe5dVtW/pk5kGFK7l222j
         96xY8CbFxN2HgDyfUtk4mVEKY1/zSwbhkvY9o7U8uoVt3Kax03WpDIPXt9ESMvFThncf
         JaZut1EURdeM4fs2EPQjgaigDw3hX5+bm47nuWY6w12nmBgV451Uende8HjmLpnsWOuu
         Fliw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aQZ0dzIDpfrKUhSnd/FzG6ka0JbenBmuHetDRt+HNZY=;
        b=TVqgLQfXPRt6c2nf/UeWgSu/aBLNaJKZr2NNtfy5ANIMytrVYdTYU6i9ru1mE8sPEs
         f1hti8r0AyrJOWTbY3r2Xp4uxbuyf1OVTecjtrFG/Gx/+3eCZmp7b0oIDMKzhLS3icBY
         HnDIGtuhbbMLIoTvfFAv73pVt7gHgk3DR6sNk1eS7D3yjqAlH7IlZdDCJkvk4YO3y0PE
         EUNsNYiGJZoIC2iF1+o9FHA3idhx483o8CcO7t4FNYSa1Gr18g7ZiMmaZMKzZUkoM1eG
         2ZpfeBcdFkhGPjVbGavc/Fi6eWjDDjwpjsvx9rk3eADZUp/1H7nrgz8VQjN6mQmmYgm3
         uBEQ==
X-Gm-Message-State: AJIora/XUAyq8C3/jNzVnC87dvZIKda0BpFdkReU85oMc6YuSoeDP1vA
        n4yVlWCmf3sAncYAGCxzzU0=
X-Google-Smtp-Source: AGRyM1u7BcoFJgDQCcSK/1Ew259OagjHxRzyM8xeLWTBKuXv72/JpFob6VCKoQZhmkxNhbOfdDLB5Q==
X-Received: by 2002:a17:902:8f92:b0:16c:e485:7cd2 with SMTP id z18-20020a1709028f9200b0016ce4857cd2mr6428739plo.50.1658086009187;
        Sun, 17 Jul 2022 12:26:49 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5? ([2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5])
        by smtp.gmail.com with ESMTPSA id w6-20020a1709029a8600b0016bea26bb2asm7529029plp.245.2022.07.17.12.26.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 12:26:48 -0700 (PDT)
Message-ID: <f7d4e9ca-b7fd-4a75-608d-d618028a6e16@gmail.com>
Date:   Sun, 17 Jul 2022 12:26:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 13/15] docs: net: dsa: re-explain what port_fdb_dump
 actually does
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-14-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220716185344.1212091-14-vladimir.oltean@nxp.com>
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
> Switchdev has changed radically from its initial implementation, and the
> currently provided definition is incorrect and very confusing.
> 
> Rewrite it in light of what it actually does.
> 
> Fixes: 2bedde1abbef ("net: dsa: Move FDB dump implementation inside DSA")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
