Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04751AFEA3
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 00:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgDSW2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 18:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725848AbgDSW2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 18:28:18 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC1CC061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 15:28:17 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id s63so8720394qke.4
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 15:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yrSgLjmmk5lOjNgpDsC00AX/ddXDa1OkvRFiq3xKDGo=;
        b=m9HcrMK3UYjatj0tgM0vJp5rz3QMrbWn21pkoO2k36kEPgCgPecWmJdq3pl9da514h
         AeeZqlLdjHT7r3hNc9fN1vzXiG63oGB0kFX6bpguvUPYWaVACuNisrqJwqJ7BBu1W3IP
         qqtCAmhohiVGSI6vxQ66VendmKQvds6Y/jVoZ/kefjqdkdfRORdW/+ltiX1taU5ssFjW
         iBMkh9HRvz3e0Y/oelV6/HuuSmff4nSkUORfdI1CZoHUfKwc/oRu85Ph7oac/A86JXjA
         V4e/KNHLe0tl8UolNrFz32190WmO8eS1Tzr8F7J8oXRWfWHkCicnCC5QwIW0s6o294iN
         gnqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yrSgLjmmk5lOjNgpDsC00AX/ddXDa1OkvRFiq3xKDGo=;
        b=JCM9Il/VHeNkeTPdfgOBrlIgBBS/6mjqNXNAcDQ3PhvVpjcQiK6kuFx7wDsyUlO4fU
         JkNxjHM194ravNnrdy7iWKjxdWBPs/n3VjyaiJOfE5BmakOZ2vWsZK8bsitCCtDWJ+4j
         iSAlbdLmns5YxfjT+/HBGt5yHJYjf+OV/q78m6D7iQTb2jick8Nk0wKAQzlToPBGxo5M
         KRjgnbgdg3yCLJNxKn1E2T6B5eSni/6Q0R5s8IBJl9UwDBXTS/iHp3WFsJxuzVerJqYm
         Gpmq+9C2NpWbeUCtP8OmD4uH5orEcodW4MpIz33F3Yh+3u/JWUqbhMw4wqzTv9urm+e1
         ScIw==
X-Gm-Message-State: AGi0Pubol0RId6cn3hDCBB09cmoOH/Ly1tIoJMGnugAYoNTFfbGoqslO
        4JxTofJ2esAnXHzQrKa2ItkWU2pK
X-Google-Smtp-Source: APiQypKDHGmZV6uvRakOSe65wDoKZiDJJtPkNS9nJJbjgAU70+ZzaBeFcsIpuEYDOiHS6TwoQ8qoIg==
X-Received: by 2002:a37:7a84:: with SMTP id v126mr13084883qkc.423.1587335296381;
        Sun, 19 Apr 2020 15:28:16 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:1168:6eff:89a1:d7f0? ([2601:282:803:7700:1168:6eff:89a1:d7f0])
        by smtp.googlemail.com with ESMTPSA id g3sm18296448qkk.24.2020.04.19.15.28.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 15:28:15 -0700 (PDT)
Subject: Re: [PATCHv3 iproute2-next 3/7] iproute_lwtunnel: add options support
 for erspan metadata
To:     Xin Long <lucien.xin@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
 <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
 <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
 <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
 <20200214081324.48dc2090@hermes.lan>
 <CADvbK_dYwQ6LTuNPfGjdZPkFbrV2_vrX7OL7q3oR9830Mb8NcQ@mail.gmail.com>
 <20200214162104.04e0bb71@hermes.lan>
 <CADvbK_eSiGXuZqHAdQTJugLa7mNUkuQTDmcuVYMHO=1VB+Cs8w@mail.gmail.com>
 <793b8ff4-c04a-f962-f54f-3eae87a42963@gmail.com>
 <CADvbK_fOfEC0kG8wY_xbg_Yj4t=Y1oRKxo4h5CsYxN6Keo9YBQ@mail.gmail.com>
 <d0ec991a-77fc-84dd-b4cc-9ae649f7a0ac@gmail.com>
 <20200217130255.06644553@hermes.lan>
 <CADvbK_c4=FesEqfjLxtCf712e3_1aLJYv9ebkomWYs+J=vcLpg@mail.gmail.com>
 <CADvbK_fYTaCYgyiMog4RohJxYqp=B+HAj1H8aVKuEp6gPCPNXA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <edcf3540-da91-d7af-12ff-8ca7d708bd3a@gmail.com>
Date:   Sun, 19 Apr 2020 16:28:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CADvbK_fYTaCYgyiMog4RohJxYqp=B+HAj1H8aVKuEp6gPCPNXA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/19/20 2:39 AM, Xin Long wrote:
> This patchset is in "deferred" status for a long time.
> What should we do about this one?
> should I improve something then repost or the lastest one will be fine.

I am fine with this set as is; Stephen had some concerns.
