Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC4594FA9
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 23:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbfHSVQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 17:16:23 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43724 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728441AbfHSVQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 17:16:22 -0400
Received: by mail-qt1-f194.google.com with SMTP id b11so3566946qtp.10
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 14:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=7VHtZbwbPt3cU09BBgYw7poQEOj3jlMhPLiN2OljcMA=;
        b=V5066buQuRr78wQdPzw8kd+m7x1GprMPKKsq8UvUXMqKs6THmRiYon3hdSop+Iv3Nf
         QH08Eu+ZO8EjMIWyXXqmm44G9qd2I6gX3z8JNztDWPSHtPUR/5KYjuRSs78jtR4IXbtX
         rQ9TCsSBzZWdyQTXN9nVpBALK8CpMJvN6SCKPjySg5wGzt2nEgkoLLDBGOZgUgQX2W1u
         H9YycO2D1CULesTI+IibqTeaI3bEjg9pxdGQ10UMBT8bJ1ToDA8Jhwlx6EdNJ1X+NPmT
         5CanvyJJUq5MUN+GlXxf5Zm84mDDZpAezdiLU5c1JGci9+gl/2j484nsVWLXygexSZzM
         dRGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=7VHtZbwbPt3cU09BBgYw7poQEOj3jlMhPLiN2OljcMA=;
        b=KSl8Mg0lee+TNzbLwitK956ibHLXx+qAkvgg26JGcYRqQ0K5Z/AopQV+pwULoIpODe
         fAtt4+KvuSsabi26qcoFE8USzOrpAHxsM0Kr7HzjR1V4XXHjx8I579yQlExIUkXiuUkT
         LVJFEcGGWAMlACMAmeMOZzlM9tHbJv6a3FBQSijLnenFWjaU6OYHml4rYs7c3qi57Zgo
         /3qeSTeXW0szF9v4zy1uxQ8s4n7j67Oig1fZRDivtOUscHmz82cjJHpL4/0VyubscCz+
         2YKjIzNgeJtND1FK1DdZYWrtBeXov8e7gXt5o+p1nqksHVd6xNFZahQuQmLcDu7I+CyA
         wmPA==
X-Gm-Message-State: APjAAAWQWs6ydgaUyhgORhrUAmmjNFMYLduhsj+OQpXdDDPg3pGeJdbv
        wJ1KgJQD73MgiDcucoOk9YqzNw==
X-Google-Smtp-Source: APXvYqzNa4SUZDJ+Yo86loQ5/oKVNPe+0jCMpvUbyIavjYFzElEFIq6jpHvEwVtf2Aj0Pc1imbxMMw==
X-Received: by 2002:aed:2667:: with SMTP id z94mr23843274qtc.343.1566249381868;
        Mon, 19 Aug 2019 14:16:21 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j50sm9644271qtj.30.2019.08.19.14.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 14:16:21 -0700 (PDT)
Date:   Mon, 19 Aug 2019 14:16:14 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     syzbot <syzbot+503339bf3c9053b8a7fc@syzkaller.appspotmail.com>
Cc:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, Eric Biggers <ebiggers@kernel.org>
Subject: Re: INFO: task hung in tls_sw_free_resources_tx
Message-ID: <20190819141614.10d5c07c@cakuba.netronome.com>
In-Reply-To: <000000000000cab053057c2e5202@google.com>
References: <000000000000cab053057c2e5202@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 04 Dec 2018 00:48:02 -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    6915bf3b002b net: phy: don't allow __set_phy_supported to ..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=177085a3400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=28ecefa8a6e10719
> dashboard link: https://syzkaller.appspot.com/bug?extid=503339bf3c9053b8a7fc
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11e6996d400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=117e2125400000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+503339bf3c9053b8a7fc@syzkaller.appspotmail.com

#syz dup: INFO: task hung in aead_recvmsg
