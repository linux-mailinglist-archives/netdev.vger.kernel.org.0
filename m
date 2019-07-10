Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 480D1645E5
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 13:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfGJLri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 07:47:38 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56186 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfGJLri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 07:47:38 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so1968163wmj.5
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 04:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KKoc2stN3HTxb5u0JfT4IcOuHwChF9CFxLPAfAhxu1k=;
        b=EXBTq4REEwg3fqNjhcw8ynGB72iSyVAxMzI7CFqICEwxpxYRl10U29hlUHSofkmm6+
         UcupZlSkilGxY1I98t/HgmuyN73T+V8NfI6V+Q7BElR21NBWicABMjZNK2Yy08HHsPU3
         +QIgozYo50NQOKmvzRjdhRGbe9MFfTNJhXJBNU9WFD+LPZUBoV1ET++SVaud3VkqaVFX
         cftp+FA3EgYVSE24GObGiH7UfRPcZejmwm3JzKE4siCkPnQghq39iL+gUMuqO74exlFQ
         O4A8Qc/YCOuLIwq5VIlHvL6oO/v33CC+lMnjWgNTxPG7wVz0IuS/npj5Jf/lxb4YQwBe
         yIIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KKoc2stN3HTxb5u0JfT4IcOuHwChF9CFxLPAfAhxu1k=;
        b=pYJiktwH67Qgd88hEdGlZiJ6MjQ/McNe3XQ7bW7xlYDuhqRccAgWLQb3VERDsqaDwj
         Vr6P+6POYNFsiNuwyLGwzwILC7O0n/Kl20LvYvOPoQrufldxuWQeMn45vo1lLLNavHc5
         fkVAF0ppkIExB19kB+b8lYF7YrqlNtTrysizXQNDLtydPJghEnJN+PVExLgQpQEYgh1g
         ahl9ZbIDkTQjKw2kmgNKT8iXyr1Ws80ZaaKNY8UguSWuHXIlb0Voo53R6VCQBwp/To1H
         ZwucJUQz0/lgNau3/LfingrlDI4wmKvY1JMZj0lKN9d4G7XDi8bVsQmAJYf6JjzQ6IUl
         DjxQ==
X-Gm-Message-State: APjAAAXqNcjM6R+CUsRunerVoha7OgEJ2tbpmbFrOHWaV1TWawKdm9Rg
        QqXzH3jQ1EsFVgQ3BJ4Ae9snLw==
X-Google-Smtp-Source: APXvYqyvlYBo4DfKro3iseYApcehu5C1R0tkYpp74ov+OhOUlDd6NRMp25mvBWroETE5Fh+z93tu+w==
X-Received: by 2002:a7b:c301:: with SMTP id k1mr5077156wmj.43.1562759256399;
        Wed, 10 Jul 2019 04:47:36 -0700 (PDT)
Received: from localhost (ip-89-176-1-116.net.upcbroadband.cz. [89.176.1.116])
        by smtp.gmail.com with ESMTPSA id a2sm2122705wmj.9.2019.07.10.04.47.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 04:47:36 -0700 (PDT)
Date:   Wed, 10 Jul 2019 13:47:35 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, moshe@mellanox.com, ayal@mellanox.com
Subject: Re: [PATCH iproute2 master 1/3] devlink: Change devlink health dump
 show command to dumpit
Message-ID: <20190710114735.GB2291@nanopsycho>
References: <1562756601-19171-1-git-send-email-tariqt@mellanox.com>
 <1562756601-19171-2-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562756601-19171-2-git-send-email-tariqt@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 10, 2019 at 01:03:19PM CEST, tariqt@mellanox.com wrote:
>From: Aya Levin <ayal@mellanox.com>
>
>Although devlink health dump show command is given per reporter, it
>returns large amounts of data. Trying to use the doit cb results in
>OUT-OF-BUFFER error. This complementary patch raises the DUMP flag in
>order to invoke the dumpit cb. We're safe as no existing drivers
>implement the dump health reporter option yet.
>
>Fixes: 041e6e651a8e ("devlink: Add devlink health dump show command")
>Signed-off-by: Aya Levin <ayal@mellanox.com>
>Signed-off-by: Tariq Toukan <tariqt@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
