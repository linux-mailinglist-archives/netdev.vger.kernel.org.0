Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC965A0E6A
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 01:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfH1XqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 19:46:08 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37095 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfH1XqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 19:46:08 -0400
Received: by mail-ed1-f68.google.com with SMTP id f22so1922791edt.4
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 16:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=lwAYU7SB5jIDkttjpEhSjVB4Jmz8vCYzWhIimXVsskE=;
        b=I/wd8vx0SScvlvog5F9Pn/BsE/GwpWt53yoYdao1SFQPtCikmUlDbq3UR5zmMMPv9b
         /KNq9uU5pKH3u/gYO6YrqhyPwnfrj3Fg+3I6k6xK6SYsdyn8NiEZGDbK7IRK1qEfjYCT
         3WRacdzKn50XjOQbnLXA/7s/YE8bUPWI5Zu+0/Jttj1Dy+nQ1oiOPEtNf0eCdrrYlwWF
         5aID5/e8i+zGx6ojhYu8zQyIGy65euIpzHiCGgQTAqcOMrYl8G8GLnU09z6Uic9gSn6U
         qLkhJ+ZyODiIH0MfElA2SlWri4MpcihCUpvvn/Q375XCQcXUeyhovbWdjhuGw06g3tNt
         tOjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=lwAYU7SB5jIDkttjpEhSjVB4Jmz8vCYzWhIimXVsskE=;
        b=Zrgl7FXaXewbhUvtv7dQBEHOF3e364HG+nVGRtVGPl2Vjbzh3zXUsYXlTpX7dt9Amt
         f6HpkuTXgB9DeqdEMseEflBRkkJY92Ij1ptkZ8POn5Uw4X6tAe5kRGlPxkHdJqk2na/u
         Tyn6osM+O4lo/ew2XJw53LbA5eD99E6UiogPVpzTpLDFdc2PLEPn4tRLxSuAtWNw8hjJ
         NGSS8gh15pWVD5HFg0hnJEcxOceVUpbMTmsZCPeuJSXlTBabjpMp3PhU802qxqUv7lWW
         5FyByITJHIY5q3hKyu0OXvQwTPx1RXy7HqQh/yrrEbBfFAk7YgpMK2HZZjZuzUlSP6jV
         0qaQ==
X-Gm-Message-State: APjAAAVkN858fNNzqMOgoK4M/uHHW6yDo4GwvtWIGVF/rRh255gUgwF8
        DYVFlEJyHK9V2NzYIrmOofmP9A==
X-Google-Smtp-Source: APXvYqwu9IsQHtGiuAmjkCBqUGXyClEWy1PfqGWQYYamAYMzTPH0SCIXNdN5PLg4l9mLNC0qQud5fg==
X-Received: by 2002:a17:906:bc2:: with SMTP id y2mr5634915ejg.148.1567035966614;
        Wed, 28 Aug 2019 16:46:06 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d20sm114436ejb.75.2019.08.28.16.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 16:46:06 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:45:44 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/4] mlxsw: Various updates
Message-ID: <20190828164544.30938d4d@cakuba.netronome.com>
In-Reply-To: <20190828155437.9852-1-idosch@idosch.org>
References: <20190828155437.9852-1-idosch@idosch.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Aug 2019 18:54:33 +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Patch #1 from Amit removes 56G speed support. The reasons for this are
> detailed in the commit message.
> 
> Patch #2 from Shalom ensures that the hardware does not auto negotiate
> the number of used lanes. For example, if a four lane port supports 100G
> over both two and four lanes, it will not advertise the two lane link
> mode.
> 
> Patch #3 bumps the firmware version supported by the driver.
> 
> Patch #4 from Petr adds ethtool counters to help debug the internal PTP
> implementation in mlxsw. I copied Richard on this patch in case he has
> comments.

LGTM
