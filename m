Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A115B18729C
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 19:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732397AbgCPSoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 14:44:07 -0400
Received: from mail-ot1-f46.google.com ([209.85.210.46]:39062 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732266AbgCPSoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 14:44:06 -0400
Received: by mail-ot1-f46.google.com with SMTP id r2so3525978otn.6;
        Mon, 16 Mar 2020 11:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dD9qGn/FmD1rIVTC9XP6vGVct8WmBBkX3v6FBswGPLo=;
        b=esJMsHWZs+0PiRjH1AF2Hk5PbE+Y5R7BCiJrNVdMcoZKSi+C0xzNISCgs/mOWzY0ww
         gCmBY9dGL02PsqJdCZS5/wBs8Hf70P6RDvqfKxgg+ihoJxjSUq1fQ9YH66lCGBmafAVM
         kETmoetguC2zop5uJIv42hFWUauMUhqm/yMur5RV9yM/abKe5DHypK/mCUHUu2srRchi
         7jV1pl7UM+uYxS6yRzqfMKsexl1U2c5ItHczyqqs0QeVGyFRC//kaLFUyWtknlXcexE6
         f4LCMnglc/PSFiL9QOcWcGgQHsbc65WohjBjzYsz9LvnzpPcbPDcQ8XUTrwHYkDebOKZ
         oqBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dD9qGn/FmD1rIVTC9XP6vGVct8WmBBkX3v6FBswGPLo=;
        b=HJVXavB6aE6b9mvmHLnaCjDPplX3AgfHu/dZrQZYFjY+0H7FhSFiIKiZ+QbZh4rG1A
         nGjj1grjJTfqXxiLTXHQ87QUrVKykzKLu32/FkiknlLIskLh9BUgpjT++IfJFzLZ7/zd
         wSWmbJOav1CXV+cFxZ0Z/hGuT7+JXAXGINYUwRQxpaF78O0LbLxendBlOZ/7y65aw08M
         yOuT6PmRAGAT+3r/1LEMwDioLF78MdVB0wGneZMKdglEOVGJetPqyWTSgWjtXah33nUM
         G6TApmOysuLSlE3p8KJ1s2tt+pIWZxXsF9GmVUoZLIDfViBrvcbE1ntK3IglwTGsdG1F
         HOUw==
X-Gm-Message-State: ANhLgQ0aH8OwOvWOds+Bp4hGLMta6xvtXLCasR4sY2xmUGSR3RGeYD3m
        e9gGiU5lgajRyhr9KyywEOvWfxqk0XAPKOfe1VwW9vcSKYc=
X-Google-Smtp-Source: ADFU+vtheCmSwN1cXxJGNkX/ItmoDbQsGdufvuyMgkH1GqbyWVjt4ajqUacyxSFy/mBtQNQYQzItBR97ME8aHQgqhrY=
X-Received: by 2002:a05:6830:1bc9:: with SMTP id v9mr474176ota.319.1584384246005;
 Mon, 16 Mar 2020 11:44:06 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000b3cfc805a0824881@google.com>
In-Reply-To: <000000000000b3cfc805a0824881@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 16 Mar 2020 11:43:55 -0700
Message-ID: <CAM_iQpV_h9ej+bnz7Z_Jjf-NXGzSpq+6kY_-kCynkn=5TxPPJQ@mail.gmail.com>
Subject: Re: WARNING in call_rcu
To:     syzbot <syzbot+2f8c233f131943d6056d@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: net_sched: cls_route: remove the right filter from hashtable
