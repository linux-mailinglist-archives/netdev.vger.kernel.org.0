Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A887934D33C
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 17:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhC2PDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 11:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhC2PDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 11:03:17 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B5DC061574;
        Mon, 29 Mar 2021 08:03:17 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id v26so13070746iox.11;
        Mon, 29 Mar 2021 08:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=/M82DVGCiyCGtxECSz5RJ4iJR+NeofIlyKwdwK3+gKA=;
        b=TSP5tEJYmSVYcsITdad+jnrx+2PvWKc2OgKSgpUf6tcRZ6MU1bjlb+4YC0/22pAvpL
         K6yswOs2+ZPJyEAuwwbWUA6IS+aYviUyg5PWOeEdRT51L3ebwkqwrAr/kw5e6xzQ4RbE
         Uj4fNqCsx3lZ/KEO1vXQnkF5/gdgMxIeqBDspHSN/g965xitGSQznPFPgP5Xy5SPTzhI
         UR5EwrDoBO9AILVGPefgS1A8jrjJv4oa/xAdfNhx5tVkqlc0kTcNdJ3NSpruLFqblMnj
         +X7bn6pObnYZ5hJn2UVJkMmvh7i5UY6PcQ7HEE2o8sFilGF7RBfHnUQi0zgcK+/pYrE7
         YbtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=/M82DVGCiyCGtxECSz5RJ4iJR+NeofIlyKwdwK3+gKA=;
        b=caFMfAbtYvS0enfE/SSrZrH7fJKRcYHBY9EaZ0WSNsGMqjZ5rYddsn26xjIZjaihys
         JfjLyZ3AHX0Ik0Kcyf3xfK4ne5Uew+Ih2gjq8TUHmWR+ISNQTyfQ5QJOixcwaR94S9g9
         VRaDtWxTl8JFfOm2gZ8Vulk3tglts9MPuFydzNBqWW9LLxXZRcAjCiUsht7U9WLZRIna
         wOjuN9ZP0ZF0s46m4C86H/VA3XaSBj6WGXhOoaSVMfGKTDdpLfytuYaG/vebmD+UbuUO
         1n99tqThnDOHylUTUMRPg4ZAWeZfqUfFcZdiFpPVeeANV1tAirYehaUnsEZbsZAa0wg7
         w5YQ==
X-Gm-Message-State: AOAM530QQoLoH/3OTqqXVX9BkUGsGuEtj+EoxM32wE5PxoJJnA6kx3Zj
        8SpMY6dpcDoB13lf7Mqcbuw=
X-Google-Smtp-Source: ABdhPJwUJyTS2uwvlQiqIGN7DuSCD5DxrBOFd/hxr88tTlUDsgRsLbVKNfoRklKCBM1aByw+r6AuBg==
X-Received: by 2002:a02:c50f:: with SMTP id s15mr23759053jam.133.1617030196979;
        Mon, 29 Mar 2021 08:03:16 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id y18sm10061772ili.16.2021.03.29.08.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 08:03:16 -0700 (PDT)
Date:   Mon, 29 Mar 2021 08:03:07 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>
Message-ID: <6061ec2bc63e0_3673a20848@john-XPS-13-9370.notmuch>
In-Reply-To: <20210328232759.2ixde3jvudnl3pi6@ast-mbp>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
 <20210328232759.2ixde3jvudnl3pi6@ast-mbp>
Subject: Re: [Patch bpf-next v7 00/13] sockmap: introduce BPF_SK_SKB_VERDICT
 and support UDP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Sun, Mar 28, 2021 at 01:20:00PM -0700, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> > 
> > We have thousands of services connected to a daemon on every host
> > via AF_UNIX dgram sockets, after they are moved into VM, we have to
> > add a proxy to forward these communications from VM to host, because
> > rewriting thousands of them is not practical. This proxy uses an
> > AF_UNIX socket connected to services and a UDP socket to connect to
> > the host. It is inefficient because data is copied between kernel
> > space and user space twice, and we can not use splice() which only
> > supports TCP. Therefore, we want to use sockmap to do the splicing
> > without going to user-space at all (after the initial setup).
> > 
> > Currently sockmap only fully supports TCP, UDP is partially supported
> > as it is only allowed to add into sockmap. This patchset, as the second
> > part of the original large patchset, extends sockmap with:
> > 1) cross-protocol support with BPF_SK_SKB_VERDICT; 2) full UDP support.
> > 
> > On the high level, ->read_sock() is required for each protocol to support
> > sockmap redirection, and in order to do sock proto update, a new ops
> > ->psock_update_sk_prot() is introduced, which is also required. And the
> > BPF ->recvmsg() is also needed to replace the original ->recvmsg() to
> > retrieve skmsg. To make life easier, we have to get rid of lock_sock()
> > in sk_psock_handle_skb(), otherwise we would have to implement
> > ->sendmsg_locked() on top of ->sendmsg(), which is ugly.
> > 
> > Please see each patch for more details.
> > 
> > To see the big picture, the original patchset is available here:
> > https://github.com/congwang/linux/tree/sockmap
> > this patchset is also available:
> > https://github.com/congwang/linux/tree/sockmap2
> > 
> > ---
> > v7: use work_mutex to protect psock->work
> >     return err in udp_read_sock()
> >     add patch 6/13
> >     clean up test case
> 
> The feature looks great to me.
> I think the selftest is a bit light in terms of coverage, but it's acceptable.

+1

> I'd like to see the final Acks from John/Daniel and Jakub/Lorenz before merging.
> Folks,
> please prioritize the review of these patches.

This is getting really close I'll take another pass over it today. Thanks
