Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1639B648B8C
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 01:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiLJAIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 19:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLJAID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 19:08:03 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8E02FBE0
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 16:08:02 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id i12so4164525qvs.2
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 16:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JGohJnbmLGZZUdmCKr1mOIe3CVpGMmtFLNYoDwB+tKA=;
        b=D+sRxG4yq+fCE+2JSNCD/SPbd8ZLaemIezhvhsINHKhI+W5RHssxRuhdx/K/aB9VZk
         NYYcHNsNu+fL4ZcF33kZg/qJs4K94QE9gd2LwSwNHQAq7z4JbNqD5jL7CFz0HCbVsn64
         2atXDV9KZ3tjhPPM9hBMdJt+oUiGSfTCxpSwumLhrcIqbRFCUxyKtMRMXEQmr+PFv1wt
         rhBPcaIVdejpV4MKxZt8x6nKYipbeQGJWiEdPPnX02fRAbRlYJjXpR0vmbDMj6t0QXBJ
         FLNrZivbMN3z2PUTeCbVhdFGkjLpgXva30p+GpHlkQrJTMbQD3XrsFpOLKuAnhRCFmgv
         2JZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JGohJnbmLGZZUdmCKr1mOIe3CVpGMmtFLNYoDwB+tKA=;
        b=QKXfFI1duTU8pmpYaj9uU/Vbb8Ymqox00VpdWBQt+Z5bCN8O5a5i2xtMN7JiSRSIEt
         ds97qkwi+UzY0oPm1XYl8OJ2oHTNoUmMIkIHybYjQGH65w+ba6oQopvmZSr7lZLmTDDK
         kdlLsorT2+7e/lD+4ZQhpe+k+gTNKuNYX2aYKusB6A4eSOynntfB/xiuD0K2dzE+8t4i
         x7d4Q2ilF/w/MqlLnQnQLTKv0DgY7YnWa36FcoHki2Mekaw1/nm5O7uG3BToyvbkDj64
         u+HU4zTYMvxswoOfVRJXKZ21utZ5my8Z6Ru3WPHanJ+fMZPRjQ6IuBETud3ecVNkuu2s
         j3Ug==
X-Gm-Message-State: ANoB5pludoZRGsZpVCyZ1+1jdH+w5PuAOHQ2q3J+Tcy35/GL5gxVlyuC
        nz3qgZSt6r62vUujQ6DputA=
X-Google-Smtp-Source: AA0mqf7IVKhTQqu+gtAkV1Hvc7xUT3+Qv4lsMbOqQujGrp3VIiyL+jIdA4o+cjSZKzxMT6PtX4DAfw==
X-Received: by 2002:a05:6214:1c1:b0:4b4:a3d6:7c16 with SMTP id c1-20020a05621401c100b004b4a3d67c16mr10552625qvt.46.1670630881789;
        Fri, 09 Dec 2022 16:08:01 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h19-20020a05620a245300b006cebda00630sm993803qkn.60.2022.12.09.16.07.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 16:08:01 -0800 (PST)
Message-ID: <f077e15a-c924-fb4f-8fa1-229bad67c2ae@gmail.com>
Date:   Fri, 9 Dec 2022 16:07:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 net-next 4/4] net: dsa: mv88e6xxx: replace VTU
 violation prints with trace points
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Saeed Mahameed <saeed@kernel.org>
References: <20221209172817.371434-1-vladimir.oltean@nxp.com>
 <20221209172817.371434-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221209172817.371434-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/22 09:28, Vladimir Oltean wrote:
> It is possible to trigger these VTU violation messages very easily,
> it's only necessary to send packets with an unknown VLAN ID to a port
> that belongs to a VLAN-aware bridge.
> 
> Do a similar thing as for ATU violation messages, and hide them in the
> kernel's trace buffer.
> 
> New usage model:
> 
> $ trace-cmd list | grep mv88e6xxx
> mv88e6xxx
> mv88e6xxx:mv88e6xxx_vtu_miss_violation
> mv88e6xxx:mv88e6xxx_vtu_member_violation
> $ trace-cmd report
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

