Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28910234C39
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 22:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgGaU1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 16:27:08 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:56476 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbgGaU1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 16:27:07 -0400
Received: by mail-il1-f198.google.com with SMTP id w81so22356901ilk.23
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 13:27:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=vsQ0DA/5bvGhTmkbMHk7MzKsMz9FnLBedu0Y4dKMUQk=;
        b=nbAFhwMfA8vOoqVNtqEnhkz3sT4IduQnD1L/ymQOLirGmDVCSl3fL71xD9e8cAX+aF
         1CVECrWaOdleA1R1BdpucR1qA4qGi6ha0rqYBnTrCzV66C9M/vqXHYvvGZTqT9XRvAAZ
         3iSg1u8+cJ5mKhqbt9oCs91cqoiNSskFn6XKh9StCd9EjnqFTc9ZW/iTeUZrzxX/tnAo
         ZZc1lYzOouEi7taY2L86Ikzqu9YnxAJ3pDonpVqPF3FUP6VcUlTzrYvBjTGbzRBM4FSp
         kqbFuoFwPXklwMho+QCLkU6D+fByOLle2RsB6d9E6hVQnbviiNNoIAyPU7EfITpM5WEq
         Lwjw==
X-Gm-Message-State: AOAM530z+xYdnD8zNhybEo8MXaoBZGTvkQPqkla3UPPEgKGeBtFZg58c
        P8TIGJ7H3l6WVHqQ+71q4MmvMa/Bwv8Q2YviYFBRNTkVqBIr
X-Google-Smtp-Source: ABdhPJwscJdmgTVAyN5A0mZcFslfTu4NvgG3c61P7M1Sunc5hbze6ecpT6iF8lTHZO9lbQOYSIomIKIyhyXMYrlqb/aJNkQgzi+J
MIME-Version: 1.0
X-Received: by 2002:a92:8b45:: with SMTP id i66mr5706387ild.19.1596227226917;
 Fri, 31 Jul 2020 13:27:06 -0700 (PDT)
Date:   Fri, 31 Jul 2020 13:27:06 -0700
In-Reply-To: <000000000000c5c9ad05abbfc71b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d75f8b05abc29c92@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in qrtr_endpoint_post (2)
From:   syzbot <syzbot+1917d778024161609247@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit e42671084361302141a09284fde9bbc14fdd16bf
Author: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Date:   Thu May 7 12:53:06 2020 +0000

    net: qrtr: Do not depend on ARCH_QCOM

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12a8076c900000
start commit:   83bdc727 random32: remove net_rand_state from the latent e..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11a8076c900000
console output: https://syzkaller.appspot.com/x/log.txt?x=16a8076c900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
dashboard link: https://syzkaller.appspot.com/bug?extid=1917d778024161609247
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ac9b60900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14256c5c900000

Reported-by: syzbot+1917d778024161609247@syzkaller.appspotmail.com
Fixes: e42671084361 ("net: qrtr: Do not depend on ARCH_QCOM")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
