Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18A9712FD67
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgACUDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:03:32 -0500
Received: from mail-vk1-f196.google.com ([209.85.221.196]:43978 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728611AbgACUDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:03:31 -0500
Received: by mail-vk1-f196.google.com with SMTP id h13so11026672vkn.10;
        Fri, 03 Jan 2020 12:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=M6xBo1xbVNvJspjWjJb82T/G1NkjpTBJRiyiyckkCkQ=;
        b=YMTo8D68OOL8TL8FneG5BdF/ZyR01hslkeKqJyJwGhb6u7r7N4gFV+tRGVFSc1H6rq
         /n5UPXj47XkJ93IyCiscHAQ9AYYx0zegegCTyNWVgY5KLPdtL8asWb699O2wc8S9Cyli
         YSqSveRhKpV+qIZLH8brZj+7r3Dgbv1sn6mAQwcYVdPC42K23ZBS/UE2csqmVbYG5mKH
         FTvomDpN64Cjp1oATZFvh2PeuzJ5eex4mHNV0JvYyEIf+T0VZxEJ99mcoqemZaJxjTTj
         EPl4uM9aVBRbSnPpc0T1bzPZ6lPIEOsXG6wFnlhYs65AQ95f5r/hsxj4ZqNQH+WIZv+F
         lMrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=M6xBo1xbVNvJspjWjJb82T/G1NkjpTBJRiyiyckkCkQ=;
        b=FS/POOAF5ef5jM1X6AycH2IHi+sfjEDEyMXhny1KTV8+Z2l2gQ/McsTq5LFE65jqIc
         RMe/s7eFJyC/T3vC0GbQEru9SeI589LbYzbh/9rsPX57ICVbX1cYQZrHQ5g4cqd55GnW
         Md4WvToI5sAeVm+nT8GejWDB13Xqqjc+b//TdgbawGQRkTIZLQLZz8ziXhsg7fZXwUfE
         x85Gach8BSpxgqFu60WKQeRhXk4qOojeBguWHwC5GxQT+y7NGBNkAAKeCLr04XQsFVIk
         1y1zQWX87e0OLkEOnHT24BibS1+F/4PnxQb2AokFsQYBqfQJdrvDZxuIaLdDsbXn1usW
         v4+w==
X-Gm-Message-State: APjAAAWa4te6ogtJx3aeVXJ82ZuZ2nqEkjSsvXHTZMltzKq+88e2ZcLp
        v94blV8zeX4Id4bBtV3KoOgWXx1qyvJyS+cZgg==
X-Google-Smtp-Source: APXvYqw2MfiIHDh1BWUrstmJNd63vsPBKSKt2EshBiTzEWtjKLsHvJNb1KQAUNBgqTogycyPzKA4k3K6f0g6iEBShzc=
X-Received: by 2002:a1f:c686:: with SMTP id w128mr51615376vkf.34.1578081810377;
 Fri, 03 Jan 2020 12:03:30 -0800 (PST)
MIME-Version: 1.0
References: <20200103121907.5769-1-yukuai3@huawei.com> <20200103144623.GI6788@bombadil.infradead.org>
 <20200103175318.GN1397@lunn.ch> <CA+h21hqcz=QF8bq285JjdOn+gsOGvGSnDiWzDOS5-XGAGGGr9w@mail.gmail.com>
 <b4697457-51d2-c987-4138-b4b2b92e391d@gmail.com> <20200103193758.GO1397@lunn.ch>
 <CAP8WD_a6QJNz2mUpz_eCaNReoZKVAdL0TpoF-m+gA4VPWRrrMg@mail.gmail.com>
In-Reply-To: <CAP8WD_a6QJNz2mUpz_eCaNReoZKVAdL0TpoF-m+gA4VPWRrrMg@mail.gmail.com>
Reply-To: whiteheadm@acm.org
From:   tedheadster <tedheadster@gmail.com>
Date:   Fri, 3 Jan 2020 15:03:19 -0500
Message-ID: <CAP8WD_b5Su2niZiDWSFXpTgGKnC7CCQRC9kCyQOWUm0eLJhVxA@mail.gmail.com>
Subject: Re: [PATCH] net: 3com: 3c59x: remove set but not used variable 'mii_reg1'
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        yu kuai <yukuai3@huawei.com>, klassert@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        hslester96@gmail.com, "Michael S. Tsirkin" <mst@redhat.com>,
        yang.wei9@zte.com.cn, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, yi.zhang@huawei.com,
        zhengbin13@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 3, 2020 at 2:40 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > And since more reviewers are on the same boat, the fix should probably
> > look to eliminate the warning by doing something like:
> >
> > (void)mdio_read(dev, vp->phys[0], MII_BMSR);
>
> Yes, this is the safe option.


I have actual hardware I can test the proposed patches on, if desired.

- Matthew Whitehead
