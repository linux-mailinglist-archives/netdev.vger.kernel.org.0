Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98FC2C610D
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 09:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgK0IkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 03:40:10 -0500
Received: from 95-31-39-132.broadband.corbina.ru ([95.31.39.132]:36132 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729111AbgK0IkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 03:40:09 -0500
Received: from metabook.localnet (metabook.metanet [192.168.2.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by blackbox.su (Postfix) with ESMTPSA id 53A858067D;
        Fri, 27 Nov 2020 11:40:13 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=blackbox.su;
        s=201811; t=1606466413;
        bh=FMp8u4JnX7lN0xg2nl/yjDV4sB0pAjpT17yAu1i/KDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LCPGE5x2IP4wYkfadNO9E55Zaq4onhyZmj4QwzF2DVuq2LBdS+887EWpxUif8SKOC
         NH8Eb9h//yJzpYpSRKP8pN0xLlOMHWHgDo2v03oc5LCE02y8L6/qvYwD0Srz+KNkPK
         XKHK1yGnovO1TYdL3wQe7gUxeUo3b8AtCIUIDTJlmCrHzRT5OAkhS75kbgZBvMlgba
         v3JoFCG/3JFnxFzryCj2hXGSTA0bHhv//kfbXqiJDRvVMj7DfGVVaM7P2Y4jAuvydF
         HlARUnNjm/c2Om/Slota7DB/7nv5jIQkxhH2FM7Zyivb0ZqG6yj2r/n2ptELrCf79n
         wV7uX1T3HB2hA==
From:   Sergej Bauer <sbauer@blackbox.su>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Markus.Elfring@web.de,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] lan743x: fix for potential NULL pointer dereference with bare card
Date:   Fri, 27 Nov 2020 11:39:41 +0300
Message-ID: <29226509.5m4h6Y2tBG@metabook>
In-Reply-To: <CAGngYiXFJTQN3+-HC7L0F5cVfXBpPLS3O4gbaSdMmNurzgnwGw@mail.gmail.com>
References: <220201101203820.GD1109407@lunn.ch> <20201103173815.506db576@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAGngYiXFJTQN3+-HC7L0F5cVfXBpPLS3O4gbaSdMmNurzgnwGw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sven.

> Hi Jakub, Sergej,
> 
> On Tue, Nov 3, 2020 at 8:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon,  2 Nov 2020 01:35:55 +0300 Sergej Bauer wrote:
> > > This is the 3rd revision of the patch fix for potential null pointer
> > > dereference with lan743x card.
> > 
> > Applied, thanks!
> 
> I noticed that this went into net-next. Is there a chance that it could also
> be added to net? It's a real issue on 5.9, and the patch applies cleanly
> there.

It's my mistake - I missed pointing of stable branch.
Should I resend the patch (with tag Cc:stable@vger.kernel.org)?

                Regards,
                    Sergej.



