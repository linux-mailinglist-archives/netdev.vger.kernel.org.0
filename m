Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A690F166E04
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 04:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbgBUDps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 22:45:48 -0500
Received: from mail-pf1-f170.google.com ([209.85.210.170]:43723 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729539AbgBUDpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 22:45:45 -0500
Received: by mail-pf1-f170.google.com with SMTP id s1so476253pfh.10;
        Thu, 20 Feb 2020 19:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=AtZBXgvE6bfxgvPtqJavVkpaf+V71Rnwot815Lu7Enc=;
        b=i6TKjZP2HtqW7yWE7dxz+dRkdvqlslnbPzjUEqr7r6uAZDrd/05S9ilUgQ7RFqkbbK
         bPJJT/0/xIenKi/Lgo8t4mLC3IF58/USYLBsniPRyf2X+FyvUnqg/NcBlnpxx1JDgqL+
         YaoLTknxbIjbIp2RpRC5C9qxdlOD84qwwtotUGpsMUTnGnO0c9BSddlQYZrnyilN1yDE
         xJw6pLzzKALubyZ9M2dvhzYEiA/OvwRYt9iDElBSI4fTL1qWNEELJK3yrNVZICdjtsxC
         ijZOIB+0z5lOSjWAos4eAozZslENxupjJ/GXvwavdfIRo0h/dwNpD63FL0w2opqmA+dC
         tkyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=AtZBXgvE6bfxgvPtqJavVkpaf+V71Rnwot815Lu7Enc=;
        b=Fd7HyP2uW7vLwlvtwRnIIwc/d2EoQCn/dbXTR87bsibjThnIcpFxz4ORgyfnG7nKA4
         pMgtk1FJ6Wy/k0ARAm1eHbu+0GF7qOLXIRcpJxEmnrfntsscv7HLkk6xIIo4Ed74lgq5
         yRZFazq9TKbUjMvAjiV20k4IqidZ1EE5fLGnq4BF+xrhNQalQcoA0YjsyftrTyNehx7k
         NmZc37KvpkHA1pATzW5u/7ndnpW9OFtXW9dAVkJqEPQ31ALZlqheNbF7E0fAm1coR0rD
         /xDcFYdQ4dP5Rf2o5ICDf9X34u3e3WWNNtwLyEK1Y+JkRLvYWR+DzwXD10S2btDLsG71
         55rw==
X-Gm-Message-State: APjAAAVB5H8O8Sdgo6igdPrjyPkjkKQS1qn7oUzzvJd8sFf/HDvbCJrP
        WCzSLqCt8Q5C7VjJ76aPYiw=
X-Google-Smtp-Source: APXvYqwVCX8AZ6V4cYPkqz2vvtRJ0cB45DeGqHjrb0BvjUpGilLKF4jPBHtbfY7AuH/ikfhESJfEzw==
X-Received: by 2002:a62:7883:: with SMTP id t125mr36668144pfc.141.1582256744570;
        Thu, 20 Feb 2020 19:45:44 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y3sm1060312pff.52.2020.02.20.19.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 19:45:44 -0800 (PST)
Date:   Thu, 20 Feb 2020 19:45:36 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Message-ID: <5e4f52604cc94_18d22b0a1febc5b8e7@john-XPS-13-9370.notmuch>
In-Reply-To: <20200218171023.844439-7-jakub@cloudflare.com>
References: <20200218171023.844439-1-jakub@cloudflare.com>
 <20200218171023.844439-7-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next v7 06/11] bpf, sockmap: Return socket cookie on
 lookup from syscall
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Tooling that populates the SOCK{MAP,HASH} with sockets from user-space
> needs a way to inspect its contents. Returning the struct sock * that the
> map holds to user-space is neither safe nor useful. An approach established
> by REUSEPORT_SOCKARRAY is to return a socket cookie (a unique identifier)
> instead.
> 
> Since socket cookies are u64 values, SOCK{MAP,HASH} need to support such a
> value size for lookup to be possible. This requires special handling on
> update, though. Attempts to do a lookup on a map holding u32 values will be
> met with ENOSPC error.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
