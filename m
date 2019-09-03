Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6B80A6BE3
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 16:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbfICOwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 10:52:11 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38254 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfICOwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 10:52:11 -0400
Received: by mail-qk1-f195.google.com with SMTP id x5so2102745qkh.5;
        Tue, 03 Sep 2019 07:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ps+1qBIYP6KjmN8NHqV42MFrNx7S+FPkimZnp5acIJM=;
        b=H1gNxc0JLn3joY50JU2Pzk3TS3uT9gU0LFdRRE69+ngcrlSk9KMgl1XqvamadffXL/
         Nc/BBykO7P/Q/nNwqv27Il0NHH/tMdC6/XVfotrL8aWj4orUTxkF0cdaFFdNP0ogVlR6
         k9dxeddj1xhm01hoWJTNZXE7WCdkC2P2wcD7ScgMcucdpEgLmAUHEz/c3Z3N3lhHCyxq
         QL6e3RL7QDgaQ9L2dHlUfkDuV33nbnyTs7QW/Rq+R1Lss4fUX3GzpjvVnxkQ3J3fxhIy
         AxNw+lmZfk36GdCXUplQFj3J9kbmLHfiir19tduGVNw7NBjpdbgSJ3Kwm58oGRquixfn
         /8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ps+1qBIYP6KjmN8NHqV42MFrNx7S+FPkimZnp5acIJM=;
        b=Hkzg54u/B6E2eUUz/uUUfxJxgAqMqy8HB6wk/d5gjfk3Js6r6fVyA152ioo3QPhJEr
         V5H40XYb4FNMo7p8g/407HMLwwHe0um2KSCSlhUPg00v+0Ssxpu7UY2fHwBuyD8zDAc2
         Rx50WZayLMvEUESDEVtLB62+kpCrj0HXOR6jKVZjk9ezWbW9jhf2ByHR2EOzLevZPCqH
         qGnzp0oLL6q5/H1c/5rYT6/jut/omzO14lGPagOzSvvUB4LjZ6cpKQLr504p2ewRV09M
         nIvdlO8QXJrb4gAhY8ozAl6f0+lZJrScyaVGOtPX0V6zm05CIaPTFhLWwdWKiwn2v0F4
         x7rg==
X-Gm-Message-State: APjAAAWVimiKOgawQaE/F48gkhGhWUNz+oMkjPpeiK9DqG3SITFgh4Gl
        CND7pnqGAm2cHbj7+aRR6Ro=
X-Google-Smtp-Source: APXvYqyfJvk1FLvTIKPQax5aRgCZRm04gyo09ArgZmDwHWxKZZA1zWCtx3JvcimIROODb9XBFwPk6A==
X-Received: by 2002:a37:4ed8:: with SMTP id c207mr31794090qkb.99.1567522330103;
        Tue, 03 Sep 2019 07:52:10 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:f7da:37d1:dcc1:ef78:a481])
        by smtp.gmail.com with ESMTPSA id p186sm8727223qkc.65.2019.09.03.07.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 07:52:09 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id EDC8EC0A43; Tue,  3 Sep 2019 11:52:06 -0300 (-03)
Date:   Tue, 3 Sep 2019 11:52:06 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Baolin Wang <baolin.wang@linaro.org>
Cc:     stable@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com,
        davem@davemloft.net, hariprasad.kelam@gmail.com,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org, arnd@arndb.de,
        orsonzhai@gmail.com, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BACKPORT 4.14.y 4/8] net: sctp: fix warning "NULL check before
 some freeing functions is not needed"
Message-ID: <20190903145206.GB3499@localhost.localdomain>
References: <cover.1567492316.git.baolin.wang@linaro.org>
 <0e71732006c11f119826b3be9c1a9ccd102742d8.1567492316.git.baolin.wang@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e71732006c11f119826b3be9c1a9ccd102742d8.1567492316.git.baolin.wang@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 03, 2019 at 02:58:16PM +0800, Baolin Wang wrote:
> From: Hariprasad Kelam <hariprasad.kelam@gmail.com>
> 
> This patch removes NULL checks before calling kfree.
> 
> fixes below issues reported by coccicheck
> net/sctp/sm_make_chunk.c:2586:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> net/sctp/sm_make_chunk.c:2652:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> net/sctp/sm_make_chunk.c:2667:3-8: WARNING: NULL check before some
> freeing functions is not needed.
> net/sctp/sm_make_chunk.c:2684:3-8: WARNING: NULL check before some
> freeing functions is not needed.

Hi. This doesn't seem the kind of patch that should be backported to
such old/stable releases. After all, it's just a cleanup.

  Marcelo
