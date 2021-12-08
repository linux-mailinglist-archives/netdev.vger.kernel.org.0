Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD8446D7F0
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 17:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236734AbhLHQWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 11:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbhLHQV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 11:21:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AD6C061746;
        Wed,  8 Dec 2021 08:18:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F22B2B82153;
        Wed,  8 Dec 2021 16:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD63EC00446;
        Wed,  8 Dec 2021 16:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638980303;
        bh=uPNCPj/dCHDTXvUUpIHtpAD5SCYcVvvqovVDUbdyspU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q5HqR6e7o2q7YTDeVVTMz3SvUaCCuXmWgAwkMe3xkyVyJQYQbOhV6R87Rg/R6//mW
         PAWrgu/APqrGME8ytqI+jMBDT75Jv+xEQkBLXG9xkH1EHWarn6lg89Z+5n5eCqhQ8n
         qYhxJEZfYKB9om/gRsIGE2OLg8eXW1ut73lttRzNmto/zwB0roqnYjqOscN+Mes4XV
         B9M5QDG6eZwfMELfUarOki3iN+LYaEDMRwX4938CyG+zaWeKERcskTppxZyk8lehWD
         06bMLQ5nHfbKL8AQ21qLPGtZ1tye8RewwuOQOGmeWcPIEcUtUN13hOqzIYqVm+FR+R
         bELV9p9gxvU0A==
Date:   Wed, 8 Dec 2021 17:18:18 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Ameer Hamza <amhamza.mgc@gmail.com>
Cc:     kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: dsa: mv88e6xxx: error handling for serdes_power
 functions
Message-ID: <20211208171818.4746cb39@thinkpad>
In-Reply-To: <20211208155809.103089-1-amhamza.mgc@gmail.com>
References: <20211208164042.6fbcddb1@thinkpad>
        <20211208155809.103089-1-amhamza.mgc@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Dec 2021 20:58:09 +0500
Ameer Hamza <amhamza.mgc@gmail.com> wrote:

> Added default case to handle undefined cmode scenario in
> mv88e6393x_serdes_power() and mv88e6393x_serdes_power() methods.
>=20
> Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
> ---

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>
