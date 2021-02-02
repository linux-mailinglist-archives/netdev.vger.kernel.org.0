Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A7B30BE47
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 13:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhBBMfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 07:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhBBMfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 07:35:15 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE7DC0613D6
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 04:34:34 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id f14so5422626ejc.8
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 04:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=M4jU+3iZFXJN1E+hhIRXaJSTROYQUNIq1XEe9a7FEUk=;
        b=HRUGGng8KhRxmM7E7Y4cP2CyhTYk7BpVcglKob5wcn5xX6imwLlAkvSodxJ/+F0VL/
         WMHrdncHx1IAdaonCcij7gna7lagYQnQ4PhNGwJ7aY1ljAZBru4VLCo970fjNiCadCn2
         nCLNPcitxFzGHX7MsXU3Q2RDm1wVYHfOR+1fO5MGOkhHjDIpT4/Bh3KKyVXLf/caePQ3
         sAxqLtqxOqqUx7V5fczIOCI1ganqs2uoGK/YsVmcCEk7tUK+BI3s6btKaJCiJVh6XK4O
         cAXgeRvm9mcwCQ31J1pjOS+XqZxy3cDydWrFVmESJgFSV7ftAs+oXQA8tk/X78n6Mra4
         Rvrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=M4jU+3iZFXJN1E+hhIRXaJSTROYQUNIq1XEe9a7FEUk=;
        b=EiFrXaMkVNn6ZQQ9AuqZRL4gUR9uH990LyVxDl/NJzMR5VE5cPEOVSKS0g3s+cUrVt
         wxERtMhSyiny8FfJRCxhwZ6fMhHoMqgBiYTGDuUWnIGN1LTFVwgTtxGgcgYxE0cNoxqm
         DcZVNFAaYKGo8zdAtKdguNqsYChaPdUXHt3oUeNV7ixOoHeyuN52q8pSAyZ7uf8yAW4w
         KG7VYd9yJj70kuYcRBGNkvyAlCEVnE8gS5858ecnpmYYsuYMLlgMZ4yQV2N8L9BMBHS2
         pZlKoQLeURSrNl/1HwUbklgLU3Hmhb4TUNnDKo9m9pHohywfMU7L36YZprApNuw4ih5M
         aHzw==
X-Gm-Message-State: AOAM533as7zmYcdf2H3u2e+YgBefbaMuN8O14IhVC7nBWwf6NJhx7OAP
        k6bMTQHdmWKspRq+FMQz33r9w5tvnQESKw==
X-Google-Smtp-Source: ABdhPJzuy/plNdToL1n/zsx2vZmiYfzV4JPm2BYBJhO6hvEWVK04NoeswNWqiXqrEOoSov9ZVL7bkQ==
X-Received: by 2002:a17:906:278b:: with SMTP id j11mr22238718ejc.438.1612269273415;
        Tue, 02 Feb 2021 04:34:33 -0800 (PST)
Received: from [192.168.0.10] ([65.18.223.249])
        by smtp.googlemail.com with ESMTPSA id ce7sm9371667ejb.100.2021.02.02.04.34.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 04:34:32 -0800 (PST)
To:     netdev@vger.kernel.org
From:   George Shuklin <george.shuklin@gmail.com>
Subject: BUG: missing man section for 'ip link' for type bond
Message-ID: <d0b33b09-73e5-e98f-07bb-41da5080fcff@gmail.com>
Date:   Tue, 2 Feb 2021 14:34:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

Man page for ip link is missing all bond options (there is no Bond Type 
section in man ip-link).

Those options are rather confusing and without man page it's really hard 
to understand that

'primary' and 'active_slave' are not the proper way to add interfaces to 
the bond.

