Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC33D373D
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 03:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbfJKBmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 21:42:23 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40093 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727584AbfJKBmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 21:42:23 -0400
Received: by mail-qt1-f196.google.com with SMTP id m61so11634834qte.7
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 18:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=KZQFrGRLwBHimX2BoXDCI03Om1cNZC8wfYiIaqtDi8g=;
        b=pn+TJzI6qOh/vBLExartYPHr4bF+Iq2YLTN87rDGnPlmzBHCYbhAoLLjiAl6FK0iBJ
         eiy+w8ua9fRbVZB53ipurplxMwH8GEOQsaTD+n0zdG3099JvTbpRt1gTHQzgulL1X5sT
         wj37OLL8tbCUqaefsEdXvMmk9MgQ16mR5ktSPANPTrCGRwik/jYn652dATTCf/9CHrTp
         V2gmGdMjjEmkFOKDs+HtFGq+BbLrW78HCKwhEyRupKviBn3TeXeknJGD0+mGMCYbKOYI
         Nw1QgNju4TawvU+RW0VSzD4xk0RVw66GjTUHHnb6z3NWg4RqMqvfxxuJTOmTlMG9H3EL
         ibTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=KZQFrGRLwBHimX2BoXDCI03Om1cNZC8wfYiIaqtDi8g=;
        b=l6LlRk0BH0m7KckN85E3dreHgKWaczJYLjl7wpWTZNQRd1mEevafxU/07H/ssYEUhd
         8a1DLkvYxgw0Bcg5/jSc+YbcV47VFxO7K1aMjA5cO5H7DzzjqMYWmTkRbWh1DgK5LxUy
         1X9YH3fXu9XvuagJ47ZV1ENLHoG8t/yNBAggLUq66ne6neEF5eFLxyu3Vv7+ZGa/YN+H
         MMM0ab9VytZaHCY6sMNOTQpw1CNi/h6Dmy5/mHU0prT6+m9/tQszLPOAPLX72ZVSM6EA
         z0AZw/0KPzzMWbypcWLjkukBRUMA9xILKA+elnGAoGKfmo3nit4AQUGptpArpKXOWeT3
         x/yw==
X-Gm-Message-State: APjAAAXzGheuKytAbERWTXHoTMMc03jj/AQZaAvtO3N39qKfAOLlsVLM
        QqyoTHvFlNmZ9kYwX4MVeWoV9g==
X-Google-Smtp-Source: APXvYqxR7Y8PY+KVbpXek0j97o6NEHHGGEiyEj5CgV5LgOAbA8RvjIc7gFI7aPxH2hesURul1nwebA==
X-Received: by 2002:ac8:1732:: with SMTP id w47mr14440558qtj.167.1570758142541;
        Thu, 10 Oct 2019 18:42:22 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t17sm5342112qtt.57.2019.10.10.18.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 18:42:22 -0700 (PDT)
Date:   Thu, 10 Oct 2019 18:42:05 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/2] ethtool: Add support for 400Gbps (50Gbps
 per lane) link modes
Message-ID: <20191010184205.32c40cb0@cakuba.netronome.com>
In-Reply-To: <20191010063203.31577-2-idosch@idosch.org>
References: <20191010063203.31577-1-idosch@idosch.org>
        <20191010063203.31577-2-idosch@idosch.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Oct 2019 09:32:02 +0300, Ido Schimmel wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

I can't apply a patch without a commit message with a clear conscience,
sorry :(
