Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFBFAAF1CB
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 21:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbfIJTUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 15:20:15 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:42795 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727849AbfIJTUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 15:20:14 -0400
Received: by mail-pf1-f181.google.com with SMTP id w22so12109107pfi.9;
        Tue, 10 Sep 2019 12:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hjznco4o+Dn2VZDtAq/yGZeHT9P3y4uXRyWwDlemFd8=;
        b=uB/j04XhQy9gcrHHUzlehnhciEvTRORIgE4J0ndyecZLOjRjT4JajtKWu0kpxikJLb
         4x0zdKIAaQJJyY6xo+Q6dynLMyPqVALj+O28N3m4viFPVa0itRDwMK2gumJ4P6zvhu09
         CdqWKTse0HCe+UGnxTTsiiaBrWigEX/2yEFJxN5J16MHN6WgDftvBE+pUaZkvgE3TleZ
         reeDzRAtY5/ZbitbMLtwr4RV38mYXHagGLKhedV9tYv6ci7sodD3Q4w3xUJ9cp/30OwX
         o3a2ubGgld7rLJXMPxXIGEPr+xQ9CmrN0INuf2XXo71SoT2BpjnUUeNJconGN+QHztVx
         gxDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hjznco4o+Dn2VZDtAq/yGZeHT9P3y4uXRyWwDlemFd8=;
        b=VACq9D1O8PiEkyjIEkyAj74QtrIgBk8gyR5NLxTYST9bGxflhneOy0Yb73vVwWhHEO
         mH1c3Owd3ml2HLYewqOQ5xEBulVM5ZOqX8DsRZwBmmAxnwSWlC3A0SwUiCpdUI+KMpO1
         i22sWWO1OSjYyJ/p5m8Y3qG42zvFP/658lRlqKEJbCelOcG7msqlcFU9RLvb9OUCt+xR
         j+nWj4zVnaI8O0RIx9D4u1oRnO9nmln+E02Fct6uUuw0JJr+7GT20G45l+Cwioso0TRF
         tP/6maR8kNTvTBoh/r98yP2kKZgl/Sq6gydy1fiu1DH5Sh7U1mihMnDhP0IjlizwirsX
         EIPQ==
X-Gm-Message-State: APjAAAXQTSKxD9xeX/BWnlYpU7/1+WuLVBuB2wr93rAjtI1MtjJMiKWt
        HPiZ+ngpGnOJ+qh6e6vkq0dv0As5JCEwU86LnFVKHhK0
X-Google-Smtp-Source: APXvYqzJmobuOi9+anmfnVhmA7rIIzuih9Rauyz5oJFaz58VCah2upByYxS/NN7pthFXwoGIif2JPwZwKeFYg7Eq+/M=
X-Received: by 2002:a17:90b:8d:: with SMTP id bb13mr1226359pjb.16.1568143213885;
 Tue, 10 Sep 2019 12:20:13 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c1391b059237c3a6@google.com>
In-Reply-To: <000000000000c1391b059237c3a6@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 10 Sep 2019 12:20:02 -0700
Message-ID: <CAM_iQpVfOu4qzxRUaA-Sy3GB_bGO7PA_euLFNAk+v-z23sxW6A@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in addrconf_dad_work
To:     syzbot <syzbot+0055e43d6f67fb9b8ba1@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: sch_hhf: ensure quantum and hhf_non_hh_weight are non-zero
