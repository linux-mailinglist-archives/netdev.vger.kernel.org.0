Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6980F20E624
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404031AbgF2Vop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727811AbgF2Shp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:37:45 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFC5C031415;
        Mon, 29 Jun 2020 10:19:56 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id k1so7359191pls.2;
        Mon, 29 Jun 2020 10:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jpuhbA135WXku8iFW2x2VvwuaDgLtebbBEPR7YXw648=;
        b=pyiSRomZfO/v5T2TO4PBu72bMxJtvlvYt9qn0So/n2vOJYsgca9/r25apCJ18O7EDf
         vMfcp3cOVV4rme9OvMqo4DoUTOCALh92vvYyuW/kq7eVEZkajTgshIYvr6szi5sOUp98
         fKrhTrRne6uAZt8ZSE1vZsLqQrJynXAP4nSJsO1UAdlErlGfFyohaWi2RuTHux7PGM4w
         iTuXu8hG5PMzmB+tz/SO5gSusxCCQHv/uC0RZk5Z39E9g9c9/58mKt8U15k5+y7S0MSk
         M0p9mDLrAq7H1AShxkuLAcd1zTKgsv4JK+vlwR4egy1rNiWkdYDLNysTunTFO091fvMJ
         eexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jpuhbA135WXku8iFW2x2VvwuaDgLtebbBEPR7YXw648=;
        b=em5G4BuCSDIaw0sZG0oC4/WKcOJ9WIdpVI9QF3zRS90wnsESiIY0OfL5naUbI860Co
         7bJ47vY96I7KK4JM7vo1Bt9N6P0v8ae6g6JK/vE2nejMcbjjtdoBPDbhxHeq9qOE2hPb
         vn3m43qNjYO2H0jLNtmrTlZ6Gt+O7JVMQZ9BmcTPPi3yZFxm1dXIqYjvqT8Gdq1zZDaf
         jqV0bpHPP0KHDZrVFDcLmPyZ0jbD9YP43jYIwploF6ybpxDAlxPTVHnEN/S79lL0tPNT
         IsRDj7fGbRJ+NpOxW3XNXXUApJxwQtlm7iecB1uwqXoWI6ydDIVUvJhdSXoEnuQaxOw7
         HGGw==
X-Gm-Message-State: AOAM532G6Z1EtzD8DV7ksPjQFKeDKU605i5luoefhacHf/xXoMC+RDKT
        yRScJ5Xqwz+SAHNsH/YxuKc=
X-Google-Smtp-Source: ABdhPJycUnUhTacxELkkzMTHqJCc1AEZ6djKxUQSXRPs+TD5RBzndAEK/awekMblZLe8/TYOxfN4dQ==
X-Received: by 2002:a17:90a:d48a:: with SMTP id s10mr1743434pju.116.1593451196167;
        Mon, 29 Jun 2020 10:19:56 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u128sm257548pfu.148.2020.06.29.10.19.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 10:19:55 -0700 (PDT)
Subject: Re: [PATCH v2 06/10] phy: mdio: add kerneldoc for
 __devm_mdiobus_register()
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
 <20200629120346.4382-7-brgl@bgdev.pl>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1ad2dbe6-ed87-4be0-f431-b5f223b9dd6c@gmail.com>
Date:   Mon, 29 Jun 2020 10:19:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200629120346.4382-7-brgl@bgdev.pl>
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
> This function is not documented. Add a short kerneldoc description.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
