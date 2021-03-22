Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D865344FEB
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 20:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhCVTcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 15:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbhCVTb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 15:31:56 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2489BC061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 12:31:54 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id ce10so23191390ejb.6
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 12:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JnguM+UozMrjIhxKZi5hjkgPUQVlY18Gu7gulBkg40g=;
        b=TgpPyXR61AZZD3VAyXolNtVRrKITQaSHtXXpLWA45+YO9/4B4d1ZH1MRNmtu3U8oa2
         o6oiqF4bOVz12pSKBPCwBDYIlde4zJ9efyP8Yrarnn/fjIY+fvPGZVEiSQE4FuWlIhJ5
         3bQxxgU+pvtlVlNBHjukILNRnt2uTpvBQtbaCJKHcP86q/y2pEljxOMwiAtCsFZq6Xb3
         2WLJmpjdrkwuETJHSAaBenmOifcov4NrJ2MRvLtL26Q2m6L7aJm41RNxO3z1ZCNCBXHs
         giJwsVYCpJIOjfoyplfrko5YjNArXLgki72NeRWjZBDt77VPwmjXxA9M2Q619FBzQsa9
         nK1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JnguM+UozMrjIhxKZi5hjkgPUQVlY18Gu7gulBkg40g=;
        b=s4Vpk9x8G9UyiTCQPgjLuGfJqsYiWo7g+wPHEyBR+pbruFtuZO07hYY75P3eudn3G4
         0Uakl7W8zC1nOj6PltP9mffSohJWzoT7yjPA1qeGWohhwjHU54X5m/BfzMKahX3IMg5g
         lgKZ7sQ3vValZJCh4qDr3IEV9Mruvsfj6edg46zsPV5qo64tGNQazHYuGb48LRjuVst1
         zuIdveKWUkR+6OLtUyyss1p/OJCIi9FRp6ypxgwIDKMp3xADPc7Da8cKhVitbBsyYqVB
         c+pUFpqS6YlXaGxLtaMAfpeW3j+ENlZ327FW39BVAWPV1n3Ji5bV/Qe6jtMihj0V0zRp
         biHQ==
X-Gm-Message-State: AOAM532T0oBHcjcNJ3Liz2URMSXVSfz4hbDqQTO0sVgM+qB+JREjk3Rz
        6kaxn19+dXOrl3tj/85ftv4=
X-Google-Smtp-Source: ABdhPJyfwis0z36wwLyUThCyujBhFlpGTP207PVyAVmEhxQLcGZwTlCB0lK4ozQt0hQsDdQ+W2W5aA==
X-Received: by 2002:a17:906:f296:: with SMTP id gu22mr1376212ejb.20.1616441512933;
        Mon, 22 Mar 2021 12:31:52 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id d19sm11862954edr.45.2021.03.22.12.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 12:31:52 -0700 (PDT)
Date:   Mon, 22 Mar 2021 21:31:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: dsa: hellcreek: Report switch name and
 ID
Message-ID: <20210322193151.ptkhcl5amzuvcyxm@skbuf>
References: <20210322185113.18095-1-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322185113.18095-1-kurt@kmk-computers.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 07:51:13PM +0100, Kurt Kanzenbach wrote:
> Report the driver name, ASIC ID and the switch name via devlink. This is a
> useful information for user space tooling.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
