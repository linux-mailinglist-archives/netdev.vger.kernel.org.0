Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B9C2650FB
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgIJUhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbgIJUbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:31:03 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA2DC061573;
        Thu, 10 Sep 2020 13:31:03 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id m12so6532382otr.0;
        Thu, 10 Sep 2020 13:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8LiDEfXSWfpsbBSoq6IWpeigMyRkjdi4v6vinxD3gBY=;
        b=FabsM6mH8zl+nq3wFo2aBTClQ77IW9YtTEQFjPcUypqarW6Iii0RBqd67QFSN9BuFu
         VZIqrihaQjBjdDfqPFldmfMLxe12KhJz6DD6rvh8lXjCJ2JMOPSew1oK7YtjtdGuuVFb
         /sfvaxRn8ZJy54x2Re3L9TlWOFoBX/xtitpeYmbSxYcSkf9QUQq7VXu+QXyYcFunHp2s
         7Zhd+zWAP/cqQVXHQjf0b66oadOYLZYPes0gQ/D4mqlYx3MYzr1bS5FBdS6d5r5H3k5l
         fECRvuuR1tHGOp0bKkR1nGOilK6OAFT8Tiedz8ao63+B0rNM1KVwHz+Op9o96yHZEyHi
         xpzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8LiDEfXSWfpsbBSoq6IWpeigMyRkjdi4v6vinxD3gBY=;
        b=finJoVG/cqrjPnjmSTE5rDwS48uI68DkE95vYNKPzsMCzKB0e+JZjcqyLSDPJlvQy1
         nZu8nx5d6YC+VVWG86x+dO8lbP0oJ6nKx+yePwfUG4rM9dnYS71H7j+Rl4NJoMF6wI5s
         oAlX6HKEtL0If4ozVRifQqZr+5S4TqBaB4bAHMNzty9OJiDphQWq2gIDjdcB1y+WT1Gf
         gw4cXyQU7iVNuMuauXyVvdEU+5B1SRjsdS8qYr1EqGPgl86wnNbpX1W9sv3gnuyLC2hQ
         ZFf22VGxnVbVVkmympjLju7sv6RsmrFyq9tIyuQd7zdQ/w2zx9GpPc5WDWbdamh0D1Zg
         02og==
X-Gm-Message-State: AOAM5319B2KLVd+dH2fOjlLkDBuGni6DRZX1Qk0e5VjYBBHJaL5ZI1PZ
        BBnf9WAkaj7KvwD0Nx3X6gxwrnTkaDBuFjSLB6M=
X-Google-Smtp-Source: ABdhPJyZq/S5WVawGZRevjQg8KzxPj8flrds48iTlaqbZPlhYQvrKF9MAceJac0DCZ1GeyVad8svHQ51AYjmda3iBZI=
X-Received: by 2002:a9d:6d95:: with SMTP id x21mr5300130otp.339.1599769862040;
 Thu, 10 Sep 2020 13:31:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200910161126.30948-1-oded.gabbay@gmail.com> <20200910130112.1f6bd9e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf13SbXqjyu6JHKSTf-EqUxcBZUe4iAfggLhKXOi6DhXYcg@mail.gmail.com> <20200910202513.GH3354160@lunn.ch>
In-Reply-To: <20200910202513.GH3354160@lunn.ch>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Thu, 10 Sep 2020 23:30:33 +0300
Message-ID: <CAFCwf11P7pEJ+Av9oiwdQFor5Kh9JeKvVTBXnMzWusKCRz7mHw@mail.gmail.com>
Subject: Re: [PATCH 00/15] Adding GAUDI NIC code to habanalabs driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 11:25 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Can you please elaborate on how to do this with a single driver that
> > is already in misc ?
> > As I mentioned in the cover letter, we are not developing a
> > stand-alone NIC. We have a deep-learning accelerator with a NIC
> > interface.
>
> This sounds like an MFD.
>
>      Andrew

Yes and no. There is only one functionality - training of deep
learning (Accelerating compute operations) :)
The rdma is just our method of scaling-out - our method of
intra-connection between GAUDI devices (similar to NVlink or AMD
crossfire).
So the H/W exposes a single physical function at the PCI level. And
thus Linux can call a single driver for it during the PCI probe.

I hope that in future generations we will improve that, but it is what
it is for GAUDI.
I don't see how to do it otherwise currently but if you have ideas please share.
Oded
