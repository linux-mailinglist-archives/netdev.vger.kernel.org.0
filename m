Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9754D211BBF
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 07:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgGBF7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 01:59:07 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:44389 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgGBF7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 01:59:06 -0400
Received: by mail-io1-f70.google.com with SMTP id h15so16928068ioj.11
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 22:59:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=xbytn9M3cxRfOi5zth6kd9KGsR1TEtsxTskqPLpg9gk=;
        b=HcP9OGNr+gd/CNdAr8EsCWtGpWMYwXYLcJFTfNoUICcXS9MtAv4EFOl1IJIBAyeV/j
         hFjN4x2HAVrmM1ftlo1DdxPxS4+pnH06+9CjMih2GDdCKmaY9X/3bjekc4yucscUyWSP
         53gYwkpYPfaABAw0olhY7vjX79HnA4dogz8xg8xeAwSqc7RfEXxSkZZo3rK19vDKHtei
         z/u/Jm3+anBMipsYRMsSBQR4SGfyPrBrcpbRHk5wLCIL+P6c/BCiI10JRN5HHGeMu/JU
         KBUcKUpN13IeW3LMFM7NamdG7sOp5mejVNOdk75bHfGI+rFYHqCJ+Ja2qRcvuO4I0pNG
         sFJw==
X-Gm-Message-State: AOAM530F+Rt+WrglJLTmT593m1XnE78n0EoF6DCTxj7WEvZARjaio6Qi
        l+4OfsHuykSej598joRYs+p6n9nqobOEqvhM51v4fcmHtagh
X-Google-Smtp-Source: ABdhPJwYd5RKhOT9Nti7IyaWKnwwbMZeMQ8zrGXQzpwoBuIFp4ja7As0wb5vuWZZ3LxVZPkx2R/wE7IZVvBFXdpbxa54lsJZzdA4
MIME-Version: 1.0
X-Received: by 2002:a92:2ca:: with SMTP id 193mr11456381ilc.299.1593669545736;
 Wed, 01 Jul 2020 22:59:05 -0700 (PDT)
Date:   Wed, 01 Jul 2020 22:59:05 -0700
In-Reply-To: <000000000000b41c6405a8e38c6d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000029c39c05a96f1bb8@google.com>
Subject: Re: WARNING: suspicious RCU usage in qrtr_ns_worker
From:   syzbot <syzbot+0f84f6eed90503da72fc@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, colin.king@canonical.com,
        dan.carpenter@oracle.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this bug to:

commit e42671084361302141a09284fde9bbc14fdd16bf
Author: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Date:   Thu May 7 12:53:06 2020 +0000

    net: qrtr: Do not depend on ARCH_QCOM

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=105f7755100000
start commit:   7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=125f7755100000
console output: https://syzkaller.appspot.com/x/log.txt?x=145f7755100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=be4578b3f1083656
dashboard link: https://syzkaller.appspot.com/bug?extid=0f84f6eed90503da72fc
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1521944d100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1298d245100000

Reported-by: syzbot+0f84f6eed90503da72fc@syzkaller.appspotmail.com
Fixes: e42671084361 ("net: qrtr: Do not depend on ARCH_QCOM")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
