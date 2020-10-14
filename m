Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A2B28E8F3
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 00:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbgJNW6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 18:58:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbgJNW6t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 18:58:49 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAE0520776;
        Wed, 14 Oct 2020 22:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602716329;
        bh=kMpSZ3gkc8inIapGbTJlpkhoLPPmZniPgrwUXxmM2FU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B6VbtQ3tyTewZBxnTOsymsv3qs0RJqXSESXnExKF2QgXdsa3371f/s9Md09zdoZP1
         skefn7C8UTTMAPuZRpo/nshzGKnBY5p0ivy6KSTvO6wDn9Gr3o+aF20KMEVPRie70p
         DZDFnxFz2cyVZiugZWwkbMt7LnmBB4Udpy+4kdyU=
Date:   Wed, 14 Oct 2020 15:58:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
Cc:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v5 00/10] net: bridge: cfm: Add support for
 Connectivity Fault Management(CFM)
Message-ID: <20201014155847.2eb150f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 14:04:18 +0000 Henrik Bjoernlund wrote:
> Connectivity Fault Management (CFM) is defined in 802.1Q section 12.14.
>=20
> Connectivity Fault Management (CFM) comprises capabilities for detecting,=
 verifying,
> and isolating connectivity failures in Virtual Bridged Networks.
> These capabilities can be used in networks operated by multiple independe=
nt organizations,
> each with restricted management access to each other=E2=80=99s equipment.

Please wrap the cover letter and commit messages to 70 chars.

> Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
> Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>

You have two spaces after the name in many tags.
