Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1168109B
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 05:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfHEDn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 23:43:59 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41875 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfHEDn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 23:43:59 -0400
Received: by mail-io1-f66.google.com with SMTP id j5so160263127ioj.8
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 20:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:message-id:in-reply-to:references:subject:mime-version
         :content-transfer-encoding;
        bh=M20F16zKuaKLu3Epb7RvxkL0Qz7PqmQ+BSIgoRfDXjU=;
        b=PysZHlC1B5bd0Ak0YSt9ouHT1RbZQxk6QXKzXvpusJs2DZ9MfQFVG0V5gng0t8acXI
         Wu2jbgYnkUASzrFeosHuokF6wlH/GWnzGV15NkfTU5Q6Ivj/5uEytFwcFVj9Z2gCBOfG
         LfC3Dl660/SypsrQPXGssflL8RJ+XW2wVloQLQSk1Fvd7F55SbQ9IJtdEYv2dO9Kd26V
         zR7fqZGbtVHHec+EkxCenyR/5xeIM/XhbRpMOmwKR9YHpjDOIvolbbXQpiPSI3ULyblR
         KpdFrMNpXZOZVi3VL3lOdQ4Al9Sg8/0hs0lxWLzhfGw1hhUvVSMrg02XG3Z7APXkV2kU
         xIRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:message-id:in-reply-to:references
         :subject:mime-version:content-transfer-encoding;
        bh=M20F16zKuaKLu3Epb7RvxkL0Qz7PqmQ+BSIgoRfDXjU=;
        b=FjACXd/9zJgRCBNsX/WeH4xeJEWobS2wU9KqiTZ/H5CEG+2BjxfqIyxuzPZQH544j4
         nnTAoUiWd5NoY3Gul/oGLVG6yY6MWDIx9LDlkKkRIt5ZotsEpYo/6IcAqkJtBFIInWD2
         HaVy+4jBRGAodlcmLQ2T/bf0ryKxWQc463uG91Q286ZCHxWGQdmhszwKpbZLftOPeAv/
         PdZwl4byp5EdaEs7CMuFx8/5P2D+ih13m957ukxFHnPjrbtLl2iAjV0JFskbmq/wJPV2
         VlNij0uacOHpXBMfcw6qNV9ScNISYSZ9j4NffZ55jL9puHvCEfSumi6hsyHCfn35fMK0
         GA8A==
X-Gm-Message-State: APjAAAWoLXASEcom78viuj+eHMl9XegFKz4uCNPHvvJxN5YFhHhNFcts
        tL6hbVY0eg9KTfXqweJGxyq3WsDD8LQ=
X-Google-Smtp-Source: APXvYqwq4heDoG0W0V/JFSWr4yXqNT/t+oEcbsuFbvcIUvTwdUfaCpZKFKdwrn27Q6IwJgHY42g2pg==
X-Received: by 2002:a02:aa0d:: with SMTP id r13mr47968633jam.129.1564976638545;
        Sun, 04 Aug 2019 20:43:58 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t19sm74448360iog.41.2019.08.04.20.43.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 20:43:58 -0700 (PDT)
Date:   Sun, 04 Aug 2019 20:43:49 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Shridhar Venkatraman <shridhar@neemtree.com>,
        netdev@vger.kernel.org
Message-ID: <5d47a5f5d2889_f622aea32f005b826@john-XPS-13-9370.notmuch>
In-Reply-To: <CADJe1ZsZcWrtdJGgXeoEnG4FFUGxT-BmJvJW2xwDUF+uCUp-kA@mail.gmail.com>
References: <CADJe1ZsN8+1brBNdN2VNMp4PRdeYjCC=qaMZALQxOTvPmgJQhA@mail.gmail.com>
 <CADJe1ZsZcWrtdJGgXeoEnG4FFUGxT-BmJvJW2xwDUF+uCUp-kA@mail.gmail.com>
Subject: Re: BPF: ETLS: RECV FLOW
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shridhar Venkatraman wrote:
> Hi,
> 
> The eTLS work has BPF integration which is great.
> However there is one spot where access to the clear text is not available.

Guessing eTLS is a typo for KTLS.

> 
> From kernel 4.20 - receiver BPF support added for KTLS.
> 
> a. receiver BPF is applied on encrypted message
> b. after applying BPF, message is decrypted
> c. BPF run logic on the decrypted plain message   - can we add this support ?
> d. then copy the decrypted message back to userspace.
> 
> code flow reference: tls receive message call flow:
> --------------------------------------------------------------
> 
> tls_sw_recvmsg
>   __tcp_bpf_recvmsg [ bpf exec function called on encrypted message ]
>   decrypt_skb_update
>   decrypt_internal
>   BPF_PROG_RUN on decrypted plain message - can we add this support ?
>   skb_copy_datagram_msg [ decrypted message copied back to userspace ]

Yes I'm aware of this I'll push patches this release cycle. At least that
is the plan. I have some internal patches I've been running for some time
but need to clean up an edge case. Hopefully should get to it this week
after fixing up a couple bugs first.

> 
> Thanks
> ps: I sent this to the bpf list as I don't know which one it should go to

sending to bpf list and CC netdev would work or just BPF list.

.John
