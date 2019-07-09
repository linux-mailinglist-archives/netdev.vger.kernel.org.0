Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D06AD62D64
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 03:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfGIB2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 21:28:21 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:44185 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfGIB2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 21:28:21 -0400
Received: by mail-oi1-f193.google.com with SMTP id e189so14081585oib.11
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 18:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iKptimPvGUeQtzTZIjYB/hrV48fLDD/ylYqyCIpWXr0=;
        b=C2/bmVXm99ZidnTCO1VY4a8ItBwew4EjHYACMy4xXg5/qNjLZKrOS9ZkHe4mGqQZvN
         LAycr88CVGD8OgWMkDZYJO0j+G1yqVhBSoiyX1M68NZkR3q9z7jHLKEudXA7Ph8EWkpw
         AxayWxc5d6fngwA8DR7Pb7AVSFsfl1X8e3/gznNrJOgTua90bkdikla9m+T0ufohjD4v
         bgds2IoGUEdB5oPj4/oeESIGf/WEXrtcyiyYRHo+ewd49lBO5bUe1BHDzSisX38bkAGq
         DwHU93sxv6Rc6Upc5XPO1Y813q9ZJH2RxrtoWhFqBuDNpV61w/y+vXh/emnEDmqYgQoj
         KXoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iKptimPvGUeQtzTZIjYB/hrV48fLDD/ylYqyCIpWXr0=;
        b=e4vEaNhZx6X6S/9qUJDj137fIvK/1MP1HtJdzBBpnZblaz/q6c4OrXfmFpTh8AIJWu
         1NP9nACor8qM4lTEW7luSWu8wZhULfXFIjcuARL03z1Gyrd1EIMgMjXPkrL1rYLl3p2u
         vtA/yavGE7z3Y6RNuKLJ+6WMYgbfFvKUTDPlGKBcv+hBcx68LH3uAKxCsJ+5c5Gtnc4x
         lk4qOuUYuknWdpL6jXo8RtxobgC0lLw+PQcdoKUMfLE707SQb/KkjbqRfqJpPIAFcJVn
         oIMZPME5sUfMSay1ij1C5lTNM5iYk98EAHxn/GDgJCDhgKdrEFWMKkmig0iifiR8jdpq
         vk1A==
X-Gm-Message-State: APjAAAUxNTidVDEHUh71aIMb+Wz8RLLnACHlmzTPKvLZtcpB4UK3SCX2
        gSRwqEkDkCkKYA8yiQgs8TEzzlX7ME4tKaxkvEg0Rg==
X-Google-Smtp-Source: APXvYqxHvSWTSDDPfo161vX1VXLy6PpAxSBTx790u5hTlAJwJ6i2pO6iGbzu8dKWG6LZ0NwLFrhVWOYUroy977Q/Z5Y=
X-Received: by 2002:aca:170d:: with SMTP id j13mr213185oii.77.1562635700547;
 Mon, 08 Jul 2019 18:28:20 -0700 (PDT)
MIME-Version: 1.0
References: <1562201102-4332-1-git-send-email-lucasb@mojatatu.com>
 <1562201102-4332-4-git-send-email-lucasb@mojatatu.com> <20190704202909.gmggf3agxjgvyjsj@x220t>
In-Reply-To: <20190704202909.gmggf3agxjgvyjsj@x220t>
From:   Lucas Bates <lucasb@mojatatu.com>
Date:   Mon, 8 Jul 2019 21:28:09 -0400
Message-ID: <CAMDBHYKwxnJYMp97vMmhZR5unqT7LyXivhqFm+-Vc59LMqmO4A@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 3/3] tc-testing: introduce scapyPlugin for
 basic traffic
To:     Alexander Aring <aring@mojatatu.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>, kernel@mojatatu.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry Alex, I completely forgot about this email.
On Thu, Jul 4, 2019 at 4:29 PM Alexander Aring <aring@mojatatu.com> wrote:
>
> Hi,
>
> On Wed, Jul 03, 2019 at 08:45:02PM -0400, Lucas Bates wrote:
> > The scapyPlugin allows for simple traffic generation in tdc to
> > test various tc features. It was tested with scapy v2.4.2, but
> > should work with any successive version.
> Is there a way to introduce thrid party scapy level descriptions which
> are not upstream yet?

Upstream to scapy? Not yet.  This version of the plugin is extremely
simple, and good for basic traffic.  I'll add features to it so we can
get more creative with the packets that can be sent, though.

Lucas
