Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00E5621B82
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 19:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234817AbiKHSLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 13:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234764AbiKHSLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 13:11:07 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7AD58BC0
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 10:11:01 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id ml12so10791180qvb.0
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 10:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wuukP1xM24agsPdNWzB0V7MzMdZrDHPSVeezP2mB0s4=;
        b=TMV2prw0HwDSgNatzkDqCwxCLewLG14vddkytRzcuTP/oHGBQgVb9LWTC5B8n09G2e
         ahNUPLJiHKogDbBnmQthg66c6Vf0Cbk7OPSLdnOMGR6oQ8oesDyUZ0NBoIJKl8l7J8PX
         +8sk+odxVenz+meZrwkIJXFzaHWZyC0E5lj8PQucqNW2kWhGxo9iUhOE/XWiW2WTpLc0
         Ag5DOXcGN00JGU8hZG5bIEAlfLpE8SCqEbhOdgxt68B1zejdAoC+k0qGGkmkcT6gu1FI
         aINqzkeQZqk0Jjam3q9DvXukbV9Nqll9SeZgDiGdoYjyKBGw3axDL1RF/87Rky13sK+M
         yB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wuukP1xM24agsPdNWzB0V7MzMdZrDHPSVeezP2mB0s4=;
        b=K15CPlWimFOola/sXxtvkCFRxDhWVnv/nwGjHxLAcr6RQbSozBFjWr0sLPluomcoOI
         D+HsaHiCEUMg+BkkGyCwDTMAAuP5I1KqLvqnAOVw9fk/hgSgOhXSWbvYuq9witn+ImCy
         9Yd+RNEogyEsRqqQ39Y6OO5eSYE7rfQhMEcYHdRNIfot/6eaz5qZZMjfuh7fKdKE59aP
         DOoe8HaqJpn3pXRB1Q0EzqgPBKHJTdyGLxko1mdClHUJY04Q37WvKz8qbmQ9GmeZ+GnW
         871WsO+vcYWFlF/xokmBw3kV0qOvRKR9gUU2AJjHGZr20zsNwmFCj/8xAk8WysP9TvUD
         PbPg==
X-Gm-Message-State: ACrzQf19yx3b7or3hvWtw/nqvqfj80PO4tc4be7QMkclnzunBDO1u2RS
        kYaIGQjRXf9GKG6fc/fbpkg=
X-Google-Smtp-Source: AMsMyM6qcrXWXDuBK19roHCDAVPG7nrwKjBl9ntKFOrPcysQeObTJifEaeHoBHe6aiarDqTM6KaRDw==
X-Received: by 2002:a05:6214:411e:b0:4bb:f5bc:f807 with SMTP id kc30-20020a056214411e00b004bbf5bcf807mr44148531qvb.114.1667931060710;
        Tue, 08 Nov 2022 10:11:00 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id m19-20020a05620a24d300b006ee8874f5fasm10169048qkn.53.2022.11.08.10.10.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 10:10:59 -0800 (PST)
Message-ID: <47222d85-608d-e07a-4bfd-663685f131a7@gmail.com>
Date:   Tue, 8 Nov 2022 10:10:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 1/9] net: dsa: allow switch drivers to override default
 slave PHY addresses
To:     Lukasz Majewski <lukma@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
References: <20221108082330.2086671-1-lukma@denx.de>
 <20221108082330.2086671-2-lukma@denx.de>
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221108082330.2086671-2-lukma@denx.de>
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



On 11/8/2022 12:23 AM, Lukasz Majewski wrote:
> From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> 
> Avoid having to define a PHY for every physical port when PHY addresses
> are fixed, but port index != PHY address.
> 
> Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> Signed-off-by: Lukasz Majewski <lukma@denx.de>
> [Adjustments for newest kernel upstreaming]

Seems unnecessary when this can be specified through Device Tree entirely.

It is convenient to be able not to declare the switch internal MDIO bus 
and how the PHY address to port mapping is established, but Device Tree 
remains the most flexible way of mapping all possible types of 
configurations.
-- 
Florian
