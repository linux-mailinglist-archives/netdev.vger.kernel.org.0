Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC3D6EA43
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbfGSRh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 13:37:26 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41648 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727577AbfGSRh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 13:37:26 -0400
Received: by mail-qt1-f196.google.com with SMTP id d17so31772506qtj.8
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 10:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=md74l1tP+3MjgDMecOFujGhSYnRDKsU/DGj+r4fcaKA=;
        b=o0Or+ROwXh+YLyB2aEGTFyHtfesjXiXIrpdbAQngHhqLThjapIYUAKcKkSwpSvvl0C
         6Bb7CdHSj8RIZVo9EMGHiHAwtG17xnYj8cEcTIPN9dw1lVp8Zj98kld9AjS6rancgC95
         h6iu/SBUsb6MNuXMSoJ35lfRyq06SMeSxnmKjahz/szhJUZbIg3Cz9QxhDwmcAfhwtsK
         PeZrXA9EGYXyqOYkZPdiXFeSX+UTHZppUXB9BhbDxL6Wc29cBH56F5wtXszmV0r22vKE
         EY04IV/7FDZDKevCpYxfbMtqtThoMmWe62dDtELeuw19XspEjp60gxcV8OYubnS4OKlS
         jgOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=md74l1tP+3MjgDMecOFujGhSYnRDKsU/DGj+r4fcaKA=;
        b=KVQdo/JO3hjYFieB6ZckZJ047ZuDquHJtjrYRylNi2akULMGKedq/pf4aFu4bnjIU8
         VSokK9LY7h0Wwy94BoHgSLUU6DVTOz6Li5bQ9JrBtVd4xBjKWJKtAVUgyfaaiogy3Mzc
         7E6m23GLhvNDvhNe8Gtg8s+SLlFYE8F50Q1otYPQcetftmQZavKhXGfH4/Ip8ecACXM4
         SIZX5tpUnY5WoDzAytami+SWuMzcZFR5h03F3/Rjrpp3khIlBQvcKWFESl1LTDW2btSo
         3bpsfA/oisytKbGV1M3msOHw/QSTi6KChQetBjmtSqYZWvpnuRgNIPmy4dJCThJGq0SB
         4ZzQ==
X-Gm-Message-State: APjAAAXhQwnqqgTvGAOuP2XpMarQgDoqRiGyogLnGs93vqF/Kt0wQNog
        J3pZYyMcmJdYDw+v9yk6YIUXew==
X-Google-Smtp-Source: APXvYqxdzwTKTjLFLIHtd2+PRC5rnYBA36IJhJcYj1ZBcnYvlY4HaoSFJLg5LS84k7nO7zA0WHFzbQ==
X-Received: by 2002:aed:3e96:: with SMTP id n22mr32894870qtf.247.1563557845634;
        Fri, 19 Jul 2019 10:37:25 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z33sm14605101qtc.56.2019.07.19.10.37.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 10:37:25 -0700 (PDT)
Date:   Fri, 19 Jul 2019 10:37:21 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     edumazet@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [PATCH bpf v4 00/14] sockmap/tls fixes
Message-ID: <20190719103721.558d9e7d@cakuba.netronome.com>
In-Reply-To: <20190719172927.18181-1-jakub.kicinski@netronome.com>
References: <20190719172927.18181-1-jakub.kicinski@netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Jul 2019 10:29:13 -0700, Jakub Kicinski wrote:
> John says:
> 
> Resolve a series of splats discovered by syzbot and an unhash
> TLS issue noted by Eric Dumazet.

Sorry for the delay, this code is quite tricky. According to my testing
TLS SW and HW should now work, I hope I didn't regress things on the
sockmap side.

This is not solving all the issues (ugh), apart from HW needing the
unhash/shutdown treatment, as discussed we may have a sender stuck in
wmem wait while we free context underneath. That's a "minor" UAF for
another day..
