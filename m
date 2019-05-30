Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91AC82EA43
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 03:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfE3Bgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 21:36:35 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39166 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfE3Bgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 21:36:35 -0400
Received: by mail-io1-f68.google.com with SMTP id r185so3647675iod.6;
        Wed, 29 May 2019 18:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=irinaYFfplFObiKBsJmYaHsEQZ1KpbKkCxIEwRZjjFU=;
        b=dfwSc+GQ97vXQ4CPM8w9u3zBgDStVgkR4cYi/l38n7V9JAcOjEMpZGh17nBvNE92Xj
         tbOdVyFvyTuniYSvb754RZCwEbOo5Tg+x4px3o42M+2seL0kttLN9GJm5MTXsz8a/3ce
         4JvEVfHt5R+nOmXnhwAorvBvGm9UIjworiSoskPSQ+NvfENMVWck5GB4/nmlKeu53Nrw
         DREledL/9HcJsiv9wn/aR7PNRyk9U6aTt1gDpHAbRhUAz1m2ENj6CPzlZPmKm+NuPnrr
         iPRqfWKLFQveWvW/ZCnG9Q+BCG4pAwosVnSzEbBAcR/tQeALyi3Y/3+OId43hUViZb7O
         KEZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=irinaYFfplFObiKBsJmYaHsEQZ1KpbKkCxIEwRZjjFU=;
        b=pC7BpfdjgF/IVdr5INTiPIodSD0pxKBNWSh/hDAZBpO7BPpSMLkK7nF8og23PdM1j4
         NprHky9GUB5tDuekwB1NFKbfZyp5mwqcCk0B2blMeokK7wZ2AXTdtQhiPmWenhcv0uG3
         ilv3XoP1bSZYQTFCIz+K3loNPAWWFuMIH/OMiZKr6hoYf4BTMdKeeQzC94Wp47qakLxT
         YiOeNlJLJ9mGfxwBcqQjeaBtRzDaU+EO8RDmryucIn0WAhaJnSzsPCrHsrjf0NSwCPjI
         PcJDYMB+eQDQqEz4W+FLUu4EqtSuT5hFMhcMCZ/l9kxm/H2XVswmlaU2qQBVOaQbtsdW
         ohrg==
X-Gm-Message-State: APjAAAVmloIcG9BRRVZA47zTsnI5bYW24QOopG7AUHyw//8JCwWosIaj
        BPa51zhbnmXDe8e23x86pmugSNVKD2JkDMM6kug=
X-Google-Smtp-Source: APXvYqwXXniw3DxiQ8rgN/3mjrxf/rcx98ATwOCFDpnhwot08KfekceL08J5gQJndET8qP3ifU8BiJzZgaMNKRrR1IU=
X-Received: by 2002:a6b:8dcf:: with SMTP id p198mr1028939iod.46.1559180194549;
 Wed, 29 May 2019 18:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190529130656.23979-1-tonylu@linux.alibaba.com> <20190529130656.23979-4-tonylu@linux.alibaba.com>
In-Reply-To: <20190529130656.23979-4-tonylu@linux.alibaba.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Thu, 30 May 2019 09:35:57 +0800
Message-ID: <CALOAHbAghVKLKE2Y0A--cTUgheA=-HzF_kSmsBeNUguLFTT_Xg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] tcp: remove redundant new line from tcp_event_sk_skb
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 9:08 PM Tony Lu <tonylu@linux.alibaba.com> wrote:
>
> This removes '\n' from trace event class tcp_event_sk_skb to avoid
> redundant new blank line and make output compact.
>
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>

Acked-by: Yafang Shao <laoar.shao@gmail.com>

> ---
>  include/trace/events/tcp.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
> index 2bc9960a31aa..cf97f6339acb 100644
> --- a/include/trace/events/tcp.h
> +++ b/include/trace/events/tcp.h
> @@ -86,7 +86,7 @@ DECLARE_EVENT_CLASS(tcp_event_sk_skb,
>                               sk->sk_v6_rcv_saddr, sk->sk_v6_daddr);
>         ),
>
> -       TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c state=%s\n",
> +       TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c state=%s",
>                   __entry->sport, __entry->dport, __entry->saddr, __entry->daddr,
>                   __entry->saddr_v6, __entry->daddr_v6,
>                   show_tcp_state_name(__entry->state))
> --
> 2.21.0
>
