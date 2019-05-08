Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2388F178DC
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 13:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbfEHLuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 07:50:44 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43048 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727945AbfEHLuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 07:50:44 -0400
Received: by mail-qk1-f195.google.com with SMTP id z6so2598983qkl.10
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 04:50:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ILuFhvHSobbaZ61Z9yuK/cqA3RsgkCbpEkcFgIAzV04=;
        b=LFgY1KqjHrJzZMScdR6SwQDk/jHUCK+rkvTHmjMdaHQoRz05Jc3umpSkSUKgiM1Pno
         xtUGB81f/UgNMgWRxpUExKoHdzVlymVvKhYOLNyBeoHidVQV4Fu2tPDtln/S1aQqWwC7
         eashWqoIhX92850jM6XUIUtrMMrRhGCY+F36toPLJizpuE869nZJPLE5POHpPEnN2rxi
         Tibq+qwiXiaWS/M4wMAKCOLVy50wYCIsSh+Q4D1ZXKJeIGPj+LDBoky6GVmQAEiQXCNT
         1DW2vvNmnWcjuQbz4RglxFFWL/vkF59v0j01EWY4A33pzx1vTsiBpVyv0whfYy2G7MRl
         2Glg==
X-Gm-Message-State: APjAAAUE0teiP5sx7IF3aNSgrIsW6yDBWA44iMWzylb2uaNZOZt+XFHw
        jhsSoa2wFYF41DqUZFUR7/tdzA==
X-Google-Smtp-Source: APXvYqw/MWdlCkD4aez13QH65u02WSZBNk5ZO4nwkw4pcFO6/moSDLKhPxlAykIrFyRxzn7JLISyEw==
X-Received: by 2002:a05:620a:1449:: with SMTP id i9mr7104388qkl.4.1557316243422;
        Wed, 08 May 2019 04:50:43 -0700 (PDT)
Received: from localhost ([177.183.215.2])
        by smtp.gmail.com with ESMTPSA id k63sm8766688qkf.97.2019.05.08.04.50.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 May 2019 04:50:42 -0700 (PDT)
Date:   Wed, 8 May 2019 08:50:40 -0300
From:   Flavio Leitner <fbl@redhat.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] openvswitch: Replace removed NF_NAT_NEEDED with
 IS_ENABLED(CONFIG_NF_NAT)
Message-ID: <20190508115040.GR3494@p50>
References: <20190508065232.23400-1-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508065232.23400-1-geert@linux-m68k.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 08:52:32AM +0200, Geert Uytterhoeven wrote:
> Commit 4806e975729f99c7 ("netfilter: replace NF_NAT_NEEDED with
> IS_ENABLED(CONFIG_NF_NAT)") removed CONFIG_NF_NAT_NEEDED, but a new user
> popped up afterwards.
> 
> Fixes: fec9c271b8f1bde1 ("openvswitch: load and reference the NAT helper.")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---

Thanks!

Acked-by: Flavio Leitner <fbl@redhat.com>

