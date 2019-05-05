Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE6EF13ED2
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 12:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbfEEKXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 06:23:19 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47141 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727327AbfEEKXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 06:23:18 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A1919213CA;
        Sun,  5 May 2019 06:23:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 05 May 2019 06:23:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=pXmTfioM1yvQtmQVTIb0DkhrSLh
        DCPiCmbsEzhUSqH8=; b=qvC6pmcUWG+MJ/6+Ag0lQ7QUSk4GRDnuUI5njmH9gQv
        UgIXqH/KGJeH/xAD1ph6XCNsjbSBS85JU4gENlutJJVwOcxc0xUmjqiFLMSyhoYw
        AAdndhK/Cao2vlkRLY88c1IM7TkqhPFEEIGEOXvNZeuftqlw4MmJDrYyv52ik4IL
        Vk9c2FLaCWeBM+ZrcGJymWCAvhFTa4Hh44QwTB4NVqJIdSZFFb0yP1XhsbFxjBew
        4gKwiEjFruBlbBoLFbsoKWFuxp1V53G05UNyDE8r5EuiiTbzmO4GiklngqsuXMUX
        yQQ+55P2ZIFyyaPKQGQWLd2SUlwm91GJeiHO5Nh+QSg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=pXmTfi
        oM1yvQtmQVTIb0DkhrSLhDCPiCmbsEzhUSqH8=; b=W5/FqdfQME1MaSQD3oLwCW
        Zt57b27ljN0ildt478R9l9xETFdhc3bcFKRmEbsmd/Em6D0zS70HLeEYo0jXnYUr
        QuchIDnpXhMIugftXQRFxpzHG+UG/2g+Z0UiTPKRqTSfkKyOH9A7zewbDFj1IWd6
        INnlL9/ziId9iZEbzyUl5fkmOZurSkPmdnH2RbKTpTYuvyaWpMXYhLkxLFoGxtk8
        rWqv32c3WPetNzjXi+tFfBuOks9U/TcgHfNdjw1bqaEsS8Sxo+ESY55idjAMGVhn
        mmbsTnXC3jZK3EpqzUlPCQWnasJ0YB/srAg5niUqwCB31caEimbYH9/KDrM1JwGw
        ==
X-ME-Sender: <xms:lbnOXOmvZ9gCEAnFFzt_OeZVl_uelv3nY8OEGVz1gf6tuLR5ewzmTQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrjeehgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:lbnOXKLdsOKGsepbTc5C_3zMpRsEd3hlH62vLr33d_lrpwlFoFxLbA>
    <xmx:lbnOXHB5OO2V8w_-ZnollHE69XJtjWI3sJgkd6hdz2_sTAo5JdDIrA>
    <xmx:lbnOXAnrD1Fs-Oo939OPQ1eGKuA1IDyOZoFJzSBGMUtzJjJiBaH4dg>
    <xmx:lbnOXHwWOrztJZ1EBfFmtDY9kNucI_bNSaE8Z47S6NkWRw-l99Mq8g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8AD7E103C8;
        Sun,  5 May 2019 06:23:16 -0400 (EDT)
Date:   Sun, 5 May 2019 12:23:14 +0200
From:   Greg KH <greg@kroah.com>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc:     "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>
Subject: Re: [net-next v2] net: sched: Introduce act_ctinfo action
Message-ID: <20190505102314.GA12761@kroah.com>
References: <CAM_iQpXnXyfLZ2+gjDufbdMrZLgtf9uKbzbUf50Xm-2Go7maVw@mail.gmail.com>
 <20190505101523.48425-1-ldir@darbyshire-bryant.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190505101523.48425-1-ldir@darbyshire-bryant.me.uk>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 05, 2019 at 10:15:43AM +0000, Kevin 'ldir' Darbyshire-Bryant wrote:
> --- /dev/null
> +++ b/net/sched/act_ctinfo.c
> @@ -0,0 +1,407 @@
> +// SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note

How can a .c file, buried in the kernel tree, have a Linux-syscall-note
exception to it?

Are you _sure_ that is ok?  That license should only be for files in the
uapi header directory.

thanks,

greg k-h
