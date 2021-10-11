Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF48428610
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 06:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhJKEvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 00:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhJKEvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 00:51:31 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22BDC061570;
        Sun, 10 Oct 2021 21:49:31 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id g5so7410827plg.1;
        Sun, 10 Oct 2021 21:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=PJRPSmHOQxCp45UEkvrzfKi8Gls65lpBH+lWVNhdSr4=;
        b=j2+X13U0WS5BXUJdQ5J41WDAVk74/CaEjB57CEadeSHodbjZE5nWxdd9Yej6VyO8MU
         V08Ofu82n7qcZ43gQ1zpXsts1TpgweBbBJj0UJXDi6RPlwgkxL7XsU8Ea037YNAl4ojU
         PqbBJhLea1gNvIJRxnoJgrGAkWzUsb1jhUy4LYGbldSug0bPG2W4u/V7mOwGvb4dOQOT
         h2mIyihmRSjWSVWHDrlx/CLKsG1HlAFnLtJ5A7h5aJns2kNAgEv3JBVtGve3c9n4dVA/
         bqYcqt7olgFTZhhVEPiHs6Ylvj7JlVwxHwcaAeaXQPPE9RiBZR41darCbQi0AwwJN+oi
         V5cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=PJRPSmHOQxCp45UEkvrzfKi8Gls65lpBH+lWVNhdSr4=;
        b=IbAPfD764Y91aguDto2sWdbgslMOBYIGI6PntnVayQ7W0wdMfHSPQOFD/iNZaHLd8w
         xw84XP00JJUmTCWQkz3gmMqCsnky1wnCHhjEZNmIrM8CchtvdtNchq6IwliK6WWLlvwE
         BuCM8Ezs5q80Jf786pADccrl4K31fOgwcVLkLLOCH5S+ycA+Inap/9VRxuWKzc250hM7
         Zs2Z2EGnGpHUMHAKScZOI8BP4r8V/pqlDvnBmM0aIAxnlY91gJ90UEOMwMiqdr+nWynd
         iJu23fUxCMEWMwMwSxJBAwJLuniujkXGhHYizEB7Xyd2r+3jCfAQqwP9j9JQvu8ZD/B5
         AdYw==
X-Gm-Message-State: AOAM532h92JxhYiTD6pG83mrgtnHGWkErd2uQfsgSc0NwqeT5JWi4JTv
        WOXgpggVvev0N8/VGvue1WY=
X-Google-Smtp-Source: ABdhPJxx25ZKhM8mTGHSh7wU7+XAshVrV9AI6rxzfGxFi5ufDqLv22+h5uLw8+oMmX/QQ5YB9j9Prg==
X-Received: by 2002:a17:90b:370f:: with SMTP id mg15mr7215550pjb.209.1633927771474;
        Sun, 10 Oct 2021 21:49:31 -0700 (PDT)
Received: from localhost.localdomain ([171.211.26.24])
        by smtp.gmail.com with ESMTPSA id y13sm6657792pgc.46.2021.10.10.21.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 21:49:30 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v5 05/14] drivers: net: dsa: qca8k: add support for cpu port 6
Date:   Mon, 11 Oct 2021 12:49:23 +0800
Message-Id: <20211011044923.23063-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211011013024.569-6-ansuelsmth@gmail.com>
References: <20211011013024.569-1-ansuelsmth@gmail.com> <20211011013024.569-6-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 03:30:15AM +0200, Ansuel Smith wrote:
>  static int
>  qca8k_parse_port_config(struct qca8k_priv *priv)
>  {
> @@ -1011,13 +1027,14 @@ static int
>  qca8k_setup(struct dsa_switch *ds)
>  {
>  	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
> +	u8 cpu_port;

cpu_port should be of type int.

>  	int ret, i;
>  	u32 mask;
>  
> -	/* Make sure that port 0 is the cpu port */
> -	if (!dsa_is_cpu_port(ds, 0)) {
> -		dev_err(priv->dev, "port 0 is not the CPU port");
> -		return -EINVAL;
> +	cpu_port = qca8k_find_cpu_port(ds);
> +	if (cpu_port < 0) {
> +		dev_err(priv->dev, "No cpu port configured in both cpu port0 and port6");
> +		return cpu_port;
>  	}
