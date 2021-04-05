Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B120D35479F
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 22:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236532AbhDEUjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 16:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235057AbhDEUjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 16:39:46 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10220C061756;
        Mon,  5 Apr 2021 13:39:40 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id d10so11173917ils.5;
        Mon, 05 Apr 2021 13:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=/uqtrTk76E5aD5BCOBGzpRyzBUYwdahQgpdwOPHUsbY=;
        b=uut0Tg011r0h+bZrv3oGSMerCa21hHin5S5onMV0erTVHdv0a157vg3SKc4xh6RYWD
         5LZDrus62Fhb9o9rPjpAKm0YAyln7QyWk+Uc3XvVvL2GpKCgZQU+XtxfKvBB+qdkmAKK
         5VTMoF8hKMp174nxt5o9BDfrR0J/9Hr1uSokOI5Rez3F427p1jXpx91VCVXuyINsYhHz
         C7R2YmEGO+VB0EKjUaHKK++PMUyssuFaXYHCisQolMtflyK6lLEOUX+A54U1IdZR93v2
         g5q9B8Xs2Jd9nd8X6WI+sKHXl0prmSrz7LvQFfndP8PTxH0Y5yxxdm7ed4ATGpm+NYhL
         rTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=/uqtrTk76E5aD5BCOBGzpRyzBUYwdahQgpdwOPHUsbY=;
        b=m7Lg3InvJsEui9zaABihz764tXTyZqjqSsOCie7d2rxvJsaVHTtFtwT3snKPhyk+LO
         5nurvjP3Qj9trB6QNE8d/O7dFGiuvq0dADascUUGm09a8hj0ZprSdT9fx5Jl1+Tv3aEm
         okuu1GuuLXur3eDkiqKJzT76af2GcWstGt9/bDJKUauLnk0967Wxp++NbuE6TIzCU74m
         0kniTiF1zbMTcnH/U+BevXpivh/2vYr4sKwge4VsB7B6EU94EYvZYjTlKHPhW+/yrMN+
         BhO2GL4mx0WXDZGNaiYtOA0Z+H32hmaTw9kamBqTPIc40k4zk+W/kZlcAyOUMsdcodQ4
         9L5Q==
X-Gm-Message-State: AOAM5325tcEEDBbSPemB41XJG/uQfDc+8KZE5GPE/0r4e9K1MJfN4QaY
        p6Z3gyJ9M2cfOPGvxgR+G3I=
X-Google-Smtp-Source: ABdhPJxIFyPWeo/lkEmGH66fwXz+3sGpfGMN8nqmqszZc3PhxdEwhwEM0ic5SlwtrfNC8qj2ht8qPQ==
X-Received: by 2002:a92:c545:: with SMTP id a5mr21330554ilj.209.1617655179563;
        Mon, 05 Apr 2021 13:39:39 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id t9sm9852025ilp.65.2021.04.05.13.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 13:39:39 -0700 (PDT)
Date:   Mon, 05 Apr 2021 13:39:30 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <606b7582a4bf1_d464620890@john-XPS-13-9370.notmuch>
In-Reply-To: <20210403052715.13854-1-xiyou.wangcong@gmail.com>
References: <20210403052715.13854-1-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next] udp_bpf: remove some pointless comments
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> These comments in udp_bpf_update_proto() are copied from the
> original TCP code and apparently do not apply to UDP. Just
> remove them.
> 
> Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
