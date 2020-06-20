Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C50202762
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 01:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgFTXc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 19:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728633AbgFTXc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 19:32:57 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCFEC061794;
        Sat, 20 Jun 2020 16:32:57 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id d4so6332792pgk.4;
        Sat, 20 Jun 2020 16:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4UqfsRG46wjWjqH4jWh/MQFQOArV6ySZ/OgegkgOC6c=;
        b=Vmv2nGxsguQy28IEVrlMlNItVy6qEqBUxn3/iGAyp63aeeTDhefUEA2EVOzxCVowUs
         rp8br5eCzeRKWwtkVMBRv2MNxzWHtfwmW6zWaTbzNMZijtRI39rXvI+ngdceB835Sr7/
         aMm/fftg9ZkjR4T4mluxQ/vV8+WSBBV7WjykhNYEKJSk0p3gPA10L11zOafxOmXBb4jL
         ZNRP4SAmi3SGi0HJUEM8Z0TeR8GMHSYbKyVb1i2AxCzLp8nJnDoBnwFMn7eP92e/SSBx
         fI3KPFtSJLxJ6iUB4ihR7PuaW0SnDzYcgl4QYVOzFkKzCYEPJlBZEdVnP+oK6lrFO263
         0Uog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4UqfsRG46wjWjqH4jWh/MQFQOArV6ySZ/OgegkgOC6c=;
        b=STVrTTQt14C9OYMeQJq8mpolqAL+sYEYEocsqUKOmJZMAD3CiUyvJQ3huVznCfl8Ga
         uWhCvqo0YDsCUJDkAT9ha1iqnZ2Xiky7tp7nuskXXurXzibZ1v+DYS+52AB+z+ArZReL
         hsmBWHNLY9frNSg9CwJfNimWKrAngP1z/YR6Tm+7BDIoMGe9xyjjUxkvCvfMtQzsbnU+
         f1pzccvF8UJBAPLam/YTHbjbu6qtZO7hZlofyJddCyB58YkeJyCBcV7bmmrpY9bTNp/h
         vgaLcN+zAnLHpoMLf8A2V0iauOzwk9piKblHHgBcw2oGoBXPMkrYNBYrELHWkvoKuLmK
         L6/w==
X-Gm-Message-State: AOAM532OQWCq8YmoVL6ktjgsYGghkued4p2756D93o8zwLU8PSH4v3/H
        ODNR3P1YC8WoMy1y4HBQ554=
X-Google-Smtp-Source: ABdhPJy77RnoEAFQ/B+urSnP2RFM0AmmF5T2YRjEstDU7bcpyu0QwYkpSmDDvBozs/4B88VQxRODLw==
X-Received: by 2002:aa7:972b:: with SMTP id k11mr14471578pfg.299.1592695974963;
        Sat, 20 Jun 2020 16:32:54 -0700 (PDT)
Received: from [172.16.110.59] (047-044-021-226.biz.spectrum.com. [47.44.21.226])
        by smtp.googlemail.com with ESMTPSA id 191sm9346005pfy.161.2020.06.20.16.32.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2020 16:32:54 -0700 (PDT)
Subject: Re: [net-next,v1,0/5] Strict mode for VRF
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Donald Sharp <sharpd@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Dinesh Dutt <didutt@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels@gmail.com>
References: <20200619225447.1445-1-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f13c47d2-6b08-8f73-05d2-755a40fba6a8@gmail.com>
Date:   Sat, 20 Jun 2020 16:32:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200619225447.1445-1-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/20 3:54 PM, Andrea Mayer wrote:
> This patch set adds the new "strict mode" functionality to the Virtual
> Routing and Forwarding infrastructure (VRF). Hereafter we discuss the
> requirements and the main features of the "strict mode" for VRF.
> 

For the set:
Acked-by: David Ahern <dsahern@gmail.com>

