Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A493F6D4510
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 14:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbjDCM75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 08:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbjDCM7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 08:59:52 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782613C3E
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 05:59:50 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id h8so117008623ede.8
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 05:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680526789;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dWMhy/t539IzUjxTQlxZzF55vJj38fXw5CgiiST7WoI=;
        b=EIMfkueJsSyGSK+8OPBVlrRE1m7H37jVvs3YRP8wgnjjjRYhCkyZw9/mpLD8XtG0p6
         iYyw3yyXtJ2gIgLf+G3BBfv3U9NkkwcMMp2PCwbaozw0ZL9r7HaagO/zFa5Q3Le1/ROw
         Z7mTY9gOCIuGDV7f8rX3OPnzLs42QOvsnasDU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680526789;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dWMhy/t539IzUjxTQlxZzF55vJj38fXw5CgiiST7WoI=;
        b=iYqFiNaH+tjzYi/5Mv377AHOlOkug5P1RvIcXsea++ZKLrgvPA4j5pn+8WPOsc42Lk
         FRKyZ5US7OsJ0h9rvTW0uONE0mIEzlqjxmncsEHGJnup0htRjjRX7EyGUNCxBkpsX5SE
         gQoge93w5ZbxHyWiKTcr4RWuESYPET5ACjmP5vpxmCPeytXOXeqnNm4Xdu8Da9dORY9W
         EfhYOCtAaCK4VGzqitAsX1tv61+5MWTszm7ZWuT/APq9XBTPfbzfp4r5dKUsvfVzoX8j
         4rook3Wltmomub2jnKkHUz5iKkgT1Yi6cYVNNkKSbOlwrka1uf74THZhefNLlzvQA8Xo
         U64Q==
X-Gm-Message-State: AAQBX9cbbKKfmTj9CLNdkfBNbW8dgcjgHzTfdydDPKexeQWXDId/bL6P
        ymvUYiwitqWSv5IGOwh0cu8ttphz8k736/Qp7dlA6g==
X-Google-Smtp-Source: AKy350buzM/6fGqG9ifTA/zHfPscPJQRPN9Aaudu77e/ZrcnbirUhnCLxw1InMJ7FFXja1clKzLlL1EHhV8lpgNhmyM=
X-Received: by 2002:a17:907:3f96:b0:8f1:4cc5:f14c with SMTP id
 hr22-20020a1709073f9600b008f14cc5f14cmr19885345ejc.0.1680526789038; Mon, 03
 Apr 2023 05:59:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230403120318.30992-1-kal.conley@dectris.com>
In-Reply-To: <20230403120318.30992-1-kal.conley@dectris.com>
From:   Kal Cutter Conley <kal.conley@dectris.com>
Date:   Mon, 3 Apr 2023 15:04:29 +0200
Message-ID: <CAHApi-=9Rgss=8spbOm=V0UBS+_XesmFUZVhDK20RWdTSXRa5Q@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests: xsk: Add xskxceiver.h dependency to Makefile
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I will resubmit this against bpf-next.
