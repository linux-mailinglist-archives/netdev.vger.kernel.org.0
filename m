Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB29347A1FB
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 20:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhLST5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 14:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbhLST5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 14:57:41 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2526C061574
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 11:57:40 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id a23so7510693pgm.4
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 11:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NUqDD6b8yHAnH3/bzE0FW20E5qAIvcpZ4uiw5gcWiuY=;
        b=LanjYAMPNM9g97/CcHrjpK5nxmu7foaukr68zlaEavJee2V07y3xkTa+jC9/BYF6ET
         7KpBt92UZROTpCX6xiDEbzFEnxcLem+pTKAqVY26iCKONM/5BXf5+QVOgmt/ljCrzTXD
         BQ6e1AFAODuHlmEuqZ68zO6Ukl4XlnikeWJdfsWFsXTWdtJr8aI5hKWt0MLmhvqHi/A8
         vTb1C4Ogv1SCU3Hw83ePuq56wNaz1xnyO/49pvtzJgQ/4we/CRkf+eIhsmpT2ei04R3S
         oj/NmQbbDFynBRI8OnrrcGTOLJAxWg33u0LanWJ/Ci6xwulb8qh+WFmnTG52/LFCwHg1
         dcEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NUqDD6b8yHAnH3/bzE0FW20E5qAIvcpZ4uiw5gcWiuY=;
        b=nMWwMs9jqvtbuL9hItTjMfTETWs5SaNEvyejo0Jsx5G9LnrphhaoYw34Pm7mSjeUFD
         CfthkUpylfHQd5dwYoVB7fLlszQgYUZ9JMU5OdN4hbV9MBf1nPl7nrhcEMWEdnA8G80D
         bwTJm64uwebMJEQMJS4warcs+/c6Rle7/j/61ucHHDyDSPn+2HDaZ+1ndGX67yu5Aj00
         adeYx7g9Iqs/wAscQgM0e6vBI0//5YsZpqOX4ir8uN1OnZ7bXyBfu+pG7y979mJj+lnb
         kvCwHjSS9OZjgTuhqhME2Sv0qEB8A9MOTDUVPbKGHG+J9Inhhvp2YImLhUN+jQYDPkI5
         vMhQ==
X-Gm-Message-State: AOAM53363oytYmPveaOV19Zj1ss+JAAZQnPpTWTVmD0Fw6gmACLE/PpF
        zb1mcQaLxB8InGu3HUjylJUZ9L5wBuk=
X-Google-Smtp-Source: ABdhPJxYq43rj01YDfZQwpl0HA9r5cf3NJW68QqgyeZUFQBgYaBOx0OMQUtAwKFhbjlpD6KFDD9TZg==
X-Received: by 2002:a05:6a00:1a56:b0:4a3:3c0c:11c0 with SMTP id h22-20020a056a001a5600b004a33c0c11c0mr12953329pfv.42.1639943860457;
        Sun, 19 Dec 2021 11:57:40 -0800 (PST)
Received: from [10.1.10.177] (c-71-198-249-153.hsd1.ca.comcast.net. [71.198.249.153])
        by smtp.gmail.com with ESMTPSA id u22sm15660337pfi.187.2021.12.19.11.57.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Dec 2021 11:57:39 -0800 (PST)
Message-ID: <2935dc19-5c93-43c9-a930-be6277c4a237@gmail.com>
Date:   Sun, 19 Dec 2021 11:57:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH net-next v2 08/13] dt-bindings: net: dsa: realtek-mdio:
 document new interface
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, alsi@bang-olufsen.dk, arinc.unal@arinc9.com
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-9-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211218081425.18722-9-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/18/2021 12:14 AM, Luiz Angelo Daros de Luca wrote:
> realtek-mdio is a new mdio driver for realtek switches that use
> mdio (instead of SMI) interface.
> 
> Reviewed-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

New bindings should be in YAML format, see:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/devicetree/bindings/net/dsa/qca8k.yaml

for examples. Thanks
-- 
Florian
