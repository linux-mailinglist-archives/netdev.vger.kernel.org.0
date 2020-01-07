Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A03132A39
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 16:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgAGPmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 10:42:25 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43300 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbgAGPmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 10:42:24 -0500
Received: by mail-pl1-f194.google.com with SMTP id p27so23335071pli.10;
        Tue, 07 Jan 2020 07:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mOKAUWML1TFTWaJ7wVdgP8BJ4Cjz8s+9gtXGI6Ex/jk=;
        b=gSW7HO4pTdqJxlWVKCR6uhC6jdezVM9/xLJYNkDAbKHsfQnU2Bksu127W3XS1FH0NP
         MjGwlvOUDUOY7W8PL3RGhQt857tc2SA98S0w0pminHY6s4pVzjgXG8V9zF7Yb5LYOEgA
         +Ci7RaZfP4MSX9kP/OAoqqzMnsHIg0B3iyvQFrCOY7rvwAztaVkBadB34g7JBF1lWkzG
         Q+pqOxLIXkknIc9CP7QrVRtpK4N528gW6wV9ko9n8h8esaOebmAr8gu4VsFUiWAD+YJb
         pZmDkVkH2Uh5M7YAv6n4or5zr9KL04ETPHtqqi7wGwplDUS82kU6kOxZ+x9rEPdSE5yD
         DMJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mOKAUWML1TFTWaJ7wVdgP8BJ4Cjz8s+9gtXGI6Ex/jk=;
        b=oRTT7kxSOSFs55bsohbxbShVaaB6ozarFodw/u3sBq5gwToFxhmVTOSubZgc08oW6Z
         Ysc2rS8996LTCDoAnKL/+funr33qIFbXJxOSWat37yhphpDUG3admSoZPTHXMztnb6Ra
         4QW78Xg7UsMHguDGNXtQ6wCEomyu44VDj3CsU6ziACMqP2b/l6Rcnkt+IVUXE9zeF4yA
         chJuQA5T9I/WVEaX+JuWV7wEigqUm39jN4/ymlGvIB9haF9lhJU0/zYhvpNC1e+0WNKj
         tuCWnZNXzV92uhSz9YvfAAxPiGcKsTaFg8PIvzaF2hogdi0iafLJqbSlVJCloohyKXVN
         Sfuw==
X-Gm-Message-State: APjAAAVOclqHsffmNitzm3cyDG9Qn94KLWbrZLIzKmbAAnneoMN/SZHI
        c/uv5CsVNENMgb+uXBpVcmI=
X-Google-Smtp-Source: APXvYqzjYtn6/YzemGIzVUvI2cuoJB3lK2QEiULmrIBAz8zX6VTg45Sni+wFU8KjnZOEKfD9mOElDA==
X-Received: by 2002:a17:902:7209:: with SMTP id ba9mr289009plb.118.1578411744231;
        Tue, 07 Jan 2020 07:42:24 -0800 (PST)
Received: from localhost (199.168.140.36.16clouds.com. [199.168.140.36])
        by smtp.gmail.com with ESMTPSA id v10sm141764pgk.24.2020.01.07.07.42.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 Jan 2020 07:42:23 -0800 (PST)
Date:   Tue, 7 Jan 2020 23:42:21 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: networking: device drivers: sync
 stmmac_mdio_bus_data info
Message-ID: <20200107154221.GA28873@nuc8i5>
References: <20200107150254.28604-1-zhengdejin5@gmail.com>
 <BN8PR12MB3266661B136050259B5F7FD7D33F0@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266661B136050259B5F7FD7D33F0@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 07, 2020 at 03:16:10PM +0000, Jose Abreu wrote:
> From: Dejin Zheng <zhengdejin5@gmail.com>
> Date: Jan/07/2020, 15:02:54 (UTC+00:00)
> 
> > Recent changes in the stmmac driver, it removes the phy_reset hook
> > from struct stmmac_mdio_bus_data by commit <fead5b1b5838ba2>, and
> > add the member of needs_reset to struct stmmac_mdio_bus_data by
> > commit <1a981c0586c0387>.
> 
> This will file be no longer maitained as we are moving to RST format. 
> Please see [1].
> 
> [1] https://patchwork.ozlabs.org/project/netdev/list/?series=151601
>
Jose, Thanks for your notice, abandon this commit.

BR,
dejin

> ---
> Thanks,
> Jose Miguel Abreu
