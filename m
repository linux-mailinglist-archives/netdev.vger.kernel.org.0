Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD173DDAAA
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbhHBOSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237714AbhHBORM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 10:17:12 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FE6C04984F;
        Mon,  2 Aug 2021 07:00:50 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id x11so30137135ejj.8;
        Mon, 02 Aug 2021 07:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1Za1Yj9NjOylf2JMkcBxcOLagUVAwLPeusWL40lZlvQ=;
        b=MSGxR1uk7XakGmBg8RmnXvyK+9XAw3uOmK5Gsan1JlNVQR7Jhno7DDrsx/b/jLMTLs
         lm0Q6Pr2wKLfbgm2wpBnqrmetXUDpzTlEH/WSfxUwqHfD9Tc8e4HNgSotM+ptcT8jkFU
         uBXRHi9S1qZxzDCUT73n3knQAfcA/vuYS+/RWBbU7lWUcUHXyd1pzBgXBY8kexmtFtc5
         opfsXTOD+5fwJXVwQrayavSWnhwbcg3Ii6ZAVxLSYo7JqAuHgH93VusKI/ReNK3yoOxh
         aTCH1pqsWXZRQdoyQTCyhF+4QqnVAg61RKAOibqnkofWQ/E2WGhcAcXRReoV9faA2TyX
         2nFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1Za1Yj9NjOylf2JMkcBxcOLagUVAwLPeusWL40lZlvQ=;
        b=VybDHjJT/hYIOu9FFKme9q6lHYyngymABE0lruyKgrRy1xoN7Um1Oog86hMLMgaB+H
         UnhblHAlHpt8agCz6q5+zI1jSau4SEqpTGZl/DqeJEomVu8459mCqcpoJFQhP0jeZrU4
         DnG97iN6+Qcue9RCd1U5uUK8OSDWginKmgYSCZRzQwzDEw01ozENLdkY8+M21Mfg6FTe
         FV5NSjDQ2jAU0kSUaGtp0NX/5a1nKUL0eZGsY3TP83N0lTqpE08R8Uufzj1N7PZk2bl7
         5Y6aBRrw3S1EO3sffNx3ru9V/UertZszmJ19k15qUbhZ1atzIdpUGddhiiFg1wx2fgLR
         8S3Q==
X-Gm-Message-State: AOAM531q7PN2xaBVA38kbbvUzJshJIZfjuhd+ai/fRH6mS1xctqQ2XTJ
        08PMjnS0r7K9DXga2JQsX14=
X-Google-Smtp-Source: ABdhPJwmc3U0XGaiP4J/l7ORgTTqgzAjE7GqluO8BvZQx+46vEUHJ1XXO4CAuCJ9aLlCbQQgtaQ0iQ==
X-Received: by 2002:a17:906:40d5:: with SMTP id a21mr15739258ejk.325.1627912848843;
        Mon, 02 Aug 2021 07:00:48 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id oz31sm4567170ejb.54.2021.08.02.07.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 07:00:48 -0700 (PDT)
Date:   Mon, 2 Aug 2021 17:00:46 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/6] net: dsa: qca: ar9331: reorder MDIO
 write sequence
Message-ID: <20210802140046.locxzehdjdw3cjua@skbuf>
References: <20210802131037.32326-1-o.rempel@pengutronix.de>
 <20210802131037.32326-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802131037.32326-2-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 03:10:32PM +0200, Oleksij Rempel wrote:
> In case of this switch we work with 32bit registers on top of 16bit
> bus. Some registers (for example access to forwarding database) have
> trigger bit on the first 16bit half of request and the result +
> configuration of request in the second half. Without this patch, we would
> trigger database operation and overwrite result in one run.
> 
> To make it work properly, we should do the second part of transfer
> before the first one is done.
> 
> So far, this rule seems to work for all registers on this switch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
