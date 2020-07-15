Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C92E2210C6
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbgGOPWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgGOPWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:22:43 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB5CC061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 08:22:42 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id h28so1914454edz.0
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 08:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qq5WLS3AucPGRX665L55UeFrNtWnb1SlE0LBssP8n14=;
        b=a3oy/9Xy5fVp2VVAgMcOiaZHtgFJsSPifTIqcy1o8zaHySl2UkTzJJEENyUjq+YxnU
         Q5eO/YEIOnzFxaW7Ddo2plhGTB6UojsvG1SKoOGdLu4k6Y0IiR4bIKCTUQ2XaM5m5xBk
         /B7UMRcLn1E1qW4XTzQuKNdgom3OeJS0OpHQrUUyK4pP8rFqUiVulZuUfzu8RgXHr3N9
         ATNzoq9R/PeNnX2ef5viFwIw70b4ndQmW6tUZ8/0hfjhZWhOlaHY7FzEmqZa5x0qA3cX
         tPPTeqDvcle5P2n5FrnFNOFsemUMo1DiXAHUQNpcwAfwkrNEAmSAbnqm9wQKraE17n5S
         /ggw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qq5WLS3AucPGRX665L55UeFrNtWnb1SlE0LBssP8n14=;
        b=h/dMfpazb6sfapzPrjS+bRMTgVihP+iTVQFclBSolrMnUKMmOIiOHaV2c6NBzkQNkD
         xdwU8fWIerjt4N9L3IC3iriujqpQRZyP5DxKfbP+pXJBsB8Tf/GF6M8NK1BYXur1I4LF
         5U0P1h0odm1cmBnn4m/VLzKclwhH0OASWLouUFIuvgxCTgoht0la99/6zmk3+ldEHzmZ
         WTpraQWHFPQ55Lfh4eRs3HYkvyO0g19Iqqeye4CppcGPN9xcLKWJ15kalUkdNv2eo9kM
         A1+sFeFWcCASys2XMyprfdwFlc8XUK7GiJQT7LC+WegdCJo7jPhpMqiDth1vzyKYvpPP
         hPNQ==
X-Gm-Message-State: AOAM531PfStWK6fDZAYzkn1ALa3aanM4r5EugWMEAxW64HERyauSD5L0
        8J8BIHFya0llSQBJ+mt1igVMTQ10uIk=
X-Google-Smtp-Source: ABdhPJynaujtjbIKhze8qg5QHFb2MQse1SuGY79RHYaxpOPecEThqcn4AJsNddz5ujbEv/b3mObMsQ==
X-Received: by 2002:a05:6402:1ca8:: with SMTP id cz8mr115175edb.55.1594826561382;
        Wed, 15 Jul 2020 08:22:41 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:a057:4ec1:54f8:5de3? (p200300ea8f235700a0574ec154f85de3.dip0.t-ipconnect.de. [2003:ea:8f23:5700:a057:4ec1:54f8:5de3])
        by smtp.googlemail.com with ESMTPSA id cq7sm2472343edb.66.2020.07.15.08.22.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 08:22:40 -0700 (PDT)
Subject: Re: RTL8402 stops working after hibernate/resume
To:     Petr Tesarik <ptesarik@suse.cz>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     netdev@vger.kernel.org
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
Date:   Wed, 15 Jul 2020 17:22:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200715102820.7207f2f8@ezekiel.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.07.2020 10:28, Petr Tesarik wrote:
> Hi all,
> 
> I've encountered some issues on an Asus laptop. The RTL8402 receive
> queue behaves strangely after suspend to RAM and resume - many incoming
> packets are truncated, but not all and not always to the same length
> (most commonly 60 bytes, but I've also seen 150 bytes and other
> lengths).
> 
> Reloading the driver can fix the problem, so I believe we must be
> missing some initialization on resume. I've already done some
> debugging, and the interface is not running when rtl8169_resume() is
> called, so __rtl8169_resume() is skipped, which means that almost
> nothing is done on resume.
> 
The dmesg log part in the opensuse bug report indicates that a userspace
tool (e.g. NetworkManager) brings down the interface on suspend.
On resume the interface is brought up again, and PHY driver is loaded.
Therefore it's ok that rtl8169_resume() is a no-op.

The bug report mentions that the link was down before suspending.
Does the issue also happen if the link is up when suspending?

Interesting would also be a test w/o a network manager.
Means the interface stays up during suspend/resume cycle.

Unfortunately it's not known whether it's a regression, and I have no
test hw with this chip version.

Also you could test whether the same happens with the r8101 vendor driver.

> Some more information can be found in this openSUSE bug report:
> 
> https://bugzilla.opensuse.org/show_bug.cgi?id=1174098
> 
> The laptop is not (yet) in production, so I can do further debugging if
> needed.
> 
> Petr T
> 
Heiner
