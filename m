Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F312E58DC1
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfF0WOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:14:39 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44839 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbfF0WOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:14:38 -0400
Received: by mail-pg1-f194.google.com with SMTP id n2so1621641pgp.11;
        Thu, 27 Jun 2019 15:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NZXRbshkIzDoSjsEe6DOCALRS5cAnDLBAFY0PCjxxcU=;
        b=cBdX4LpeL+5vcJzIjdWukBMVOC25dcs8gOFk8FaXLeZh4mPQ1IqFwisSjMlNNNaHZZ
         vyULpV6qOd2TK95gmTBDrlWV40A+36b0wKcUNdXPqrYsHR5eOSVDTXeapan3VLKFTClX
         OZxaSnKCMbx/0JiYw40Sqp2SFmJjzz+1SJlbWTe3eeVKiOD05lMcOfTRF183iEoeZuaa
         +JcwA0nz5Vgd/nycUDCVEnFKH27S7GrEP4p9YLv2OF0s6KhhNf7tDC1jhm8ApnuYNIej
         lo5Lx/SGn7UeDl3q2IOxeyIl4y721mVaKAin81Ne7L2+M4K8z3ex1FcNzNVUCnfS773j
         33jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NZXRbshkIzDoSjsEe6DOCALRS5cAnDLBAFY0PCjxxcU=;
        b=X3tuDAXatyxYKTO3EGV7+CrqbTViU3siTc0szAs01Sniy4l1mq2UU4CKhmvLqn3zne
         d/yKci752zX7AbOGXZqasT5QJMI2WslkLzpmW4uraN0IXzyhq2xE0HGDR1hx47Y1d658
         N38mrTKGOkX/PQ66Kw7qWyYVAQMj/8SD9wToiapDbBKQ//ohYPux0tsHgfpXCy03OJZ9
         BouHdWer6JN1LRaGZlENT6DDLjVm7xUtsAdEYWkjRcfz9xMruyQKq0MCSlYya13+fKIC
         q/+XuUPcgXvKNnoaeJW34YMKBHv5V5q1nmMbRd/PVK1GdAgC5ZwrJuPYdq2qThYvkwMo
         BM/w==
X-Gm-Message-State: APjAAAXLhE6OUA1MB9B+PNyDYggtJ0B6QVmDclckMv5lEY5qJ5TVrL2q
        j46r4FDl+NnVljASSCOC0CM=
X-Google-Smtp-Source: APXvYqzgUPfbteOtdizfNvJDkNBveWB5fGZbGGCcUfGxHAzouvZj2SyT/6FKfztouZ9ftzAfbsE4oQ==
X-Received: by 2002:a63:e156:: with SMTP id h22mr5909967pgk.370.1561673678002;
        Thu, 27 Jun 2019 15:14:38 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:305a])
        by smtp.gmail.com with ESMTPSA id j2sm81162pfn.135.2019.06.27.15.14.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 15:14:37 -0700 (PDT)
Date:   Thu, 27 Jun 2019 15:14:36 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next v2 0/6]  bpf: add BPF_MAP_DUMP command to
Message-ID: <20190627221434.tz2fscw2cjvrqiop@ast-mbp.dhcp.thefacebook.com>
References: <20190627202417.33370-1-brianvv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627202417.33370-1-brianvv@google.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 01:24:11PM -0700, Brian Vazquez wrote:
> This introduces a new command to retrieve a variable number of entries
> from a bpf map.
> 
> This new command can be executed from the existing BPF syscall as
> follows:
> 
> err =  bpf(BPF_MAP_DUMP, union bpf_attr *attr, u32 size)
> using attr->dump.map_fd, attr->dump.prev_key, attr->dump.buf,
> attr->dump.buf_len
> returns zero or negative error, and populates buf and buf_len on
> succees
> 
> This implementation is wrapping the existing bpf methods:
> map_get_next_key and map_lookup_elem
> the results show that even with a 1-elem_size buffer, it runs ~40 faster
> than the current implementation, improvements of ~85% are reported when
> the buffer size is increased, although, after the buffer size is around
> 5% of the total number of entries there's no huge difference in
> increasing
> it.

was it with kpti and retpoline mitigations?

