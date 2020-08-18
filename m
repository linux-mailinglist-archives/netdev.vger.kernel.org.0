Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF32247DFF
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 07:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgHRFon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 01:44:43 -0400
Received: from mail-ej1-f67.google.com ([209.85.218.67]:33360 "EHLO
        mail-ej1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgHRFom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 01:44:42 -0400
Received: by mail-ej1-f67.google.com with SMTP id jp10so20615779ejb.0;
        Mon, 17 Aug 2020 22:44:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8xJ+uVT/WHccEkVlHi1wKll5tijnlgRwLyicm8LM78A=;
        b=pvax8nwiTzlSC8KLnlD5iBsWFk7Se46AKY8/yWk0VEMGeoWkJbm8mafPjkg7PUt6VF
         Xqgaq86t9PUmBY1oVAFQGeLeo/0/5qxRti4jHJfuHDbY4WQYUMJsG5RElHGYPXd9dDhy
         S1p3kiIsU32s9fpFoT3ABrNtngUbJ2bllcCCNUcyYYL2KAcaA0027slT8dydyrUc2Us1
         GsNHyr+Mk373Qc1Cp6IY3yPWY/6kpA8GhIP0DgiN4eky2RAxi1NM/Xb7XEXDUahCTwdp
         lya7XJtszn0E6xzmzY82KpkR8wDCAXh8hoaVGxBHyzuzE/dITdbPDnVWzVz/zb7oBe9i
         WPAw==
X-Gm-Message-State: AOAM530fDM5yQZv8SnZ+MwIYFC3yiT0Alu6tthiHnP8tCaZvhQhhzKHt
        UlQA/D0e1pfJ0x165Q0N9z8f1pYDhbUmXg==
X-Google-Smtp-Source: ABdhPJwyOOGrfzUtvh0bzgyzCD9OdFf8HsVYlqBtL8jzJNuBwgt45xYpvdBEwHia444d6IN47WvOGQ==
X-Received: by 2002:a17:907:36b:: with SMTP id rs11mr19095297ejb.544.1597729480728;
        Mon, 17 Aug 2020 22:44:40 -0700 (PDT)
Received: from ?IPv6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id j24sm15574395ejv.32.2020.08.17.22.44.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 22:44:40 -0700 (PDT)
Subject: Re: [PATCH 00/16] wirless: convert tasklets to use new
 tasklet_setup()
To:     Allen Pais <allen.cryptic@gmail.com>, kvalo@codeaurora.org,
        kuba@kernel.org, mickflemm@gmail.com, mcgrof@kernel.org,
        chunkeey@googlemail.com, Larry.Finger@lwfinger.net,
        stas.yakovlev@gmail.com, helmut.schaa@googlemail.com,
        pkshih@realtek.com, yhchuang@realtek.com, dsd@gentoo.org,
        kune@deine-taler.de
Cc:     keescook@chromium.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, b43-dev@lists.infradead.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Allen Pais <allen.lkml@gmail.com>
References: <20200817090637.26887-1-allen.cryptic@gmail.com>
From:   Jiri Slaby <jirislaby@kernel.org>
Message-ID: <9cbb824a-5769-dd24-dcec-d9522d93e9b2@kernel.org>
Date:   Tue, 18 Aug 2020 07:44:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200817090637.26887-1-allen.cryptic@gmail.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17. 08. 20, 11:06, Allen Pais wrote:
> From: Allen Pais <allen.lkml@gmail.com>
> 
> Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
> introduced a new tasklet initialization API. This series converts 
> all the wireless drivers to use the new tasklet_setup() API

General question for the whole series: have you considered the long-term
aim instead? That is: convert away from tasklets completely? I.e. use
threaded irqs or workqueues?

thanks,
-- 
js
suse labs
