Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CADC7185B21
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 09:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgCOH7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 03:59:55 -0400
Received: from mail-vs1-f53.google.com ([209.85.217.53]:42087 "EHLO
        mail-vs1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbgCOH7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 03:59:55 -0400
Received: by mail-vs1-f53.google.com with SMTP id i25so9192607vsq.9;
        Sun, 15 Mar 2020 00:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oN4/KUQ8b4ahyaIikru+djpxL5XQQFIKZYbjC0vKpsU=;
        b=ZJpqU0YacLXt75ZJb6otm/x5pXGpsxQe52fa+/Ho7/a/XLPO9QCkPmxf0t2DFT9VaI
         IxHddILTsRA88mQ5EvKNhXmG747pT5L1hJKwxZuwRMx3IRjVhAX+bUI69L8dmJ4AXWmE
         6Am1/0QqorhookML6Yn6nNljt80TOiK9B1pnS49GjM4NDy+W2WwbYCoN5bKdLEw8xikS
         SGFby3OGnM9JbJa2uUMKBFTVqFYaDRNSpu6UaRZ5dKP6x4e5GNMuP5Dz6fiSMVUPw//6
         nboI4VNQYRma/rqik1hzVb0YxtI6/NewbWoUQyNltU1OqHGGSDBADPZxYsEzavnaEhUB
         ZndQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oN4/KUQ8b4ahyaIikru+djpxL5XQQFIKZYbjC0vKpsU=;
        b=fvtTtw2I+/lKtIti5qqccrjcYxvSvU5r/7xHlvNoWMOn7kgtjVYlCb5SldYX3Sz8dy
         hjLJBPqDqF5oVTVQUrkHMa2BijRjbYf8tWx9WRzodaoftMNbGikdGFpUsPJAU9vL2cMP
         pmPwPNEcjK/K4apRefCIot3gy9PCMkiFUhPhw3LJ0HDvJh4f7FvtDafgoFIvUl1Dy70+
         5RvAoLtvclyY447ByYsm5tQBIcVZYaNA96APDBT+Ssg+2McymBEzzC2W4tL22P3Grl/n
         2jc95PB/+HvD5RC0jVKzwAGAhe7ft4qUC3YiQXNE7sOo47j7mMuNdsMejLtgQaZvfrgw
         pngg==
X-Gm-Message-State: ANhLgQ39ms13KJ6EKxBpo4dNa+5GBUBGcKgARbfICJxv1Xixu+K54x2e
        ZXijWP3qXRMF/P9JVDIR0xocCs88Rw4KcxiZSsA=
X-Google-Smtp-Source: ADFU+vuDN3k5UPA2Gh4K0jBtCB8/WfcDXhr26U/rtPdnGR6obi6LfAC8dBjYdTyDve8ClkHDcPaAU8SW8sPYVkVoTBA=
X-Received: by 2002:a05:6102:2272:: with SMTP id v18mr13740542vsd.108.1584259194385;
 Sun, 15 Mar 2020 00:59:54 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000088452f05a07621d2@google.com>
In-Reply-To: <00000000000088452f05a07621d2@google.com>
From:   Qiujun Huang <anenbupt@gmail.com>
Date:   Sun, 15 Mar 2020 15:59:41 +0800
Message-ID: <CADG63jCNAngPC9+KuGAChibPn0ZeTmfiUvYntUqDudGQF0h7xw@mail.gmail.com>
Subject: Re: WARNING: refcount bug in sctp_wfree
To:     syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: https://github.com/hqj/hqjagain_test.git sctp_wfree_refcount_bug
