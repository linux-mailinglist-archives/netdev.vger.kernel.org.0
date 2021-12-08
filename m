Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5369146DC63
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 20:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239685AbhLHTm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 14:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhLHTm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 14:42:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF08C061746;
        Wed,  8 Dec 2021 11:38:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9A427CE2336;
        Wed,  8 Dec 2021 19:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F030CC00446;
        Wed,  8 Dec 2021 19:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638992331;
        bh=iQD2LmaURq74thhhqRVHYwJAb7u1xwzJM7hKiFMtjkg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LMs2Kg/wotTWI7fk7wzoCCABu7E42/VCXi/Q80WLal+ZUHjOcV+wjlISjbB84QQiu
         XC0MbyOJcAKzHIW39jrWvSWna/4PRyDDWdckXdkmUxuXmJWi8qcEsxq9QG7t3OVkds
         nLdigtu1Y5JovlBfWNTyCMMrnjmHVsQi9cyklk7Fz8xKeSsQaZPoRsmO6oKqMK+MC7
         u3ZzroAfX/V0GEsDm7xXJlB1lMGLWP0Q+s/d2URPc6GfLjQQeWT3aeYBdAG7TfpKR2
         DQd5DqGef0ImRl+M88bEOw25TZ2r1zfqcLqtjROUZhlaqPu5pkyrC9Yzde2OBlWFG6
         beHOfBaQe7Jdg==
Date:   Wed, 8 Dec 2021 21:38:46 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] Allow parallel devlink execution
Message-ID: <YbEJxjicbaIVni9J@unreal>
References: <cover.1638690564.git.leonro@nvidia.com>
 <20211206180027.3700d357@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <Ya8NPxxn8/OAF4cR@unreal>
 <20211207202114.5ce27b2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YbBkzy+I1Buxp286@unreal>
 <20211208071507.2ba46b0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208071507.2ba46b0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 07:15:07AM -0800, Jakub Kicinski wrote:

<...>

> I do appreciate your work, but we disagree on how the API should look.

No problem, I'll send different proposal.

Thanks
