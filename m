Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D13EDD5341
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 01:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbfJLXOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 19:14:40 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38695 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbfJLXOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 19:14:40 -0400
Received: by mail-lf1-f66.google.com with SMTP id u28so9379646lfc.5;
        Sat, 12 Oct 2019 16:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ia0hSBa10knYKGOnZiDVQmpAvNOJ+DPL78NAZDUpJtE=;
        b=GYQvrGg9HhSMYphkXFdQhqgM0mquEQEJ69Ut03YgUNLIBLFb6/MHfUshd/BLWbO/uw
         50PJm8HpjgPOJ0b9NRmxpPFm9uePxbePlKRoLhvpoGo18lzfQAklQ4f/YhVwa/UCWek0
         qvk+4WBbGTZkce1rEof9NEi/az/yiiB1ODRpE9YVGZ8maBw+P9mfj3H0n6yegVPhDTtr
         UaWnYxmUc9Ry3wkVN74BZiU0hVdsqEUCVAZ9/5GF/q4FGnWn+bkh5iQinTNiMdOlKS68
         PQgzF5agqSG1fpfNFtaiMkQmxuKCNv5RfMThVvHLS8RWKVBL/v4RPXdcv6mI85cUssn7
         rnuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ia0hSBa10knYKGOnZiDVQmpAvNOJ+DPL78NAZDUpJtE=;
        b=aKRJgmKyvWHAfMYR4lN3ElmLRB4IaCwcWOagBINo15BS2ceqNR4U8ADuAXxsufw+Vw
         BuaxoUaRY2dqJVWq+6Le0EKC5+SO9QJLXEM0LGjDsKTw2AmbuP3jlWTslJewgt1dNXHf
         O+8ok+odFhMYFvxpRvf7BpIXA/S3cAfEhUhp9noQa/meZIFpeiugaC1fVCqnsS5KJUS/
         dcH6ReRmEoqkc/+Ock5uWtCcUAKaHqA5r4i6RibWPnKxVAH5qpZlx7/WtdH8hoVAiJRO
         T72WZRsuDpsjZvvAYf/InagLYsCnrEg5Rq2aCfVtVunKcZdGOoIn0e7GeMpI1JRFy4kv
         8PIw==
X-Gm-Message-State: APjAAAU4ETXVFyaaoPWnJ1GoV7OSQIUqPPgSp9ZHnVq/loO2PGj9WiTw
        cqOmCGTTkhMcaMiCnLs4oo4XyAFj539RRHYWb80=
X-Google-Smtp-Source: APXvYqyVfVqJ1AZWYOKfESjSkoEXUw13Idwn8M5D5bsFsu+4wES8sUW3KdZ7NfeuZraYgCs5UxP5xPtAAFsAFWNo+PA=
X-Received: by 2002:a19:f707:: with SMTP id z7mr11974821lfe.162.1570922076534;
 Sat, 12 Oct 2019 16:14:36 -0700 (PDT)
MIME-Version: 1.0
References: <20191011002808.28206-1-ivan.khoronzhuk@linaro.org> <20191011120715.GA7944@apalos.home>
In-Reply-To: <20191011120715.GA7944@apalos.home>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 12 Oct 2019 16:14:24 -0700
Message-ID: <CAADnVQKhYohS_5KUHeFiiyXZWTNeDz3xBf5qBQgjvFiStO+TOQ@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 00/15] samples: bpf: improve/fix cross-compilation
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 5:07 AM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> On Fri, Oct 11, 2019 at 03:27:53AM +0300, Ivan Khoronzhuk wrote:
> > This series contains mainly fixes/improvements for cross-compilation
> > but not only, tested for arm, arm64, and intended for any arch.
> > Also verified on native build (not cross compilation) for x86_64
> > and arm, arm64.
...
> For native compilation on x86_64 and aarch64
>
> Tested-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Applied. Thanks
