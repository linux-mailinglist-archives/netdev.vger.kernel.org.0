Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69B0763A3D
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 19:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfGIRjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 13:39:42 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43724 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGIRjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 13:39:42 -0400
Received: by mail-pl1-f196.google.com with SMTP id cl9so10428533plb.10
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 10:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=88lfHfD23FtPzBpCefzbSRUTqUnLPVFUOVDCoVbu/dw=;
        b=nAZl9jWAqQuZvJaWBW1j58bd1groXlZqPzN5Q5unYHhMFOxnEuIZ+gCMPlqUFTx6mj
         U/Tghu1OwdXOYnW2OzwLuY06PL2YP9vppzbnKhY+X2qb1EYqqIHkd5W5XNyJZpq+b3AK
         N1Rs91L/uD6dLT8il3l29dIiOyJu/fRJF9LYjQTtkiAubyeSJtBaf0AjLSaQs2SCrLuc
         a7s4gOemt93EypsTwwB9EAkBpm7WOugL2U2L6emonfEyNQ063TT3mJLfcqOsPD96GmqK
         wz3CSi/3b0fMUl8GCXib/bhTRspNBoNrnzdmG1Vsjzv92GrfxeWCTZOLBNHxxYL2S3Kh
         nYkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=88lfHfD23FtPzBpCefzbSRUTqUnLPVFUOVDCoVbu/dw=;
        b=U+0wL+r8fqiJTlRy++6Rq5JPb5t1WxqpUZfWg7+nR3L1membNvHZJlypjX+pYVh0x4
         eKiCM8AXq85qRBR4xruOAF0yCWLF2a8xZwJpX6AES4or8sskrXsyYBTqkM575CFQ9ZpN
         8hdZ3UOtZ/mu0FiZccbkXsEh1NO641pt8HD9IbCOEC1I2F3LT8KZzj8FZe7XdCLmO3i+
         dU0jmlqJLV242+wq9kGaF7cOUjVONoHS1ojVuKgULeJ+tLBEmDRl1Zmwbbm7WBJB2Akd
         1AbIQ+uCXWTto9iSlf+9I2Mddmvjsrz+bVcrjYzXnkZi0stSy15i70C5xWooTtGdEUBz
         I72A==
X-Gm-Message-State: APjAAAUozCDX0uiT75ckj3T5Ko5Xujlc2UWjdkV5MCwhaQFJXxYRpMEJ
        +KaY9Zd9HJzyO11x6d5DDKYaew==
X-Google-Smtp-Source: APXvYqx8qiQkwWaN21+AhX+fDWe4Uavl3MaJ8eDXjEBpMygwnKEoyIf/wWF/RKh72Tv3Ac6dpeHZKQ==
X-Received: by 2002:a17:902:e20c:: with SMTP id ce12mr32925211plb.130.1562693981760;
        Tue, 09 Jul 2019 10:39:41 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id x67sm23146899pfb.21.2019.07.09.10.39.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 10:39:41 -0700 (PDT)
Date:   Tue, 9 Jul 2019 10:39:40 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org,
        dsahern@kernel.org
Subject: Re: [PATCH iproute2 1/2] Revert "ip6tunnel: fix 'ip -6
 {show|change} dev <name>' cmds"
Message-ID: <20190709103940.2f591367@hermes.lan>
In-Reply-To: <2460e246-5032-7804-fbc7-e689cebb4abe@gmail.com>
References: <cover.1562667648.git.aclaudi@redhat.com>
        <5caaac096e5bbbf88ad3aedcc50ff2451f94105c.1562667648.git.aclaudi@redhat.com>
        <2460e246-5032-7804-fbc7-e689cebb4abe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Jul 2019 11:14:00 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 7/9/19 7:16 AM, Andrea Claudi wrote:
> > This reverts commit ba126dcad20e6d0e472586541d78bdd1ac4f1123.
> > It breaks tunnel creation when using 'dev' parameter:
> > 
> > $ ip link add type dummy
> > $ ip -6 tunnel add ip6tnl1 mode ip6ip6 remote 2001:db8:ffff:100::2 local 2001:db8:ffff:100::1 hoplimit 1 tclass 0x0 dev dummy0
> > add tunnel "ip6tnl0" failed: File exists
> > 
> > dev parameter must be used to specify the device to which
> > the tunnel is binded, and not the tunnel itself.
> >   
> 
> Stephen: since this reverts a commit in 5.2 it should be in 5.2 as well.

5.2 has been released. Probably not worth doing 5.2.1 for corner case like this.
