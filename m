Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BE13AC924
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 12:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbhFRKvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 06:51:17 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:35419 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbhFRKvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 06:51:15 -0400
Received: by mail-io1-f70.google.com with SMTP id y14-20020a6bc80e0000b02904dc72726661so3770660iof.2
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 03:49:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=HrK3zoZ7mBoYxTNh9K06ogvFxCCPaWcCp7U6uUfuszg=;
        b=mqLYllOcLn01BFN4dRsezr7LqcOajxwVJIH3XUhSWoflLj9j4O/VxsMyTVzBHl6alB
         eDSRyDWViHVbWS+B2sajU7m8p5IED+X4RY5VRQyRqXfFyj+MfynpCoXFffiHs8BmR/3b
         hrTC1+eVJNxerdulm28uo7/MW5JYH9RonpgO9kYvoEvUvwYa7yH+0LgltdgW4+poj4ah
         5KdbQu8Svv214Di66A5mRt0s5qg1cfpunpNveu3KHuWrIdGN1E4wb6ul6bTd3uKksF0O
         uqdIdYw44AyAZMIl3tFLCkiyD42xpVL5LxzXKpcqTg7WYlE+YpoqhIzBWPEVcLfHCZGX
         ogfQ==
X-Gm-Message-State: AOAM531CsE1kW0o4gp1TENq6/7QOdmCkal0i1p6DdynZqdRb+smY0hRI
        AussWCv/t3pV/dHTAeXKUxGRLjQ9EGmp+MyVMytcH5bvo4YW
X-Google-Smtp-Source: ABdhPJzCs/4OA4IQ6EdpX5w7LDi1TyMBN9jVHynWWJ1IIwL1ilVww+diOFD/9gDfLlvjM0MAPMOEjUjnAUdQpIPV/79GfMvNceNj
MIME-Version: 1.0
X-Received: by 2002:a05:6602:38d:: with SMTP id f13mr7558181iov.109.1624013345667;
 Fri, 18 Jun 2021 03:49:05 -0700 (PDT)
Date:   Fri, 18 Jun 2021 03:49:05 -0700
In-Reply-To: <20210618133112.596c60d8@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000943f6e05c50812c3@google.com>
Subject: Re: [syzbot] divide error in ath9k_htc_swba
From:   syzbot <syzbot+90d241d7661ca2493f0b@syzkaller.appspotmail.com>
To:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, paskripkin@gmail.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+90d241d7661ca2493f0b@syzkaller.appspotmail.com

Tested on:

commit:         fd0aa1a4 Merge tag 'for-linus' of git://git.kernel.org/pub..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=5a4fe6d9e0a3e71f
dashboard link: https://syzkaller.appspot.com/bug?extid=90d241d7661ca2493f0b
compiler:       
patch:          https://syzkaller.appspot.com/x/patch.diff?x=14f9aff0300000

Note: testing is done by a robot and is best-effort only.
