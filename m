Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57FD4253D9E
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 08:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgH0GUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 02:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgH0GUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 02:20:49 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C0EC06125E;
        Wed, 26 Aug 2020 23:20:48 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id i14so2291424lfl.12;
        Wed, 26 Aug 2020 23:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r5l/iVKTiUVvbZkbB/b51IFn+fyGDLG9SnEtHS4suU8=;
        b=gGiDwhEv1QTfrUcR+8cI034luCHsccSlcEBu4qtLH2RwvgnJcG4Xeof1mqqStFpDrt
         Lc5RGJvFLZlBeIaF2tGRfAQiUrFpdrhbM5ikcbQGCBGC58HXByLL0FPK0zjXgLrniLBg
         5z28r0D1s1gNrUcdVnRezy9M6WJUiIEDjh7PrE0KV5CcFOdZDiVCb2kOIpSSf1h9Z0Zs
         h1tR1EKXWFKic6cKMfCIIwnO/eW014LBv/LYHMJI/TVlvu/6g/RZnprFr1gZih8PJLLr
         SJTs8wXIifRDi4IVCTdZUNXjsARJdL48H+QEf1mEJAZmKTgUBX8VzVnQEEH9k2S9iZoS
         oPkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r5l/iVKTiUVvbZkbB/b51IFn+fyGDLG9SnEtHS4suU8=;
        b=qkZFGpft5NE4LZILhwLxhCI2OguxSwLHmjH1ucTvka0OCbz0riKyTT8XuyLcW5YdoH
         XPQ+/5Igl6fyTSSzDP4w87rV8QI6XKhZYHLdbk7S87flRu5XDG/NaEQtZfbLnwEgttJA
         cAeNbPPfZhMNpP5JmwWlrc8h1SXNJrMdI9MgWhGcTtfOSXYFHkXt5ou9pOAEHe67vAP1
         ZrY13Zs7qbGz0HTsYKzA9MULYkQrvrPEJjioEJIbvSPIm3LvUhIBi9kMTFOi8GUilXLT
         YvXRyLsBasXES8WdX94CQqh4uwZgHMF4/2BOLs0cx0pO1RCWXrxSt3d/0w/cTk2PWC2e
         0nVw==
X-Gm-Message-State: AOAM5314EP8BT866nnzgT+qiDuzDpRK1XhhKcq3T+9QD3byuGNeg/mkY
        CIGJ09zLAa486QzkjtWTzP+GTB/ZmYo=
X-Google-Smtp-Source: ABdhPJy2QOqs34ZJMXeyTLFZt00WuO7FOhxkaAatGFpajU2bYLSOfwWUHJeYlGDqqIiuHil3tSkEPg==
X-Received: by 2002:a05:6512:3e8:: with SMTP id n8mr9177272lfq.210.1598509247095;
        Wed, 26 Aug 2020 23:20:47 -0700 (PDT)
Received: from [192.168.2.145] (109-252-170-211.dynamic.spd-mgts.ru. [109.252.170.211])
        by smtp.googlemail.com with ESMTPSA id m15sm244209ljh.62.2020.08.26.23.20.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2020 23:20:46 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] brcmfmac: drop unnecessary "fallthrough" comments
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200827060441.15487-1-digetx@gmail.com>
 <20200827060441.15487-3-digetx@gmail.com>
 <9ba55d08-879b-cf66-b5d9-cc8fd292a4aa@embeddedor.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <d34ef95d-fd65-67ad-520a-7cba17eaadc0@gmail.com>
Date:   Thu, 27 Aug 2020 09:20:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9ba55d08-879b-cf66-b5d9-cc8fd292a4aa@embeddedor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

27.08.2020 09:23, Gustavo A. R. Silva пишет:
> Hi,
> 
> There is a patch that address this, already:
> 
> https://lore.kernel.org/lkml/20200821063758.GA17783@embeddedor/
> 
> Thanks

Okay, then my patch is unnecessary. Thank you!
