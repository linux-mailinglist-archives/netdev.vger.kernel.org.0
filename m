Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEFAE55E24
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 04:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbfFZCQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 22:16:20 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45143 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfFZCQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 22:16:20 -0400
Received: by mail-io1-f67.google.com with SMTP id e3so1501695ioc.12
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 19:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M+P3QL9dr5sDDWm8Xit2HhAkTYxAdcAwoXbzH8Z7Tsw=;
        b=a6oOogl1/taJJhrkDcTermHO7plHHJLxAXAdZBxCvNKJ2jPFWJZMhZQZ6IJhQ5SNJy
         vVKuOZHhbJNWMoumOl/05mzoTw8neHlFB/cwk6vTJ7imLBurSFbd91muxLS+BAxdqzGs
         WaVsoNKj5tyA986c8zdQb20dKbUCS9tSk4kgBO33EGrl/yrYT3VyISVpDqQ/t6iydRTT
         wsTT5OMixbtlBPjKM9JTGr1cRXPApEAz1/3kZY8J0q0pYvVAQ4v6i8zo3YagpQS1zdky
         3m2IFiSwTcRrr7k5FerhCyMANwlZdNQrfp4gKD0tOEu+ZzmUvfV5sPrrNHms75mrAatR
         UVqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M+P3QL9dr5sDDWm8Xit2HhAkTYxAdcAwoXbzH8Z7Tsw=;
        b=X7V+y8DsFRN3HXShe8RFQji/W/qgLOb14MZOYID9yGyEq3PJ6TCt+44NCQth+gKu3t
         gj2bwzS3IJfQrSk794FUpOG1+mt/gneEqITJtrG506fUZxz/DEa9GUiANBV44kSnEfwf
         MKEkqvq6/iBBaprcwqGd554ET9D/R/rUl8voqLTypTHYfTNf1aEYc4oHYncTpX7YyD6O
         3KxTED9/gwT9GLwoheFWkyDQNEITTEr9YpzjuqroPRN+tBAtYTfbqNzzfTFotSHrsV4o
         ZvjroDv7eTGW2X1AFI+Mk+Hfa9KbBEBdM8CMdF4pTwRkBnEjlbDf45mUQyVEkmU7yF/e
         0VRg==
X-Gm-Message-State: APjAAAU5coQ4FTZUDfsFy0N7lc/1LEodBJ+1SPXR0wasPQ8hsPSLg+bu
        9NCB18FIrLFU0gypoTRI+d7Ekrmk
X-Google-Smtp-Source: APXvYqw5nDBKDZ/pNG8sn0lc8bpjVxEnhvybvlKDb2LxsENNp3YHT15URPwPLOg+cTDeknTPD4hMEA==
X-Received: by 2002:a5e:db02:: with SMTP id q2mr2030403iop.306.1561515379087;
        Tue, 25 Jun 2019 19:16:19 -0700 (PDT)
Received: from [10.230.27.93] ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id q15sm13892618ioi.15.2019.06.25.19.16.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 19:16:18 -0700 (PDT)
Subject: Re: [PATCH] net: phylink: further documentation clarifications
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <E1hfi09-0007Zs-Vb@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <fbe9d348-76c6-6cde-457c-1e90080d9774@gmail.com>
Date:   Tue, 25 Jun 2019 19:16:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <E1hfi09-0007Zs-Vb@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/2019 2:44 AM, Russell King wrote:
> Clarify the validate() behaviour in a few cases which weren't mentioned
> in the documentation, but which are necessary for users to get the
> correct behaviour.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
