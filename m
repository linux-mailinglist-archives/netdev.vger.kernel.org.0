Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE35E3A74
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 19:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440055AbfJXRzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 13:55:43 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44038 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436672AbfJXRzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 13:55:42 -0400
Received: by mail-pf1-f193.google.com with SMTP id q21so15584962pfn.11
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 10:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=FidDOLCxWh+reFUNqqD+6YZ8xoaPV+WzuM6jWJj2+oQ=;
        b=l5SZyZYt7DFDq+eDkZY2sUG43BXOT8qN9Fyygi12xtrgVDnTJJDgYAHazOTnBWXGop
         EQ7hrh51bahUQH6l7xRcAK38Orhx/qOglPC8P/wUyKzAusIahWNeZgSZOuyZa3forVAh
         M/DtY/jKHK54sRu3kp/xyfP+u+MHi0+gZZZAAFyQregBnfyhkkkmhUTDOH1ZhAooXQul
         PNQgEDrO586P502iTGKRfVNZmM0c8sREtrPYTqW2Vxu2gOCVuBVaIK5iH33op+bf1uIh
         fv6mVdNq59epoCLzUTN4nzo5H2UEAsjAhCk6jPEykHFb1nMZnqGDg5bzHSlObSP4cQv9
         bSHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=FidDOLCxWh+reFUNqqD+6YZ8xoaPV+WzuM6jWJj2+oQ=;
        b=m3uUe2ZIM9/KCwsFVhRjM3CarxWjyX6V6bwUBS9cvTTr5bvYay3vh/Gpjq2g5dEapc
         QEIsniLLE8Ymhbq0N6rr8QONIClNq/DiM219aOaFYqyoa5omgyG7DTWT/50qxkFZi5tY
         Wjs61ehN09VsakMdzLB/Im6yfdBwB9C19aGCVqCOi0N1mqZyXCCcjTVe44fd8L20P1EF
         QXEm6qyEKHCTCSLwPxX3EuBuO15K1ISNE9QNEDKnHxmrpHhX7fFNrtOtD0+P2IjjAWWA
         RAmQP6mvDaS/R8U9v5ff8xlAVNet0mIZuGDSF/i3+QO46zlvQVQx27Ge9NPLeKnqoDU1
         7REQ==
X-Gm-Message-State: APjAAAV+DHbVWIRaXLiYBxLoumga13Kww+9lGwRFMC/s6ZW4MjKQ1Y6r
        M5D4fEO2YKd5ejT0Ugu5EK0FFA==
X-Google-Smtp-Source: APXvYqx7tStZkpyPtmnq86Sk46kPNkjnjRN6vGKRlgzuY5I/jeLaSxTA5xcb2FmTcdOiV9uz3nLKqw==
X-Received: by 2002:a62:1889:: with SMTP id 131mr18927589pfy.235.1571939740772;
        Thu, 24 Oct 2019 10:55:40 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id i123sm16895339pfe.145.2019.10.24.10.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 10:55:40 -0700 (PDT)
Date:   Thu, 24 Oct 2019 10:55:37 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH] bpftool: Allow to read btf as raw data
Message-ID: <20191024105537.0c824bcb@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191024133025.10691-1-jolsa@kernel.org>
References: <20191024133025.10691-1-jolsa@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Oct 2019 15:30:25 +0200, Jiri Olsa wrote:
> The bpftool interface stays the same, but now it's possible
> to run it over BTF raw data, like:
> 
>   $ bpftool btf dump file /sys/kernel/btf/vmlinux
>   [1] INT '(anon)' size=4 bits_offset=0 nr_bits=32 encoding=(none)
>   [2] INT 'long unsigned int' size=8 bits_offset=0 nr_bits=64 encoding=(none)
>   [3] CONST '(anon)' type_id=2
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
> v3 changes:
>  - fix title
> 
> v2 changes:
>  - added is_btf_raw to find out which btf__parse_* function to call
>  - changed labels and error propagation in btf__parse_raw
>  - drop the err initialization, which is not needed under this change


Aw, this is v3? Looks like I replied to the older now, such confusion :)
