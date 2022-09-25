Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F091F5E9139
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 08:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiIYGZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 02:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiIYGZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 02:25:14 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180B721244;
        Sat, 24 Sep 2022 23:25:10 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id b21so3614982plz.7;
        Sat, 24 Sep 2022 23:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=/9+S3w2KTexUwGjM1ZrLCIzYIY9JvXq+FJwM8gQ/p3s=;
        b=DTMA7qpkT0Msnh2y0UveC3W9mPrlDD9y9sK1d/ontnH1A9idhiDKxLWJ+fLcE++N9X
         8NTHnQn7IKAx7n7jELhrAbXaaog2Nli3owFhm51UlTq3kC3A8Qtw4xsHccKix5ouxj99
         1RrS8Xm06iQ+SV9cGFA1Cpx9D0uodm4yKqX2PFSwXUnREPaXiCpbT3l6QeN1iXPjEGAk
         Cok/8+lA2E1E/e8j/WPDddG9yp7JOb3oRbs4kwwsIlAR8NloalBCT6b8HKGj2cp1Bz1M
         XO03/zB62Q+72T4XcXZzNnFYiLxGyOnJmlwv7ir6AGarWDSUZmE6TieEQZ+DRmm/mXQT
         Jn8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=/9+S3w2KTexUwGjM1ZrLCIzYIY9JvXq+FJwM8gQ/p3s=;
        b=DHvWT+1vbrsMIr8lD8xfFg6L1/wVHOPVoutQ35PSlWAZP5gckNSW7mUjpiKpkYH+J7
         zcxZNvbhZxIWC/Tz7iXReAWDct5FarnbY1hdxllPo3XB5wzbY00K+7MsM7Q0y7AAVOGp
         8xaGAi074UjFaE7l2su9t4rcgoiniVnVV8ZWawvGmNeGT673qn9SKj0gr6o09O9zRiZz
         6byHY3Fu/ZhDWdbmhgVMGaavYhOFbIWK834VE4Y0AYx9MypXmhR7suF1AB6S+qN44+BN
         5BlE0w6lzkD0zCc8trKhqfsQUOmSRqnB1D99si4MNYh/WYoqdill7u01h2kYctxVYJqA
         HUMQ==
X-Gm-Message-State: ACrzQf23+3J1Hz0P7Fa2FD/BaYRVoUZxHjHVj+lRPIajUu+RGE6wAQM/
        /hnEUhYa1xoKihgFrR8TU14=
X-Google-Smtp-Source: AMsMyM6qj6M0WLtIPQqdGN6Tkih4WyEYGV6ujOpFtZ4qTBw9Z1y4J4Spd6qux6bKHursa2Yj1i3FWw==
X-Received: by 2002:a17:90b:3a84:b0:203:6911:52c with SMTP id om4-20020a17090b3a8400b002036911052cmr31004938pjb.73.1664087109415;
        Sat, 24 Sep 2022 23:25:09 -0700 (PDT)
Received: from localhost ([36.112.180.197])
        by smtp.gmail.com with ESMTPSA id c6-20020a170903234600b0017680faa1a8sm8680206plh.112.2022.09.24.23.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Sep 2022 23:25:08 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     keescook@chromium.org
Cc:     18801353760@163.com, davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, sfr@canb.auug.org.au,
        syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yin31149@gmail.com
Subject: Re: [PATCH] Add linux-next specific files for 20220923
Date:   Sun, 25 Sep 2022 14:25:01 +0800
Message-Id: <20220925062501.4373-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <202209240905.F5654D7A5@keescook>
References: <202209240905.F5654D7A5@keescook>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 25 Sept 2022 at 00:26, Kees Cook <keescook@chromium.org> wrote:
>
> On Sat, Sep 24, 2022 at 11:55:14PM +0800, Hawkins Jiawei wrote:
> > > And as for the value of offsetof in calculating **offset**,
> > > I wonder if we can use the macro defined in
> > > include/linux/wireless.h as below, which makes code simplier:
> > > #define IW_EV_COMPAT_LCP_LEN offsetof(struct __compat_iw_event, pointer)
>
> Ah yes, that would be good.
>
> > According to above code, it seems that kernel will saves enough memory
> > (hdr_len + extra_len bytes) for payload structure in
> > nla_reserve()(Please correct me if I am wrong), pointed by compat_event.
> > So I wonder if we can use unsafe_memcpy(), to avoid unnecessary
> > memcpy() check as below, which seems more simple:
>
> I'd rather this was properly resolved with the creation of a real
> flexible array so that when bounds tracking gets improved in the future,
> the compiler can reason about it better. And, I think, it makes the code
> more readable:
>
> diff --git a/include/linux/wireless.h b/include/linux/wireless.h
> index 2d1b54556eff..e0b4b46da63f 100644
> --- a/include/linux/wireless.h
> +++ b/include/linux/wireless.h
> @@ -26,7 +26,10 @@ struct compat_iw_point {
>  struct __compat_iw_event {
>         __u16           len;                    /* Real length of this stuff */
>         __u16           cmd;                    /* Wireless IOCTL */
> -       compat_caddr_t  pointer;
> +       union {
> +               compat_caddr_t  pointer;
> +               DECLARE_FLEX_ARRAY(__u8, ptr_bytes);
> +       };
>  };
>  #define IW_EV_COMPAT_LCP_LEN offsetof(struct __compat_iw_event, pointer)
>  #define IW_EV_COMPAT_POINT_OFF offsetof(struct compat_iw_point, length)
> diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
> index 76a80a41615b..6079c8f4b634 100644
> --- a/net/wireless/wext-core.c
> +++ b/net/wireless/wext-core.c
> @@ -468,6 +468,7 @@ void wireless_send_event(struct net_device *        dev,
>         struct __compat_iw_event *compat_event;
>         struct compat_iw_point compat_wrqu;
>         struct sk_buff *compskb;
> +       int ptr_len;
>  #endif
>
>         /*
> @@ -582,6 +583,7 @@ void wireless_send_event(struct net_device *        dev,
>         nlmsg_end(skb, nlh);
>  #ifdef CONFIG_COMPAT
>         hdr_len = compat_event_type_size[descr->header_type];
> +       ptr_len = hdr_len - IW_EV_COMPAT_LCP_LEN;
>         event_len = hdr_len + extra_len;
>
>         compskb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
> @@ -612,16 +614,15 @@ void wireless_send_event(struct net_device *      dev,
>         if (descr->header_type == IW_HEADER_TYPE_POINT) {
>                 compat_wrqu.length = wrqu->data.length;
>                 compat_wrqu.flags = wrqu->data.flags;
> -               memcpy(&compat_event->pointer,
> +               memcpy(compat_event->ptr_bytes,
>                         ((char *) &compat_wrqu) + IW_EV_COMPAT_POINT_OFF,
> -                       hdr_len - IW_EV_COMPAT_LCP_LEN);
> +                       ptr_len);
>                 if (extra_len)
> -                       memcpy(((char *) compat_event) + hdr_len,
> +                       memcpy(compat_event->ptr_bytes + ptr_len,
>                                 extra, extra_len);
>         } else {
>                 /* extra_len must be zero, so no if (extra) needed */
> -               memcpy(&compat_event->pointer, wrqu,
> -                       hdr_len - IW_EV_COMPAT_LCP_LEN);
> +               memcpy(compat_event->ptr_bytes, wrqu, ptr_len);
>         }
>
>         nlmsg_end(compskb, nlh);
>
>
> --
> Kees Cook
Yes, it seems that this code is more readable. I will refactor the patch
in this way, with some comments on union in struct compat_iw_point.

By the way, do you think we need to refactor the **struct compat_iw_point**
into union with some comments, or just replace the **pointer** field with
**DECLARE_FLEX_ARRAY(__u8, ptr_bytes)**? Because it seems that this field is
only used in wireless_send_event() and some macros in this
include/linux/wireless.h
