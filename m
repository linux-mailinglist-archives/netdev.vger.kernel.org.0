Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBAE2543C4
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 12:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgH0Ka1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgH0KaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 06:30:01 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC4FC06121B
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 03:30:00 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id m22so6909938eje.10
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 03:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8kKhTgMT5cekaVxOj9I1WLLZYyRZDJbAJtYDZpXweIA=;
        b=UPnzOl1HXBGGQi8cRqe5IPgOwMzBBBrVlLaurD3q8q2BQ4If1t5HHb4ho5I8XWlruo
         4hKZHGNJNMIBw3P2pP3R4IrCZ4Dw0MmZ8YQBN7UYjBaob19ufFHtxRtYuvR+d3MtpmMe
         ib6PgNg4ZhR9RhYUGIcgfaz2v315tPNNz1R9lShAHrR7HgMBrAffzCLpsJ/7Ybg4XRgT
         7rTyqu5/95Mqql1ImgJU87QjV5FIa1R5x5IkbPDWza4A2RQBcXcks/goaDLpMKyqsURH
         8fq5JEQas0yQhlUtrnluRf/x0pPLgnCVbf1bhxsGmGZnavkM+cbjFotmtljEANR02Afa
         jeLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8kKhTgMT5cekaVxOj9I1WLLZYyRZDJbAJtYDZpXweIA=;
        b=m7kKpnBxkHtA2pei6+guRDwRCz6w2C81Wej3u9O4hfHpJ4sy2/bPULGRTQsuKzVaDq
         fTfcTD9ZkHnqY48/qB0wBdgj3XSPh6lnr0xuXyh/wQQKAhdzKixw6UOvOJ3OU3sObjSU
         cQs273KDWtl0d467yg/l4TIlm/asLoKLt2Z+6HFWMdgwk5ntMumvY/Me0mw+/C3hXYQn
         NRxR54y9Y9Sg5yxYx3/CeITiybc9e1iRuZFo1et5NmE2kKNTm+nuWH6ehSaNxpoMLJZ/
         wzNbGiPgDqtmYRxc9+FGuCR6i0XaOgSWXcbbeeQsqWfeUFVWng64tlwevZMay5Cv5b0h
         +ANA==
X-Gm-Message-State: AOAM5319Iv2Te4IAbImaYyJXJSxS1MBA7z2Rm0ATm9a8goJfwiRDTw4r
        dGurOicqJCfcNX0ZDQekfRA=
X-Google-Smtp-Source: ABdhPJw17zvdLShrCB5oICfBWRtut/2o7nEDTAQnhqWIL1K2uYK4BQuS51VaYxwtJLte3T/2CBuCNA==
X-Received: by 2002:a17:906:4089:: with SMTP id u9mr21071590ejj.235.1598524197004;
        Thu, 27 Aug 2020 03:29:57 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:88d6:516:4510:4c1f? (p200300ea8f23570088d6051645104c1f.dip0.t-ipconnect.de. [2003:ea:8f23:5700:88d6:516:4510:4c1f])
        by smtp.googlemail.com with ESMTPSA id r26sm1184625edp.62.2020.08.27.03.29.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 03:29:56 -0700 (PDT)
Subject: Re: powering off phys on 'ip link set down'
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Network Development <netdev@vger.kernel.org>
Cc:     Lasse Klok Mikkelsen <Lasse.Klok@prevas.se>
References: <9e3c2b6e-b1f8-7e43-2561-30aa84d356c7@prevas.dk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7a17486d-2fee-47cb-eddc-b000e8b6d332@gmail.com>
Date:   Thu, 27 Aug 2020 12:29:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <9e3c2b6e-b1f8-7e43-2561-30aa84d356c7@prevas.dk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.08.2020 12:08, Rasmus Villemoes wrote:
> Hi,
> 
> We have a requirement that when an interface is taken down
> administratively, the phy should be powered off. That also works when
> the interface has link when the 'ip link set down ...' is run. But if
> there's no cable plugged in, the phy stays powered on (as can be seen
> both using phytool, and from the fact that a peer gets carrier once a
> cable is later plugged in).
> 
> Is this expected behaviour? Driver/device dependent? Can we do anything
> to force the phy off?
> 
This may be MAC/PHY-driver dependent. Which driver(s) do we talk about?
Also it may depend on whether Runtime PM is active for a PCI network
device. In addition WoL should be disabled.

> Thanks,
> Rasmus
> 
Heiner
