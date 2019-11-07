Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6243BF36BF
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 19:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbfKGSPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 13:15:19 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:42449 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfKGSPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 13:15:19 -0500
Received: by mail-ed1-f67.google.com with SMTP id m13so2678733edv.9
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 10:15:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kBVeDR02xbQRHJHZTmTGfGitVy7r4AKyMmNPiVITj9s=;
        b=JgDEdzln33n0vbNA95Ee0Ltavwf6vjTPDw6Is0U9Wyi0Xwapvjb0oGiv7ra/3mDxKt
         xcFcMCpUkCsMQqykE5m9cWBCxPz2ywA8eHTA+fJXuxE9BWk6YAvaTmFilTPn2vxYq7wQ
         Eh8NP9rKCKCpkyoSNZJETjXCTAR5/so/8EVPntyOyIcq+PqScJxdm/DxE+3Oxu/95KkH
         rimHeWQPeogMHGB/UVL96X+n9xsKQTMYS2Nb5ZRwKM5DaUNhry+4Xja1rNi45Q9CJwXm
         CmAfOMEaOnajPYwpt5/vsFqmPORO+o6yNnXZHKsQL3CVEJNmfhavCznDBJd9X+7Ys8W1
         hiCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kBVeDR02xbQRHJHZTmTGfGitVy7r4AKyMmNPiVITj9s=;
        b=jKiocTkboDPI2bCNrhPPopUVIv06wiTwk3g8PbLuLcvmDvDI8EWOgQ+Su2aDsJTWuH
         Gq4COt4socHCDAEEMfOa3wFeYMV5A2gYP5pYIu+aupFaZnOSxMy+pW3sJvCtgvlId91t
         sztlEiPdtB358+tcF0r5+1CQkEHl3EWr0nIszG2PGxIyeK8igQMR53jheBA8Fo8opUQM
         ltFZjeH03ulFQw02peNcMck1ylUSwHzdGIIh53dFsX+awmfVpqF9EEdZ1IqtZErbETZf
         OWaZ/YIOuqcn0BwWg251athwmYUkF4sZHFL4HNF7PON2+g/KKj64aefFRHtNJc4/rpME
         OaLA==
X-Gm-Message-State: APjAAAVh3d42S6v7K8QBo216von8g9MsJ6xv6Dt4aIVPkohZg3NmLMT4
        Qo4Tv8oIdJX44danZh7jo08=
X-Google-Smtp-Source: APXvYqzd6EJQpOwWaZBkOq8wNjd+3d1fZvGxAWuinwC6yB82+s1q7WjOlVBhICT1crxXoxJT9MOVTg==
X-Received: by 2002:a50:cb86:: with SMTP id k6mr5247249edi.270.1573150516949;
        Thu, 07 Nov 2019 10:15:16 -0800 (PST)
Received: from [10.67.50.53] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a102sm77412edf.46.2019.11.07.10.15.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Nov 2019 10:15:16 -0800 (PST)
Subject: Re: [PATCH net-next] net: phy: at803x: add missing dependency on
 CONFIG_REGULATOR
To:     madalin.bucur@nxp.com, davem@davemloft.net, netdev@vger.kernel.org
Cc:     hkallweit1@gmail.com, andrew@lunn.ch
References: <1573131824-21664-1-git-send-email-madalin.bucur@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <6a297041-2750-eba4-c172-c63c605103ee@gmail.com>
Date:   Thu, 7 Nov 2019 10:15:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1573131824-21664-1-git-send-email-madalin.bucur@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/19 5:03 AM, Madalin Bucur wrote:
> Compilation fails on PPC targets as CONFIG_REGULATOR is not set and
> drivers/regulator/devres.c is not compiled in while functions exported
> there are used by drivers/net/phy/at803x.c. Here's the error log:
> 
>   LD      .tmp_vmlinux1
> drivers/net/phy/at803x.o: In function `at803x_rgmii_reg_set_voltage_sel':
> drivers/net/phy/at803x.c:294: undefined reference to `.rdev_get_drvdata'
> drivers/net/phy/at803x.o: In function `at803x_rgmii_reg_get_voltage_sel':
> drivers/net/phy/at803x.c:306: undefined reference to `.rdev_get_drvdata'
> drivers/net/phy/at803x.o: In function `at8031_register_regulators':
> drivers/net/phy/at803x.c:359: undefined reference to `.devm_regulator_register'
> drivers/net/phy/at803x.c:365: undefined reference to `.devm_regulator_register'
> drivers/net/phy/at803x.o:(.data.rel+0x0): undefined reference to `regulator_list_voltage_table'
> linux/Makefile:1074: recipe for target 'vmlinux' failed
> make[1]: *** [vmlinux] Error 1
> 
> Fixes: 2f664823a470 ("net: phy: at803x: add device tree binding")
> Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Humm, I was actually wondering if we were guaranteed to have stubs
provided, that seems to answer my question.
-- 
Florian
