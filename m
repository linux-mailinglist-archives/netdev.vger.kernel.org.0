Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AE220D6C7
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732340AbgF2TXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729822AbgF2TWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:22:42 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C758C030F3C;
        Mon, 29 Jun 2020 09:57:30 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id o8so16058038wmh.4;
        Mon, 29 Jun 2020 09:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3obcgdSNJ950EKSMUHcl2JGdbtcQqgCIBNGkW8RhMSo=;
        b=fv7aRCqCGXOKYruNDHJqiZ3Y0d/rBS5koxd/2S/q9TNDUy5El4Px3n27rId0ZeYuO/
         eK9wvTAHTmocgawJdsMzG6VQQgRFqO5aiVRAcbPGfYRllVKg7BrR0UxDm0CpFfUDV22m
         J3QJ/sdOwdfKZfkLpeRRSX1fYIgCpVTUD0eV8ROx6Q2wdDjMhQeRxF+qhMImmTGBOZz8
         RE66N5JFiDq+5v7S4S714LzndpGglVhOwfGk4kCyZ1xxyq9QVCrVlggU3aCBCc0YXMhh
         VwQUqnReTgiNdQKzT4nz2JPE+HgLY1g5BtRZHZmkESQhR8uCHiMd2bBM4FHcKrl/1Ymq
         25Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3obcgdSNJ950EKSMUHcl2JGdbtcQqgCIBNGkW8RhMSo=;
        b=r6txf0Xh64JtveaLIxrvUm8AqFvYW/cI6Wci8xxOXUlLQf4oIwn/CiB6NkACo/42V0
         63A0sP0feSkofVClBiltOuWIBE3/FiJ/T/T7vgcPdJkBW+zh0I5+muHQqlVr0AxzNzkz
         CE6/zj0WB0JyKpGV/IXuQ+Aa43K2CaFe+h7gPMBRr/ctvVJ+kqK3aIC1yKBSAZxo9OHu
         BMshOwIkTsYu2+HRclA/8dSI2ys04OHqqkLZuZBmdUnV/lELalDs4a8ADwftHHhYZgh+
         YkOjKLmiLZxwMUn/Pi4QhebTbu9cha058JA8q2NTWP6F3jx4zAkDnvrDLh/aVVjTSphh
         iMOQ==
X-Gm-Message-State: AOAM5300GKcoZ/t92ZYrCJdcwlcoQ1Qd244lENKJLg71ylplTiH4H7pR
        pK1mswAzj0kjH/0lB1hKPI4=
X-Google-Smtp-Source: ABdhPJyWcHGoq56ob7aInZfnE9bycxIPoA/yOToZHS7KefRXyZmz6cGV8GPTRBK/aIqAGXteb4DbUg==
X-Received: by 2002:a1c:7e52:: with SMTP id z79mr18277828wmc.104.1593449849236;
        Mon, 29 Jun 2020 09:57:29 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f13sm390904wmb.33.2020.06.29.09.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 09:57:28 -0700 (PDT)
Subject: Re: [PATCH v2 04/10] Documentation: devres: add missing mdio helper
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
References: <20200629120346.4382-1-brgl@bgdev.pl>
 <20200629120346.4382-5-brgl@bgdev.pl>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3cd5bb70-ef56-c0e4-9c1a-6663434d8b30@gmail.com>
Date:   Mon, 29 Jun 2020 09:57:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200629120346.4382-5-brgl@bgdev.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/29/2020 5:03 AM, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> We have a devres variant of mdiobus_register() but it's not listed in
> devres.rst. Add it under other mdio devm functions.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
