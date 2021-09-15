Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C3540C07E
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 09:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236518AbhIOH3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 03:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbhIOH3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 03:29:04 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F6EC061574;
        Wed, 15 Sep 2021 00:27:45 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so1544592pjb.5;
        Wed, 15 Sep 2021 00:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=thMhSIEdWTUJl9IoUdGM3OzXRfCqs1Gxmi00AN63wRw=;
        b=ad8Q8iiKl02jyaAub56UTFxhgXKILVN4/eM0ww77e/PvEgt+c9g60r8GZC09FkQ1qu
         ZEdWt56AhIPSIGmFNYDtXoy/ik+qfTEZMv6pEGqklkAZAAA974ZW4+PgrerELalHRGSY
         IxKuY8miz8GNHID87xXtt7me1yc6Xhkwd4SLt2v7Z+ZsRarNvUywg9JAn+1iT8/CJbJt
         KEa+eRvVHLokuGHE/jTY70Rq+6+r9DLr0AWYwBpi52DrIDkWO/Fwnc+D00Ss/6+J8Un2
         VCjCJBKIiF1YNJVWDrXf2zg4MViDv0pBCyixOaH3y6k6WX2x7vguz7KM9t8MznLDqg5S
         IVnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=thMhSIEdWTUJl9IoUdGM3OzXRfCqs1Gxmi00AN63wRw=;
        b=gg+vq+MFKJ5PtS1s4W+ZCMf1kqz7oD4RFrWOTWsqn6WYGfbaoC6po9dpwFsKPNklao
         C0x+E2tiEgDz8TDmFOwOfIZRv5nzEdnAifwUQepAbvgsD+yWj48k9sa/eX8gGUrps81A
         kmUFcpI7lvYFWxUKkyzxBjoNvDJYwESvS54uNcm7HXKprVyVun9oi7aIR9H6kIkEdfRD
         LjUPil/Senn8oJGhAYHUlrvMyrf81hwODv0oTWiHytBIirWphA1eaf9zzwbgoww4usuG
         F8P3lklQuKqhXP/q/MfIRFNzAV210jPE72AWrwDrG0r8vfSTPmYLMZpRpFFaxtMpdB1Y
         m0Ng==
X-Gm-Message-State: AOAM533eWS9ydNc91GEny+FNqGWLxnYC1b5mnUwZwMrKL3P72Qm5Z9bz
        t8b1ksmXUTvwaenRMLNlkmM=
X-Google-Smtp-Source: ABdhPJwxV5Tilsrl/Zw2RqRaXbHNnAL17sx2FJKdrfeqeNd9dle0NUIdHkc0wxVKVngSTEnge91kmQ==
X-Received: by 2002:a17:90a:fd85:: with SMTP id cx5mr6924149pjb.168.1631690865299;
        Wed, 15 Sep 2021 00:27:45 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id 207sm10064690pfu.56.2021.09.15.00.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 00:27:41 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rosen Penev <rosenp@gmail.com>
Subject: Re: [PATCH net-next v2] net: phy: at803x: add support for qca 8327 internal phy
Date:   Wed, 15 Sep 2021 15:27:33 +0800
Message-Id: <20210915072733.1494-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210914123345.6321-1-ansuelsmth@gmail.com>
References: <20210914123345.6321-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 02:33:45PM +0200, Ansuel Smith wrote:
> +}, {
> +	/* QCA8327 */
> +	.phy_id = QCA8327_PHY_ID,
> +	.phy_id_mask = QCA8K_PHY_ID_MASK,
> +	.name = "QCA PHY 8327",
> +	/* PHY_GBIT_FEATURES */
> +	.probe = at803x_probe,
> +	.flags = PHY_IS_INTERNAL,
> +	.config_init = qca83xx_config_init,
> +	.soft_reset = genphy_soft_reset,

How about setting .suspend and .resume? Without these, the PHY cannot be
powered down/up administratively (via ip link set xxx down/up).
See commit 93100d6817b0.

Off-topic: When is .soft_reset called? The MediaTek PHY driver seems to work
fine without it.

> +	.get_sset_count = at803x_get_sset_count,
> +	.get_strings = at803x_get_strings,
> +	.get_stats = at803x_get_stats,
>  }, };
