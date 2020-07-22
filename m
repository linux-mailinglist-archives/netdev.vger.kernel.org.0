Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D834229AEC
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732644AbgGVPCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730382AbgGVPC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 11:02:27 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DBFC0619DF
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 08:02:26 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id f5so2821145ljj.10
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 08:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=PihvrkcIdS9+OJBOnU38h7yqxzd2Wqd+kwsRkrJ6J2Y=;
        b=RNHbSFFPJwnAFASGuINzCqJII/5IgjdU8e7BUEvXcf1eqAmEktuEVJKVESGGzgK7Ys
         h55rvylSRZ9KlfZdAbq+Avva/GTpLfNS+WhPzIrOCUAaAaKW5qq6UYU+gy9HXm9Quszp
         KmDuDLxKfGnkDo9egr99I5bqA97enE6crWenk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=PihvrkcIdS9+OJBOnU38h7yqxzd2Wqd+kwsRkrJ6J2Y=;
        b=rwMzcl79SNh4y32uom07mwAd1GnAp7fNGjzZc0VVhMId+Ik71fxnkrobjkX43hxuUG
         89QJrvSpC81dvu8nwlcWSSZa2dYnQ0oBqtqjW2tQTe5eJ+iti9k5z7lrabo0rNRu+HwV
         LiLhySvYtJFFf1JReHMqSfXedq8jMNSx5u+XR4N6RwIrpt4I5/pLslF0aU8lllFiJjRe
         pu05qIRy0S9ofOayx1nr/IjNUonz98YkT1rORORp4ePDlVhoccosu+l/3fNEHHPi0Zdq
         ApXhOQe+RwRfHEoW4eUXd2wFxlZUF6xN06cHCXvtA3INm2DqlKfs1y+en6kjcJqb6qzU
         6l4g==
X-Gm-Message-State: AOAM531jgpNSSau0K5GE/AxLL1lt0CglRe5pAo4iAVGJ8Z1dobFyX1kF
        IOdQZApIfZNW92rbUFETojkPrQ==
X-Google-Smtp-Source: ABdhPJyDawdPxmJ6OAHeMXj2O5Vbp5F3TvglkcvQxvPpg0TysBMH3BD+mhxwlvotlSwEljW6jSKHGQ==
X-Received: by 2002:a2e:9b8d:: with SMTP id z13mr15240620lji.463.1595430144039;
        Wed, 22 Jul 2020 08:02:24 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id e20sm123227lja.137.2020.07.22.08.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 08:02:23 -0700 (PDT)
References: <87wo2vwxq6.fsf@cloudflare.com> <20200722144212.27106-1-kuniyu@amazon.co.jp>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kernel-team@cloudflare.com, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, netdev@vger.kernel.org,
        sfr@canb.auug.org.au, willemb@google.com
Subject: Re: linux-next: manual merge of the bpf-next tree with the net tree
In-reply-to: <20200722144212.27106-1-kuniyu@amazon.co.jp>
Date:   Wed, 22 Jul 2020 17:02:22 +0200
Message-ID: <87v9ifwq2p.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 04:42 PM CEST, Kuniyuki Iwashima wrote:
> Can I submit a patch to net tree that rewrites udp[46]_lib_lookup2() to
> use only 'result' ?

Feel free. That should make the conflict resolution even easier later
on.

Thanks,
-jkbs
