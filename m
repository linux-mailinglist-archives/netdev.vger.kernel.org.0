Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32684166E24
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 04:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbgBUD4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 22:56:36 -0500
Received: from mail-pf1-f170.google.com ([209.85.210.170]:34400 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729546AbgBUD4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 22:56:35 -0500
Received: by mail-pf1-f170.google.com with SMTP id i6so509629pfc.1;
        Thu, 20 Feb 2020 19:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=gCbYsLyU1KGIe1sOsm/3n+35+QzRb9iVghoB5eCrExI=;
        b=Oq74jQBTGeol42v8i4ILJMfemc2hgDc+ywenG9f5JTWjcUCDRH+0RHUfLfjv/98iHx
         FYh8uuvHL1kHZquXadYbOCl42jqX5J6rt7Hr3VX0pTUJoP9K7swvW14WkMquOwudxdSH
         Yu1kP5gpWeDrBGZ3aIgf8Tyoo/xjrnyXBZx+w130Y5EXXEB06nIyApNBvhqTkgzI/gID
         Cii4hu+s4Y0ZcROrS6ntOJrxehhYmDuKyU7MOJ/GtnFw+bvxKJUVMO8KUSIgGjt2is94
         kuOSomuFwwlzXIpFpowb2aWt+NZ+s9MdnCjrWx0ajwQyr/tc+43Qz/Ok6/YrOyZTpKwc
         c8dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=gCbYsLyU1KGIe1sOsm/3n+35+QzRb9iVghoB5eCrExI=;
        b=s0CQTokF+rggsMb4IQ5wOuVueBE5WVzB4yQjIMw0SNPUrc9QGg24r3W3F5YXfggBk1
         XvVapWAUSpjmd9BKvqvWDOkc2JP3A3RBMR5nOIK6exnIlJ+jBM4TZlm5Xa3Mw+01IT6k
         UNU/KTLA4yQb6+TmA3QLORHKp6WIyZHihynLELJ4nhS/rTYxhT0gjkbmT5PoN1/HoYF+
         C4gb6kC7Wt48DZEvSv8Rtmz81XCuPffhOoehNm0LxhPKEwp85AOD5VjCtuSQN3HWt4DL
         4HuV1k8nVZ9YDfZZ65odC312QYRgvm98yYPe8rGuq/plPVWTMv7TnYIF1PgZSxcO91P3
         WL7A==
X-Gm-Message-State: APjAAAWOb9TQgiiYaKpK8RI7QdA2AQSLZqHpSzNcMRXUkBZHkzJCCXcs
        oDQtY4WM9+Yt2Qyup9sF/Ww=
X-Google-Smtp-Source: APXvYqzF6dLm0s6FONJWZ88dGq1tk3J5dScNE5w+WHK5TOdYWQGpiIW3xqzPBY0vWMmj0xvoZaZPKw==
X-Received: by 2002:aa7:9a42:: with SMTP id x2mr35587288pfj.71.1582257395115;
        Thu, 20 Feb 2020 19:56:35 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q17sm720427pgn.94.2020.02.20.19.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 19:56:34 -0800 (PST)
Date:   Thu, 20 Feb 2020 19:56:26 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Message-ID: <5e4f54eaee9c1_18d22b0a1febc5b8cc@john-XPS-13-9370.notmuch>
In-Reply-To: <20200218171023.844439-12-jakub@cloudflare.com>
References: <20200218171023.844439-1-jakub@cloudflare.com>
 <20200218171023.844439-12-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next v7 11/11] selftests/bpf: Tests for
 sockmap/sockhash holding listening sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Now that SOCKMAP and SOCKHASH map types can store listening sockets,
> user-space and BPF API is open to a new set of potential pitfalls.
> 
> Exercise the map operations, with extra attention to code paths susceptible
> to races between map ops and socket cloning, and BPF helpers that work with
> SOCKMAP/SOCKHASH to gain confidence that all works as expected.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  .../selftests/bpf/prog_tests/sockmap_listen.c | 1496 +++++++++++++++++
>  .../selftests/bpf/progs/test_sockmap_listen.c |   98 ++
>  2 files changed, 1594 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_listen.c

Reminds me I need to clean up the sock{map|hash} tests as well.

Acked-by: John Fastabend <john.fastabend@gmail.com>
