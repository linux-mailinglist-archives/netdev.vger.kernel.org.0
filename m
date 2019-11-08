Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4D7F4C03
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfKHMnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:43:42 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:45826 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfKHMnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 07:43:42 -0500
Received: by mail-il1-f194.google.com with SMTP id o18so4991744ils.12;
        Fri, 08 Nov 2019 04:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u8obCCtRiabqcHSXwbzDRpusLvtXClX2dy2Z3AWgWUw=;
        b=tsRLdRka6uE9+Zi4R9xgupIKKeIHBhlzkzzQ2lhv9h33iUzD6p5LVRK722wQrQJmZA
         8d5ZftrTrbcd371boA41kTRHcOKSk5u0LL28usLarIBcUXlLyxUnLhU7tAZPC4s2MB1c
         25pOcussRxUmI4+oI75E5IvMtha1hJCR+piZ/fwewgNAG8MvoOY9F83+w6pxzfd8gNI9
         M57zwvIAuHsO9+qa+/AnyPzFQ0fD4CVtuCWKyw4THyz114kRLRaUf+dPhox9wuMFstg7
         rixXbNnrKekZaJvNtn/vEwEFr5Q3FUWR05pCDL70j4rOkgadXfPMdbU81ZZAGNh/lnaE
         X47A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u8obCCtRiabqcHSXwbzDRpusLvtXClX2dy2Z3AWgWUw=;
        b=t9GGE9W3NklRpKLLWgkjSy1NvfdoA0SoEuO7+iajKJRn1Gih8X22N6F4RoxN0baVpC
         ug266DY3UaKYSM+b39Rl4FWO5VMWcVuqWzKT05GuJtLU2Xx4OXCgmKfiFFMUA3PtKVzk
         C8pqluY+h6wQQABuG+MZzpMm8+J4P3KX5HRRnCXfHALt4BakkQJ0EvXD3DudRWrsGWBn
         zEcACW7qNxLwW2Hcz8CaeWeZ0m9NomYO4YyFUy2wTLvpKVXapg1J0hGITwU/NoNpJB3R
         qXywmQrjEyXIgeX6RBbjYWDkqKHFsyzh98cvAaMmhM5E8OEoTIERXnNvc6mL8l9/F3e6
         kEyw==
X-Gm-Message-State: APjAAAVrfMWssuIA5pI6VIUUDrN9YY12ipM/tFMa8bHEgoMvSYuCLzqS
        cmtDNqsC7PuyQTf28/1pRSMcSP3XszuDMEK3WhI=
X-Google-Smtp-Source: APXvYqyy8Qn/FY5+ZKeJwig6c57BebjQNrSLV58a0qU9A0tsNxnAjlIlE/7xIepelyqttm9BkTbRqv+z26qjPQ/YA6w=
X-Received: by 2002:a92:5850:: with SMTP id m77mr12615200ilb.203.1573217020972;
 Fri, 08 Nov 2019 04:43:40 -0800 (PST)
MIME-Version: 1.0
References: <20191108095007.26187-1-tonylu@linux.alibaba.com>
In-Reply-To: <20191108095007.26187-1-tonylu@linux.alibaba.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 8 Nov 2019 20:43:04 +0800
Message-ID: <CALOAHbByAFM5_L4sT8AKz0M1cTWjocceo2OwWcfasT+5nM=Eyg@mail.gmail.com>
Subject: Re: [PATCH] tcp: remove redundant new line from tcp_event_sk_skb
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 6:12 PM Tony Lu <tonylu@linux.alibaba.com> wrote:
>
> This removes '\n' from trace event class tcp_event_sk_skb to avoid
> redundant new blank line and make output compact.
>
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>

Thanks for pointing this out.

Reviewed-by: Yafang Shao <laoar.shao@gmail.com>

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
> 2.24.0
>
