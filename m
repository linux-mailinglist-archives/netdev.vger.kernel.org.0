Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16A5660979
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbfGEPkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:40:13 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38346 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfGEPkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:40:13 -0400
Received: by mail-ot1-f67.google.com with SMTP id d17so9464037oth.5
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 08:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cfLYtjwRbGgqjqtX3p+LYkrrzJv5p7DHvqJfsU6lt7M=;
        b=INe+sVQHor530EAfdd+dVo5M40MvmgbCeLv6Af8JueUpeCzZ8CsQvZaQyBTwCX7TN5
         WiSc7/74VMtvkUsZ3eEFKreqFEOE5ocxJCL7SMzPbSWi5cH7Qmhaqld6vFb2iR0Tbzvz
         L8tJliCuvw7Y+qvaJArOJktxp9BtFql+hx5zUbJ0g5wpoxOOn/KqX0DrgruQQdm3ypdx
         iAeOzYBrVRFGhBtoHMhWSeTCPCGBPgMWKw1qXDPOI0jY9jrd4QBE/WnyiOmfW71X5MJb
         QNO2dJFK3nUmTpIDkr36lr+71MUXhH4SzCwI6BVM1indKgAAdlT5IPDz2MQycAhw+osq
         kYyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cfLYtjwRbGgqjqtX3p+LYkrrzJv5p7DHvqJfsU6lt7M=;
        b=otfn2SYuO3QjFzJbUosFaRBnbugk7lLlgmi8vTVThEM7AbJGbuRbVRlTLwyv0CK5l4
         pC9VWj3KVjA3vgQfWDYoFh40fkk5WK12gC9U6jEWxbIeDeIZRDdE1bHs/6+HsJJQFDJw
         D7H9LoQ6iLnvKom3TkgwRUs6uvQ1XisYM4PouGpau/OhFP0GEZPt+cBhSj2umJd4x6xZ
         dW9y2FShwaXyDFZW8SLyiGj6kd4pvPHr8HKr+nTUlmCe3DngRbbW91l9LpKbwxSP+juX
         kBNOGT/9PM11dA9poRQitNjmwyxo0fBZqcIoRqoM2CtQMsnv8p9uNHkGYwxE6Wh0Humz
         1GSA==
X-Gm-Message-State: APjAAAXAroTK15lVvgGqVwObq5ZywcT51pEoPTKJrCZHoyRtN9rQTfsz
        J048YoMW2PthNsHvO+p+Xy4=
X-Google-Smtp-Source: APXvYqxxQFJuwyDc1CMiClliGZYnBMX/rlHIGosKrET7HO3pTWbvpr+Al82RvC3y/8Apt8cwUNOwqw==
X-Received: by 2002:a9d:7847:: with SMTP id c7mr3521731otm.290.1562341212407;
        Fri, 05 Jul 2019 08:40:12 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id d62sm3100049oia.28.2019.07.05.08.40.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 08:40:11 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] Documentation: net: dsa: Describe DSA switch
 configuration
To:     Benedikt Spranger <b.spranger@linutronix.de>
Cc:     netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20190705095719.24095-1-b.spranger@linutronix.de>
 <20190705095719.24095-2-b.spranger@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <70dfaaf3-a5fd-6fb8-31c9-a37ecb6ac32d@gmail.com>
Date:   Fri, 5 Jul 2019 08:40:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190705095719.24095-2-b.spranger@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2019 2:57 AM, Benedikt Spranger wrote:
> Document DSA tagged and VLAN based switch configuration by showcases.
> 
> Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
