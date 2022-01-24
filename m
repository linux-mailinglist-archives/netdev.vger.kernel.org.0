Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9164983F3
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 16:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240862AbiAXP70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 10:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240856AbiAXP7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 10:59:25 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D7CC061401;
        Mon, 24 Jan 2022 07:59:25 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id a8so22573499ejc.8;
        Mon, 24 Jan 2022 07:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SPs0KtT5EHl2Q5psmOSipZrVDwNuoDxsKSGua1QkkZ8=;
        b=RdvmKY2SX6Dc7mVF2/PBXqKKpRPhzXFKqeIK9MtiR2+F1OMWwBuoruQFz9THfsVwgb
         02ilngHJbbEuquM2o+YZRGNtVvWGbKLIqPcRYYxKxrzIY6eln6aBTSH7gvc3PYqS874y
         zgkN1ilA8HoOSJWPvM8r0HosIUupgDC4d6YJ0pqNWgvKf9kKC1hZGtdyybf2K6IYYbzU
         1obVxOJYtEY54Z2OKyXStk4SVyUby1yTmriyHZe9Bz5JpDuxS6+hyztjUMF2sZ5JSfk5
         kQfeIKlcO7qS//OpWCUFXrU21k1Gz2t8xqD2mZ3aI4ZabjKhubNswMj9r0HyQVQEwb5I
         UF6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SPs0KtT5EHl2Q5psmOSipZrVDwNuoDxsKSGua1QkkZ8=;
        b=zjv3Q49vSRvR9/q6czZUAwyUpzZhv7+XNGWYKyyZatba8SvYRykEAXZ15oLmhEHe77
         8aZ7HuP+cbJlwrD751wc5s6CY8RIvnLA8pLmou0t8RPJGg2GBw5xOgxoXSEOClwDHsEG
         ixFXs72tzBgjXNdBobTzBrVoRB4ZEUQtosNC8ybhjIsXYNu57w0w1Gu7C3MDiHQjSAIY
         mIfYP700/3LcKDZf5Wj5BPfmwNGm898QSNesoSuDVxUnTwsxCuBKMNr+3/5p5vNX7eyx
         hCWZAs38qEVQMmrB7bBksEY2smTUapysfdchxO8r9FRhx2e++gZxM4D37f1N5Wf9WmVL
         Li5A==
X-Gm-Message-State: AOAM531PbzfhaEz0nxNAGeRKEd9D9CS+1JMqD+9BS2Tqk1CMPSgRPyhL
        cWDP7fkrlncCyhdySno6Xds=
X-Google-Smtp-Source: ABdhPJxzoPpX2r+9GAjf3g/xLj8VkdDZO2uYvqMl49ymPQ2PZBOfbk8FxWoanenUcz1gdhVsF2tsdg==
X-Received: by 2002:a17:907:7ea8:: with SMTP id qb40mr6094701ejc.541.1643039963874;
        Mon, 24 Jan 2022 07:59:23 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id i3sm6741296edb.13.2022.01.24.07.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 07:59:23 -0800 (PST)
Date:   Mon, 24 Jan 2022 17:59:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v7 04/16] net: dsa: tag_qca: move define to include
 linux/dsa
Message-ID: <20220124155921.zhu3divm6brezjdd@skbuf>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-5-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220123013337.20945-5-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 02:33:25AM +0100, Ansuel Smith wrote:
> Move tag_qca define to include dir linux/dsa as the qca8k require access
> to the tagger define to support in-band mdio read/write using ethernet
> packet.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
