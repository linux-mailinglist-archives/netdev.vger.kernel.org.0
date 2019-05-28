Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFBC2D011
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 22:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbfE1UIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 16:08:55 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33515 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbfE1UIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 16:08:53 -0400
Received: by mail-ed1-f67.google.com with SMTP id n17so33641789edb.0;
        Tue, 28 May 2019 13:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SjF+86A9m1M+atbxSEPSNy8KPYRNpeEGdkrJdSTr8nM=;
        b=f9wEmtxZnE47Uuv6AxtP9cM51UkErZL54zvMMy/BUmx+BxkEECBzxnQ9VXon4pjTpt
         enHDRUsGhxu3L0di0HLsKzlwSiW47f/Qn9Ps4fTPJwM9CFOpw7cDwJlkdSIkdgR9Oanv
         id6CD8Q/NlroocPbiiL6GTM9CrdodOMcK9hfEZHRwW91JwKwVH0X/6O5vZ+2bS0xU82b
         bTzJhuzXDiRf/SmFTdP52W5aqNSTvYBPwJeHaIvQdc6VXDairEVLxHe1VDJR8XRi1Ot+
         R5gE1QB92O7xMjQYYsdAbaOfC/YCoHtjYR2HyH9IS+Z/1m+B9r4/QPNSwWD+v+OBJGHP
         NkoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SjF+86A9m1M+atbxSEPSNy8KPYRNpeEGdkrJdSTr8nM=;
        b=uabwGqVDQgmyukaJYvlBCDeBH1yo9t5lORtr6eUEhlCr9Jri/AE+ypysh8Mp2LM1IZ
         qyulz+8SieHKqpZirqMLDxSfSkhiZOh1FEYBBrm8FCGQcdLcf02Z1tLwRwJwFl0bGzh6
         dvbhDK9FnPCR4o55FJzZeKsgC3X/NzokbkpAptlqe5HG6K4V35C2quApqU2IMq7tDuFz
         TojhKc3hir1RwKxJRWaEy9s8Gj+QatIicFXUaIcdsnuH+BSU56ucljoxCFK1QnRgeKTq
         eRtM2zSdfC/HfKKMHo1U2Nt95n24B3W1MEWsXUQ8j/h2El3hnSNnyBAyxcI6ZwZVws5v
         i3QA==
X-Gm-Message-State: APjAAAVxW+5gBjuKNIBMl0Efe6pHa7JJ5VjqLuA0G+/HbvMDVpUaGGqy
        sjVnN6g/4qeq652ihaCXA9AdRW34d1ghuYaLL4qmHA==
X-Google-Smtp-Source: APXvYqy0WKb0Az9r06UWh1hsp9ZV8w6Gbh2+DCruvVFCH5k2vjl8gXFNRb1YNE33ezp7hciA/zW572alocjbYaWGhv8=
X-Received: by 2002:a17:906:c82e:: with SMTP id dd14mr42804911ejb.133.1559074132185;
 Tue, 28 May 2019 13:08:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190528184708.16516-1-fklassen@appneta.com> <20190528184708.16516-4-fklassen@appneta.com>
In-Reply-To: <20190528184708.16516-4-fklassen@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 28 May 2019 16:08:16 -0400
Message-ID: <CAF=yD-KVUo5ZM4wivh0iwucfRxf2wp3WtMLce2jj497uOg-LOA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] net/udpgso_bench.sh test fails on error
To:     Fred Klassen <fklassen@appneta.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 3:26 PM Fred Klassen <fklassen@appneta.com> wrote:
>
> Ensure that failure on any individual test results in an overall
> failure of the test script.
>
> Signed-off-by: Fred Klassen <fklassen@appneta.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks Fred.
