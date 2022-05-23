Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1691B531CB2
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240432AbiEWS25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 14:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244433AbiEWSZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 14:25:45 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831A412719C
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 10:58:53 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso8840pjg.0
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 10:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nQ2XjBmqagrH02gXtcNOLLn+oI0x38qbgguqkJjLCio=;
        b=gk46313qvyhaBwr0/EKnHEHDbJQmbrLfUCSeysmrP4afGmfQWdRTKWPko0QnFASy49
         SKilJToSlnC4u5GN9arzCWc2UuGE+CQUDfCHBht4+eIF8eNy22U9h5Exo7hnGuIGR7v8
         3a0lnrG2nyM8NOb+EspHWzo/gB9/Rcz3tjD+1KEVhsmzbg6VJuorD4mlHv231aMiXMAU
         rmBT2G/tHLGihBGwh3u0ZZKbnqb1T1RWneT4TI551tGfLDP4VYmDlTphNxr5umxgr6U7
         TdnIsiJAofCFDW5kXeOnQppbSceJlJ55n5nVpn4ODKfdh+TGUsOdqpkir0YFSBwzbbdE
         wbOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nQ2XjBmqagrH02gXtcNOLLn+oI0x38qbgguqkJjLCio=;
        b=3BAaqOr7ykAxuvj9St1dZAW8IYfd7WC07AnIZ1vlSAB3kITBjL0kQ5JZKk9vh7r0ic
         hY4Y+mGxuqJxMgazmg7RgOlHqhHs1mZGcYQiM5jtSIcfpXQyLugqWG9LsfrOaCmuuu7I
         ph/7aSh9x5CZqQ5lYsTFt6Xd3dT0knxOqbj1AmPxL8MtlLN8NQsZrDORgQfqmL/dX3z9
         VKCyD4gJ8MLNMGa0XWdbd+tF/Bc4sJHMIFqYO9gf38eZc6JIvyDk+vS92ll0fM8JKENV
         /oVZ3xxP/AoMK4FsZUBm75pwtFZtcq9C1TpM0jZCqBY9EkUG0RtQL/62FGqziXV0GtqM
         3qPQ==
X-Gm-Message-State: AOAM5318GTOH0s9hw4KEADlrL54a0a4zLc1moldhPALSQpo7TjUiw4Tt
        yxluqepcgcHK7la5V4aig6o=
X-Google-Smtp-Source: ABdhPJxOJiRbk76PgKmbWVGp+hk+OJ889KtnVFVCazek/tjlnznTd4pYSVAyTPlZiYCdqX9QGxxPqA==
X-Received: by 2002:a17:902:ccd0:b0:156:7ac2:5600 with SMTP id z16-20020a170902ccd000b001567ac25600mr23663571ple.156.1653328727772;
        Mon, 23 May 2022 10:58:47 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e18-20020a170902f11200b00162017529easm5392739plb.167.2022.05.23.10.58.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 10:58:47 -0700 (PDT)
Message-ID: <fe46fd14-0635-a68d-ad5e-e9be06aa2a82@gmail.com>
Date:   Mon, 23 May 2022 10:58:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC PATCH net-next 05/12] net: dsa: existing DSA masters cannot
 join upper interfaces
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220523104256.3556016-1-olteanv@gmail.com>
 <20220523104256.3556016-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220523104256.3556016-6-olteanv@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/22 03:42, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> All the traffic to/from a DSA master is supposed to be distributed among
> its DSA switch upper interfaces, so we should not allow other upper
> device kinds.
> 
> An exception to this is DSA_TAG_PROTO_NONE (switches with no DSA tags),
> and in that case it is actually expected to create e.g. VLAN interfaces
> on the master. But for those, netdev_uses_dsa(master) returns false, so
> the restriction doesn't apply.
> 
> The motivation for this change is to allow LAG interfaces of DSA masters
> to be DSA masters themselves. We want to restrict the user's degrees of
> freedom by 1: the LAG should already have all DSA masters as lowers, and
> while lower ports of the LAG can be removed, none can be added after the
> fact.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
