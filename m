Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6D3494FE3
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 23:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbfHSV3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 17:29:16 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40612 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728402AbfHSV3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 17:29:16 -0400
Received: by mail-qk1-f194.google.com with SMTP id s145so2739962qke.7
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 14:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=0l0Pa0ElqK1DZWn0mgQwwfUufG1B6hMxS63646CFTfA=;
        b=vFz2D+dsGimCQxKLYPtL7kb/5ZcKWdyiABI2FKvG71x0Bt4YfuWuG8RNWUymu7+m63
         icUb3o9Hvu2mjZDqcuQyJtpfPz5WuJcFWSV08m2zKHRq/736D558UHD2+TfpavBooYE3
         byafPyfYpri+HCXimSPC/s+okyeKn7GYqvUg8KLPFFH9IGtta2DBVXasDP3o7kU+B8yB
         hK/qkWZIQdl/8ts0c2lDMC2hRpXdo/dkSgNJ1SHd5k1sRjw1okoGZcVA05Lyls1/vxUr
         mJMEMOnaJPE/nidQWBE9NTNc2+pgrZJlIQ33GP1teo9fmrNqtBtrDfFPTHrzVK1dE2PH
         /AYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0l0Pa0ElqK1DZWn0mgQwwfUufG1B6hMxS63646CFTfA=;
        b=tUYmFvPMfYSuF4RaNGyWwOgByoUq+x5AednwsvsUQD12mA1AqSr0lV0OU5v9v9bKja
         ZyQUxnHa4mE9n9yTm95GyTJxe1bABs7ouUHA2pUxNrGx5a1cmA0xLAtFFxb+gi3jzLiw
         5V9NXUO3BbD+aIYNkXR3wtpH/ch3h1zGLEF5xKzHx57lb291qX1jHOAW055ZUkCawe0F
         i/ubHDbYoQUTBBuKIwKFNrU3oKqy5NSQ16Cg25usqUUvPuJcCi7T8p1krt8GrFI+4FWr
         3phrSc/jCp/85z5P3Unl0X3VZY5c0YV0oL2x6Nckail2Xhin5TTb0x0f9wN7oq7elvhe
         dcuQ==
X-Gm-Message-State: APjAAAVtOSkVTzeG5rUWjIuVXsCWdvQpzZDl9zB5h3x91KeY5seoR6cr
        Wivia3mcl7XmgvGNmCCDq5igEA==
X-Google-Smtp-Source: APXvYqzTQy/Lr6Ti+E/hIvFy1hXuDHcWSKY1hLZDpyObSYqbHZKCD29b41aVxncBy/HWCPAzxZo3yQ==
X-Received: by 2002:a05:620a:10ae:: with SMTP id h14mr7798507qkk.40.1566250155654;
        Mon, 19 Aug 2019 14:29:15 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h26sm8387575qta.58.2019.08.19.14.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 14:29:15 -0700 (PDT)
Date:   Mon, 19 Aug 2019 14:29:08 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     syzbot <syzbot+23d9570edec63669d890@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, aviadye@mellanox.com,
        bhole_prashant_q7@lab.ntt.co.jp, borisp@mellanox.com,
        daniel@iogearbox.net, davejwatson@fb.com, davem@davemloft.net,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        shuah@kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: general protection fault in tls_setsockopt
Message-ID: <20190819142908.72082c69@cakuba.netronome.com>
In-Reply-To: <000000000000d917f4058dd525cf@google.com>
References: <000000000000d917f4058dd525cf@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Jul 2019 16:58:06 -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    a131c2bf Merge tag 'acpi-5.3-rc1-2' of git://git.kernel.or..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1603e9c0600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8bff73c5ba9e876
> dashboard link: https://syzkaller.appspot.com/bug?extid=23d9570edec63669d890
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13560870600000

#syz fix: net/tls: partially revert fix transition through disconnect with close
