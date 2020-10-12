Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E334928AB48
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 02:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbgJLA7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 20:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgJLA73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 20:59:29 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66023C0613CE;
        Sun, 11 Oct 2020 17:59:29 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 133so15245252ljj.0;
        Sun, 11 Oct 2020 17:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=jWvlIBzh+NxbUx8sE9GgdjQVlb7CmsH9J6UF2pj8tsA=;
        b=LABqZHmq6JY2YZLhX5Ds7Y1BT6ng2OTIsyuBOKIik1+vpc+rLWhUb3UoPYfszspiwR
         AOQgEf7V1DcX6zFqK8YgY34xm3v7MBwdrWQ6VshQZo0vcYe9QmgLVeLXFG8jiG7Ln+k0
         J2UPfkRqfzkmShubcDGdUYWhhM8rFY6pwFV4aK7VUfgrkCc2HU07ro5UhP9m+hyln9QF
         8hw3oFy2WAgVK7riMHt+YfvE1QWT0YGjuHLykONzRTPnsfmpw5aakuvfe/FrPe5Uj88u
         XDMFfp9H3k50O7nTW1rlQz6YbhUimVcgoU5YeXFnixHTKxe/dLBzNoeYtbAGLJGxXLUG
         zLZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=jWvlIBzh+NxbUx8sE9GgdjQVlb7CmsH9J6UF2pj8tsA=;
        b=WIVrbgUj2F3woQkrRlLNnhb9NxQ/tHvDMwkpGa+X7h3MwuQzZzuBApKCkGey6IBjIp
         /iaa2da0w00pLVgQtxkHl0m1aeOWUeL+HYmeQWu0wJgmGr7z4ZA/mvdyQzIWju7ArqY4
         hqW+HVE3reItBa1zJ2x/jCh3+eJPhvSmMLIdjh7NbHRbI1Q7usCFJRCwtXMxYKhdG9y+
         aRkxugKY9+nkGz/oy4aLcwu/qGseJrcxLDInThSFEd8743JqsIvQrn/S8y6+O99y8htH
         0k5l0o0i675k0lDev0TlN4ImCD3GNlDSgII2RIeO0wIshuvDQAu5+VB82iV9MLT5IjVK
         8fRw==
X-Gm-Message-State: AOAM530Kj9LoDEBH1lJ8x5878sLTTZ++9othK3q4lOn6BTesLjjpR7Nr
        jt3k2pBRb+7PMlPXlUFBE+qfefNKM4vMsU+3nMLomn/ZyQs=
X-Google-Smtp-Source: ABdhPJwwXkOCmdtfQdDCkSYAEFUSxSjTaaKanT7huL1qg1DEApgdSI/1J/E+2v8mivEIW2D5XJ+RzPRzLJAh6/PY+ss=
X-Received: by 2002:a2e:9015:: with SMTP id h21mr9871539ljg.450.1602464367764;
 Sun, 11 Oct 2020 17:59:27 -0700 (PDT)
MIME-Version: 1.0
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 11 Oct 2020 17:59:16 -0700
Message-ID: <CAADnVQ+ycd8T4nBcnAwr5FHX75_JhWmqdHzXEXwx5udBv8uwiQ@mail.gmail.com>
Subject: merge window is open. bpf-next is still open.
To:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi BPF developers,

The merge window has just opened.
Which would typically mean that bpf-next is closing,
but things are going to be a little bit different this time.
We're stopping to accept new features into bpf-next/master.
The few pending patches might get applied and imminent pull-req into
net-next will be sent.
After that bpf-next/master will be frozen for the duration of the merge window,
but bpf-next/next branch will be open for the new features.

So please continue the BPF development and keep sending your patches.
They will be reviewed as usual.
After the merge window everything that is accumulated in bpf-next/next
will be applied to bpf-next/master.
Due to merge/rebase sha-s in bpf-next/next will likely be unstable.

Please focus on fixing bugs that may get exposed during the merge window.
The bpf tree is always open for bug fixes.

Thanks!
