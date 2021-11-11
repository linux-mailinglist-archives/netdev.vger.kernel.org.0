Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A601144D78D
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 14:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhKKNxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 08:53:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhKKNxL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 08:53:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C82361152;
        Thu, 11 Nov 2021 13:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636638622;
        bh=+5BVqAsoY8wGcWf20UJMuBrzjZy8ZO2bg4t5fbunUtI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lxVLx9oxOugEoI2LjhYNCtYoP71YOvsfLpXYYQyc1RB7pgxfRUZKzQ6RgTsqFnQoc
         1Sz1Hp9WjucwbhTzUzVgvQMlT12Dm8jNG08+6RmY6jtBNKQuPhuWB0OQvj5wxUQ7Bj
         gH5QhNeNYqiyXDozc081JLwI6pQu+LM4BZ4ofVfEaZRgJaZRQ4ja9FZ/anXmZWgFz2
         +5tqa9ArWtV1W6tPpLXSP+MJyniB3/6+VPgyhBsDKIYGPZTeIly6VxROEgSTnsDOix
         XrcdMAkJWmVDnzXr2UeslexQenTgWxO504BEYN/DmptYnkauVpDnD/FikdNDz356H0
         FOEYKzZyfbK/g==
Date:   Thu, 11 Nov 2021 05:50:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Lin Ma" <linma@zju.edu.cn>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jirislaby@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] hamradio: defer 6pack kfree after
 unregister_netdev
Message-ID: <20211111055021.77186242@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <724aae55.1863af.17d0cc249ab.Coremail.linma@zju.edu.cn>
References: <20211108103721.30522-1-linma@zju.edu.cn>
        <20211108103759.30541-1-linma@zju.edu.cn>
        <20211110180525.20422f66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211110180612.2f2eb760@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <724aae55.1863af.17d0cc249ab.Coremail.linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 10:09:59 +0800 (GMT+08:00) Lin Ma wrote:
> > Looks like this go applied already, please send a follow up fix.  
> 
> Oooops, thanks for the remind. XD
> 
> I just found that the mkill adds the free_netdev after the
> unregister_netdev so I did it too. No idea about this automatic
> cleanup.
> 
> Should I send the fix in this thread or open a new one?

New thread is better for me.
