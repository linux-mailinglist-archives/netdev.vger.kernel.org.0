Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25CDB139EE
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 14:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfEDM7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 08:59:46 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43563 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfEDM7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 08:59:46 -0400
Received: by mail-wr1-f65.google.com with SMTP id q10so2512650wrj.10
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 05:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7uGYdW0GHzKB4TE34vr14IoEUCscHunax3ZcieXxGk4=;
        b=eLh4WYBdlIV9jNoXjQoSzyzLP48/W97yk0HYfzPqCw17+9WPrLNrxWdOB2JN6EjFns
         0Bccg80X/WDinNdAkmlSsjLjEsFs6bF8MVz88KoNCcBlW769XyZFD2CEYdZaLL3pw+SA
         WzrJvGb4LDcDjPoLKaRfqFfwFkiqFlj2IiKSya5uNV1WSgQEH+AkedIDkXDaNptzWtAd
         nOSp62s8oeE3zjqvhvLJBrZu+yEZd23P1EqKcYHkiZDLg14BdF53WTWXmbCNDqrJgbpo
         eC8DIwcSOC/tdPtl1TcV/iBKanCi2/TAcCRXHJERzb6AQN2IcN7Ly6tnC61tGIG4qC9U
         BPMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7uGYdW0GHzKB4TE34vr14IoEUCscHunax3ZcieXxGk4=;
        b=eGNKriHSVzDu8DZ0S5TM/bn+4nss8zjm+Zb7pn84uwdrdd2CwU3z9RrJBgIA1Exf6O
         kVddRlKI9cvQEW0XAYdNduy/XKUjYDpzimvdvhhReiVd4LqJNONbg84Ol6dW/DfxzLPq
         aXXwD7xCqxMHXhS5SFZ8bfAKLUJiQYNnltNO0M6awn7HZxITFz4U8nprFIpTklVXGr1r
         OA1lZpDT2JvMIJCJhmlUWVJngxKo12t8ecCXjD122AoO8s5rs/9YxMmrg29durlmf89y
         lX2WTKMZD9yuomlqPSW9SDFhYncvOth4jx31LZ/Rf+wcvpiEKv9Rh2ipi2aAvG/76jir
         5iXg==
X-Gm-Message-State: APjAAAUnBO1etmDtL/cgD/xC+U4JDqSvrMVCvKl5QXCeLItTdNq6bzrx
        KllIhPZxPwEX//BiqkGi8dB7DA==
X-Google-Smtp-Source: APXvYqwiYn82kjt1epGeDL7rfhFUk0XsrNdXLFEnS4f8249K3NrdFJnD+DEg7AcWab4Z/KjxCluhSg==
X-Received: by 2002:adf:dccc:: with SMTP id x12mr11134799wrm.168.1556974784891;
        Sat, 04 May 2019 05:59:44 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id e5sm3468376wrh.79.2019.05.04.05.59.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 May 2019 05:59:44 -0700 (PDT)
Date:   Sat, 4 May 2019 14:59:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, xiyou.wangcong@gmail.com,
        idosch@mellanox.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, gerlitz.or@gmail.com,
        simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>
Subject: Re: [PATCH net-next 03/13] mlxsw: use intermediate representation
 for matchall offload
Message-ID: <20190504125943.GD9049@nanopsycho.orion>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
 <20190504114628.14755-4-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190504114628.14755-4-jakub.kicinski@netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, May 04, 2019 at 01:46:18PM CEST, jakub.kicinski@netronome.com wrote:
>From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>
>Updates the Mellanox spectrum driver to use the newer intermediate
>representation for flow actions in matchall offloads.
>
>Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
>Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
