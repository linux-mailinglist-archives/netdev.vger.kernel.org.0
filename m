Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0516287A6
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 19:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237843AbiKNR7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237881AbiKNR7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:59:16 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC47D2793E;
        Mon, 14 Nov 2022 09:59:14 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id h14so11015866pjv.4;
        Mon, 14 Nov 2022 09:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XFhHePacexOmBw7Tz/K0F1TGsvHM9Xi3kq9mowYg3II=;
        b=mKGYb4c/KOkdbR+XBJPlya/hmWVHCFNnV61CSqtAIHvWeoCN5McZl69AJpgMp0+q8/
         fEXNvpXDd/6IofiSotqtr5Gq5jg8ej3CwK3NEk3QV/BG68LzUK8sR7++HtE1ufyp1YrD
         PkkuUfsxivFGh28S60h7jCDJcE2QTgn+e1O2c4WPWPwKveFDlUQRjur7KbC80ytF2PD+
         vulsUFqJlas28ZtR8Jyi3cOQDBtP2AxZV37sJsNX+s64+J8wubJjNSMwTFB5nspve8Pi
         i0Pd7ccGRB5PnroJArQ9CfINbDVVmiUhbA4+0M8Y9MCHNTXvMI6PZYHEAZZlbRAKTNpW
         z+sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XFhHePacexOmBw7Tz/K0F1TGsvHM9Xi3kq9mowYg3II=;
        b=R1JwJBULtxPvIElQlUJHut0SNn63b5X4Db8Eo54NiXCXqfS0IlKzIbIJx4O4TBhsjm
         jUso35Lz5OpqYHe8dUpNlSIkEa8bWLZDjvdlAkt82IDmPR66sYHsBSvpExIvUvqdDIc5
         WGoZsFiTqS5ctSJe5RKVfXI/AetZ+WFwGPnjuP/PCraBoBT+QAIbPO6bxI2ZsLmJA8WP
         F426H+36j7KjrkMrkQxBq5TJrieLsI/ZHoepI8vekBQFkFhkBsXap+oXw+8SgwK+YNAC
         ZEO1jPrYgVS8FYTpc0Ht1zFBPrIvniFFhjMNlV2RSTPwl3+FPgqPbEnzk79Lt0UCTBR4
         jvSg==
X-Gm-Message-State: ANoB5pkKS8lDvJ5wsSDjdRiHwHMrvm5e1sCcxMw8D7mIVCIrHftNJGik
        6YBFIYY+j4Iz/zreZUfpptZJwY4PFZwYeA==
X-Google-Smtp-Source: AA0mqf4qOQgyYkQt4HJdG7WX760vY2rDxoj0gyCABd6ax+im8jnAJmNq3aPTBjrkbclUabgelS+j2w==
X-Received: by 2002:a17:902:bb8a:b0:17f:7f7e:70c7 with SMTP id m10-20020a170902bb8a00b0017f7f7e70c7mr337841pls.107.1668448754213;
        Mon, 14 Nov 2022 09:59:14 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y28-20020aa793dc000000b0056c0d129edfsm6962689pff.121.2022.11.14.09.59.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 09:59:13 -0800 (PST)
Message-ID: <50a9e9c1-68d6-4edd-42e2-c5b8a9ac7e8a@gmail.com>
Date:   Mon, 14 Nov 2022 09:59:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v4 1/4] net: dsa: add support for DSA rx
 offloading via metadata dst
Content-Language: en-US
To:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     linux-kernel@vger.kernel.org
References: <20221114124214.58199-1-nbd@nbd.name>
 <20221114124214.58199-2-nbd@nbd.name>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221114124214.58199-2-nbd@nbd.name>
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

On 11/14/22 04:42, Felix Fietkau wrote:
> If a metadata dst is present with the type METADATA_HW_PORT_MUX on a dsa cpu
> port netdev, assume that it carries the port number and that there is no DSA
> tag present in the skb data.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Is the plan to use the lwoer bits of the 32-bit port_id as the port 
number for now, and we can use the remaining 24 or so bits for passing 
classification (reason why we forward the packet, QoS etc. ) information 
in the future?

Might be time for me to revive the systemport patches supporting 
Broadcom tags in the the DMA descriptor.

Thanks!
-- 
Florian

