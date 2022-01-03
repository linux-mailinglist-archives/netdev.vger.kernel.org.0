Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88322483688
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 19:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbiACSC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 13:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiACSC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 13:02:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1A5C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 10:02:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC3AEB80B4C
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 18:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61405C36AEE;
        Mon,  3 Jan 2022 18:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641232974;
        bh=M/oFKtrfG3GB8Rk2NcsZbETcA6f6nkwDsxujhY+49Bw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O+n6SN6qQCo+FIMrHCzqdjdZXrSF1qigOIkXfz6sN6sRPyl04P7t48FA5CHDL7/US
         irC40ckBJ5rRYZ3O7mJMEZdptfADVBovpaneiAGxinbNMLrDiQw/w/89c6FD7k6K8E
         3ecBwyj/7tLrT3eEFwyN3CYim+Ig/EP1wI4rnitUW5DROQiAEjz4T+qZpwZUN0/PeZ
         5w9dyNa7ZrfYOggI8XEoNi2FK9d1XJVgCYBylI2uROcNJcfu/jhXodl9qaqqoue0yw
         k5LHbRICB42ONO2dutPKlPsgMduQqxBvPgZQjhUzy0xuj2uP1ttrsz3EdUjNsOuhAd
         UND/ho+JRgPfw==
Date:   Mon, 3 Jan 2022 10:02:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] ipv6: Continue processing multipath route even if
 gateway attribute is invalid
Message-ID: <20220103100253.40a2f914@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <a850c493-ec47-d73d-35f4-3666892fceb3@6wind.com>
References: <20220103171911.94739-1-dsahern@kernel.org>
        <a850c493-ec47-d73d-35f4-3666892fceb3@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jan 2022 18:31:03 +0100 Nicolas Dichtel wrote:
> Le 03/01/2022 =C3=A0 18:19, David Ahern a =C3=A9crit=C2=A0:
> > ip6_route_multipath_del loop continues processing the multipath
> > attribute even if delete of a nexthop path fails. For consistency,
> > do the same if the gateway attribute is invalid.
> >=20
> > Fixes: d5297ac885b5 ("ipv6: Check attribute length for RTA_GATEWAY when=
 deleting multipath route")
> > Signed-off-by: David Ahern <dsahern@kernel.org>
> > Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com> =20
> Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Fixed the commit ID and applied, thanks!
