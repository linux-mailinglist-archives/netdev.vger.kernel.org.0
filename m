Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D429624A78A
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 22:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgHSULT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 16:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgHSULT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 16:11:19 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21B5C061757;
        Wed, 19 Aug 2020 13:11:18 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id k13so11343168plk.13;
        Wed, 19 Aug 2020 13:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=dbcOzTqx7hOOJVlLikGR6xEV3IO3I5Sm2hqIIob1Cuo=;
        b=DPsJXVrE4wsCVAUtKsCOLb0YlLh7Om3nNkFl0FqcfsIcx8uJav/oLgVJmYsTroWpAt
         s9kTeMsnuX112omdMZ8Oxa024PmVMXGgYRG5cRpVUECVxsUcyN+DrJY7KFmuMYZrdG00
         k0BH7UkcZ2Yaqh09IuRyJDWKUd6349jkwvc2whcHZMezjP65WV7V8dBuCTeN+XT+nl7r
         kKJdB0jL6lioLHwvJYzwRrthg+bEMxuDMobrRsNVFC3RwvI76mPPAAynEaDTEzT1PCLk
         9CsjyIcbysz7H1fNXVH2KNd0nkYZgfSlRShswGEe528kABtIOV0g3uy0G+wQkr6rz+mw
         Jfvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=dbcOzTqx7hOOJVlLikGR6xEV3IO3I5Sm2hqIIob1Cuo=;
        b=AV4II6ZmdDZi/IcxGi4hE6vmKzmyvo0ymm+9zyqLSXFjyqHQpNR3jbyKxXG6eUPXyS
         B4Yu18qQ0iiEUSOr4Sf1mfTRa7GKhaUMmBIGNcQGRZbi+xMIIJa2Ku5gKCL8SM60Z87N
         KJOMJeQnQBjRFkZ4zBxTG6lDwdEdsuG9jPvKXu5d2a/FXcZXvSwtJUmSYy0lMr2A2C82
         OhCjHV646ls1c9ysktG8e1t/R+QYwtMS3rl7N+99P5KpgD1nV/1uLSngwDxeiEFUDF19
         ml+ZAw6O+ooyuEaGRlyQBVESN44UpSFtbadSApTT+ekWC8qxRlxnhM0Tc5dQojCfBD/W
         MKQw==
X-Gm-Message-State: AOAM533eUjNru3CV0vPK+7gFw15Ss4kBIhRPMcrNqcyC7YivVnRzGyzK
        gIP0uK93oJz2BsPEsI1yHZ4=
X-Google-Smtp-Source: ABdhPJxKb6igMqNCmJg6p6N0OwVskY/zaKIHTUPQISWCRr/ANvJg5GGLvX2ebLkFVLNRFjfXrBa5pQ==
X-Received: by 2002:a17:902:8546:: with SMTP id d6mr20334128plo.218.1597867878106;
        Wed, 19 Aug 2020 13:11:18 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n12sm44536pfj.99.2020.08.19.13.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 13:11:17 -0700 (PDT)
Date:   Wed, 19 Aug 2020 13:11:11 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>, jakub@cloudflare.com,
        john.fastabend@gmail.com, Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <5f3d875f43b9f_2c9b2adeefb585bcea@john-XPS-13-9370.notmuch>
In-Reply-To: <20200819092436.58232-3-lmb@cloudflare.com>
References: <20200819092436.58232-1-lmb@cloudflare.com>
 <20200819092436.58232-3-lmb@cloudflare.com>
Subject: RE: [PATCH bpf-next 2/6] bpf: sockmap: merge sockmap and sockhash
 update functions
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer wrote:
> Merge the two very similar functions sock_map_update_elem and
> sock_hash_update_elem into one.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  net/core/sock_map.c | 53 ++++++++-------------------------------------
>  1 file changed, 9 insertions(+), 44 deletions(-)
> 

Fixup the warning, but otherwise

Acked-by: John Fastabend <john.fastabend@gmail.com>
