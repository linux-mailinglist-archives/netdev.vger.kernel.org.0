Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98F12B552B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbgKPXiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbgKPXiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 18:38:02 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BF1C0613CF;
        Mon, 16 Nov 2020 15:38:00 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id k4so3821287edl.0;
        Mon, 16 Nov 2020 15:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nI/cl7nDQd0fhiORyPmmr0YFovMzD/0ieXZnd9XN2UU=;
        b=an0EQtds1xZLqealI/3DywFZNUBL92nVzD8N6QoBf+ytMAbneGRcu/xqHVFk+X8IMZ
         ZepfqMtFnvQ6ZnO3QBB7gMgYpCeU5W2fpWHtUsVi4EzxKaw98h8zYHAXzWqqRE5y52Nr
         NgRLSAPgaSYyxzF5tbdPlqWXlXUKXHmSaZRRTXWlTDs3Dsh16b/d4JtomiQo80ruQXgA
         UaZKOWAmuGWXLPfh5roCrlH3A/DbbOiOXLFU1WSmFwVzboX38ZA7xjEqJ+19AVagRCsr
         PPIbcOPYbMzz4I1Nl34svq97Byqakdg0n+iAllnVJhKTB3ktnJfDzOqSNVsmcVnL9N8n
         vaAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nI/cl7nDQd0fhiORyPmmr0YFovMzD/0ieXZnd9XN2UU=;
        b=E7GdPbujCLC84mv4iH0qaqoh9dwF5RoYhrBDF3rxhgD32X8TDWwT6Fv8g+WC6sUsWe
         C3EzaMfFjWhVmL/A/m8mbTwvMrFkiF4HgcLK8pjWDkSjjDCh4ej9o4Nu0Tg/02VVHP8Z
         yd7Duwu/fGvoRkdH2e8oJj6ONUULLtzpdz/wTDh5irWgGmMHwKEuyFTKNovmUAAh4SHs
         uRaYcc3qdGSKSm/PfJcFiUInGVDVNwuOVLMFCWvPKmFQHLMz+8N1KiWY+4adw4aG7epN
         FGFyGzQZgguBQuIv2DILorzM8gYPCnOujYa9bErxheT2UTHoQxJoee558G+79Swp/cdg
         uxqA==
X-Gm-Message-State: AOAM530CBEUhWZPFe92rOrlM9/wHffz9b9xc4utEO2LXtDhd/TaPl2Qg
        u6/fYczHiPA3EHIqJY5mbi4w/dRtPm8=
X-Google-Smtp-Source: ABdhPJyJUOi4IwCSf1KLFu6ZhOg9Vh31vG53gj8CS5fifoJjMIc4hL+vjfE5Zll50Zp8y2EELjeBUw==
X-Received: by 2002:aa7:c358:: with SMTP id j24mr18309737edr.265.1605569879294;
        Mon, 16 Nov 2020 15:37:59 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id dh12sm115890edb.58.2020.11.16.15.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 15:37:58 -0800 (PST)
Date:   Tue, 17 Nov 2020 01:37:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Yunjian Wang <wangyunjian@huawei.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: Have netpoll bring-up DSA management interface
Message-ID: <20201116233757.nou3fgdpdd6akzlv@skbuf>
References: <20201019171746.991720-1-f.fainelli@gmail.com>
 <20201019200258.jrtymxikwrijkvpq@skbuf>
 <58b07285-bb70-3115-eb03-5e43a4abeae6@gmail.com>
 <20201019211916.j77jptfpryrhau4z@skbuf>
 <20201020181247.7e1c161b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a8d38b5b-ae85-b1a8-f139-ae75f7c01376@gmail.com>
 <d2dbb984-604a-ecbd-e717-2e9942fdbdaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2dbb984-604a-ecbd-e717-2e9942fdbdaa@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 03:20:37PM -0800, Florian Fainelli wrote:
> I remember now there was a reason for me to "open code" this, and this
> is because since the patch is intended to be a bug fix, I wanted it to
> be independent from: 2f1e8ea726e9 ("net: dsa: link interfaces with the
> DSA master to get rid of lockdep warnings")
>
> which we would be depending on and is only two-ish releases away. Let me
> know if you prefer different fixes for different branches.

Florian, I studied a little bit the reason why DSA wants the master
interface to be open before the slave is (not enough to actually submit
a fully tested patch, though). It's because Lennert Buytenhek wanted to
ensure that DSA only manages the promiscuity of interfaces that are up,
because of a bugfix from 2008. See commit:

commit df02c6ff2e3937379b31ea161b53229134fe92f7
Author: Lennert Buytenhek <buytenh@marvell.com>
Date:   Mon Nov 10 21:53:12 2008 -0800

    dsa: fix master interface allmulti/promisc handling

    Before commit b6c40d68ff6498b7f63ddf97cf0aa818d748dee7 ("net: only
    invoke dev->change_rx_flags when device is UP"), the dsa driver could
    sort-of get away with only fiddling with the master interface's
    allmulti/promisc counts in ->change_rx_flags() and not touching them
    in ->open() or ->stop().  After this commit (note that it was merged
    almost simultaneously with the dsa patches, which is why this wasn't
    caught initially), the breakage that was already there became more
    apparent.

    Since it makes no sense to keep the master interface's allmulti or
    promisc count pinned for a slave interface that is down, copy the vlan
    driver's sync logic (which does exactly what we want) over to dsa to
    fix this.

    Bug report from Dirk Teurlings <dirk@upexia.nl> and Peter van Valderen
    <linux@ddcrew.com>.

    Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
    Tested-by: Dirk Teurlings <dirk@upexia.nl>
    Tested-by: Peter van Valderen <linux@ddcrew.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

followed by commit

commit d2615bf450694c1302d86b9cc8a8958edfe4c3a4
Author: Vlad Yasevich <vyasevic@redhat.com>
Date:   Tue Nov 19 20:47:15 2013 -0500

    net: core: Always propagate flag changes to interfaces

    The following commit:
        b6c40d68ff6498b7f63ddf97cf0aa818d748dee7
        net: only invoke dev->change_rx_flags when device is UP

    tried to fix a problem with VLAN devices and promiscuouse flag setting.
    The issue was that VLAN device was setting a flag on an interface that
    was down, thus resulting in bad promiscuity count.
    This commit blocked flag propagation to any device that is currently
    down.

    A later commit:
        deede2fabe24e00bd7e246eb81cd5767dc6fcfc7
        vlan: Don't propagate flag changes on down interfaces

    fixed VLAN code to only propagate flags when the VLAN interface is up,
    thus fixing the same issue as above, only localized to VLAN.

    The problem we have now is that if we have create a complex stack
    involving multiple software devices like bridges, bonds, and vlans,
    then it is possible that the flags would not propagate properly to
    the physical devices.  A simple examle of the scenario is the
    following:

      eth0----> bond0 ----> bridge0 ---> vlan50

    If bond0 or eth0 happen to be down at the time bond0 is added to
    the bridge, then eth0 will never have promisc mode set which is
    currently required for operation as part of the bridge.  As a
    result, packets with vlan50 will be dropped by the interface.

    The only 2 devices that implement the special flag handling are
    VLAN and DSA and they both have required code to prevent incorrect
    flag propagation.  As a result we can remove the generic solution
    introduced in b6c40d68ff6498b7f63ddf97cf0aa818d748dee7 and leave
    it to the individual devices to decide whether they will block
    flag propagation or not.

    Reported-by: Stefan Priebe <s.priebe@profihost.ag>
    Suggested-by: Veaceslav Falico <vfalico@redhat.com>
    Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

So Vlad Yasevich, through his patch, leaves this decision at the sole
will of DSA now, it is no longer mandated by the networking core that
the master interface must be up when changing its promiscuity.

As from my point of view? I think we're missing the forest for the
trees by requiring the user to bring up the master interface. Even _if_
there still was a problem with promiscuity when the master is down
(which btw I couldn't reproduce), then who's stopping DSA from simply
bringing the master interface up in the first place... I think from a
user's point of view this would be a beneficial change.
