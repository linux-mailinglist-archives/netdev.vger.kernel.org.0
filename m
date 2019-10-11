Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F74BD35F4
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbfJKA3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:29:16 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33605 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbfJKA3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:29:05 -0400
Received: by mail-lj1-f193.google.com with SMTP id a22so8066448ljd.0
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 17:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4WsWgFcQX+4hcpk8fzSs1Uvm+uJ+nhztEkt8zqmznqg=;
        b=ctOBcBURvGgmJ1YcNG6NC//LFndWhI0zEGO2+cDY0qa66y8fxEW/CXFgEpco3GyBE/
         zj9K8xfS4StDiRO26znkvTJ9CaoFGJYJvP+AExZhpeNS8wUd9Di6heimHjF41uJZIH8y
         oH0g6tGELuQom9pG5eE/i6sChB8vJl216T0mhCc/wVKazkoXz8UCoJJ0R/tcgpbCbgbY
         wDiO8urRb6Nv0b4/zAN9hrNFCHvuS2IukXWFidTX3Fr5mWdgmJJjXmST613+2O1cL5Kv
         cbLg6AyRPnO358ie71Hox/9a9ha/MIWfQvL48wGoz2M8MO2jpWLL10vE5dYAcNgNdaae
         JNsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=4WsWgFcQX+4hcpk8fzSs1Uvm+uJ+nhztEkt8zqmznqg=;
        b=cM/lViIKcqgFwvg4MEds5aBnAKVkQcVIxx9MIa7szRIVIx99KsqQDemgizZ+/uac2M
         P+Iv1SseDg8fq/VS/Lar4Kt/gPwF7xIYrHDjx7FO2HyWWZ33zTOnjdIP7JreqWNV4o7/
         9x1k4n8GNLYP9PFFEOgY+7z5TRLhA27cqzK0GxBKw0CdFwJHWn7rjlxF7yyqnus/RAOi
         Xtiq5Bcp6JI21lsGZG5ezvSz4ETFPX17cINGo/EPJ/ExrLtSbbDrdeGXwlf9u8s/QE6/
         M4pNOFRyRTi+w0b0QGerKZB2HQuM/qcoNESQ0qcE5x+jA3AvB+VzyrH5T95UnrL9Cnwt
         zK6A==
X-Gm-Message-State: APjAAAWLOUtw2wja1v360DYcZWcAEyhnKQNQe/TYehVcaUBS4OWBffwr
        rJPi4ZT//HqR7/bSJRvTg7/vNg==
X-Google-Smtp-Source: APXvYqySw5/2iZFOp9V0R18gVq02vew1YIQUx4qtGUkTfdB1VNPqrML/tZj5hh8JTwJShrTOzdeQEQ==
X-Received: by 2002:a2e:9ad0:: with SMTP id p16mr7677917ljj.179.1570753743905;
        Thu, 10 Oct 2019 17:29:03 -0700 (PDT)
Received: from khorivan (88-201-94-178.pool.ukrtel.net. [178.94.201.88])
        by smtp.gmail.com with ESMTPSA id c26sm1785025ljj.45.2019.10.10.17.29.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Oct 2019 17:29:03 -0700 (PDT)
Date:   Fri, 11 Oct 2019 03:29:01 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, yhs@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, ilias.apalodimas@linaro.org,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v4 bpf-next 00/15] samples: bpf: improve/fix
 cross-compilation
Message-ID: <20191011002900.GA4121@khorivan>
Mail-Followup-To: Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        yhs@fb.com, davem@davemloft.net, jakub.kicinski@netronome.com,
        hawk@kernel.org, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        ilias.apalodimas@linaro.org, sergei.shtylyov@cogentembedded.com
References: <20191009204134.26960-1-ivan.khoronzhuk@linaro.org>
 <20191011000056.GD20202@pc-63.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191011000056.GD20202@pc-63.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 02:00:56AM +0200, Daniel Borkmann wrote:
>On Wed, Oct 09, 2019 at 11:41:19PM +0300, Ivan Khoronzhuk wrote:
>> This series contains mainly fixes/improvements for cross-compilation
>> but not only, tested for arm, arm64, and intended for any arch.
>> Also verified on native build (not cross compilation) for x86_64
>> and arm, arm64.
>[...]
>
>There are multiple SOBs missing, please fix. Thanks!
>
>[...]
> 5 files changed, 218 insertions(+), 99 deletions(-)
> create mode 100644 samples/bpf/Makefile.target
> rename tools/lib/bpf/{test_libbpf.cpp => test_libbpf.c} (61%)
>Deleted branch mbox (was 9f35d1d0c8f0).
>Commit 9f35d1d0c8f0 ("samples/bpf: Add preparation steps and sysroot info to readme")
>	author Signed-off-by missing
>	committer Signed-off-by missing
>	author email:    ivan.khoronzhuk@linaro.org
>	committer email: daniel@iogearbox.net
>
>
>Commit 1878c1de4607 ("samples/bpf: Use __LINUX_ARM_ARCH__ selector for arm")
>	author Signed-off-by missing
>	committer Signed-off-by missing
>	author email:    ivan.khoronzhuk@linaro.org
>	committer email: daniel@iogearbox.net
>
>
>Errors in tree with Signed-off-by, please fix!

Done.

-- 
Regards,
Ivan Khoronzhuk
