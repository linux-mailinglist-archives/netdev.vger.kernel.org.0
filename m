Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3595562856
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 20:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732434AbfGHS1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 14:27:38 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39262 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727373AbfGHS1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 14:27:37 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so18218577wrt.6;
        Mon, 08 Jul 2019 11:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Hlh9LRDKeGCVUQgDVMfTWim6xtUlmgbDQCaCg/jkiYk=;
        b=VF1xT7KwCZxRMnaL+6qqKLLW7p/aZtDvikAtOa39yeM/wIg/uwc8p4j0G6VqAZ4LHj
         1VBSM//iVF9NmbZXhACSUrvu0IV1Kcw8CKg0cOF1ut2IZHq03DyZ5X0yJ/v57LMS3vMU
         g6YAx2adBMrmbt32FoUonOlvCIT2MgciCeujkX/do8d1tFcZmg+EDC4IOJJGQPI5o9Gs
         b/g8F7X7716eKnasDYehjAdy57l6VbUXf1mQrkUPEhzk4e52UYHzoaJijeDkd0jR/A4u
         q8zDEfvS//MQi+Dz4e+OuYd4X5S1Af51ISL0rNfqptiFMGE1qc4y9L8V3li2w2iOmQVi
         NT5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hlh9LRDKeGCVUQgDVMfTWim6xtUlmgbDQCaCg/jkiYk=;
        b=OvjcmODzVNtcJ4qoDQ8TlOzD4Bj9gqYsiMXY1Y6+v2l4BL4OhNEGRspee/+V4gFkhx
         bMNKtG/z8o+4K/IgCXMFRlCeSZfW3MZVQOpjkSEpkUMpCKvRAHC1k9KX1poxH1ROc6hp
         AQDkX/ytqzSkZGpqm4VsgUs6zKiVuNM2EWEWzLFkNWpIIwIwJIPjaOEN1atLFiy45lBe
         7xLrO35ByWFqvW3bsgLT4fbRoW2LykDYWrBXAtZ27ERYxv8h/TqED4I/BRpGZphA3N4D
         Mlkk8TLg0UeIlyqLA/8Gq9AqxVohNN9RY3UGYWEr2zmcvEbe24XmS4hEkGSZ/6zMIVtY
         kC+Q==
X-Gm-Message-State: APjAAAUUIIRdFVkL9Jwh2z/tjiRjIpAdNFAxXuiTsdaqnPwSNfZxdViv
        9ylbWRrYkdn5pnlAaA/F9JSmNexQ
X-Google-Smtp-Source: APXvYqx2WaIHYYv7USvSWcc9lx8VRffOVJTPXGQi4dzabC8TF8wp2u7RSMiclZl4bDpnZEiwPY4FfQ==
X-Received: by 2002:a05:6000:1043:: with SMTP id c3mr10139883wrx.236.1562610455220;
        Mon, 08 Jul 2019 11:27:35 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:1cb7:5e0e:6ae1:8cca? (p200300EA8BD60C001CB75E0E6AE18CCA.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:1cb7:5e0e:6ae1:8cca])
        by smtp.googlemail.com with ESMTPSA id d7sm15183992wrw.0.2019.07.08.11.27.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 11:27:34 -0700 (PDT)
Subject: Re: [PATCH] r8169: add enable_aspm parameter
To:     AceLan Kao <acelan.kao@canonical.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190708063751.16234-1-acelan.kao@canonical.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <53f82481-ed41-abc5-2e4e-ac1026617219@gmail.com>
Date:   Mon, 8 Jul 2019 20:27:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708063751.16234-1-acelan.kao@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.07.2019 08:37, AceLan Kao wrote:
> We have many commits in the driver which enable and then disable ASPM
> function over and over again.
>    commit b75bb8a5b755 ("r8169: disable ASPM again")
>    commit 0866cd15029b ("r8169: enable ASPM on RTL8106E")
>    commit 94235460f9ea ("r8169: Align ASPM/CLKREQ setting function with vendor driver")
>    commit aa1e7d2c31ef ("r8169: enable ASPM on RTL8168E-VL")
>    commit f37658da21aa ("r8169: align ASPM entry latency setting with vendor driver")
>    commit a99790bf5c7f ("r8169: Reinstate ASPM Support")
>    commit 671646c151d4 ("r8169: Don't disable ASPM in the driver")
>    commit 4521e1a94279 ("Revert "r8169: enable internal ASPM and clock request settings".")
>    commit d64ec841517a ("r8169: enable internal ASPM and clock request settings")
> 
> This function is very important for production, and if we can't come out
> a solution to make both happy, I'd suggest we add a parameter in the
> driver to toggle it.
> 
The usage of a module parameter to control ASPM is discouraged.
There have been more such attempts in the past that have been declined.

Pending with the PCI maintainers is a series adding ASPM control
via sysfs, see here: https://www.spinics.net/lists/linux-pci/msg83228.html

Also more details than just stating "it's important for production"
would have been appreciated in the commit message, e.g. which
power-savings you can achieve with ASPM on which systems.
