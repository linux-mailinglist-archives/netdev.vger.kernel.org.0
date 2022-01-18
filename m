Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3583949216A
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 09:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344721AbiARIlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 03:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344701AbiARIlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 03:41:24 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A803C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 00:41:24 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id x7so67670167lfu.8
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 00:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=KayE+dD9BOJPbBI3dzY5YWHtd7b0tO6VXGPUQ7A3tSo=;
        b=DCLSLN8WIBnU7Hxizbo3PUruGT2r/4vhs+wQQEEc2OOrewVjYLvioOSxRM7Nem8ruU
         qqv+iahul3Comoky8pxi/sCjrwsqsb4ZH7q4h+KVMzCZCBd1EUpEadQTuuOb9cvNYglF
         coVLRUBnbCLrdLK/Ho/sAy/z+fGIdn3FnsztK8vjNNvpQNG4+3hpBiETh6AYBi7AONNO
         XZP3Eaz5EsoMNt/6rWjplvGywTFKYBwr3Zt4BFrudrP4cer3QEpM/vHF+ncCMOJZOAQw
         ZkpB62Q8oaUz/Z7BF5E0/xascFRcZv465Axfu9pQj+iiX+VsTxvswI3sIpoViPSyIWla
         Waqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=KayE+dD9BOJPbBI3dzY5YWHtd7b0tO6VXGPUQ7A3tSo=;
        b=8ExH33AE9MM2VjBKQxLv6w4nSW25pyA9Wl9EUup3Uc5PIwgeeDqDPsh9x/itKXpKd7
         YRkeiyru7DB5KqbREKR4MmeVM0aX2gdEVNp3hlI8bs3a/I9OffbXnz1/J+nVEWLIGEy5
         Nk/ex9d+Af0IEemcuRO23xwSBEW2ilxjZc2VAbVAOnuS78n8ny1oUsC1Dp63Z0s5JLfO
         C6hW67fukNoEc8NdtTvTT3r5Iz+sjhJ8FpPJAaTexAZF3AmMrnI1rdR+odK+G53OiTEu
         7jxZWC6nsSY66djPNUlnOueGXaLkMQF1IZc+2EQHu+aJvaRDvdN4seQV5rReUSB5O097
         dHGw==
X-Gm-Message-State: AOAM532xsKJWasSfSBhypXvEt7MGMMW/kMyecyTSajKuEos3aMB5vSTT
        mhOVVMsCg93VozbwWgQynKQAy5BoDBthAA==
X-Google-Smtp-Source: ABdhPJwYYYw7AZR9dAg45TO/f05v2lVVcZQ6g00aO7hhIvX7+FI5r6NaI0qaM2apqWQ4D/SSaZVJxQ==
X-Received: by 2002:a19:5f51:: with SMTP id a17mr19365584lfj.122.1642495282602;
        Tue, 18 Jan 2022 00:41:22 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id k8sm779383lfg.1.2022.01.18.00.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 00:41:22 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     madalin.bucur@nxp.com, robh+dt@kernel.org, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net 3/4] powerpc/fsl/dts: Enable WA for erratum A-009885
 on fman3l MDIO buses
In-Reply-To: <20220116211529.25604-4-tobias@waldekranz.com>
References: <20220116211529.25604-1-tobias@waldekranz.com>
 <20220116211529.25604-4-tobias@waldekranz.com>
Date:   Tue, 18 Jan 2022 09:41:21 +0100
Message-ID: <874k61cu6m.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 16, 2022 at 22:15, Tobias Waldekranz <tobias@waldekranz.com> wrote:
> This block is used in (at least) T1024 and T1040, including their
> variants like T1023 etc.
>
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Fixes: d55ad2967d89 ("powerpc/mpc85xx: Create dts components for the FSL QorIQ DPAA FMan")
