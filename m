Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF4728C5AF
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 03:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfHNBvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 21:51:53 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34059 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfHNBvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 21:51:53 -0400
Received: by mail-pl1-f193.google.com with SMTP id i2so50071939plt.1;
        Tue, 13 Aug 2019 18:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Lp7W6yUkEuFiW/WJUDPMwQwcRO85PXGwYwhO+f6+kU0=;
        b=b9nj8loOV7wYJhqW2MQYQYfsfUy66sVheULhrOwofd433JBeEN+i8V5W38V2Md+T14
         XOlaurr+1zpfMOivdbdbi0NINzZzqZ8P/1GOWTuoVTFix4GOfqRgabe90fiUkiX0gzxq
         auSvK9u2uKOKLCHRQkIHRg6z8QCjlPcKR6sKLsP4KQv7ECPT39vLXeU9pvNg4gTYgZR1
         oNjsR1RqX2HJXAQg47RtcggmNrxgFz+7alZYVO8rsfvKSCTpX6faJl8MfqkEEwrcLe44
         cHxfbjEhtE5fIrJJCkvdg097X8zirBV7W0R4bsKNMAM33+gq+1Kx65A+bA52+MUSyAAS
         uUCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Lp7W6yUkEuFiW/WJUDPMwQwcRO85PXGwYwhO+f6+kU0=;
        b=B6erfSupiUkJCgLO7MAdev16XUn0LpnIobO72LD6RVqn7WP/TlvLPD8Mlf8DvqnODI
         VygHJlDYvIZghiZSDacl33ksg3mO0vDiXM+tRYOI95M5Rxra8egiBskAeOV/gqDqKdeb
         mcz4X0tH2LJlOMXb3q0vNqa5KSFYoZCQ0XDs8WahyxiGEM1o3N4keidpzUPZ/qpchAWi
         A6uBi7xmO1NXGft/6Pob6zBIq1jN9Y8HFM5sddMEXVcnO9jUQUhE504p7GswYizxkuHX
         oPrUvLlsK30LLK/8c07zMcxE6LUfk6gVqye109HR1gu+zN1bvb3Br1+NxUwRI2M1K4QC
         UqIQ==
X-Gm-Message-State: APjAAAWNM6rPcnGWoR8FzqVzxdXE0TYA05DAH16l7b3VIV/9hTiZfSzO
        K1b5ryUCs9hEXcFpNG1Te+0=
X-Google-Smtp-Source: APXvYqyswiRVE+m4G3bq/gAgAZJdSiwO9Y1gh8SDM6KfnFG0Vtc0vem6hmYmvDsidO+dlppXRg0hwA==
X-Received: by 2002:a17:902:7797:: with SMTP id o23mr9324583pll.102.1565747512814;
        Tue, 13 Aug 2019 18:51:52 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::3:8a34])
        by smtp.gmail.com with ESMTPSA id ce7sm3006639pjb.16.2019.08.13.18.51.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 18:51:52 -0700 (PDT)
Date:   Tue, 13 Aug 2019 18:51:51 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [RFC bpf-next 0/3] tools: bpftool: add subcommand to count map
 entries
Message-ID: <20190814015149.b4pmubo3s4ou5yek@ast-mbp>
References: <20190813130921.10704-1-quentin.monnet@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813130921.10704-1-quentin.monnet@netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 02:09:18PM +0100, Quentin Monnet wrote:
> This series adds a "bpftool map count" subcommand to count the number of
> entries present in a BPF map. This results from a customer request for a
> tool to count the number of entries in BPF maps used in production (for
> example, to know how many free entries are left in a given map).
> 
> The first two commits actually contain some clean-up in preparation for the
> new subcommand.
> 
> The third commit adds the new subcommand. Because what data should count as
> an entry is not entirely clear for all map types, we actually dump several
> counters, and leave it to the users to interpret the values.
> 
> Sending as a RFC because I'm looking for feedback on the approach. Is
> printing several values the good thing to do? Also, note that some map
> types such as queue/stack maps do not support any type of counting, this
> would need to be implemented in the kernel I believe.
> 
> More generally, we have a use case where (hash) maps are under pressure
> (many additions/deletions from the BPF program), and counting the entries
> by iterating other the different keys is not at all reliable. Would that
> make sense to add a new bpf() subcommand to count the entries on the kernel
> side instead of cycling over the entries in bpftool? If so, we would need
> to agree on what makes an entry for each kind of map.

I don't mind new bpftool sub-command, but against adding kernel interface.
Can you elaborate what is the actual use case?
The same can be achieved by 'bpftool map dump|grep key|wc -l', no?

> Note that we are also facing similar issues for purging map from their
> entries (deleting all entries at once). We can iterate on the keys and
> delete elements one by one, but this is very inefficient when entries are
> being added/removed in parallel from the BPF program, and having another
> dedicated command accessible from the bpf() system call might help here as
> well.

I think that fits into the batch processing of map commands discussion.

