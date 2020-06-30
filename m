Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870FE20FC5B
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 20:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgF3S5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 14:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgF3S5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 14:57:52 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E3CC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 11:57:52 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k23so22121143iom.10
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 11:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zwVzVVbF0UoaAY9lPyvGIq0hqmhYayrY8IewqclwhjA=;
        b=Uj+zmo/+nbKUPQEOSBH6UukozjVxoRlbIqqblnygpi3iObiEjBUB8oMliUDNJDLb/V
         ztvLw0XoXWSEYOdtr5I4IbW3d1IubT80Tzqg69ycxuGzBJxIAOcDywhdKNr50sshIKBH
         OP194A/FaObYd+VdlOu7T9C/jphXDhlEGYztoSJD/MHd+soFwgN++a4ObmN1fbMH/8fo
         7Yewhsz4FSxXhr8SWrzMa3zBUzPsyi3TYVngd6IPtjzfMbBr51+SS8pR9/CfzNiOS6cX
         3FlkIhAMkRB08lfwDcAUuf15TTG2ZFUACfU2DGnPV+I4yrpFSNsLBbeYbGmPdxLrFY9t
         Vgvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zwVzVVbF0UoaAY9lPyvGIq0hqmhYayrY8IewqclwhjA=;
        b=EGZ6BnlSs3hAjvGc747M2l3WxwtLonOhH7g2RxMUUj56wd5G/qlJpymPA88u9dAJlZ
         NxOn2XV2PEogG7ilzifA0luBffHD/z4lkNSqAI1RJgQKe9LeBUbonF/zm4zsjLRlhp4F
         HS7b6UvtyB15i1fkC9K318h3mccyCEFsPaSWOUV+t0iaxitvjux/wKojf5Db+6TUX8+F
         fYgK8jox+Y9CF9QlSySIb971Kvqpt8PkLyEYnA4H+Se8fulXWeGqSFnNZ9f+piGpRQmD
         X6jryDIDG+bkaL9JcxfYS5Q7l+KJ1KZGAZu9Mrx9vMz7mnvIwQAKE4GewR6z5hP94Z7O
         yyRA==
X-Gm-Message-State: AOAM532zHQTGosagfYkAda4oZzdzdcl2BCbJpBlnvyQ8kBpgbGq8NfYp
        iXCgmVfdKQdVePF2DU7vg4aX66iiiaFf9A0l2YXmV46kcTU=
X-Google-Smtp-Source: ABdhPJwvhQ1kojD8RkKLqOdMlFxesjlw0DS8SGVioXD7RHkumQotXqY8GAh2ONQGpx9ZUWCXesBOqsLzxj5RblC8RMk=
X-Received: by 2002:a02:c785:: with SMTP id n5mr25057159jao.75.1593543471329;
 Tue, 30 Jun 2020 11:57:51 -0700 (PDT)
MIME-Version: 1.0
References: <1593539417-19973-1-git-send-email-stranche@codeaurora.org>
In-Reply-To: <1593539417-19973-1-git-send-email-stranche@codeaurora.org>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 30 Jun 2020 11:57:40 -0700
Message-ID: <CAM_iQpV9cL9Ems7pedZdg4Yai7iPFTNy78zKFQ96OM1JeLTUqA@mail.gmail.com>
Subject: Re: [PATCH net v2] genetlink: remove genl_bind
To:     Sean Tranchetti <stranche@codeaurora.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 10:50 AM Sean Tranchetti
<stranche@codeaurora.org> wrote:
>
> A potential deadlock can occur during registering or unregistering a
> new generic netlink family between the main nl_table_lock and the
> cb_lock where each thread wants the lock held by the other, as
> demonstrated below.
>
> 1) Thread 1 is performing a netlink_bind() operation on a socket. As part
>    of this call, it will call netlink_lock_table(), incrementing the
>    nl_table_users count to 1.
> 2) Thread 2 is registering (or unregistering) a genl_family via the
>    genl_(un)register_family() API. The cb_lock semaphore will be taken for
>    writing.
> 3) Thread 1 will call genl_bind() as part of the bind operation to handle
>    subscribing to GENL multicast groups at the request of the user. It will
>    attempt to take the cb_lock semaphore for reading, but it will fail and
>    be scheduled away, waiting for Thread 2 to finish the write.
> 4) Thread 2 will call netlink_table_grab() during the (un)registration
>    call. However, as Thread 1 has incremented nl_table_users, it will not
>    be able to proceed, and both threads will be stuck waiting for the
>    other.
>
> genl_bind() is a noop, unless a genl_family implements the mcast_bind()
> function to handle setting up family-specific multicast operations. Since
> no one in-tree uses this functionality as Cong pointed out, simply removing
> the genl_bind() function will remove the possibility for deadlock, as there
> is no attempt by Thread 1 above to take the cb_lock semaphore.

I think it is worth noting removing the -ENOENT is probably okay,
as mentioned in commit 023e2cfa36c31b0ad28c159a1bb0d61ff57334c8:

    Also do this in generic netlink, and there also make sure that any
    bind for multicast groups that only exist in init_net is rejected.
    This isn't really a problem if it is accepted since a client in a
    different namespace will never receive any notifications from such
    a group, but it can confuse the family if not rejected (it's also
    possible to silently (without telling the family) accept it, but it
    would also have to be ignored on unbind so families that take any
    kind of action on bind/unbind won't do unnecessary work for invalid
    clients like that.

Thanks.
