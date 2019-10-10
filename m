Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF54DD31BF
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 21:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfJJT57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 15:57:59 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33563 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJJT57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 15:57:59 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so4589426pfl.0
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 12:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=D11jdimFUgtFsEzOrX+OLo6cwiUtcVEfQ2z/j7ikNl4=;
        b=IOkwotS1hA/OO7TsIwuEmb9v3X8qWOdPDtLOAnEl9y2d8KaQQY9lyKiDxPjXmH9abf
         dpVQc8Z1hWV12jsuFVdKP1trELyhe4FdqB8oSxUvqT0uGXOouqNtzMS1qWiTQ8zoYLBg
         v2295+tNG8EtFHul6yX0bcCYpO4GEKJEdbxOXW3GCqWhnxdVo85XxbFUOHsCSX78KYDi
         NUAilW44G1VNQuzdflgad/Ku+fJ/2zrUjkyYXFq9XbvKgGhK5o+blEz9p5rDjn7WdWlT
         PQHQZ5WnusSad6jyMlu+bTtWfqe2O5rdvtbwAuTFt/jf0Q4cXvuOaf+KD5zyRnToDA7N
         wQZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=D11jdimFUgtFsEzOrX+OLo6cwiUtcVEfQ2z/j7ikNl4=;
        b=kc8BMMinJ2Iw7T3VuGwKujIdJD8aD4tb/HLSKfvAFKkwqmVxatAtqNUkVaqP5T5Cou
         8sQmAZsWevY8agOechd/25K1R/5xtpGHXL0H4PxxHLf+TyxELbe4aUIcv20fYXf5PTz/
         /zvgd1ohjLhLNA6xH1PiP2jOHs7prK0y6FRx9f6XnG4nWW4J0MNCjJ7MTNbh889s8Ll8
         O6veeOKgvFSlJzedXX++HHnY56Suj45C2qtd7j3ouSYKw8lHqfr/zsXEt8JNOEIbIMfR
         kv3Go/AhdFFBbdil/jCUBqNxSWBa3iKYJKjEi4JiiPWZv7Zv3P3QlkoDh1/DrVqzSUxs
         K91w==
X-Gm-Message-State: APjAAAUHk3FIHhHD1nkuA/sUF/SHECiK+UONREuuqPshC8MmSKJwq2z3
        +HaFQjzyzqAmrlb2DNffLHWJrQ==
X-Google-Smtp-Source: APXvYqwg7MksWsefjLmMrpG8r82nqovOAs90OqyvyY26Bq56HZrtlhI+1ezZPV/KBf7vtGSuouDeiA==
X-Received: by 2002:a17:90a:9f8a:: with SMTP id o10mr13206506pjp.91.1570737478841;
        Thu, 10 Oct 2019 12:57:58 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id h8sm7384109pfo.64.2019.10.10.12.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 12:57:58 -0700 (PDT)
Date:   Thu, 10 Oct 2019 12:57:57 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next v2 0/2] Atomic flow dissector updates
Message-ID: <20191010195757.GH2096@mini-arch>
References: <20191010181750.5964-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010181750.5964-1-jakub@cloudflare.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/10, Jakub Sitnicki wrote:
> This patch set changes how bpf(BPF_PROG_ATTACH) operates on flow dissector
> hook when there is already a program attached. After this change the user
> is allowed to update the program in a single syscall. Please see the first
> patch for rationale.
> 
> v1 -> v2:
> 
> - Don't use CHECK macro which expects BPF program run duration, which we
>   don't track in attach/detach tests. Suggested by Stanislav Fomichev.
> 
> - Test re-attaching flow dissector in both root and non-root network
>   namespace. Suggested by Stanislav Fomichev.
For the series:
Reviewed-by: Stanislav Fomichev <sdf@google.com>

Thanks!

> Jakub Sitnicki (2):
>   flow_dissector: Allow updating the flow dissector program atomically
>   selftests/bpf: Check that flow dissector can be re-attached
> 
>  net/core/flow_dissector.c                     |  10 +-
>  .../bpf/prog_tests/flow_dissector_reattach.c  | 127 ++++++++++++++++++
>  2 files changed, 134 insertions(+), 3 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
> 
> -- 
> 2.20.1
> 
