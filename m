Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8892210D8
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgGOPZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgGOPZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:25:39 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20824C061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 08:25:39 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id d18so1902808edv.6
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 08:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ka7V5tmm6lEhNNn244mMYlqcGDL34DglzRXd/I2F8KI=;
        b=q3CYyqhm18dlFu1dSyWsnqWydUaweyRzNspP5y+xgez3KnZQLYFJzT4OpgVD94dbsY
         WFuE2jcm7ngYNemHEl55vMLKXdT1IMDghHeueEOgr3vNVXDsy86WLayISGnL6JZg+ZVE
         NhsCMvpWBdkF3SjFB3i7Xe1XOTtHcE4LPpHqmILWeZNV2vW0Qcf2gOzhKhQxNTHe4psR
         LT3PSIYNuQ18pGsgjJytu3ZaE5/HpRMXTDqHVvccpAzOMpxPmQBkA/TdcLYixaK53nZI
         r/f/GOaAYiLA8BPQ2atwI0jpbBKJQ0gxBblZGdlMK50J1vaSGoGUs3g0TtWSDBbcuN/u
         E5sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ka7V5tmm6lEhNNn244mMYlqcGDL34DglzRXd/I2F8KI=;
        b=APELVdeDoqLGgOQkshQbOY/tLk+1e7KMdEtfOnhYcIGdPmAKKeykpOwSaNnrNQXJJt
         gLApwGiuKwbmm3KqVIm5s6gf18e9eozRPPveGHerW378fA4ePHP+81jd06xYvimhrTii
         EfMp25GssabWcXu1hmcfIMl2KnhE41uokW/y2AdtoEYPr/VT8E8RGgvaVWC24DDKUvNZ
         LiSoEMCE9+4ZEhA/cqZ3nVYM+ndo+OW2T2e1/wGjsUb5Rq0ITv8y9A9839EBglDdXn9+
         IajCPZ8Ko0zNR7rc+410ITmSrr+8jOysq0uWQ2BxQHUyvaGFkKzImcy3WHsaokWhkcOJ
         luUg==
X-Gm-Message-State: AOAM531/+tOii8z3v2Ney+UWGZZrL+RMg1ZBD11B/KL64uczO3aQnrjT
        l/iZpMpnc+EW+/RpQOmQ5nO+cWOXv78=
X-Google-Smtp-Source: ABdhPJwsztksVXl1NZb4HykrbgRKLLShzEA7HGNWm3y5+iu6I0GeD1SBdNL/XF+Vg/tcmK8N/p9TzA==
X-Received: by 2002:a50:f418:: with SMTP id r24mr132714edm.382.1594826737657;
        Wed, 15 Jul 2020 08:25:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:a057:4ec1:54f8:5de3? (p200300ea8f235700a0574ec154f85de3.dip0.t-ipconnect.de. [2003:ea:8f23:5700:a057:4ec1:54f8:5de3])
        by smtp.googlemail.com with ESMTPSA id s14sm2393592edq.36.2020.07.15.08.25.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 08:25:37 -0700 (PDT)
Subject: Re: RTL8402 stops working after hibernate/resume
To:     Petr Tesarik <ptesarik@suse.cz>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     netdev@vger.kernel.org
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d6894b35-1d66-808e-48c8-05964a8a636d@gmail.com>
Date:   Wed, 15 Jul 2020 17:25:32 +0200
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
> Some more information can be found in this openSUSE bug report:
> 
> https://bugzilla.opensuse.org/show_bug.cgi?id=1174098
> 
> The laptop is not (yet) in production, so I can do further debugging if
> needed.
> 
> Petr T
> 
One additional question: Do you have the firmware in place?
Check "ethtool -i <if>" for a firmware version.
