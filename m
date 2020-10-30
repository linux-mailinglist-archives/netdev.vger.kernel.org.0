Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F38929FBF1
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 04:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgJ3C6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 22:58:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbgJ3C6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 22:58:06 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40FF4206ED;
        Fri, 30 Oct 2020 02:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604026685;
        bh=bn3PwUQZ4HURowa7zUAdB3s9KM7KO4YoVStGZI5euac=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tkx+Xas6CA/B6c7y7VPcYq0AsN9C19JIdifc4LzYM3Y6DaEPjvAZRqZzb8g0s7Li5
         P0x79d8V1qzWeqV+WoqmiGQjuIi0IKMA67NVa9f/wBEuOvfc9m31ZRlQAKqxpxSTyQ
         uBPOT4HwwnNHEb/+jsWmRBEIwusl7Hpi3Ieys0RI=
Date:   Thu, 29 Oct 2020 19:58:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
Cc:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v7 00/10] net: bridge: cfm: Add support for
 Connectivity Fault Management(CFM)
Message-ID: <20201029195804.0fbbf0c1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201027100251.3241719-1-henrik.bjoernlund@microchip.com>
References: <20201027100251.3241719-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 10:02:41 +0000 Henrik Bjoernlund wrote:
> Connectivity Fault Management (CFM) is defined in 802.1Q
> section 12.14.
>=20
> Connectivity Fault Management (CFM) comprises capabilities for
> detecting, verifying, and isolating connectivity failures in Virtual
> Bridged Networks. These capabilities can be used in networks
> operated by multiple independent organizations, each with restricted
> management access to each other=E2=80=99s equipment.

Applied, thanks!
