Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0087A2AFF04
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgKLFd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbgKLFZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 00:25:54 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2BEC0613D1;
        Wed, 11 Nov 2020 21:25:52 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id 11so4697046ljf.2;
        Wed, 11 Nov 2020 21:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wTOtMAj/ACdeJE5J+kcN4F6aIVLf3f+x5ICOuaLcXkI=;
        b=Rl3MgtCnsvtwJUCBZUVrDCaUqowijkvniH4yIj0+UK+KSUAj53EMM8OHXuKVweGa9F
         CMkMuE/a1arloRIk/BzNMq/mFkxSLPnZdSln0GSS8Ga/dQu70ozGkyzvth08CnDUESz5
         eJdWDSrn2/B9cJwhtOfbo1AJnIDK0ODX8LiVZKL1WR0BV/nIO7ucLiROjjzwWeayT+Nw
         EaPMvjtxWxTmBxoMiShTYiPfqT4OFfzeoq3HFzbGTf/ig10DyRfbOz9tXqoCumleJ4+9
         Pij2W3SQHwsNJPv20MEdAJbX6GLN9YPtTu3E/Lf+Eb1Qrrg2/VH7BCuMrCMRfb8dow0z
         zP4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wTOtMAj/ACdeJE5J+kcN4F6aIVLf3f+x5ICOuaLcXkI=;
        b=VH9CsIBO2HXdUJCeZ1RWoF15G8DC2+5n7IaBCzSgQYSYp6ctnNdJ4PrwVk9AuEe9IL
         oSxLF6ticAO3SdkZRbwI5Z9s6/bVyK05hhEAWt6FFDYKH7zARF6rJeJHYc1dp+0BcFXz
         k0YtfsNctpmEkEdYH7FJSOWh9st7YsBIUCQt4HDg4ZT5cLMn1cLMtKLz+rhFwQP2yk4I
         KgYuYznhYYXy2aN5lrQkLnkAFDaya+vh9pyx4LLiiq8x1Vexj+4jFjpGprJtPewC3MRN
         GvQltmpXdb8Bs1AHc/HYzfYt/jDpi6OfP7g+uNfKHbfLa5t401QWmJbfMhvipsJLxhgt
         OL3g==
X-Gm-Message-State: AOAM532egZty9nlgg9OKwOcxt9cscLa1nOwJJErXG+5l6mS4BLK8qN42
        ZYvEZiUsAZmXET6B7VoR7wo=
X-Google-Smtp-Source: ABdhPJwkmkv27tsdq9sH1LAdBRDYa99KaCBXqb4kiNqZx1dCv7swPti3B/KpDw8GQ2gLND58xpW/Fg==
X-Received: by 2002:a2e:b6c6:: with SMTP id m6mr5024134ljo.83.1605158751185;
        Wed, 11 Nov 2020 21:25:51 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id t6sm118187lfe.81.2020.11.11.21.25.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 21:25:50 -0800 (PST)
Subject: Re: [PATCH v2 04/10] ARM: dts: BCM5301X: Add a default compatible for
 switch node
To:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "maintainer:BROADCOM IPROC ARM ARCHITECTURE" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kurt Kanzenbach <kurt@kmk-computers.de>
References: <20201112045020.9766-1-f.fainelli@gmail.com>
 <20201112045020.9766-5-f.fainelli@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <741289b6-d7ad-a527-81fa-47fd35b5cca6@gmail.com>
Date:   Thu, 12 Nov 2020 06:25:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201112045020.9766-5-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.11.2020 05:50, Florian Fainelli wrote:
> Provide a default compatible string which is based on the 53011 SRAB
> compatible by default. The 4709 and 47094 default to the 53012 SRAB
> compatible.
> 
> (...)
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Looks good, thanks!

Acked-by: Rafał Miłecki <rafal@milecki.pl>
