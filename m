Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 408906097A
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbfGEPlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:41:07 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41087 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfGEPlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:41:07 -0400
Received: by mail-oi1-f195.google.com with SMTP id g7so7420764oia.8
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 08:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fXO0EjwvhyjamzaMy9HA80slbDkG9RpObwf0TtkxdsI=;
        b=Pi8blUMHIvxeHfbvEnVFI1aza2tQdC4v37BGQpk15jpnx/eG4qO36RzJZIukco9aUh
         d7mozpHOxLg4C+edOOlMl1zewaB8RtWzXTjwkrv2bSQZHFjkF15UP+yQRj0ErzNAS0C9
         oUrtXSeEUEpS6lI+2libvJNa/mnmLvGZD2/T3Kg5kUmBFpADwz5K51TrWc6LAlN9Hp1u
         P8K6OR+3jsMBmE8rSgYZTOc/8FRWB3/D+JlpvOgnxCQjwDY92HXROrSrJ5H0NXPkUWM0
         zGB01Vr3kiYH+/tlfB40qIhyeAlaGGqQFqwmkIhI44NjS6tEZcVaUFZZ85vLZwcI3d9y
         xwUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fXO0EjwvhyjamzaMy9HA80slbDkG9RpObwf0TtkxdsI=;
        b=qlnw9qBJ6d2HGliBg7wRG5WJk2J3m4Ahh8xYxqytO3k6tTDbObnZrdlKl0bNj5CHp4
         ChDRHrwzRqlcAbQqMgU8aILeySbZmNqXw7hEf/4lhZQpLuqR1FRM2z1VJ8ODb6wLdiil
         fcgDI3HbMT/XA2kZyhHXI7L83AoigktPbVTNRH3Xr+9Eg8Q8EfRPMa3S0UVe2JCuw5tc
         MqB/nhTw9UkUc93CsL+o1OZ6ij0Uwyvhen1muMqGmqCTA7e83E0QkSt9E8rY7OwD2Y7y
         2wh3ov8l4iySTSeOZ/kN6an2sFjGJNWbmtSsrMtXnqt4LXQpwtbHc9YNvRGEbiS0ho42
         WTVw==
X-Gm-Message-State: APjAAAXrq+k/Z6o1hT2rlAidNVUeq5EpbG8Bj5Xn4UYY9wBA5HcU6AjQ
        6hU1NZ+XixUZ5rxgSOvbHnA=
X-Google-Smtp-Source: APXvYqzdnjdFg3zFvMfV2vIwMB2y3RGXZWjj0RcZQfqcMQL2eTjo0EhOanG6TvqtgdYvQ3FiR8ILJA==
X-Received: by 2002:aca:6706:: with SMTP id z6mr2250086oix.43.1562341266732;
        Fri, 05 Jul 2019 08:41:06 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id w140sm2971732oie.32.2019.07.05.08.41.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 08:41:05 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] Documentation: net: dsa: b53: Describe b53
 configuration
To:     Benedikt Spranger <b.spranger@linutronix.de>
Cc:     netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20190705095719.24095-1-b.spranger@linutronix.de>
 <20190705095719.24095-3-b.spranger@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <e443bf68-fa12-42fe-d41d-860fb22809f7@gmail.com>
Date:   Fri, 5 Jul 2019 08:41:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190705095719.24095-3-b.spranger@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2019 2:57 AM, Benedikt Spranger wrote:
> Document the different needs of documentation for the b53 driver.
> 
> Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
