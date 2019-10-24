Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3EBBE285A
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 04:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437145AbfJXCi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 22:38:29 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:35075 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408271AbfJXCi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 22:38:28 -0400
Received: by mail-pg1-f177.google.com with SMTP id c8so8473586pgb.2;
        Wed, 23 Oct 2019 19:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W2bu4Fn4RFMDHBW7iO6wGU9vGj8pXizaxUdy9yOfeFA=;
        b=um4wf+yg7+jsMVP4cjwA3Zfy28R8EO1QwRWS+hVi+t/vX04KSy6nbLKMfXUl1BW9dF
         J+44fl43OP5jOt9aU5i5uKtRwucpw9uMmNE1eDnz7AHQ0JgTfyHvLHicGhIh/Ss+jpBk
         xMDDXp+EIshBWvMLnNMkXiLbN1QJ4VsRyVrAGT0Vmq98NNGLAUfmlD8qaNY2FEfKxuwb
         Y9YYKtB9MxAlsPqWWyG1QS74WsBH3loXzd4tHahgq30gn4zdf8Bj7he/Mlj8qkJLitKP
         KlgaNjF4QD06mi+QjFBTMw2C+Q/KHqJ/1POZ57JMFzJgqz6rexXDeE9qcA0S8Tltq51m
         czTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W2bu4Fn4RFMDHBW7iO6wGU9vGj8pXizaxUdy9yOfeFA=;
        b=U62/IHxa27i7BTA7uwrH35WJqFJd86Pk9OidG6lE35dtcINuzGHnuUtFo48DEqMohh
         NTv3grGFdDSzi2H1ViGI/uDVH0V43gqsbpiiYcJKRr78rHaZPzncxKjKIHPTSRkq/ZTR
         pNXWo0lprcoJuMOYvrO2KuUO4Amj+XIQKtrOsJ3w8MUIxDRWVK8gOAEV11lP5/1WU0/S
         mJ9SEKj0orojX4szqksUA1PYXZjXByqJ9bPN4y8U4WagZXN89jqOkR1Q607+GSjtrslg
         aVUwziULLqYK38j3+hYPI04bTKhJs96hFNwdLk+AR983R8QvyZJ0+9+VmBDOWI85Ydfs
         5RKg==
X-Gm-Message-State: APjAAAWEY4Inz8wwvsT+MVn7mv+CcI/kp8t9S2vOXl1KW5SYluBdWCKs
        7oXN1evul/WGt/uZ/l0eEV/u2aRc
X-Google-Smtp-Source: APXvYqwpZfo9jbuJvTTb+ojy/PC0AD/69emJEj3c91Wu6Lu8qwG6Poqwg4+bOA474CbB6fm8wQN8KQ==
X-Received: by 2002:a63:9302:: with SMTP id b2mr11044609pge.342.1571884706330;
        Wed, 23 Oct 2019 19:38:26 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id q6sm26836314pgn.44.2019.10.23.19.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Oct 2019 19:38:25 -0700 (PDT)
Subject: Re: [PATCH 1/2] net: phy: dp83867: enable robust auto-mdix
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org
References: <20191023144846.1381-1-grygorii.strashko@ti.com>
 <20191023144846.1381-2-grygorii.strashko@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ffe518b4-4a71-35db-bd30-b1d325fa179f@gmail.com>
Date:   Wed, 23 Oct 2019 19:38:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191023144846.1381-2-grygorii.strashko@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/23/2019 7:48 AM, Grygorii Strashko wrote:
> The link detection timeouts can be observed (or link might not be detected
> at all) when dp83867 PHY is configured in manual mode (speed/duplexity).

s/duplexity/duplex/

> 
> CFG3[9] Robust Auto-MDIX option allows significantly improve link detection

allows to

> in case dp83867 is configured in manual mode and reduce link detection
> time.
> As per DM: "If link partners are configured to operational modes that are
> not supported by normal Auto MDI/MDIX mode (like Auto-Neg versus Force
> 100Base-TX or Force 100Base-TX versus Force 100Base-TX), this Robust Auto
> MDI/MDIX mode allows MDI/MDIX resolution and prevents deadlock."
> 
> Hence, enable this option by default as there are no known reasons
> not to do so.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
