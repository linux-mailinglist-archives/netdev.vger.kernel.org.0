Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7AD331B6
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbfFCOGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:06:50 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35478 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727429AbfFCOGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 10:06:49 -0400
Received: by mail-qt1-f195.google.com with SMTP id d23so9497157qto.2;
        Mon, 03 Jun 2019 07:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=w0yLxHsJbslcMzLy0Jrz5cje+O40mj+d5C6nq83ERwU=;
        b=ChD59yD9/qIzeEuVlUgYr2kRSQ9PbfaWhcD5fnO+KiGTuddcC5pRQoujkh62lznFgP
         hNcyQ9IQdMIoO10XtaTnZqOuE6F2dBlRDFInLgf9GDqBTtM24UfQfI2oaA/rRdbITp0R
         jNMe7P8w+GziK4xae1Zd5C6/KJzWqEhY2abvLttllgizoIIsE1Z7QYynT94m8dUQaA5v
         fsY2fvH0XVY7Uh9vWtnzuyoz1AGTXCSXFOam8TsFNOYw8TYMNapgV6rQBZ4/wxCfmcZp
         AiFb5gfSU6Bac4XIXULFDhpss+BYhdcIWY5cZXpmHOWi7ADZ0aA6UxZxCJs6zZ0eX6hC
         74pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=w0yLxHsJbslcMzLy0Jrz5cje+O40mj+d5C6nq83ERwU=;
        b=JWEEOsy9n8aY/ltmn+XF8Y3D4OfeeLKyp302wfDYMScDH0QXsmYLt9KFJ5I22jS8R0
         j1eejW3kn/Ny+fM0QBlF1Oa7jjZrTVY90LEoZlU655tUtReUbCsY0rfsIDlvwUnHvdHL
         oE12+FCR6hYKAs/lD6ZhQhcfnQLJqqtrL4lX8GF3lFid8gDYHNNJ6MnvoUnNVqKRAl/L
         RYJaezaHzSxZMxIa3IH+VV/Dqur7AHJQkZq9JT8h07ugSNtQQBSBq/1tD68NNDah4eGh
         8DWhrZrcKwefbkzw0yN1G2q40KIJenAOL1wUl1qPBDB0PgsrjYkAqqiiENB6ZTUT5xU0
         KMrA==
X-Gm-Message-State: APjAAAUDERKd4d6pTzhb+Rf0cRCEdmkmUIg143/cBZxu5NwoOZya1lWn
        ExdtSCu/96d58WJIz7eFHqA=
X-Google-Smtp-Source: APXvYqziBLGPBCIt0cGGZ1Et+8pXyaqkKcyQhRU8Xuf++2BUZTmer3I4dlqCHlrvLfdA5HU8PxuG2g==
X-Received: by 2002:a0c:fcc6:: with SMTP id i6mr11503970qvq.109.1559570808758;
        Mon, 03 Jun 2019 07:06:48 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id e133sm11586087qkb.76.2019.06.03.07.06.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Jun 2019 07:06:47 -0700 (PDT)
Date:   Mon, 3 Jun 2019 10:06:46 -0400
Message-ID: <20190603100646.GB22742@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: make mv88e6xxx_g1_stats_wait static
In-Reply-To: <20190603080353.18957-1-rasmus.villemoes@prevas.dk>
References: <20190603080353.18957-1-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jun 2019 08:04:09 +0000, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> mv88e6xxx_g1_stats_wait has no users outside global1.c, so make it
> static.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
