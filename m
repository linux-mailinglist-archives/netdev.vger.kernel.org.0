Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64DE86B544
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 06:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfGQEDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 00:03:54 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38624 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfGQEDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 00:03:54 -0400
Received: by mail-pf1-f195.google.com with SMTP id y15so10147580pfn.5
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 21:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=qUVjvveLSFGTrCu0Qk1Ewt2MB9ElwIbfiXPxIfTt4TI=;
        b=uWjV80+YJret+2Y4NFU3lDDVJHNSxGEFGkDHEm55MsBWCb0KCEsIc9efGtUQQ5Yht6
         KDzbRX3pP/GMrGVTtrudUDBksjvSTJI6WVsjNqEhevRFUcXKfTR7cG82F97VVNdQ1tMQ
         w7TAXfzkWHIpzQvh6EsmuJ5gkHPoO6SquleRjLBvpJ0F9CMZTYlrxhbieBUrq+qy8uk/
         RVcfh7Z82UcNJ5s6VoHv6weIqOe+yXXrbqWWjiNIti+DGO5Ca1K8xCg2ZQMbqIls93Xq
         BemyGq2lQXkh4wMPK+QALn26RfpRsue1VpPYhx+pQrvWO3IYg1HNfq3N3rhXrNA/aWNO
         1L1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=qUVjvveLSFGTrCu0Qk1Ewt2MB9ElwIbfiXPxIfTt4TI=;
        b=uoCSwgOOBdh5viRXvldKwdG4yd4Hp2NCb3rP1+IOhLGwD2ixZU8tEPZmOZ1/lSzGOH
         Usn7IrD52JnCg9cFNpSqvs/KwBt1XhM3yfi/H5FgvCWOKGYH8uEzaC2LOinrKZvP8c3Q
         ZPo6uuxP1LYkFbDr7Y99lWzqLZaEliqdyAeoSwNQHde7ImtiaLjm6yyGa71/UePWb/tC
         MLBF/Ffe7h1myJ03+J62dNuPTATuqUG+GVyJVmMA6t1ugEg8tyq3oMlhlBqOKoLngHLU
         fzL5UCSzpknuw4zTcoi8GKLrh3EuW3YenodnD9MjAQFQX9N1Fkr5MwJ/Rw4pG8s7Jswu
         7++w==
X-Gm-Message-State: APjAAAXbXSDFn0osKpcFjmRqTK0DdfHm/xR4e7ntOcoJx//MZBVKYaYd
        BUc9aQlapIRmlnVAleEJiJsQiQ==
X-Google-Smtp-Source: APXvYqyH+bKbrPUmGxlyJ2ePuub+fczUhqnNquIiznL3eAQMyxsl+dqGDFUHOlPBFZkh26ZGo9UGAQ==
X-Received: by 2002:a63:6c02:: with SMTP id h2mr35890374pgc.61.1563336233223;
        Tue, 16 Jul 2019 21:03:53 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id b1sm21159707pfi.91.2019.07.16.21.03.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 21:03:52 -0700 (PDT)
Date:   Tue, 16 Jul 2019 21:03:49 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Subject: Re: [bpf PATCH v3 0/8] sockmap/tls fixes
Message-ID: <20190716210349.61249036@cakuba.netronome.com>
In-Reply-To: <156322373173.18678.6003379631139659856.stgit@john-XPS-13-9370>
References: <156322373173.18678.6003379631139659856.stgit@john-XPS-13-9370>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Jul 2019 13:49:01 -0700, John Fastabend wrote:
> Resolve a series of splats discovered by syzbot and an unhash
> TLS issue noted by Eric Dumazet.

I spent most of today poking at this set, and I'll continue tomorrow.
I'm not capitulating yet, but if I can't get it to work for tls_device
soon, I'll make a version which skips the unhash for offload for now..
