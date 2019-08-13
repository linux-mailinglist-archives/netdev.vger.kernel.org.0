Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9188C37D
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 23:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfHMVTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 17:19:30 -0400
Received: from mail-qt1-f178.google.com ([209.85.160.178]:40683 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbfHMVTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 17:19:30 -0400
Received: by mail-qt1-f178.google.com with SMTP id e8so7389082qtp.7
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 14:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=EFWQ4jRCEd8FDkIajgVLnR+9FJPAclCDJqxx4O3K6cM=;
        b=Uhqq6zLgUzH8NOnI6um+OvZlJTV4BOdsi9we2uNC6K9kKPpRJ/fKLAXMTOND4i58/4
         jUQeGgcoCwewV8FUpAKWd5CJPlt6G9tfZlDrFtQus00zfDwWbg19riTtLBj4XAqRG9Lj
         e6omlbWCvIA9q0rzQWEGDWrhCLNHK8xuAJ6t9XIY5ZxNghs4gn9Z4XhJmqcYQKxCFFK8
         HYYOaE/MHrthxHR8PaeSXpgrGMAsBQAYCRtzxsprE/JjO4hWMx5D3pSxLzZGbxTfes33
         uAIgEjcf+KZhxUqwgD07/+JNDvvmiutIWtHdbEpU4pSXxZLo/LHMK4n+w9Y2tWO8qM2r
         UqVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=EFWQ4jRCEd8FDkIajgVLnR+9FJPAclCDJqxx4O3K6cM=;
        b=sW2lR/7a5Da+TMJkBhdxyVtdfEqQLXE9MIa5gd/3bLnpwikqSPiXKk4QEOToyZTZjo
         5VBIQt1ys8jbbU2dpV3KTmF1t6jrjbnf5eYUHW8ZPjFwRA6GqVJdwb2z3QfKYkIv3LcA
         stz+mgwiEoqJrDTrm1B44DSzISzckQt+eW/AFDBmFvP3PkjrLg3hBIuYbeAI4HPhjktI
         YhlG6g1buZClo2kyFoUFH7Cvsakvk5jTTCOH7bJNC6c+IkEiF/g4oFpfTJw1ogkYrDn6
         xceV+aMer6Rj96LQ9tch8vBzezqKQADwy2OJ2dx4FpcXv1FPp21LPH/yASouRlD/d3YF
         i6Zw==
X-Gm-Message-State: APjAAAV0dqY8alQ2iSf82FUr5CUGL9HDoyfVvuC/9sqePBZi573awbGZ
        l/VGZE90exD0nfulkFvXf5fgyA==
X-Google-Smtp-Source: APXvYqx8AHPEuStN+ub7pm2zn9aiQcHCFLgI8UqHRNn5qyIpv84YbbRdbjZrRhAdb/Zul9jpQxkcRA==
X-Received: by 2002:ac8:43c5:: with SMTP id w5mr35103972qtn.280.1565731169195;
        Tue, 13 Aug 2019 14:19:29 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m38sm13989192qta.43.2019.08.13.14.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 14:19:29 -0700 (PDT)
Date:   Tue, 13 Aug 2019 14:19:18 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 07/12] net: stmmac: Add ethtool register
 dump for XGMAC cores
Message-ID: <20190813141918.1601a649@cakuba.netronome.com>
In-Reply-To: <3d860a78ce4e98941f7e292d251d7360755fdf2e.1565602974.git.joabreu@synopsys.com>
References: <cover.1565602974.git.joabreu@synopsys.com>
        <3d860a78ce4e98941f7e292d251d7360755fdf2e.1565602974.git.joabreu@synopsys.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 11:44:06 +0200, Jose Abreu wrote:
>  static void stmmac_ethtool_gregs(struct net_device *dev,
>  			  struct ethtool_regs *regs, void *space)
>  {
> -	u32 *reg_space = (u32 *) space;
> -
>  	struct stmmac_priv *priv = netdev_priv(dev);
> +	int size = stmmac_ethtool_get_regs_len(dev);
> +	u32 *reg_space = (u32 *) space;
>  
> -	memset(reg_space, 0x0, REG_SPACE_SIZE);
> +	memset(reg_space, 0x0, size);

no need to zero regs, ethtool core zallocs them
