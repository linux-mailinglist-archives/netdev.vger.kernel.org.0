Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1C923ABC6
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 19:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgHCRlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 13:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgHCRln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 13:41:43 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE87C06174A;
        Mon,  3 Aug 2020 10:41:43 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id e4so344119pjd.0;
        Mon, 03 Aug 2020 10:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ITdLnDICTMXLD69TXhj+jeJHGfxEvBcozE7CtADBcX8=;
        b=NJmlgUcjeZU/TIrRhV03rLWSzzOEII/yKkk7LwDEjrDhOsSwTXZpt5Ojr/tkHFx1hD
         THxLDbP9F10pwKIckCtMVZJfEq5W/cK7FWz3L+5FNzmIPANbCGsmrsihOU2n18ULaePM
         yPgv8hfazlsyPByNtBwLEYxzZevCT9pr5X1GFtvrjDHJjiR7f+IpQ4FuX2MEVsOWD+gY
         QY4Fc6mbV7ldbwMuqpCo/ioUor+IBSNnyn53xfM/kum3tmC1v5ANjpsstarXkXpWv/z2
         VYPXHFhsWgLMqikJzi/Pnorc6ku4V4Qf/HFJDa5vfhQhfd8E7ebWrNGrtJFW+eOhSd9a
         qZXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ITdLnDICTMXLD69TXhj+jeJHGfxEvBcozE7CtADBcX8=;
        b=kZBH7UBlbzScwjNiQnchf2jc0iHRir4tGVoK6NDOgRUmHwTJxxzSzDPkka5YlJVdI/
         wS0sDTUDurGEyRDFD/hbrTFY7BdB11he/bHtmvxuXFUFWhhZ2434GWhaKznB7pcsU0hi
         +0VS1AJK2pbKWqPOzPbuCMywwY2N/F8n29G1avRdgLEhvooLOcYlkMek7lbO0hAVRfNH
         dzXMHscsFTv0C3nL1ZWZKVNBXpeNeA2nMv+HaQFRd5Eo+UK8T5zbf6atYCmMyz7tWCcI
         7BVDkWH5dmNJ6z1yFtHLPxDTGSPmJRwtLR1Y0CeXAYZBOFW3Iz1yVTzWw0n8Yle5MbOm
         dfPQ==
X-Gm-Message-State: AOAM530NKlNBsXZ32hisjUzDG571TnkhE35qH+xD0AJlY9mRvRiWqOkY
        mQLEnW9YF1IZrx34etYQkGgIXE9K
X-Google-Smtp-Source: ABdhPJy1hSl+0vhbsItK151t+5JgI4JzUeDP0ECJib1D1rIFVoFLTr4/ThRt76C7BcrA7rc9NkUDoA==
X-Received: by 2002:a17:902:ff13:: with SMTP id f19mr16067564plj.326.1596476503272;
        Mon, 03 Aug 2020 10:41:43 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w16sm130929pjd.50.2020.08.03.10.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 10:41:42 -0700 (PDT)
Subject: Re: [PATCH v4 11/11] dt-bindings: net: dsa: document additional
 Microchip KSZ8863/8873 switch
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel@pengutronix.de,
        devicetree@vger.kernel.org, Rob Herring <robh@kernel.org>
References: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
 <20200803054442.20089-12-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d35c9a72-035d-fcc2-b0ce-a986ce55b78f@gmail.com>
Date:   Mon, 3 Aug 2020 10:41:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200803054442.20089-12-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/2020 10:44 PM, Michael Grzeschik wrote:
> It is a 3-Port 10/100 Ethernet Switch. One CPU-Port and two
> Switch-Ports.
> 
> Cc: devicetree@vger.kernel.org
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Acked-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
