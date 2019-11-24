Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0329B108208
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 06:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfKXFgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 00:36:09 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:40573 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfKXFgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 00:36:09 -0500
Received: by mail-io1-f66.google.com with SMTP id b26so10635062ion.7;
        Sat, 23 Nov 2019 21:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=whOqFcaRa6hxNMBi94fnr+BqbvhJmTcK9gp80L3iRiQ=;
        b=OjzIh3vQlTwS8d9fx8WMHKr8s5/FYktvIXnidSSvPTuK7qCKucd5v/BDUevMWWjn5A
         5jGzMaBU4bEXF2XLasXl7fMW5jxy5ayVj5IDW97XGM08a5uBCAHapS/hOvckUksOXp4R
         sDeF8xBM0yQr0iMXmmkHSxr4RFjrVKfJpwKC5pOGeWGmU1TtdrTrsx/gkIQ97Nkj35Vx
         0YNJBBK8fr47GJPMWyGqT+Jfjg5xi3d0q+64xTkVncKDVVEmKh6KwJ3kVTWCdzjHHgMf
         kLBDPwa8taCJs0on8NQBb4yBKAUCGCL37hT5ydCI0CzV+izNOxymhMcTxTXjkh7SJUaY
         dmJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=whOqFcaRa6hxNMBi94fnr+BqbvhJmTcK9gp80L3iRiQ=;
        b=IOTfC8lfDixhvODnkt6qjO/R5UKQtexcD7v8lhVI+RxU8+aMIe0S/6IvraZrlUSnD3
         GEmNzUiOOWc0RFqeLOly+8hXdEe7Vnah0DHkGMktOO2+Irxkioq0hlHDD5hheiKja8DQ
         mZ9IhHxyTe5XjCWFnrWmXR4t8/zaDxv2X+7tVlmG0JnB9GzGtVTjoOzGZcrsdDi8aiGO
         KS44bQkEMeweokoLxnvDTU7Sw8QHEE3aGyl+OM0kKx6EA9e0Wl6b/6T8XKf2psIv6L0W
         94xz/ke1gI/e6EB96FjT1JUO2hDSMN5cTWhoD8gWvaSrfvh5vDUrP6zUEden7409+Io6
         Es7g==
X-Gm-Message-State: APjAAAWu6dnlcbowVi1WYe6bJ0V4ywtaB4w3/F3kIxy8pFD3R5mBaFwE
        /x6x0DjIQFMKc2yBiTTuZv8=
X-Google-Smtp-Source: APXvYqycr2ivUJUt0CpAonxBdZBv4VH+CNgLGMyN0MhO993VTvuHtlRF7V+pmVg5mU/ojgEgtMgRZA==
X-Received: by 2002:a5d:8b45:: with SMTP id c5mr4601855iot.187.1574573766953;
        Sat, 23 Nov 2019 21:36:06 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l19sm803580ion.14.2019.11.23.21.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 21:36:06 -0800 (PST)
Date:   Sat, 23 Nov 2019 21:35:58 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5dda16be755ff_62c72ad877f985c4c7@john-XPS-13-9370.notmuch>
In-Reply-To: <20191123110751.6729-3-jakub@cloudflare.com>
References: <20191123110751.6729-1-jakub@cloudflare.com>
 <20191123110751.6729-3-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next 2/8] bpf, sockmap: Let all kernel-land lookup
 values in SOCKMAP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Don't require the kernel code, like BPF helpers, that needs access to
> SOCKMAP map contents to live in the sock_map module. Expose the SOCKMAP
> lookup operation to all kernel-land.
> 
> Lookup from BPF context is not whitelisted yet. While syscalls have a
> dedicated lookup handler.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
