Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F196328163C
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388169AbgJBPMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388115AbgJBPMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:12:46 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5896BC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 08:12:46 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id i3so955165pjz.4
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 08:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KU2TXmniz6eR9CV8+BbmLYaoHAM/2tXnU09sInjdDXo=;
        b=gmpCaEIUZ6HYsHP9emGBLA0V6VhDYw77VeeNdGLXdHg9ysMjFHf5fQplo0+4LeZ/BK
         ee0CNxnSivbRNQC45wAIjvbs3yM7tqxEqwyK1eNcf+Z6bQ7LsbLcEvGODTrX+xj9Ongw
         BlTRpMu6EirGF7QnDaTOV0XN2UyPmeBpAwUPZaF/we9Pry+2EN9mlaw5dZx6lEXKPAGE
         pW+98NFiDS3qJ+H77c/QvoNokmJaPJw52U8WaMjwdDMbD0yRwE6ZLpujt+pUqfDZQOMs
         F52ovSS3665KcLHv+A6tuViakDtSN9zwJsoTU91dQY0UFhsyLyPTfwGpDGxWIS7gq57L
         y7fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KU2TXmniz6eR9CV8+BbmLYaoHAM/2tXnU09sInjdDXo=;
        b=DiIEW2Wo8lEIT9qVNDznV0kqfFcYa/3PK5JuLEF3WCzBdwhXnJOD2sbcWHg5S4xkX4
         TqOoxmYORke0c2NvgzprDHPzxib5ulLYWdhOGTTtLeBS2FZntKBv1v9EeDAlhfOUEYBv
         lJfMdGugWkUm8CFugH/UAWQ4dd+6diGHrTInqRFNv+uPJeUye8xLQhvw6sqxLM2aHH9q
         Eocs1WDhogCMGTdvdg0+AVDkDBm8b5t2RpD8nsNvMpRRiOTYOwS2DN/2TE7BoFaM36dY
         OVw0/J+QXiHeZh/B5GfJ517O6zZBIyXhJHYkdufkezqGqUiO05JF3WynD3eLwQbNLEYh
         Zzqw==
X-Gm-Message-State: AOAM532iZFBHGfSswWsMQfKLHbuVD13aBkFPNP5yJkoF2HcBnqr60w5h
        237feR/UrX6jFUpR7r2yqeOSqlV+Rnr01g==
X-Google-Smtp-Source: ABdhPJxT3N0FiBx/TsoZ9Qala4XK7bpxQ3ZY8SSmEYFYdOtfrOTxDcKCn7BKi7fYbLnXPBQr6B54ig==
X-Received: by 2002:a17:90b:4b82:: with SMTP id lr2mr3273290pjb.184.1601651562781;
        Fri, 02 Oct 2020 08:12:42 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id p11sm1852338pjz.44.2020.10.02.08.12.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 08:12:37 -0700 (PDT)
Subject: Re: [PATCH net-next] dt-bindings: net: dsa: b53: Add missing reg
 property to example
To:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org
References: <20201002062051.8551-1-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8d1e1eed-6cc2-3a83-8f7e-71ec63ebe9fd@gmail.com>
Date:   Fri, 2 Oct 2020 08:12:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201002062051.8551-1-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/1/2020 11:20 PM, Kurt Kanzenbach wrote:
> The switch has a certain MDIO address and this needs to be specified using the
> reg property. Add it to the example.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>   Documentation/devicetree/bindings/net/dsa/b53.txt | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/b53.txt b/Documentation/devicetree/bindings/net/dsa/b53.txt
> index cfd1afdc6e94..80437b2fc935 100644
> --- a/Documentation/devicetree/bindings/net/dsa/b53.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/b53.txt
> @@ -106,6 +106,7 @@ Ethernet switch connected via MDIO to the host, CPU port wired to eth0:
>   
>   		switch0: ethernet-switch@30 {

This should actually be 1e because the unit address is supposed to be in 
hexadecimal.

>   			compatible = "brcm,bcm53125";
> +			reg = <30>;

however this one is correct, if you want to resend with the unit address 
fixed that would be fine, if not:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
