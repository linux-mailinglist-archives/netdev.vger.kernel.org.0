Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D67AF11EE63
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 00:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfLMXUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 18:20:22 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:32845 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfLMXUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 18:20:22 -0500
Received: by mail-lf1-f65.google.com with SMTP id n25so488079lfl.0
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 15:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=KMei8lYNXb0UTYHgEyCRfOWiAP70N/PbnvVS+aFEWFM=;
        b=fdu/Dh2m1ylz1omUQxD0S0JP86sdDn6nMCnnvflTW8c1CYwvL7wIkICsyVdGYbkgIg
         /bc3tKQcRpI9VuyCu3Q4s2ZU6MCCN1+RqN1Jbfz1x7RFs/aHWw/OqLB6qONf1e4g7vtx
         KFOiC4xpMCoAVK096G5pFfAukBpGYxx3FyqCatPU3D88nrWgKUduEf6Wocxo0VbNh/Ee
         8TYQ93d1JBJ67u7GS353y9GhrVbXdSPLvEfReOgGU9/uJ9d1RBJlNb9GFr8FMObg6zSZ
         552CuuuL/t3oMgLsHxE09cjHLpZG3LJDocHwYOG8+TEEQBDVqmJhWnWI2/MUOz6Lp/vp
         rWUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=KMei8lYNXb0UTYHgEyCRfOWiAP70N/PbnvVS+aFEWFM=;
        b=e6MF70vsPmZJpIHaeqlP9kjIvSeYSAY2nakK6buH4v2N30vQObksIEUUU4tfw148ZC
         +w8J9Psy2rU/FJPmjgrAgkvyujjxutWDyw/J8T6LEC27gA/c8zNDwderd/BP5cutaiwe
         Kl/jOPDTsmfC/PTJXGleS4+LaRURl2wxyhT8BxUNZtHxPHqvD6eWHp8xyjJn4vrMvj65
         8Jv2IGO3BCqQ/3OsJu/YjZHCnHGSV9Ofw3eexpR2T6csV8hxPmJ4ljwlgyE4DtWtlT5f
         h104knMUrY0o89gcG4oGhS5zUtjeSaq3z3+1DJhuRI0RsankHCIix+ucHq+5//JiURle
         b7rQ==
X-Gm-Message-State: APjAAAWdE3cuhyQ8DiX1r6bF64jMUNlLRihv4EtDd/raxRzkqWoMN6FS
        z8kFDJcLKWWAwN1mb+sntoYO7Q==
X-Google-Smtp-Source: APXvYqw6L+MMfJsKX67uPTGekmvZTiWrUu038dbRym8HtKNQf5aLcb7+/do6yCDqOACRzyWVFo0UoA==
X-Received: by 2002:ac2:55a8:: with SMTP id y8mr10181128lfg.117.1576279220067;
        Fri, 13 Dec 2019 15:20:20 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q27sm5626442ljc.65.2019.12.13.15.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 15:20:19 -0800 (PST)
Date:   Fri, 13 Dec 2019 15:20:14 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mailmap: add entry for myself
Message-ID: <20191213152014.365c70dc@cakuba.netronome.com>
In-Reply-To: <20191212175908.1727259-1-vivien.didelot@gmail.com>
References: <20191212175908.1727259-1-vivien.didelot@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 12:59:08 -0500, Vivien Didelot wrote:
> I no longer work at Savoir-faire Linux but even though MAINTAINERS is
> up-to-date, some emails are still sent to my old email address.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Applied to net, thanks!
