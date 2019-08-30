Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 406C6A3327
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 10:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfH3Iyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 04:54:43 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:36816 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfH3Iyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 04:54:43 -0400
Received: by mail-wm1-f46.google.com with SMTP id p13so6618751wmh.1
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 01:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xdqhILanMzzjo9Xz2xJHy7IoXrm9N7Ymo3atJx4WQJE=;
        b=I7OBv1XyEmX11igOgVcT2i4a+7xvNxZZqGLqsQbiEi+7ecyPItbN31QNhs6ABDdGHP
         aUzLjsO/6nvUMKbpebwbqDhJm20qWF6F5GfU5xmkFiWJLeZX0xzwB/tPveT/WAdo7fda
         Cba5ltwNy3BfV6GHE9emG4nlEB3h3Y8ALKi1VtXjO/EjIoFlqthDmDt91/md7s8EiHNU
         Nkm5SiwQ+VhAsTX5ncXciw/cB+iIKqgXBbo2iFczk20kkxKmHFb/9DQZOucvOLDSLXel
         RWNC4RZieyCmSy5x1z8n7vPCiaXRSmHF4ML+y3SdskLxGWwcrGuCKTB9PuZn55PqP/zC
         OSsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xdqhILanMzzjo9Xz2xJHy7IoXrm9N7Ymo3atJx4WQJE=;
        b=GY7tI0Hj+zlMnMABcUygQyLq4Yvj1khqbiT588+qcuRYa6ZsEtmsPEGBQA2mCFAJns
         hn2Rdv2Om7Oo/XF2vLe8hdunypZjxeEwKoAJOTyZ/clWKPdQqz1qMCSQ/g+kCeLr3CeA
         2ztjFBL6KwB1rqxYqcMWNn+KtVEy37sr+6VdwKWAwhl+4L17DB9s1TBj8hs24yn8xjA7
         X9Lk7Hfd8xhZUhvG2okYc3NmAvWJTtDueX+89G5riM27eNNSKkliYysrdIQ+NxpB+Bve
         u0jNaiBsuc7mjYP1OTrdY8wyppr2DSRzTPUdsyB4QZAtHPa/pGH5k2JzuZSL5h4RXgGN
         F1PQ==
X-Gm-Message-State: APjAAAUGNm0EWVH45BCM3rKcQSF2GLeNv7v7V/X3mXrV/JgGgEmIUUOw
        OMJO/uicWqB/O1gHnbAL79VWrWe3
X-Google-Smtp-Source: APXvYqzCZ164kXhwz02K3/hnLW+07c9aFWCtts3+sMl+fhRPv2Byx7l/IXuR3vvVAj/f+9QLW8LAVA==
X-Received: by 2002:a1c:a481:: with SMTP id n123mr15801886wme.123.1567155280949;
        Fri, 30 Aug 2019 01:54:40 -0700 (PDT)
Received: from [192.168.8.147] (31.169.185.81.rev.sfr.net. [81.185.169.31])
        by smtp.gmail.com with ESMTPSA id d16sm6254297wrj.47.2019.08.30.01.54.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Aug 2019 01:54:40 -0700 (PDT)
Subject: Re: Is bug 200755 in anyone's queue??
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Steve Zabele <zabele@comcast.net>
Cc:     Network Development <netdev@vger.kernel.org>, shum@canndrew.org,
        vladimir116@gmail.com, saifi.khan@datasynergy.org,
        saifi.khan@strikr.in, Daniel Borkmann <daniel@iogearbox.net>,
        on2k16nm@gmail.com, Stephen Hemminger <stephen@networkplumber.org>
References: <010601d53bdc$79c86dc0$6d594940$@net>
 <20190716070246.0745ee6f@hermes.lan> <01db01d559e5$64d71de0$2e8559a0$@net>
 <CA+FuTSdu5inPWp_jkUcFnb-Fs-rdk0AMiieCYtjLE7Qs5oFWZQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8f4bda24-5bd4-3f12-4c98-5e1097dde84a@gmail.com>
Date:   Fri, 30 Aug 2019 10:54:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSdu5inPWp_jkUcFnb-Fs-rdk0AMiieCYtjLE7Qs5oFWZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/29/19 9:26 PM, Willem de Bruijn wrote:

> SO_REUSEPORT was not intended to be used in this way. Opening
> multiple connected sockets with the same local port.
> 
> But since the interface allowed connect after joining a group, and
> that is being used, I guess that point is moot. Still, I'm a bit
> surprised that it ever worked as described.
> 
> Also note that the default distribution algorithm is not round robin
> assignment, but hash based. So multiple consecutive datagrams arriving
> at the same socket is not unexpected.
> 
> I suspect that this quick hack might "work". It seemed to on the
> supplied .c file:
> 
>                   score = compute_score(sk, net, saddr, sport,
>                                         daddr, hnum, dif, sdif);
>                   if (score > badness) {
>   -                       if (sk->sk_reuseport) {
>   +                       if (sk->sk_reuseport && !sk->sk_state !=
> TCP_ESTABLISHED) {
> 
> But a more robust approach, that also works on existing kernels, is to
> swap the default distribution algorithm with a custom BPF based one (
> SO_ATTACH_REUSEPORT_EBPF).
> 

Yes, I suspect that reuseport could still be used by to load-balance incoming packets
targetting the same 4-tuple.

So all sockets would have the same score, and we would select the first socket in
the list (if not applying reuseport hashing)

