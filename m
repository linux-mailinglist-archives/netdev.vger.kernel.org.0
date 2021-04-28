Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E4436DD2C
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 18:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240929AbhD1QiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 12:38:02 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:40149 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230243AbhD1QiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 12:38:01 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 47A9C5830E6;
        Wed, 28 Apr 2021 12:37:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 28 Apr 2021 12:37:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mY4uqW
        18n/NF/XSmc5ThVXIcVlC3sMKlFzlW3oQj1HU=; b=KCLQb8UXJ6U8R9ZfwJmIlk
        /uzeYOvde0bkgslXN9Z0BniKuOkH9YsAlvEothC6VMOJ693n/CVbBkDjwgfhxWeO
        NdZACvg1AwOfbD4HU2QImHvDN0QQiTY6KZjCwSuzUzVpr61TsfMnztFog0v0DxQ2
        dcugZU4LPFpy3vJ3PAad9/UhJ7KZ94o60u5qpNnxiJxgz10hYpe2fSNmfUwsP5Jf
        rGmVPWsnLUpQt4gb62EzFh/GFyHiI3QaDegiuIFUFB8U5sudt1eD1cWHH5/ZoSJp
        +eOTfc9KscsT0Knvb7mbz0q4wsLAQdeexKjQSMB1oTC/I/KenZsOXtH8wja9KveQ
        ==
X-ME-Sender: <xms:Oo-JYObHzJaZrovQkGIGZL1PNEgDdiCFUaY96IBdQH0Zql2tUelZZg>
    <xme:Oo-JYBbdxzSKelAmrM0ryBOKZi9PN06wbZXR4PLNS23cPvHhL5oN-G0b0jsatD9zA
    9o25Q7N3Bh-uGM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddvvddgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrddukeejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Oo-JYI8-Y-XCoMrOfDjujxSmFhMADjXWdya5M_TaQnRpLQspTJbr2g>
    <xmx:Oo-JYAqJLch0biP7iFKwBhELmVwxZw8sP0nslIOaCdNkbCIGJjOKag>
    <xmx:Oo-JYJoZ_mGG8p-DW9tMSA3qA6ZPIk6blvma6TbYtjchVRVDfM9WcA>
    <xmx:PI-JYNfoKjWlFY04tkXJ3aeBCh4CPYZww2TEWhoKcC5hyzvpcA-wQQ>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 28 Apr 2021 12:37:14 -0400 (EDT)
Date:   Wed, 28 Apr 2021 19:37:11 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Pavel Balaev <balaevpa@infotecs.ru>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH v6 net-next 3/3] selftests/net/forwarding: configurable
 seed tests
Message-ID: <YImPN7C/5BXRv6uC@shredder.lan>
References: <YIlWbxO+AFZAFww7@rnd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIlWbxO+AFZAFww7@rnd>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 03:34:55PM +0300, Pavel Balaev wrote:
> Test equal and different seed values for IPv4/IPv6
> multipath routing.

The test does not follow the usual convention of forwarding tests that
are expected to be run with both veth pairs and loop backed physical
devices. See: tools/testing/selftests/net/forwarding/README (and
existing tests for reference)

This approach allows us to test both the software and hardware data paths.

You can construct a test where you have multiple VRFs instead of
multiple namespaces. These VRFs emulate your hosts and routers. Send
multiple flows from one host and check the distribution across the
multiple paths connecting your two routers. Change the seed, expect a
different distribution. Go back to original seed and expect the original
distribution.
