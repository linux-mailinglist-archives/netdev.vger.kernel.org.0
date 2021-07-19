Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5EBB3CD08D
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235943AbhGSIkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235873AbhGSIiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:38:54 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165FAC061574;
        Mon, 19 Jul 2021 01:20:37 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id ga14so27544941ejc.6;
        Mon, 19 Jul 2021 02:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mpyf33A1sQVVQcz3IapdZfoMQHbi8kdYOp0EbZmfX78=;
        b=S6uDV/pnjhfUad+Fhz2AyaqUCoayLOP/g4IN8r0EfRR8oDvnRExLva/CukvdnO40sD
         vzR1D4Hb2LpIsgQshTDQ4mLFJ+uqxER2Wx5M5SXRWyIFAtODhKce21A8YdfgMfs7gkzQ
         0/yReZvWOoNZsjE2EoOFVhXr8lr/EYaq1fefKarutbYIcMY1k6W/UR6vShile3mLfoOD
         uWV4T9rvH8VuLHQFDS4JMqQkfNsGkY/JfdWHm9GDn3gL81TAqm5BjfhL6dIrHCTEfsfk
         zohUt/mzuM1r8/0tHVo+wakZRA10KTrNld40sJCrk0YTh/6oFIcV3DfXElkoOBqms2zl
         N2JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mpyf33A1sQVVQcz3IapdZfoMQHbi8kdYOp0EbZmfX78=;
        b=WvjS+useGugndyJ/snGFeRMlu33HusDfUugYIBf2oGDai6HUEQGsS2hFdNXkUAWObY
         AUSqHSStT04WbjIV1ddtUTUlSv56itNaj4lWKyiDyc+QABPRG97MDxiDVK8q7NySQLgP
         GGcupqMtgwNpgLkWvFJH6sf6QUpf/HfoyaH7p4a6+q87I7dUq9oc/ep+R0sm9Ne3RzQO
         TC40hU+ATKRbBTi9+KoQjAZHCNUDIGjahFdxQ7s2atZK443dnojPc/kOgMO5LvilvMuQ
         MPP0luUtq4XqFoxMO0LrpZpG05g9103Seem9k0o73GiQL0NAL0mdO3rYQ5hjhBU/9LaX
         10Mw==
X-Gm-Message-State: AOAM533TzqkMepILuMlXIH1ZxxnzApPtEMosc5IcSHHE58F/05CnULTK
        4ZqALm2B0WFMqRirCwpl+qE=
X-Google-Smtp-Source: ABdhPJyT23y0r4YXMvj0whLX3nD63SU+Q30IVtB8Af5zLWCwNoqBApEUY6EuVisVvgFJp4RSYXavTg==
X-Received: by 2002:a17:906:2a08:: with SMTP id j8mr25810993eje.449.1626686371909;
        Mon, 19 Jul 2021 02:19:31 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id jg9sm5611900ejc.6.2021.07.19.02.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 02:19:31 -0700 (PDT)
Date:   Mon, 19 Jul 2021 12:19:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, dqfext@gmail.com,
        Sean Wang <sean.wang@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, frank-w@public-files.de,
        steven.liu@mediatek.com
Subject: Re: [PATCH net, v2, RESEND] net: Update MAINTAINERS for MediaTek
 switch driver
Message-ID: <20210719091930.36l2zjlgngeq34wa@skbuf>
References: <49e67daeadace13a9fa3f4553f1ec14c6a93bdc8.1622445132.git.landen.chao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49e67daeadace13a9fa3f4553f1ec14c6a93bdc8.1622445132.git.landen.chao@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 18, 2021 at 02:14:20PM +0800, Landen Chao wrote:
> Update maintainers for MediaTek switch driver with Deng Qingfang who
> contributes many useful patches (interrupt, VLAN, GPIO, and etc.) to
> enhance MediaTek switch driver and will help maintenance.
> 
> Signed-off-by: Landen Chao <landen.chao@mediatek.com>
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Acked-by: Vladimir Oltean <olteanv@gmail.com>

Landen, please resend this patch properly (to the list and not as a
reply to the v1 patch). It is not tracked by patchwork otherwise.
