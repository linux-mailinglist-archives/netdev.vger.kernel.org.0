Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F306E1CEB4D
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgELDWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728110AbgELDWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:22:39 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4EBC061A0C;
        Mon, 11 May 2020 20:22:39 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id x1so9757823ejd.8;
        Mon, 11 May 2020 20:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+I5bD1yix5nOpkDYlSZn3YsZEj/xyoY2apRjbwCXpSU=;
        b=AQO3TYB9nGd4W2vEAR8wMmH+3tVslRv89BxRRV7kp66LDtn8hMvfasW1mQj4pwWjXb
         IbS8OZ5uhTNEJQA88+trLh1PSGrgxs2oiWh93Teoi3nnJqZsZjkanhbZApQyuBtSYZPk
         Fuu39oTW41v0KWwQkBy/1jEJ7hvFGbVKQDstGsX4KsYxcssUZvKIFefJ3w8OQbYeKB8c
         ORSFad+buiZqEql+fHcEKOE54/hKrHh20omHabgRBGRdbXjwyr+LbGafPZP1mhKCqg0H
         Zsd5g8ITq2EeJKElRZ+gbrt1pp9chOa+hBGApNhI4p7KRbSXwPLACKIsanwGGPVAdAaV
         a0jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+I5bD1yix5nOpkDYlSZn3YsZEj/xyoY2apRjbwCXpSU=;
        b=q0dk0c5+MJwQ+1sRkX9gHLnxUkuw4ZsXhpLrNZNDQpMzHjrZ/208jheWrT/dEVBJF0
         J5km++XlAtDOWbgahpuZhH0n1XhkQKNQfUTsQbHgFO2tYO9ZshADQigp7H57nCjnEzTG
         eONFBjp8si7g9r1zKBVge0w2a1JcreLHbusmbd89v5jRu+9liurx8p/1qSqz78ZYoudI
         HReK+sEM2u2yniRVhMj3NsnZCLUcqwP9i3iRO1rAI7mnx4jRD62QWLqlfS3Dt8DtIXWl
         d9EUKKKuiaYY1ZGLkP/n4bennonJcb+govgMcqHE+8ESXNJU1AtIQX534uSY0lrDI4sC
         JQbw==
X-Gm-Message-State: AOAM532VvIzuVVuPA7HmoItepmC+edVt/y2EKs2kpaz485My9EB3iuRx
        oL+AsWovqMYmRY4F5gU5Ftt476+v
X-Google-Smtp-Source: ABdhPJwLWgGvuk5x/i9/tqWhctWQHainVDce0kiIgz8uyRsrC8h1RE+UzescyL90kHrdFQSXGS9wsA==
X-Received: by 2002:a17:906:29c8:: with SMTP id y8mr5617386eje.215.1589253757543;
        Mon, 11 May 2020 20:22:37 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id h12sm1505937ejj.40.2020.05.11.20.22.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 20:22:36 -0700 (PDT)
Subject: Re: [PATCH net-next 3/4] net: ethernet: introduce phy_set_pause
To:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-4-git-send-email-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9e025afd-9952-9f1f-39a1-6228e9838f23@gmail.com>
Date:   Mon, 11 May 2020 20:22:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589243050-18217-4-git-send-email-opendmb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 5:24 PM, Doug Berger wrote:
> This commit introduces the phy_set_pause function to the phylib as
> a helper to support the set_pauseparam ethtool method.
> 
> It is hoped that the new behavior introduced by this function will
> be widely embraced and the phy_set_sym_pause and phy_set_asym_pause
> functions can be deprecated. Those functions are retained for all
> existing users and for any desenting opinions on my interpretation
> of the functionality.
> 
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
