Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCEA302225
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 07:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbhAYGaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 01:30:07 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18299 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbhAYG0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 01:26:19 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600e64500000>; Sun, 24 Jan 2021 22:25:20 -0800
Received: from localhost (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 06:25:19 +0000
Date:   Mon, 25 Jan 2021 08:25:15 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Alan Perry <alanp@snowmoose.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2-next] Add description section to rdma man page
Message-ID: <20210125062515.GD579511@unreal>
References: <20210124200026.75071-1-alanp@snowmoose.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210124200026.75071-1-alanp@snowmoose.com>
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611555920; bh=peyguf1S2h1yKsFV6dshQGWF26f9Rzv0gdpFmoSk3a8=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy;
        b=HWHjIODzGwGKVdhxNSroentc4Sy/JmqtTvz3efiC7PyXlS8DI1VmPIDhtERgjUTW4
         Mw8QinNZ+rD9lszCYVVXhmXeaK/+kcsF/qzQm+siQvK0N2I0blQjAiSvUGykCrGRAz
         IFmiDV0KQJ6HtU0CKTApt6bBphls1WpM/AuPruEw19aKxmAi4OvDYqErd+0ff7xW+E
         aFTo51h0WnJnJ6w6joWaCnhtArNpnMgUSoEWhR4qJ63h0d8WF6K94ZmhwlIMz3cC43
         LQ0Ulk8DHttbDrUfk6OwqqWtcjcWdWVL5QL+eOVXGeg780GtlNKhPqmDAeC/lQOTAu
         5rZMxhMW2lj7A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 12:00:27PM -0800, Alan Perry wrote:
> Add a description section with basic info about the rdma command for users
> unfamiliar with it.
>
> Signed-off-by: Alan Perry <alanp@snowmoose.com>
> Acked-by: Leon Romanovsky <leonro@nvidia.com>
>
> ---
>  man/man8/rdma.8 | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

David, can you please pick it up?

Thanks
