Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 175117B5F8
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 00:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfG3W73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 18:59:29 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36483 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfG3W73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 18:59:29 -0400
Received: by mail-qk1-f195.google.com with SMTP id g18so47812415qkl.3
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 15:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=JfnyzXmHhTxKk1T/CTVs+BDquMvflSyODoSkc9/cuyE=;
        b=v93WeqABA/iMecuRsg7XJOb9SvwrTXvQtg/lo6czmyd7iMAXOvO5WlLF+0+tBgjpu5
         eVPiuQIQeYx0cWyY8T4hdbZxBc83dyYS/tHxtVMrWkMrD/wmjKlrhkk9EigXT0LUX3hX
         hwv87qMTjEATPM7Kay8AXF3lMzGFORJDRqeNysVVUaMhVt+FM6vplb9juswqR00a8f6J
         TviIbrskjiVnuTrRvAu+NT6fLfw0FwmhrGQsZEqybXFUWGpB6i6axcs8IVnbEHTuOQxN
         1r6MBPGvXw+WcFbUmC6/JyI9ahVM7Je0Jmpu+mX/JdMRLUZfb0XHBCF4SgaMO2SxRzJp
         4TfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=JfnyzXmHhTxKk1T/CTVs+BDquMvflSyODoSkc9/cuyE=;
        b=i1uL3yxHbnk0UF0FL96jKBT4wTjIUkqFDiyLDAY4zlUNXCM5k7Rxsr/1MJHUuMw4SA
         fD5I1n928b8pTWRLYN7fQcgD0NJedpccknQYm5pR1fJnAEgBVzPJ5EvqFGY7SLpNkP/b
         5vUVZ3g1rfZpzkNgIk1GpUY65Fiuwvwq7nPdtS/el3aU6eHCl5niGEpH2F59ZkZt6/zu
         ui3Qrn6FKM0NrpF4iML2LhDohUKIbhJY7czCaJrGtnqoazP2Yme4FUlWTiN4mlkfYL3s
         W5ZZxeopBITEoiIBGU5Iw5PqcHSgS2D6q1BUiWFMtFcEroN8xLy9vaI/OSnI6+ZMNh5C
         uEOQ==
X-Gm-Message-State: APjAAAU61f2MHVUNpQ96zXS4v2dasnnZHQP8fZEGrdO4tUMUOrz8gelR
        lAgL708+2wpfx2sJScaiYpHhwQ==
X-Google-Smtp-Source: APXvYqynQh5pi/LLDpb576lMXo5FuZMPCTbI88mKzxpv+d/zWaihu0T355QGofCeNrhRpE6rmVEQFA==
X-Received: by 2002:a05:620a:12e7:: with SMTP id f7mr40255434qkl.471.1564527568249;
        Tue, 30 Jul 2019 15:59:28 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e7sm27419876qtp.91.2019.07.30.15.59.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 15:59:28 -0700 (PDT)
Date:   Tue, 30 Jul 2019 15:59:15 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] tools: bpftool: add net (un)load command to load
 XDP
Message-ID: <20190730155915.5bbe3a03@cakuba.netronome.com>
In-Reply-To: <20190730184821.10833-1-danieltimlee@gmail.com>
References: <20190730184821.10833-1-danieltimlee@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Jul 2019 03:48:19 +0900, Daniel T. Lee wrote:
> Currently, bpftool net only supports dumping progs loaded on the
> interface. To load XDP prog on interface, user must use other tool
> (eg. iproute2). By this patch, with `bpftool net (un)load`, user can
> (un)load XDP prog on interface.

I don't understand why using another tool is a bad thing :(
What happened to the Unix philosophy?

I remain opposed to duplicating iproute2's functionality under 
bpftool net :( The way to attach bpf programs in the networking
subsystem is through the iproute2 commends - ip and tc.. 

It seems easy enough to add a feature to bpftool but from 
a perspective of someone adding a new feature to the kernel, 
and wanting to update user space components it's quite painful :(

So could you describe to me in more detail why this is a good idea?
Perhaps others can chime in?

>     $ ./bpftool prog
>     ...
>     208: xdp  name xdp_prog1  tag ad822e38b629553f  gpl
>       loaded_at 2019-07-28T18:03:11+0900  uid 0
>     ...
>     $ ./bpftool net load id 208 xdpdrv enp6s0np1
>     $ ./bpftool net
>     xdp:
>     enp6s0np1(5) driver id 208
>     ...
>     $ ./bpftool net unload xdpdrv enp6s0np1
>     $ ./bpftool net
>     xdp:
>     ...
> 
> The word 'load' is used instead of 'attach', since XDP program is not
> considered as 'bpf_attach_type' and can't be attached with
> 'BPF_PROG_ATTACH'. In this context, the meaning of 'load' is, prog will
> be loaded on interface.
> 
> While this patch only contains support for XDP, through `net (un)load`,
> bpftool can further support other prog attach types.
> 
> XDP (un)load tested on Netronome Agilio.
