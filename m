Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F6F46A34A
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 18:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245337AbhLFRqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 12:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245024AbhLFRp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 12:45:57 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B91CC0613F8;
        Mon,  6 Dec 2021 09:42:27 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so326954pjj.0;
        Mon, 06 Dec 2021 09:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8nQCp/z9eDYnVUffQDauJk3NwnYVgoTr+iBwZrAMECA=;
        b=HshJzRjEO1F5P5W3s4l8EHwdNEBpyn/6SDmBuVfXfdj+8vg4k3Xk4Kw6+JtCWVtxtm
         wBnjwJW+ny7OZXBUOgh0/+dY0J9UAGzhhNZQ8FV5gRzT4WQGAa7S2rXPt2CTAmK9730G
         1QKnkHrqC/BVLCTgp7POvx0wkzEEYOpp7UnyH/DT1VB7nf4JrTPfmbTdHJFyAlQ3F5bY
         jYhj3W8/1/rHvr2pFTkRP+blTAaCqMZpjTb9X+qYWMGQULlpPAAN/VVbdQBrBAuV7ViJ
         i0q2h1o243aUvIUVQkzu5rn0REIoZ5YSMHVsABk32KZRQ/zufyLrKUplSPkheLudzfXQ
         OUdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8nQCp/z9eDYnVUffQDauJk3NwnYVgoTr+iBwZrAMECA=;
        b=fShjdr5N6PfvIHNUMgGTpZzdPcodQmWFNVbZq9r1ng44oIH30iXvMfU7bzgQ7XwOwg
         nCs5uABfAKMOSgmW/PeJhURUr0Kgv562NckavOxoxm4FXS+LXiDdz/TSUaazhzEmtX5L
         AecWo3rMG1vVyWUNIYwbii51kc3htbnnpsZA9eThuZE8MQDSxI99uW5elxkbU6wvH/LV
         bR5DU4Yo/uDEMQvmu7q4DLlY42rfeaRZLsbzlXqhCRLJQoW4DG6GDzJr0qC02pMG+IDk
         9v8LluXiaFPLFasVAv5cajP1CKltNiiEIddIRAFWuhNDKeostDTskzmia2PC1c5lL/Bn
         x/jQ==
X-Gm-Message-State: AOAM532E1BTakc6ME5GY5xDP+UlxdgEkTKCA6YFpUYAzQ4lMHYT1rGup
        wtOLPfjbtw/3YUSKbDG7c+3TGV0RvgE=
X-Google-Smtp-Source: ABdhPJxyVcV0LVUgIsV3Sh/y9Q6cBheraRYgIB3WupUdsgSHhQbs4CZi9+kFf67RGzVsykM+i8Tg9A==
X-Received: by 2002:a17:90b:1b4d:: with SMTP id nv13mr39770356pjb.234.1638812546646;
        Mon, 06 Dec 2021 09:42:26 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q10sm310413pjd.0.2021.12.06.09.42.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 09:42:26 -0800 (PST)
Subject: Re: [PATCH] dt-bindings: net: mdio: Allow any child node name
To:     Rob Herring <robh@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     devicetree@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211206174139.2296497-1-robh@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dc9160a4-d52c-4358-423f-02fc96559acc@gmail.com>
Date:   Mon, 6 Dec 2021 09:42:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211206174139.2296497-1-robh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/21 9:41 AM, Rob Herring wrote:
> An MDIO bus can have devices other than ethernet PHYs on it, so it
> should allow for any node name rather than just 'ethernet-phy'.
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks!
-- 
Florian
