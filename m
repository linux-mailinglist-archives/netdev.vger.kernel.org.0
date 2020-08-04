Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A3E23B1B5
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 02:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgHDAiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 20:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHDAiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 20:38:00 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C1DC06174A;
        Mon,  3 Aug 2020 17:38:00 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id j9so29342683ilc.11;
        Mon, 03 Aug 2020 17:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=/0oCy70RFIN066TrFulJWWmDnXfji/8HsiVZmqW+WI0=;
        b=rHujQqlTWFNaZFX+EyuPeECTJ4r7fXCTGlsB7CtEY4vFVVTxj7BszMsxwbAB8e4T3a
         NLyXAbRJb03eBuViG6U02S7lParJo1t+N5hhjFiEV1JIipKsgXscoDO8KIqWNUAqt4yv
         ItppMF/0ZyBq+pbYQ4TYSpKaYIE57+1k9sNvfRHjmL2KC9VxyVacxhLpxujSJADUFH/S
         Al2HbcAl0jCesf6NKx+dFzT0ajZO4p0kYQJp7oqtE+/4FjvNxN+F1d9Lg4p+I8JN+PDU
         291Yj1RNtYTjfqO/fPDYw3Caz5CJMm7H2NjobeibagJzKRrE7nsiwy6SJknPs/JAHErU
         mwrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=/0oCy70RFIN066TrFulJWWmDnXfji/8HsiVZmqW+WI0=;
        b=jUdoDBUE0+DqeSqlcivlb0utlDBp9ktPVkjX1/EAHzq/nV3miPaWw2SSs/BoCcbDC6
         wIL8ZQF19h2TbeeMwxfpnkdzQUdpXPqFhkb1umty9AIf4dD2JslOBRUMEGeLUwPBCs63
         rGfe2QYzUb4GdgzTzq6zcSk2fjECLIALwC/EIPyUquzm3dkGdJl/DNzwODBA/ieAiBTc
         FWoJpe92qetsxbvyEcVj8XUyJCwnboHXN6Bq86BFFwsskIVp31EtSl7wERdWnKHjY1ja
         OPvQXijqQsOfiV8FJb8WYRVUwG2mU6aLU6A3EFc8ekZW/FISk5bAKg+vCABqTHYv02C4
         RuNg==
X-Gm-Message-State: AOAM5309YgdnIGxHZHLHbDoC74so0ZjLeVF43IovJvI0yA9inrSA15a7
        gCBbGr0GS+1sdgcBtKORlXo=
X-Google-Smtp-Source: ABdhPJxvgP+td2hejlCfbQsCwq2IGfifwDQD65s5kBcN3uMAo8+RQH/xOGB4VG0YMWTzYIFx5rgESQ==
X-Received: by 2002:a92:5f43:: with SMTP id t64mr2121823ilb.14.1596501479905;
        Mon, 03 Aug 2020 17:37:59 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y80sm11818530ilk.82.2020.08.03.17.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 17:37:59 -0700 (PDT)
Date:   Mon, 03 Aug 2020 17:37:51 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Message-ID: <5f28addfb3c31_2a3e2af6c9e325c02c@john-XPS-13-9370.notmuch>
In-Reply-To: <20200803224340.2925474-1-yhs@fb.com>
References: <20200803224340.2925417-1-yhs@fb.com>
 <20200803224340.2925474-1-yhs@fb.com>
Subject: RE: [PATCH bpf-next v3 1/2] bpf: change uapi for bpf iterator map
 elements
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yonghong Song wrote:
> Commit a5cbe05a6673 ("bpf: Implement bpf iterator for
> map elements") added bpf iterator support for
> map elements. The map element bpf iterator requires
> info to identify a particular map. In the above
> commit, the attr->link_create.target_fd is used
> to carry map_fd and an enum bpf_iter_link_info
> is added to uapi to specify the target_fd actually
> representing a map_fd:
>     enum bpf_iter_link_info {
> 	BPF_ITER_LINK_UNSPEC = 0,
> 	BPF_ITER_LINK_MAP_FD = 1,
> 
> 	MAX_BPF_ITER_LINK_INFO,
>     };
> 
> This is an extensible approach as we can grow
> enumerator for pid, cgroup_id, etc. and we can
> unionize target_fd for pid, cgroup_id, etc.
> But in the future, there are chances that
> more complex customization may happen, e.g.,
> for tasks, it could be filtered based on
> both cgroup_id and user_id.
> 
> This patch changed the uapi to have fields
> 	__aligned_u64	iter_info;
> 	__u32		iter_info_len;
> for additional iter_info for link_create.
> The iter_info is defined as
> 	union bpf_iter_link_info {
> 		struct {
> 			__u32   map_fd;
> 		} map;
> 	};
> 
> So future extension for additional customization
> will be easier. The bpf_iter_link_info will be
> passed to target callback to validate and generic
> bpf_iter framework does not need to deal it any
> more.
> 
> Note that map_fd = 0 will be considered invalid
> and -EBADF will be returned to user space.
> 
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

LGTM. I had to do some git log research on latest bpf iter work though to
parse the commit message, but I needed to do that anyways.

Acked-by: John Fastabend <john.fastabend@gmail.com>
