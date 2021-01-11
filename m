Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7FD2F1B7C
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 17:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732008AbhAKQw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 11:52:26 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5280 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbhAKQw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 11:52:26 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ffc82210007>; Mon, 11 Jan 2021 08:51:45 -0800
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 11 Jan 2021 16:51:43
 +0000
References: <20210110071622.608572-1-roid@nvidia.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Roi Dayan <roid@nvidia.com>
CC:     <netdev@vger.kernel.org>, Petr Machata <petrm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2 v3 1/1] build: Fix link errors on some systems
In-Reply-To: <20210110071622.608572-1-roid@nvidia.com>
Date:   Mon, 11 Jan 2021 17:51:39 +0100
Message-ID: <87pn2b76xw.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610383905; bh=iqAP3EBYF7EmjqomLsGlopPopY4yeIaZGQq6/95SZC8=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=ECuS8h3CFFNOQE3b5Pc8AGULnriAcPKzWXPhx7VOOqDJaVNdV0MRv5jq2XTeVY1iX
         4UXU9w5ZgAg1xXPl2VLfWCMFGtqhBY3VmhCOyAJjwsxPW4ItTTqqRRMGg+vxxLbkWj
         5zRjeQ3a0twoHKEG93JcAAKnapLJbyV2MdTlNuaSNsaCt+N/D8FgOa1tkHnisUOEOO
         FAoHnp7tycQwtl3fvFS+98lhgdyV4EbidX4MiqlfdxvyPeNRlxGoOFPKox1wvqG5t+
         MZZ7KJtPn2lGt8Ty5TSgBpZFkz2QLjbl5hVztuQqVPiwsFVdfAfz5kvgUNoJ/PTD7/
         acVPvUubub7mQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Roi Dayan <roid@nvidia.com> writes:

> diff --git a/lib/json_print_math.c b/lib/json_print_math.c
> new file mode 100644
> index 000000000000..3d560defcd3e
> --- /dev/null
> +++ b/lib/json_print_math.c
> @@ -0,0 +1,46 @@
> +/*
> + * json_print_math.c		"print regular or json output, based on json_writer".
> + *
> + *             This program is free software; you can redistribute it and/or
> + *             modify it under the terms of the GNU General Public License
> + *             as published by the Free Software Foundation; either version
> + *             2 of the License, or (at your option) any later version.
> + *

This should have a SPDX tag instead of the license excerpt:

// SPDX-License-Identifier: GPL-2.0+

> + * Authors:    Julien Fortin, <julien@cumulusnetworks.com>
> + */

sprint_size() comes from TC and predates iproute2 git repo (2004),
whereas Cumulus Networks was around from 2010. So the authorship
declaration is likely inaccurate. I think it's also unnecessary, and
would just drop it.

> diff --git a/lib/utils_math.c b/lib/utils_math.c
> new file mode 100644
> index 000000000000..d67affeb16c2
> --- /dev/null
> +++ b/lib/utils_math.c
> @@ -0,0 +1,133 @@
> +/*
> + * utils.c
> + *
> + *		This program is free software; you can redistribute it and/or
> + *		modify it under the terms of the GNU General Public License
> + *		as published by the Free Software Foundation; either version
> + *		2 of the License, or (at your option) any later version.
> + *
> + * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>

The same here re license and authorship. The latter might in fact be
accurate in this case, but I would still drop it :)

Otherwise this looks good to me.
