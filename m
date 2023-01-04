Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8257665CBBA
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 03:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238780AbjADCC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 21:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbjADCC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 21:02:58 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D4C167EF;
        Tue,  3 Jan 2023 18:02:56 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id n12so21861521pjp.1;
        Tue, 03 Jan 2023 18:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aC/AUAth48mE3OKJG55/t5FnZKeFtEhx3MwYShiuXCI=;
        b=bKyYh1Lphjs7ORYkU3LsBV6Shg8reZzoDLfIwM1Afwk3WFKsknNXwPk7n/4x9ocJ+m
         ecAnXZCmxQj4GHZeqb8SdXzGEb4w3Xl65nQ4BjOu+nBgMp2bRsVBkGVp+aJoWh53Wruq
         sshycjrgQBSv0jA9BsSE83h9NMViM454Pn8LxfAQVLtk43MQJzqULEg1FB78HDsq2Ap0
         0nXV2a2JQh1TvVn3Dp2/ExHB1kscC/W3woyaEtqWr8m9FDyHFd1BKxH3aZw7GPkvCLlq
         HYaGTGb8x0wa96fUsG0Yya6Imj5tDbxgEwDBg8G8AerJBDc9UPn/F93bwY9bAdKd5OYH
         TlXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aC/AUAth48mE3OKJG55/t5FnZKeFtEhx3MwYShiuXCI=;
        b=XIf6j4SinMsh/BArh950+dt1GnNbRBheMjduooaNY+HfPXC8ke3xHUZLNh7+aDZUDH
         VZyzgj7IdDySNe/fTc/T9UN3NcewGUtp02utpxyHMe0cUb1OKcv2Uo+8mHuqOHUisFmV
         pFDqdeOe+6sivb/EH6AUZAyd9KEZ5lgACL+Fxrw6vOgsHXZBypxiCCEUUNwazK7sF69F
         Yma9p0IGS23EBd2X+4h9QVe5UsPL3V9uiG6j+dGmPcGHq1R+05H2Pxqq29vsnBRyBzuh
         5z88z/n93XjVvNLDZtiuQ7K0EGAkFAd7ur5zn8Ptp32jzAb9Rk1WRuTnP6G08q316/OE
         MxXw==
X-Gm-Message-State: AFqh2kolp7XnVUIFiK3Y4Aui/TfWMd//cKCf1yocXFQAq5kbdMnOGXKx
        tCU467xN/ilhKOs6E2Kceg4=
X-Google-Smtp-Source: AMrXdXuTp3fXV4/sainOxD5f2m5eRzscL+YVDoxJjlTWSE1Mo8CPc1l9X5yXnhZel55+5sRAp7PMsg==
X-Received: by 2002:a17:90a:4401:b0:21d:6327:ab6 with SMTP id s1-20020a17090a440100b0021d63270ab6mr48000089pjg.1.1672797776257;
        Tue, 03 Jan 2023 18:02:56 -0800 (PST)
Received: from [192.168.43.80] (subs03-180-214-233-71.three.co.id. [180.214.233.71])
        by smtp.gmail.com with ESMTPSA id x13-20020a17090ab00d00b00219220edf0dsm19244944pjq.48.2023.01.03.18.02.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 18:02:55 -0800 (PST)
Message-ID: <c94fd896-75f5-6a7b-1253-b1377405fef6@gmail.com>
Date:   Wed, 4 Jan 2023 09:02:50 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net v2 3/3] ice: Fix broken link in ice NAPI doc
To:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc:     Michal Wilczynski <michal.wilczynski@intel.com>,
        netdev@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
References: <20230103230738.1102585-1-anthony.l.nguyen@intel.com>
 <20230103230738.1102585-4-anthony.l.nguyen@intel.com>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20230103230738.1102585-4-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/4/23 06:07, Tony Nguyen wrote:
>  This driver supports NAPI (Rx polling mode).
>  For more information on NAPI, see
> -https://www.linuxfoundation.org/collaborate/workgroups/networking/napi
> +https://wiki.linuxfoundation.org/networking/napi
>  

Replace with LF wiki?

-- 
An old man doll... just what I always wanted! - Clara

