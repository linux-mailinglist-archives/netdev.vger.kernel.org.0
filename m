Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7CE46722
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 20:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfFNSHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 14:07:50 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40913 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfFNSHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 14:07:50 -0400
Received: by mail-pg1-f194.google.com with SMTP id d30so1971561pgm.7
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 11:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jkwHTrVD1bfNnfcBC+pKJ+/nqMlegjtMqF+RJAeKSFY=;
        b=IWiirn/qhYvuJ4YOcnfjY6GuMtQxW63HJLx7ZPCTRQ1AM4IUelG+av9cW3TOylQiVz
         Gsb4CSnUtIuJ0c9MY5QoFSU6WItOfa7UjPp9xAwCild29MvEL3XBm7ju9KTWy0Xorwz+
         XTT0sA8NOBFFAna29B03uuPMwkm/T8r73Y1ky1tg8mYyaJ9pkN7banpCWm9faiqYFDdR
         mVIFwdxmp5qhPyWsODfg8UmB6UoCX2/o+tqGWmVNO3DFUdWyVpwfuo93aOSaxujtBnTC
         buDZupfdRnrGgmSwnEPp73FC4jFsMAiRgoVwtNShVU19eskgYvMkPbzb09LqjEQWEecs
         d7TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jkwHTrVD1bfNnfcBC+pKJ+/nqMlegjtMqF+RJAeKSFY=;
        b=ZF4YIU5dZ6xWj3oHDmY4L5sPgKvAKm1Hqd04WLYxpLO9N9UYqw6JWjTCHFWRwBsSAo
         Ob6UH775kaKODrS/KSbMtGv0aMPu8ggb0rC/r4SYhTRGo9/JWJbk+z40sLLvtL+NQpQT
         tCUq7yvHl9A0EHC8hLRsWcWR/7M55E6Wrev5Z6iHlfj4Jbxct4QFK5XuXRuiGYebKaxN
         wom1v+hnmKm5UyVE1DnsXqgAT7hyzSxX5oP6bITvgiKUym0EdgGnigHnEjnjw3TNBJBN
         lwMQYPvB5bhS9xRzXQVvybQlt4QFyG7CQGSoc4T/ehNZEEUN8bDvVrkmkThIOruSVyhO
         fdXA==
X-Gm-Message-State: APjAAAVt+zZK0fz0xb425Px/KDuKTEkJVRMe6Iz0vJHNyHSNmW0dq95h
        kNHMHNM0GU+HGGUDHsPsXqdZZFSj9joNuGLen3E=
X-Google-Smtp-Source: APXvYqwCMVDDqWMi3qnsJORgRN/P7J7QlvsE7oYDA694P612CM09RIVIZWyXD3U79fjBNLa2/8dqVRgGKMAR0UO9nkg=
X-Received: by 2002:a62:3543:: with SMTP id c64mr17725295pfa.242.1560535669410;
 Fri, 14 Jun 2019 11:07:49 -0700 (PDT)
MIME-Version: 1.0
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com>
 <1560259713-25603-2-git-send-email-paulb@mellanox.com> <87d0jkgr3r.fsf@toke.dk>
 <da87a939-9000-8371-672a-a949f834caea@mellanox.com> <877e9sgmp1.fsf@toke.dk> <20190611155350.GC3436@localhost.localdomain>
In-Reply-To: <20190611155350.GC3436@localhost.localdomain>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 14 Jun 2019 11:07:37 -0700
Message-ID: <CAM_iQpX1jFBYCLu1t+SbuxKDMr3_c2Fip0APwLebO9tf_hqs8w@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action ct
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Paul Blakey <paulb@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>,
        Kevin Darbyshire-Bryant <kevin@darbyshire-bryant.me.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 9:44 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> I had suggested to let act_ct handle the above as well, as there is a
> big chunk of code on both that is pretty similar. There is quite some
> boilerplate for interfacing with conntrack which is duplicated.

Why do you want to mix retrieving conntrack info with executing
conntrack?

They are totally different things to me, act_ctinfo merely retrieves
information from conntrack, while this one, act_ct, is supposed to
move packets to conntrack.
