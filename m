Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFB224FFA4
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 16:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgHXON3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 10:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgHXONZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 10:13:25 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBE3C061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 07:13:24 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mw10so4289467pjb.2
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 07:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=My99gZu9SAiWLI/FM5xZGCr2h7VV0u5aP+ilsJxkPsw=;
        b=HpGBvByV+x8/zNqxwxPRhqIYxKvrUHK2enGkHJ7sPxNEMPoAlBPoBt8v0++iYxFO6J
         EPy1/xBRuLt6QI5T9AOKcM9DneOYsQYNgeKQgLfefW+x4wO3LOVtbc18Qtb7b+77fNUt
         KXHoxeEirHhNwNihCTUDz15pd4z/oYLEDkC4mEuEWJxCDbwg1pZXzRAdOm56BlkRN3++
         S35jhyjYBS2lkqmb8DQtgcCR77t14L37/mJwhwQFyD7tGxvEFk5+kAGgxXlOkK95xO2q
         VzcdlSorKmbJDm7k2290iNCEkKBXpB7mxMMPx3plgr3cfI86wOBWYeMmmhfQ57To7AUT
         1tyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=My99gZu9SAiWLI/FM5xZGCr2h7VV0u5aP+ilsJxkPsw=;
        b=WLxL2++mQPHBTU9vdDCPQ5C3MFkAybmpJSjQt1VLc19nhc3Qen5iHmfwNlZsiNJnhm
         VedyYGzKlCuPVg4I1uNG2wnwzXgWeGI3mJEE16+7/Da/KggkgOYEc1qzztOxbuNJZyMm
         ufReWI6swgngAA1PvWbucd7i7pKLPoNIeO6pd1jtdlPseaMMvp2SXg0pduvnPsVP84CP
         D/4SsCfkx8rsXsYcb7xq6OWO4tQ1Lc6FSsK/QNxtYrp3lBB1/m5RFlrXXHkKhT7ISZ4h
         j4whniETUt1UHvION89zRMFDIqxc93lYVeuYu1/gX2w7+5ApW8RfQSPe8G7YDqIvvhYV
         iTaw==
X-Gm-Message-State: AOAM531neadPG9rlO7l0s7MyUMLUcZK/mCG1jR+egfEeoazzzE8DJiSt
        8ixfiXbGpS7fQkDukXi1yw==
X-Google-Smtp-Source: ABdhPJyvkwGd239UD67WcPvS9vUlCtl3t3kvanxIwEy5zRezPm8CDYMJ3WWEQ7bdhzdD80GY/SO0Dg==
X-Received: by 2002:a17:90a:8817:: with SMTP id s23mr4901019pjn.158.1598278402245;
        Mon, 24 Aug 2020 07:13:22 -0700 (PDT)
Received: from madhuparna-HP-Notebook ([2402:3a80:cfa:d88f:d15b:321b:cea4:bde0])
        by smtp.gmail.com with ESMTPSA id r91sm10094555pja.56.2020.08.24.07.13.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 24 Aug 2020 07:13:21 -0700 (PDT)
From:   Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
X-Google-Original-From: Madhuparna Bhowmik <change_this_user_name@gmail.com>
Date:   Mon, 24 Aug 2020 19:43:16 +0530
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        andrianov <andrianov@ispras.ru>, netdev <netdev@vger.kernel.org>
Subject: Re: Regarding possible bug in net/wan/x25_asy.c
Message-ID: <20200824141315.GA21579@madhuparna-HP-Notebook>
References: <CAD=jOEY=8T3-USi63hy47BZKfTYcsUw-s-jAc3xi9ksk-je+XA@mail.gmail.com>
 <CAJht_EPrOuk3uweCNy06s0UQTBwkwCzjoS9fMfP8DMRAt8UV8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJht_EPrOuk3uweCNy06s0UQTBwkwCzjoS9fMfP8DMRAt8UV8w@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 23, 2020 at 12:12:01PM -0700, Xie He wrote:
> On Sun, Aug 23, 2020 at 8:28 AM Madhuparna Bhowmik
> <madhuparnabhowmik10@gmail.com> wrote:
> >
> > sl->xhead is modified in both x25_asy_change_mtu() and
> > x25_asy_write_wakeup(). However, sl->lock is not held in
> > x25_asy_write_wakeup(). So, I am not sure if it is indeed possible to
> > have a race between these two functions. If it is possible that these
> > two functions can execute in parallel then the lock should be held in
> > x25_asy_write_wakeup() as well. Please let me know if this race is
> > possible.
> 
> I think you are right. These two functions do race with each other.
> There seems to be nothing preventing them from racing. We need to hold
> the lock in x25_asy_write_wakeup to prevent it from racing with
> x25_asy_change_mtu.
> 
> By the way, I think this driver has bigger problems. We can see that
> these function pairs are not symmetric with one another in what they
> do:
> "x25_asy_alloc" and "x25_asy_free";
> "x25_asy_open" and "x25_asy_close";
> "x25_asy_open_tty" and "x25_asy_close_tty";
> "x25_asy_netdev_ops.ndo_open" and "x25_asy_netdev_ops.ndo_stop".
> 
> This not only makes the code messy, but also makes the actual runtime
> behavior buggy.
> 
> I'm planning to fix this with this change:
> https://github.com/hyanggi/linux/commit/66387f229168014024117d50ade01092e3c9932c
> Please take a look if you are interested. Thanks!
>
Sure, I had a look at it and since you are already working on fixing
this driver, don't think there is a need for a patch to fix the
particular race condition bug. This bug was found by the Linux driver
verification project and my work was to report it to the maintainers.

Thanks and Regards,
Madhuparna


> Thanks,
> Xie He
