Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4604BEFD1
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 04:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiBVDDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:03:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233173AbiBVDDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:03:03 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BDA25E82
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:02:39 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id q8-20020a17090a178800b001bc299b8de1so1110127pja.1
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6MIS2V0+HqJu20rmLOR6FzdmUcOWffjDrYqoJqHYMN0=;
        b=RpwEIIoiSS37qG0iqX9oDoUMI9UcWkDwbsT5JQTb/3/QHEHJ3UoMkNDMpwOwyeGZhg
         s7wgt1pW0fkLTaEkKQ7gasFLKvghLCuak9tKfVE3uFKrRqQzvCJXk4PwldOYeyc4yB+Y
         jcD8cMe+5LUUe65B7sHazNP9eBNskW8hXgS6cOqcHM9AZHKLi/aUC/NeLVwIXFbsd56l
         sgO3vnqhNp8dNCRIxGCool+6RPzQmwiHRPROjcVsKrH/ujhQTSgbktzXQymfcQXvF3Gx
         uxZY81cLPvygigZH3roqowj77MnsZBZwRMO50cFDV0zXQW2+8i5YmDs8ZjvANP3G6Nzn
         WfRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6MIS2V0+HqJu20rmLOR6FzdmUcOWffjDrYqoJqHYMN0=;
        b=hBgQ3r8/MhlCRy06WVHxFchLuuu/a3bpy8vPSkTLd/mq69sKwLfXX/8KHX61AEvPPf
         toW+ykt78SNE/pX3armk6StguRI1PwqEKdFK/Q8tGda2v2dj9AmLoZ+FR0biCNrBd0em
         YuYopkVaMmEFzUmy2GLn3EhvUxQOSEaiGSfBkV6rXDkRy8vPnrll4TU4S0rgEh/czcpv
         85ZpMJfHpeVn1LDi4akl/AeozB2fZSmnU6KpmIU2BWy6TCgukkbYzRSsp6PJZS3DYaHb
         Tk1LuSgkZivsJ6aTQzklAlSvcsyg1cK0uxoYGmMcwFVH0qIt5jEjUZRoa+t4NRzysiSB
         DDSw==
X-Gm-Message-State: AOAM531HsdSzkSClDGogpDQ6uAr6JYKTVvLBrzPb7xPniIex2d/qguaG
        NogFzP1/Xr5aXFbQ3XS0JvQ=
X-Google-Smtp-Source: ABdhPJw7lCvmOvM2B+PzpSHWsHt8L5LH4ltRUL8AAZygAuKE36/V480F91weOR/8+6U5yrLVu54HBw==
X-Received: by 2002:a17:90a:aa91:b0:1b5:6032:5459 with SMTP id l17-20020a17090aaa9100b001b560325459mr1965602pjq.116.1645498958815;
        Mon, 21 Feb 2022 19:02:38 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id w23sm19637202pgm.14.2022.02.21.19.02.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 19:02:37 -0800 (PST)
Message-ID: <14ce3191-55cb-fe13-8ceb-c31ae2562e9f@gmail.com>
Date:   Mon, 21 Feb 2022 19:02:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next v3 2/2] net: dsa: OF-ware slave_mii_bus
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org
References: <20220221200407.6378-1-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220221200407.6378-1-luizluca@gmail.com>
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



On 2/21/2022 12:04 PM, Luiz Angelo Daros de Luca wrote:
> If found, register the DSA internally allocated slave_mii_bus with an OF
> "mdio" child object. It can save some drivers from creating their
> custom internal MDIO bus.
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
