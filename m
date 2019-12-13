Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEFDC11EEAB
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 00:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfLMXoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 18:44:39 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41947 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfLMXoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 18:44:38 -0500
Received: by mail-lf1-f67.google.com with SMTP id m30so483520lfp.8
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 15:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ujtFYGAeMlCK434kJO5EVpXYT59nPKsME2GZZ2iUYlE=;
        b=xQig4XqXtXUC1zUi8SkaX1M/4v91WMZfz/Ryzh4jEVt+5LVo9UuzT7w7I0nAE8/DUL
         pMVSUyBnWKNmViRNzodArxmvKJGVGQA/jhhRzV2Uxx0HyBQ0O4oNpdEkQDmdBZZAFBJs
         Z8XS5nDTiFYPNYQ8psvF9l+MUMTDoX0ALwgOCQTa+EAjsutYpQcTpSElI57INLH/mU+h
         li+A9QoXMRwqx+CgUejaESoWm6a3YnctZveR2YTKjx73Dhr4qyh2UzkOmwb8E89YZH2W
         ggl0H+1pWTxqzPHwlj0aOCYLxJ7nMDtZpwMQSJFhzJnM+HJqwi1qjdYMlTKMk29jPsS/
         uGAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ujtFYGAeMlCK434kJO5EVpXYT59nPKsME2GZZ2iUYlE=;
        b=Kkl5/YAQSatajCvCb58AeZCaQJlObH/Ce6jqChumrBx35RyACEI0anyNUNVdgskEx5
         gg0VZQ5UELlyA5R8eSZcWY2qS4kOnjaYRQdImCeFe2UfxPvHe4reZnN4uy3aGrUrcWVJ
         u8nhFtK17IK6VA7S0X1jnYHcsXTQOmSsyQfSJsuatwJ/9l7OtFXrS7ksVJrmjleJaVMb
         eDMGEGspNyhz3rIB3LgZy7PsmYeNpWKXtkVOoV9qiTgSAZrgPxKYVuerZdODGlWvJTKi
         iCmkgog7SwLDTVkbK1NgcLm/rWlpxXi4F+rSNJViB4oAG03knALmL18knlP3peu5mbcK
         iD6A==
X-Gm-Message-State: APjAAAWaJiLo9Gu1kGn8sy38X029yIzbCD3Hu6S3pbGQjtym/ufrM79h
        XkgDg9SuzP9GW5nOcXaWHuzIFQ==
X-Google-Smtp-Source: APXvYqzrwYrqgU+Yo9IpDqD+LNJkC6/kogMETXIZs11SFg8pWGlGfHz1d3CIU0O88DCLF47mfpUwMw==
X-Received: by 2002:ac2:5a48:: with SMTP id r8mr10063012lfn.179.1576280676472;
        Fri, 13 Dec 2019 15:44:36 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c9sm5530767ljd.28.2019.12.13.15.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 15:44:36 -0800 (PST)
Date:   Fri, 13 Dec 2019 15:44:29 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Antonio Borneo <antonio.borneo@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        YueHaibing <yuehaibing@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptp: clockmatrix: add I2C dependency
Message-ID: <20191213154429.00ffbebb@cakuba.netronome.com>
In-Reply-To: <20191210195648.811120-1-arnd@arndb.de>
References: <20191210195648.811120-1-arnd@arndb.de>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 20:56:34 +0100, Arnd Bergmann wrote:
> Without I2C, we get a link failure:
> 
> drivers/ptp/ptp_clockmatrix.o: In function `idtcm_xfer.isra.3':
> ptp_clockmatrix.c:(.text+0xcc): undefined reference to `i2c_transfer'
> drivers/ptp/ptp_clockmatrix.o: In function `idtcm_driver_init':
> ptp_clockmatrix.c:(.init.text+0x14): undefined reference to `i2c_register_driver'
> drivers/ptp/ptp_clockmatrix.o: In function `idtcm_driver_exit':
> ptp_clockmatrix.c:(.exit.text+0x10): undefined reference to `i2c_del_driver'
> 
> Fixes: 3a6ba7dc7799 ("ptp: Add a ptp clock driver for IDT ClockMatrix.")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied to net, thank you!
