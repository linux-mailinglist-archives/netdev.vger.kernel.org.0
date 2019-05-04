Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBCC1396F
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 13:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfEDLHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 07:07:40 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33710 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfEDLHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 07:07:40 -0400
Received: by mail-pf1-f195.google.com with SMTP id z28so4235375pfk.0
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 04:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=nl39g1T53hJKf6/e5lRm3PMMlr45uQylbYUKdQVwCZQ=;
        b=P3x+TuZjO/Tiiyl0gQtR335ZstOaMNPLqE/hLK7B2kqG7r2mekcmcVcn4e7G2UB1X0
         DoppWzS5KQ0cTy4uQGWi8NejpmyzjJlm3NZvFtW5+4Som8PwKpi2/rf6kT7r1kgjiwdL
         jtQRhcm8vpn7A5vRYuLPBlsjNDO7TgVyq7+EFF8SSGzYqsY2ZBj3qV6GaL+Ov1xpw2v3
         GbtR018SSuxz73HhyIG5AYrMdjV3UwwO/TRBPDi7ugEMLI8K4jM/RqIJQfbHKzGlZgam
         9HCVdI/V4zXJYv7uozm+315T8hn+AlvvwgPvDCkTWITP2g7fvNmdDuh5WzI8Q7kkN5Ts
         7+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nl39g1T53hJKf6/e5lRm3PMMlr45uQylbYUKdQVwCZQ=;
        b=d9TYjyrJE9QGnSPrAtloFK3VWKlxh5RL1nbSdePlo8cRIDenqAaws81RUt0MKubZtZ
         329ZlulXYDXXd9ky1ykpHo2aMHIEOI9M9pHH1HvTquhoZTmPzx2sqwc0SBTs/ziytpPf
         bwotzaCzrVg/GTryjxBECYZdIRHwOoJoV5eTOTW3NIYiXV8KOmP27IERcwykNF/YZ9lY
         uRHcHrhx7E3uczQyqMUXV5/JS2nhBF09RwtQRqv/bTg7yeSCmggWK2wcgQaDImHk4dWC
         gCNWCW3Lhc8LppoLg7G0M1Ah1cat0TZ15mU38cuiufp6vk4v3M3+tPZrajxqWlLxWKcn
         5mMw==
X-Gm-Message-State: APjAAAVdikq0IvLMRsOm+LOcDVDma96HhbFDqi60qQ4Z9pwpNVA8SKCD
        z46a6PnTYB1vM7fz0zuPXpVNKQ==
X-Google-Smtp-Source: APXvYqzsaN9URwb267F102CSdh+nIvxMj4k9Y3AWShpurEAK0b2y5Tak9/sA6WKLkkL2z1Vdv6r2hg==
X-Received: by 2002:a62:62c2:: with SMTP id w185mr18628880pfb.237.1556968059359;
        Sat, 04 May 2019 04:07:39 -0700 (PDT)
Received: from cakuba.netronome.com (ip-174-155-149-146.miamfl.spcsdns.net. [174.155.149.146])
        by smtp.gmail.com with ESMTPSA id j19sm5779633pfh.41.2019.05.04.04.07.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 04 May 2019 04:07:39 -0700 (PDT)
Date:   Sat, 4 May 2019 07:07:24 -0400
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] netdevsim: Make nsim_num_vf static
Message-ID: <20190504070724.439eab34@cakuba.netronome.com>
In-Reply-To: <20190504081207.22764-1-yuehaibing@huawei.com>
References: <20190504081207.22764-1-yuehaibing@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 4 May 2019 16:12:07 +0800, YueHaibing wrote:
> Fix sparse warning:
> 
> drivers/net/netdevsim/bus.c:253:5: warning:
>  symbol 'nsim_num_vf' was not declared. Should it be static?
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Thanks!
