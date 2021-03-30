Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1573E34EB7A
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 17:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbhC3PEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 11:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbhC3PE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 11:04:28 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6E6C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:04:28 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id x207so16802442oif.1
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sW54dg7OXZ/TqY1hoQIQLh2ZGkIueUz2Xp7xo4X/Zr8=;
        b=RB7YZZoHN/kOdYZPNK0Vdkgf50AnUf30u4iXSMi+yE4qw+yBC+ofaGeL3dDJE7Vdsi
         wm6Qx2iHgR+cRvbcdnjeU8QMcjbeTUjxwYm3wajCiTdYdvKPIUv5X5axc4iq18DW7P57
         HnRtaYLeWAvvvSC6DPcT+NIFOWrCqK6zTJgbJJeYqjtc4FFq+7S5OMr46LaI18elnZ9X
         T4EXyETP8LkUWbxMXeSUPVhCt1s58qP8Xb5zehmNAcZrcuGK6kGV+AkrJwhKl4m70Y//
         RhvgoBYUoLVnDBkLDqhI4Wtoj2wJ9HP5SlsF0YNfVGnl3RfPeC2piaT7WUOi4PxGjJZc
         HSgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sW54dg7OXZ/TqY1hoQIQLh2ZGkIueUz2Xp7xo4X/Zr8=;
        b=e5c4lmsJmIHH+dTdvzBMaXLf+t0ONrIbuEdYCFp1Xe+D2HbYHu2d36WAyFpmpNAIwt
         GFlu3Kc3WHjbPbD6QkCaWW/7TrmAeMvM6bLFcVac646w9SPIlxR2bcPM1iy3FH4+RfAU
         22n0za63JFrQTv1h1tKtKAYqxh9icUA7p+xIaBMmOO8A5G9bYjhBTjtyQNbQUsCfyFPy
         hYxvJZ5WyfkKZB/zLJ0hrL8kh34HaeWpzn7yVubau04fzd8no636uu8hr2hVLBO3IfHM
         epc0RDT41FsUKEDw+KXpbnbw8niaFiB3KS7CASE5N21/PqwT5gUtxdJiAqQW0c/cCLB5
         G5YA==
X-Gm-Message-State: AOAM531pDIpuQu1hFHFeY+vXx6r+I2TKmV9xQZ08BGXXoQ4cYTWdz/rs
        v+1hFWHGPcORAZvYKil8p5y/kKB5X1Y=
X-Google-Smtp-Source: ABdhPJyCoWii4vD0ryp85NKHkZ+G5em7k1mv2jPhXsdrmVoAD1VmTXwYG9FLfDmYA+iSy0dCk9NIKg==
X-Received: by 2002:aca:1e16:: with SMTP id m22mr3492845oic.153.1617116667223;
        Tue, 30 Mar 2021 08:04:27 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id w7sm5095822ote.52.2021.03.30.08.04.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 08:04:26 -0700 (PDT)
Subject: Re: ip-nexthop does not support flush by id
To:     Ido Schimmel <idosch@idosch.org>,
        xuchunmei <xuchunmei@linux.alibaba.com>
Cc:     netdev@vger.kernel.org
References: <C2B7C7DB-B613-41BB-9D5F-EF162181988C@linux.alibaba.com>
 <YGMiBowCKbVHJrfh@shredder.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8b1bbce6-7ad9-0446-143b-4b1d3f202066@gmail.com>
Date:   Tue, 30 Mar 2021 09:04:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YGMiBowCKbVHJrfh@shredder.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/30/21 7:05 AM, Ido Schimmel wrote:
> Looks like a bug. 'flush' does not really make sense with 'id', but
> 'list id' works, so I think 'flush id' should also work.

right, neither were intended. If you know the id, you don't need the
generic list / flush option.

> 
> Can you send a patch?

Agreed. At this point consistency is best.
