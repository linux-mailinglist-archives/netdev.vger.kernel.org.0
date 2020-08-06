Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EBC23E4E1
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 01:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgHFXzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 19:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgHFXzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 19:55:15 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FBDC061574;
        Thu,  6 Aug 2020 16:55:14 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id s16so238752ljc.8;
        Thu, 06 Aug 2020 16:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dzAx/x8vW7RoWOuxg1fqwHs9H8+c1qNMnW74YoUK2qU=;
        b=Pel5W/abBlflEnQtzjkyZv9CqjL/NNasBeNW6jVMFIAHOdsFWQle0GmCuj60RwnULD
         VkGYT/86ruZF1ZovCVkeNnuQ71Jd301rLt+wN7Z7re3Ck7BbqqA+nlOuKxl0bDsD+Eg4
         t3jj6dbGJqZ36arn0dwPpA35Pfm2QjZOP9K3b4l2vDbDonGcz0l4MRlr+IcmqtleoTCX
         n6DdZLjXIGJCdD2/UgXlqNvXBgqCWv9eQswnfkmTtfgzjo2y4nO7QQIJ2AqF/izYOqT4
         pSPTkowHlMl8H76X/tyIBu7hw0HwALUxdeJTrAP4UeIYlYgdUXJkLWOrE1a+tweEu2kH
         5cjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dzAx/x8vW7RoWOuxg1fqwHs9H8+c1qNMnW74YoUK2qU=;
        b=m+RC4FqMhyCF7kFFGE1RR37jHl/d2C9srqBqz/sAW5JfFTTpFBXTNP2Uo5DAuxMDJD
         Zq2JUhxMHiglIqHd8esKXp9TpK1JGC5GxDVC8OUlJuJ/8aMW/FS7GVyXOnxvv3YCtnyp
         vXW2b/wvoeTW97NPmNRndqZmwHjXm4n081lvM5VJB229G/nYss7c34xBpwOwtIEl6X0l
         J/fpCS7rZ2Br0Oiwj2qcoZNclepNJrnwkwxR18dtvz3ltWUsoHeBijsx/xvA7qVK2MCX
         TF45ZnJNcU2f87eM32Oz5oTLykybt3ltFz50xO1f/ne0SLqAdjaxBTcNSzmIgKO6OLWo
         wHYg==
X-Gm-Message-State: AOAM5309i0iyjsRRWBXX/lnX+yt5ioEq2eZBzHwPGmi7vbJyFjVwFWUk
        CY8zzS3STuDVPQ9xVSb4N9xksSo0DIoqTbdSxkM=
X-Google-Smtp-Source: ABdhPJwsXtJpD6sNRbB4BCYEQWgjd0H+l1rDw0FX0E+2Z9CnPkdCu1WPdgraHIGMIhTcJaXd0+EOpwguaJO6q8VqEnI=
X-Received: by 2002:a2e:b6cd:: with SMTP id m13mr5071351ljo.91.1596758112913;
 Thu, 06 Aug 2020 16:55:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200806182612.1390883-1-sdf@google.com>
In-Reply-To: <20200806182612.1390883-1-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Aug 2020 16:55:01 -0700
Message-ID: <CAADnVQ+Xpd1iPJ1YDxhZvVU77ccmi5yRKCztC+df+acBY89fKA@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: remove inline from bpf_do_trace_printk
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 6, 2020 at 11:26 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> I get the following error during compilation on my side:
> kernel/trace/bpf_trace.c: In function 'bpf_do_trace_printk':
> kernel/trace/bpf_trace.c:386:34: error: function 'bpf_do_trace_printk' can never be inlined because it uses variable argument lists
>  static inline __printf(1, 0) int bpf_do_trace_printk(const char *fmt, ...)
>                                   ^
>
> Fixes: ac5a72ea5c89 ("bpf: Use dedicated bpf_trace_printk event instead of trace_printk()")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Applied. Thanks
