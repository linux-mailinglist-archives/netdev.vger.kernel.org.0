Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA5481057
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 04:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfHECs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 22:48:28 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45886 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfHECs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 22:48:28 -0400
Received: by mail-ot1-f68.google.com with SMTP id x21so18292921otq.12
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 19:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lKp78wWvU0kANLx8YD9r7it4hHU91ljdayzeBmIo0bg=;
        b=hlCm380IUNDfiDQDbBtnFQmcHNXjGPEEhK2UDeg9Y9lbmysXHCw0ISKtm08VhxZYrD
         U5Nk6sI/Lr14FSYCG1TvssqzybtHnwoHGeiclmZyQW4qc2/LckszFT3KM8ZEMpI7PfWp
         ELxzW1PB+A5QEXeo/ZcyMvQSAsh74egVNybtgaNCfHg301mMbTQxH3CuIgmd1OL3Zu1b
         UAox4io0hWWETfbVQDu+oyxRLqa72YSCrvtYnXcXq3Ajcplm/xiErzDzdCDOk9PLHDz+
         9hYxAuGvzRBCf2RLqzgpEMrU2x055L1hnJXp7x/+uFnX24Gu4Wnrta7n3U4ZaSbZNPb3
         b96A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lKp78wWvU0kANLx8YD9r7it4hHU91ljdayzeBmIo0bg=;
        b=X7UfxsFT22XGpHFTg5jRGkMum/62K+0P4Hq/XBQ5LKvAh5u+z7Q37AAvf57osoQGu5
         Qkzvl/b3MD2jSah0HJRZH7YFTUGmKQOBjuInO8ysal6xdgfdSa7V+LCA0bx4kWGXTqtl
         GZl3SJtm5VVt7M1pMOj3sQGaRw7lDgZVTrRjPvU3HUk5cRAyL2USG7i3CB2MdEUMKGqb
         dm81wpj6E4TDN0xFPVyM1fxmcRO2vAUIdoxNLkY2e7FN8fD6LM1CqxPsFU3bZON8HRMM
         vk31oMB9vZsTK1Dnb2hOkjJn+kZC+p6puRiyvZKAP7dFknyP/t22aFn9+ukMPhTUNRu5
         1VKw==
X-Gm-Message-State: APjAAAWgfsBWNrj2ZEbUt2rVBbx6YxUWOo06hsDXv2L0JlnmO+sxaQP8
        z+bDSFn7j/SG1xByxEz3WNuIhpup29OV1J3XOMAL50YXgqk=
X-Google-Smtp-Source: APXvYqz1235c8CxnMpil1iYta7skcACaJ0OXXWChydB+LVPO/75KTcpqZ87T9ywk6DPLFnhZfwfvpwyJK2IcU6xxrbg=
X-Received: by 2002:a05:6830:2116:: with SMTP id i22mr68301233otc.318.1564973307479;
 Sun, 04 Aug 2019 19:48:27 -0700 (PDT)
MIME-Version: 1.0
References: <1564694047-4859-1-git-send-email-pkusunyifeng@gmail.com> <CAOrHB_CExkSymgCU5yGKg66XywJgNxihn8VQJNr8hw6cff0rOA@mail.gmail.com>
In-Reply-To: <CAOrHB_CExkSymgCU5yGKg66XywJgNxihn8VQJNr8hw6cff0rOA@mail.gmail.com>
From:   Yifeng Sun <pkusunyifeng@gmail.com>
Date:   Sun, 4 Aug 2019 19:48:16 -0700
Message-ID: <CAEYOeXN0QCahV_kAMZ8T2zwJiP_1gSnATBnCG7hA7XrGUT8cMA@mail.gmail.com>
Subject: Re: [PATCH net-next] openvswitch: Print error when
 ovs_execute_actions() fails
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes, this fix is mainly for debugging purposes. If packets are
blackholed because
of errors from ovs_execute_actions(), we can got more helpful
information. Thanks
Pravin for the review, I will come up with a new version.
Yifeng

On Sat, Aug 3, 2019 at 4:00 PM Pravin Shelar <pshelar@ovn.org> wrote:
>
> On Thu, Aug 1, 2019 at 2:14 PM Yifeng Sun <pkusunyifeng@gmail.com> wrote:
> >
> > Currently in function ovs_dp_process_packet(), return values of
> > ovs_execute_actions() are silently discarded. This patch prints out
> > an error message when error happens so as to provide helpful hints
> > for debugging.
> >
> > Signed-off-by: Yifeng Sun <pkusunyifeng@gmail.com>
> > ---
> >  net/openvswitch/datapath.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> > index 892287d..603c533 100644
> > --- a/net/openvswitch/datapath.c
> > +++ b/net/openvswitch/datapath.c
> > @@ -222,6 +222,7 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
> >         struct dp_stats_percpu *stats;
> >         u64 *stats_counter;
> >         u32 n_mask_hit;
> > +       int error;
> >
> >         stats = this_cpu_ptr(dp->stats_percpu);
> >
> > @@ -229,7 +230,6 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
> >         flow = ovs_flow_tbl_lookup_stats(&dp->table, key, &n_mask_hit);
> >         if (unlikely(!flow)) {
> >                 struct dp_upcall_info upcall;
> > -               int error;
> >
> >                 memset(&upcall, 0, sizeof(upcall));
> >                 upcall.cmd = OVS_PACKET_CMD_MISS;
> > @@ -246,7 +246,10 @@ void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key)
> >
> >         ovs_flow_stats_update(flow, key->tp.flags, skb);
> >         sf_acts = rcu_dereference(flow->sf_acts);
> > -       ovs_execute_actions(dp, skb, sf_acts, key);
> > +       error = ovs_execute_actions(dp, skb, sf_acts, key);
> > +       if (unlikely(error))
> > +               net_err_ratelimited("ovs: action execution error on datapath %s: %d\n",
> > +                                                       ovs_dp_name(dp), error);
> >
>
> I would rather add error counter for better visibility.
> If you want to use current approach, can you use net_dbg_ratelimited()
> since you want to use this for debugging purpose?
>
> Thanks.
