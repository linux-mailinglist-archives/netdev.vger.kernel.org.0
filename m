Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F090E73BB8
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 22:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405600AbfGXUCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 16:02:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38778 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405258AbfGXUCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 16:02:50 -0400
Received: by mail-wm1-f67.google.com with SMTP id s15so21331605wmj.3
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 13:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8PyS/0yEh0m/QkdJPTqZiIMEx1tE1OoxiKyHLXTqNUA=;
        b=gldQi2Vcjby/C59wOCrQz4Op5rUAMRcTt6NzmhCjxy1ECuDD9jkR1pOAnkXYba9STU
         pTVTTtEfuJ8hDaM77yr3mlh9zgDAMEBJC2sJ6ZJLkG9+MfcNGm4jKUJnSjVIGv1SJonO
         3YeOj96ERrE5fsU5Pn2WMZPcDCznQVxvKlOV+f+RPN5BybgC7o4Dx3KELHEOwZZFXU8S
         Qw0Uub5wcntnHkc+QXwcKj75UmwDUd/d3ekZXRuybQWbEwZMLPOPJTf1Pcb8sU1Lr9yp
         rgAL/Awg7PeFieiSq6AJW7hrDfDhJCOpDD74elnnqjCNsAvRJwYp/AjOLALsigt4DZEO
         wk6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8PyS/0yEh0m/QkdJPTqZiIMEx1tE1OoxiKyHLXTqNUA=;
        b=svGZ6tl4SpvZoYO8Kt4oVdo8pKaAGoT9j5lTJupbrI3r4KidI4+BhDY5qHdyJNeVgo
         qEH6NZhl5JVd3MYToEjD0JK9mB5QIPxgVSrWOY/HmKtD1mbEHtwNEe0nGgqXYqQewFxH
         /laYxUIe5a21oaT7TC+qdrHUOQt7W9ff6vAcv9VTqZLTDNsGhbW1p8pP5m2OCmhVAmjT
         FCc+9kvrZEW8hUs6Ab4d1+razc+iNzIXCYrKXB4v7s2GNl90BbZMOkhnuWZ5cqLcnvjl
         lB9iWgzDzcqPlsGgYgL35qaLGXfU80opTn2lGUXEO+f+/C+ypFp18J88nz5BDdSMXPbn
         tI8g==
X-Gm-Message-State: APjAAAUIZR9pp0guZmP9IyAEG8rW6VZTW6BVuXGwWgFDS9NS0dwxCa4n
        ka2jGPjqum36Yb8jea2IcRA=
X-Google-Smtp-Source: APXvYqycfTRyu4DPfZS0m3p2dOXZZPrOXB6ycA7CXlUhQOXSpBeS1PbrDPYfqy8XXCFNnVKLCZitxA==
X-Received: by 2002:a1c:544d:: with SMTP id p13mr78757809wmi.78.1563998567714;
        Wed, 24 Jul 2019 13:02:47 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:60e4:dd99:f7ec:c519? (p200300EA8F43420060E4DD99F7ECC519.dip0.t-ipconnect.de. [2003:ea:8f43:4200:60e4:dd99:f7ec:c519])
        by smtp.googlemail.com with ESMTPSA id p14sm38427234wrx.17.2019.07.24.13.02.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 13:02:46 -0700 (PDT)
Subject: Re: Driver support for Realtek RTL8125 2.5GB Ethernet
To:     Jian-Hong Pan <jian-hong@endlessm.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc:     Linux Upstreaming Team <linux@endlessm.com>
References: <CAPpJ_ed7dSCfWPt8PiK3_LNw=MDPrFwo-5M1xcpKw-3x7dxsrA@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e178221e-4f48-b9b9-2451-048e8f4a0f9f@gmail.com>
Date:   Wed, 24 Jul 2019 22:02:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAPpJ_ed7dSCfWPt8PiK3_LNw=MDPrFwo-5M1xcpKw-3x7dxsrA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.07.2019 10:19, Jian-Hong Pan wrote:
> Hi all,
> 
> We have got a consumer desktop equipped with Realtek RTL8125 2.5GB
> Ethernet [1] recently.  But, there is no related driver in mainline
> kernel yet.  So, we can only use the vendor driver [2] and customize
> it [3] right now.
> 
> Is anyone working on an upstream driver for this hardware?
> 
At least I'm not aware of any such work. Issue with Realtek is that
they answer individual questions very quickly but company policy is
to not release any datasheets or errata documentation.
RTL8169 inherited a lot from RTL8139, so I would expect that the
r8169 driver could be a good basis for a RTL8125 mainline driver.

> [1] https://www.realtek.com/en/press-room/news-releases/item/realtek-launches-world-s-first-single-chip-2-5g-ethernet-controller-for-multiple-applications-including-gaming-solution
> [2] https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-pci-express-software
> [3] https://github.com/endlessm/linux/commit/da1e43f58850d272eb72f571524ed71fd237d32b
> 
> Jian-Hong Pan
> 
Heiner
