Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F2C1FFDC2
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731702AbgFRWMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727827AbgFRWMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:12:34 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9018C06174E;
        Thu, 18 Jun 2020 15:12:33 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id t18so7728274wru.6;
        Thu, 18 Jun 2020 15:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=POBgBl3MI/dA6mNJ5+hGlqrhujuUmmxFrJ0pjJyUNc8=;
        b=UaC02oShpxtI/MNfXzOqezN5e2CQ6fHyVgspS3Qf6YhYFCaq3LEhRQ+l2MfPPlnO1p
         bvxQzuJgfDsAPSt4CRMaWsNHSdAqUc4EBV9Wy6eygFu68NNNGaE35eDA+U+EqIsvltl1
         iUy5ALjPu6x9FrY1K9obF4jW55in+nio1robfbEM2zb7AAnczyLBp2bD5XBmUMZFmpvi
         NOsfeBFemydvFxA7pMkHJI+5MS6HqxALBiD/vYUTgckQwMy4JQxUZ2qgFGG8wo/gbx/+
         +o83wVSYbJHpQ/i8H7ER2YDYBp4Z0UBxzh2soQkz5eaZ+gS7oegrDmjsKd0xHWQOOn85
         jpag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=POBgBl3MI/dA6mNJ5+hGlqrhujuUmmxFrJ0pjJyUNc8=;
        b=qhkezecl1sWGt3JatMgmx6kci/uajdY8vYpxMkoUvyF2iHt8qpEXLtWSfqAElVTrZT
         /t4vfBgITaf3EqNzLyLBRkHkLgazn+CU3DUU4lAgZD21BaaWUuRbE0eQsFim8/cwJ7t/
         QPfQzUYYJPSB9IXmUI7SQBPrnWhOglpmTi8HuCKw5YB02xN7zitsEv6ifzSj+zy1qPVd
         13gJtZQbNA3NVdLzVtID1iyM8pYiImy040PNweEdgTV17FnVlFHiXRZ/Lg1BhWf6wYXY
         SXArhD5vB1d83zqh8BRX6Wg+4mkhGKJiKQXKWlwyCX5HjqO9hiJ7VIqtDqxt1CuPot30
         St+g==
X-Gm-Message-State: AOAM531LhMXwhdQWses0zKMmwdgUTf1cspIBovpTN7Aswitotqrvje6d
        e95xWUFvopj6ZCL4fHsQlpU=
X-Google-Smtp-Source: ABdhPJx8hy6wOubeqxfTx/fn/AnNUMOEzQ6xLh5Mglw12uW4b0wv42gO0zYOEw+mTUgB1GWSiSN/Ig==
X-Received: by 2002:a5d:4009:: with SMTP id n9mr575240wrp.97.1592518352590;
        Thu, 18 Jun 2020 15:12:32 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id e25sm5677317wrc.69.2020.06.18.15.12.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 15:12:31 -0700 (PDT)
Subject: Re: [PATCH net-next] of: mdio: preserve phy dev_flags in
 of_phy_connect()
To:     rentao.bupt@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org, taoren@fb.com
References: <20200618220444.5064-1-rentao.bupt@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f57e5c7f-88f0-d033-6f63-ab53addf9e20@gmail.com>
Date:   Thu, 18 Jun 2020 15:12:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200618220444.5064-1-rentao.bupt@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/2020 3:04 PM, rentao.bupt@gmail.com wrote:
> From: Tao Ren <rentao.bupt@gmail.com>
> 
> Replace assignment "=" with OR "|=" for "phy->dev_flags" so "dev_flags"
> configured in phy probe() function can be preserved.
> 
> The idea is similar to commit e7312efbd5de ("net: phy: modify assignment
> to OR for dev_flags in phy_attach_direct").
> 
> Signed-off-by: Tao Ren <rentao.bupt@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
