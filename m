Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C024ACF53
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346298AbiBHC7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345777AbiBHC7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:59:51 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138FDC06109E;
        Mon,  7 Feb 2022 18:59:50 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id v74so16451201pfc.1;
        Mon, 07 Feb 2022 18:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JhTpMGvbxGUrJKu9ijtc6q5cHQtWVbAXxqUiZ2vf6R0=;
        b=VflgJZsG7gz8vKTl+ZwEyVJ/NKBnNb1T6B1IapXX3KAcQdvdl2+jbIwj3m6k5HhZFc
         8PyUPJYerdEyFKEz6IxOHhfsZUUf4+kwHmFHVkgFMF9pWPX/C/kstJqHe0BCbWNSn4Ls
         MXJXd9ytdvN78I0bV854gdZdpYj+K4kGZ11LsbzMDeN9j6faoaCJToXMQWUHxmFO7qbV
         /Rf/IV8iiIV+DsJTfeJN2eJLmmT/KpLa25O9FPwbom3PP5d+LLOcKlBrTO4ilEukO58a
         l3m1QIK+9qdK9/M0nyK+MuyHngKj1+wcVy3Koo9fzM2bks72DceoPDpAdme2iiVv/NUf
         1CJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JhTpMGvbxGUrJKu9ijtc6q5cHQtWVbAXxqUiZ2vf6R0=;
        b=AOzxSo8xIAFF1YBkysCbL5NHayNKGZdzh6qm1fbazTuXNhG7tLkZiqCLCozXMhEfJm
         1Aa3+BxsjKsrusuBuWHsfh+51oon7qDSIF+/ZngB06B9CW4Cxe4GD0jncIOL+X8oMsFJ
         WqfLDv2xJP77itwFUaFJVDzWkXM5UD0wjNVQix/uqBispFKo1mbz1RMTKBPBHkL16y+K
         MLu1c2Kb+Y6F9tynQ6iSli1tLLiTa4OpZtB063g2Sk7E6Yyclz1O78Y3XLQn6UZbjkC3
         YvsgGZZNw8rsYGYgj8zX3udNr5Q7SqH2YsooP4RyLE1O0yS2uTsBHNGM8LQb2bxOZR2X
         EG7Q==
X-Gm-Message-State: AOAM532e+cqEFhYtPE16J1QIaaqBSwu+aWhy/LsAhwXs9oKlmjtG3b36
        5UW2lEEfkpeK6SXbvS7ucdE=
X-Google-Smtp-Source: ABdhPJwJKe8zRAXA2oArhtP8Khj2Mlg8Z67j9TqGBH4wQ5OjG+YqFAO7vZAplb49s3J/KWVRY8Td+w==
X-Received: by 2002:a05:6a00:cd2:: with SMTP id b18mr2322825pfv.63.1644289189459;
        Mon, 07 Feb 2022 18:59:49 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id f18sm13464712pfc.203.2022.02.07.18.59.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 18:59:48 -0800 (PST)
Message-ID: <3577892f-02ae-fbfd-8a6f-c58018e2efdc@gmail.com>
Date:   Mon, 7 Feb 2022 18:59:47 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v8 net-next 10/10] net: dsa: microchip: add support for
 vlan operations
Content-Language: en-US
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        robh+dt@kernel.org
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, devicetree@vger.kernel.org
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
 <20220207172204.589190-11-prasanna.vengateshan@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220207172204.589190-11-prasanna.vengateshan@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/7/2022 9:22 AM, Prasanna Vengateshan wrote:
> Support for VLAN add, del, prepare and filtering operations.
> 
> The VLAN aware is a global setting. Mixed vlan filterings
> are not supported. vlan_filtering_is_global is made as true
> in lan937x_setup function.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
