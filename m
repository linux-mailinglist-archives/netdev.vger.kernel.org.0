Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93A04D2724
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbiCIDVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 22:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbiCIDVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 22:21:00 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8F214E95E
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 19:20:02 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id m22so1189104pja.0
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 19:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dC4h3FyQU1VxdGueE8fU4GUBPgCE+13H9wqPicxo0VU=;
        b=HzvbPbeC/WgMByP4/ngCtiOXypDLVGbvio6WYzh7sXUSNnBw7BuQHCCyH72FlWfjLb
         KDHYF6b21+332AxkfNw2vlMdsGrBpZgwksiPTvf1UzInvkA1IAmldLff3Cx6Q1bPdqrt
         cmUhtqnE1S6BeNpE3YZpcS0V39py3TD07HRYoCUO/TjaWEd2dpJE2RutXmwxNz6qvR1W
         oxtD/xOLfam4ub9Yu8Rb042fcmXLEZe0BZSziXDNUg02dURlL0xJhD1JCA+MYBT4kf9H
         tRTGgB3Rb1dKbfo4VyeWA5FStk9EDlZoic33yUQFtIyBDjDeeG/fozPGSmGTm/IWF6hw
         Jn5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dC4h3FyQU1VxdGueE8fU4GUBPgCE+13H9wqPicxo0VU=;
        b=VN5FSHCYc0olhPMSPhb6/hmSii/q6+J+s/8joMGKQihguIBb+XYSwhm7rgjevDuX1+
         JTd7C164teyK9u/otWMFz39kcu83qLhTPldWbTIWTGvjJqE7K3E/oi0VH8iIJGfoVI7k
         NF0bAX2fWWzTNYoCov36iFL0T8pRbyqmdNuSMLFB9Ls/kLeCZ5QLLAWNmi/0fRpXX+F3
         Hixcd2oqPg5NAQRmoVfh4T4naUIzpu7XJdPGFou8tRDnmWTyykbgGR9nDMawP6wn/yks
         +nLBm6fambj1cstsVTF4cAxX963XLXOH5J9M46wQXtnknddiQTsoEfjweFee1qhiF52d
         9ixA==
X-Gm-Message-State: AOAM532n/6Ik9oOlUvX/43sNc8KvQ85/q8BaTjaJkJdRDV2v4g6jjmaT
        nmoD0tWN/6nFjmvjMdvYLNA=
X-Google-Smtp-Source: ABdhPJyOIxaZqJafx2o2inf8nL7mT6eRJ/cDk5eOLAsE+WCIJc85QxhufH1WGi7XHYmg4JSqmEvRcw==
X-Received: by 2002:a17:902:ecc2:b0:151:dd64:c77a with SMTP id a2-20020a170902ecc200b00151dd64c77amr16640170plh.154.1646796002084;
        Tue, 08 Mar 2022 19:20:02 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g6-20020a056a001a0600b004f2a4316a0asm541727pfv.60.2022.03.08.19.20.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 19:20:01 -0800 (PST)
Message-ID: <cfdf1196-50c9-102d-e519-8cca7ca8825d@gmail.com>
Date:   Tue, 8 Mar 2022 19:19:59 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v2] net: dsa: tag_rtl8_4: fix typo in modalias
 name
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com
References: <20220309022757.9539-1-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220309022757.9539-1-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/8/2022 6:27 PM, Luiz Angelo Daros de Luca wrote:
> DSA_TAG_PROTO_RTL8_4L is not defined. It should be
> DSA_TAG_PROTO_RTL8_4T.
> 
> Fixes: 7c33ef0ad83d ("net: dsa: tag_rtl8_4: add rtl8_4t trailing variant")
> Reported-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
