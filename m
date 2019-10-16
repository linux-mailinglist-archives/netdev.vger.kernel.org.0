Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F91D993F
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 20:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394271AbfJPSbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 14:31:40 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45767 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727610AbfJPSbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 14:31:39 -0400
Received: by mail-pl1-f194.google.com with SMTP id u12so11644188pls.12;
        Wed, 16 Oct 2019 11:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=a/1zy2tkFy+G+r0SQBZgILxnC3tbw9djFpoNmpNTsRg=;
        b=D6amgI+S7NGX9tACSuAVUt7ZDO/AHMqydlwPUUIOam91QhaGXdYQ/nz0qlS7HWu+ew
         rmMIyenQpTzNlnyrQ8Hnx/K/aykrbpCoLdzbU2Z3PLdiBPoKonUXqBijLNUCcNTQNp52
         cUx/IF+oXqQOaPPNuaCgEfiIiF2MUTDa3jzb4vZpbgpXoNyf65r34dmLjISBZelstWSl
         A9jXk9m2DeRkwOt/w+zH0xuQiYCS2yVJP07bPSv4gHx4+AF+ygNmRYSdXQmeGPCJnAKU
         BjQYhv1+obty0K3FKlNIfv+QEkb0Q2M2Niz/VQ6S8f12fRflHu4qcZRTrdKeq1vOQzbl
         gGjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=a/1zy2tkFy+G+r0SQBZgILxnC3tbw9djFpoNmpNTsRg=;
        b=hBi6pDxgQj0uo1N3tSUL3K71rHLfn/eb82+iLNrpKmMoE6jz0I3oOfkYgzPEpQeeHn
         y7Mt6xCMy5IxmRHiSY2/h8AYYgF7rUbC1oIqw+Iq3s+UeWlYs2PNwJckiAIOxWCRNcd5
         1oKVQcQi6RyPZ5tAX/A9ajvEiBUmon0UqZvnc5Oe1bCoh0SgTqG/Oj5usgKoLQOySDE8
         kLN6g0r/UBHlIXDa1og83FX/eyVp0rjHzznOh91C5piVom2oFDHutQlZ6tmmaGHYyAx6
         2V7fEPNoW7NJmV+jAkr9lCtslkEg2/eAssmlyyB+5X8xT3Af8YNo0moZHW4HZCShKlsL
         WFsA==
X-Gm-Message-State: APjAAAVn8pmE6vjyzQKBRbNmxuZeWIZRBX1ANT0hePiuw3cLSrSSVIf6
        5Ev04BY85WH3b71YgJuVV/I=
X-Google-Smtp-Source: APXvYqzotBVrKLK7Jaa8T8BE9qJ2kK7Cb6IlZ+dSvzHAMYsoBbC5J9RoHeeVoM4vI+JFWtjVZBlSUw==
X-Received: by 2002:a17:902:563:: with SMTP id 90mr40957431plf.13.1571250698671;
        Wed, 16 Oct 2019 11:31:38 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::acd])
        by smtp.gmail.com with ESMTPSA id x139sm3303436pgx.92.2019.10.16.11.31.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 11:31:37 -0700 (PDT)
Date:   Wed, 16 Oct 2019 11:31:35 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        kafai@fb.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com
Subject: Re: [PATCH bpf-next v4 0/3] bpf: switch to new usercopy helpers
Message-ID: <20191016183133.ylo7k47o5qkygbze@ast-mbp>
References: <20191016034432.4418-1-christian.brauner@ubuntu.com>
 <20191016111810.1799-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016111810.1799-1-christian.brauner@ubuntu.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 01:18:07PM +0200, Christian Brauner wrote:
> Hey everyone,
> 
> This is v4. If you still feel that I should leave this code alone then
> simply ignore it. I won't send another version. Relevant tests pass and
> I've verified that other failures were already present without this
> patch series applied.

I'm looking at it the following way:
- v1 was posted with zero testing. Obviously broken patches.
- v[23] was claimed to be tested yet there were serious bugs.
  Means you folks ran only the tests that I pointed out in v1.
- in v4 patch 3 now has imbalanced copy_to_user. Previously there was:
  bpf_check_tail_zero+copy_from+copy_to. Now it's copy_struct_from_user+copy_to.
  It's puzzling to read that code.
  More so the patch removes actual_size > PAGE_SIZE check.
  It's a change in behavior that commit log doesn't talk about.
- so even v4 is not ready to be merged.
- the copy_struct_from_user api was implemented by the same people who
  sent buggy patches. When you guys came up with this 'generic' api
  you didn't consider bpf usage and bpf_check_uarg_tail_zero() is still necessary.
- few places that were converted to copy_struct_from_user() still have
  size > PAGE_SIZE. Why wasn't it part of generic?
  It means that the api likely will be refactored again, but looking at the way
  the patches were crafted I have no confidence that it will be thoroughly tested.
- and if I accept this set the future refactoring may break bpf side silently.
- what check_zeroed_user() is actually doing? imo it's a premature
  optimization with complex implementation. Most of the time the user space passes
  the size that is the same as kernel expects or smaller. Rarely user space
  libs are newer than the kernel. In such case they should probe the kernel
  once for new features (like libbpf does) and should not be calling kernel api
  again and again to receive the same E2BIG again and again. So the fancy long read
  optimization is used once in real life. Yet it's much more complex than
  simple byte loop we do in bpf_check_uarg_tail_zero.
- so no, I'm not applying this. Instead I'm taking bets when this shiny new thing
  will cause issues to other subsystems.

