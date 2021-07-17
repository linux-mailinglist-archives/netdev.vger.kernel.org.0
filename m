Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FD63CC440
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 17:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbhGQPsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 11:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234432AbhGQPsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 11:48:30 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382ABC06175F;
        Sat, 17 Jul 2021 08:45:33 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id b12so6957770plh.10;
        Sat, 17 Jul 2021 08:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=Hfi96rlmPe+R59fiIJkywQN9f0GSoIHlsAihgcSK3F8=;
        b=p0WCreKSpGz6knWvIZiZfC2UOx3oK/hunPjr/MwSGARdJRT177f9xnwck0etUuSFZo
         QPwQw67I3G7QJUHJ7UXpZDP0bbK+FXGP6fbQ40n7iAxZXd9GA+WAMqA6rikj5zt9MaRz
         gHuPLoo3Vn7HQ7DOhJQy+waYc+iOnO/addgeXq5NlC/EqeSftrdawqtCwPT8/Uut14tB
         0kDiQxiZn6+9rrra19C0HAxZtjKPW+CAL0dEt7LkmAeuJ/D+TxGVH9SvuNaBn281qJ2L
         xJT3CUR/juyC2c9tYC8YjRUihMds2Ppa0aB4Fl4ylH0PmCxo/v+fjbW+0X3ZfXyWnNP9
         DvJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=Hfi96rlmPe+R59fiIJkywQN9f0GSoIHlsAihgcSK3F8=;
        b=USoKh841r3haIJhuVaGYO6zg8TTA4EECy5qQDUNtSDru3xi5ox1xYrpznnZMRnOSuR
         eabBbYDbFR7dpdn+D3pRC22i14M5sksMdSLY5YE0LjBx/lxmGn7j0yvM2f0AYsxy3dWU
         kVkO8oCmqUrgTMRvSRFYyspy0dBpaeCCBmldxi7iAAOYezUzTVk7sj2KafVwO5PuKgUj
         Ap8fzcGhUi+awXX8AXoPIbUBrvLKfrw2+hFktWRwLxmPvJaAoqOTcU52tZuzZWmETjTs
         f0XtVWGay0IK50HeViLsu8F24sBc67k2A7F0gm/Mt7TmDZBcMVkKTXUaI1FlkTFO3ZM4
         0Thw==
X-Gm-Message-State: AOAM531hW+a0jxksxus9E4VulrgDn7y8R7L6eKh3QpEhcQf99IaFYyCR
        YTYKF5EKuTfM9NmUjEDedAI=
X-Google-Smtp-Source: ABdhPJxW/N+e0Ct6YYUm1eqepLMt+QYVM4f/p1pqdyZAgzfPuSR/vAlxc9MSQA1vjFMEjhsWJet0Eg==
X-Received: by 2002:a17:90a:1d43:: with SMTP id u3mr21335921pju.121.1626536732650;
        Sat, 17 Jul 2021 08:45:32 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id h8sm13212826pfi.47.2021.07.17.08.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 08:45:32 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, frank-w@public-files.de,
        steven.liu@mediatek.com
Subject: Re: [PATCH net, v2] net: Update MAINTAINERS for MediaTek switch driver
Date:   Sat, 17 Jul 2021 23:45:23 +0800
Message-Id: <20210717154523.82890-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210601024508.iIbiNrsg-6lZjXwIt9-j76r37lcQSk3LsYBoZyl3fUM@z>
References: <20210601024508.iIbiNrsg-6lZjXwIt9-j76r37lcQSk3LsYBoZyl3fUM@z>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 10:45:08AM +0800, Landen Chao wrote:
> Update maintainers for MediaTek switch driver with Deng Qingfang who
> contributes many useful patches (interrupt, VLAN, GPIO, and etc.) to
> enhance MediaTek switch driver and will help maintenance.
> 
> Signed-off-by: Landen Chao <landen.chao@mediatek.com>
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Ping?

> ---
> v1 -> v2: Remove Change-Id.
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bd7aff0c120f..3315627ebb6b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11588,6 +11588,7 @@ F:	drivers/char/hw_random/mtk-rng.c
>  MEDIATEK SWITCH DRIVER
>  M:	Sean Wang <sean.wang@mediatek.com>
>  M:	Landen Chao <landen.chao@mediatek.com>
> +M:	DENG Qingfang <dqfext@gmail.com>
>  L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	drivers/net/dsa/mt7530.*
> -- 
> 2.29.2
> 
