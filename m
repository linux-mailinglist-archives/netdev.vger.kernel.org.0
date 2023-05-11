Return-Path: <netdev+bounces-1674-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2D706FEC32
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:02:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89183281694
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 07:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C978627726;
	Thu, 11 May 2023 07:02:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FBB1774C
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:02:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CB4C433D2;
	Thu, 11 May 2023 07:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683788544;
	bh=CWM2s+hvpqeMAylZLUbt7IA1vHVBXDMjhTstDykqidg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dBLbId3a+L4IqiHIqL7q+5zS6y7s2cAp/546C8L0WBQhFUzGE8cwbTyDIYUst6TXJ
	 taZNbigituJHDsZqRYAMplBptBkz5u1JKBv2dLlWgdm9AlBstZtuIz+pjm9u4zIIQI
	 6z8Z9rsRAP318FpKffAhMm5bMtQoJ8lKoTKaRzkWHGe5qrRbpfCDmNQKyYsjo0dHOK
	 8vjRgA8TisYmdltxjdTY4C7vljh5fzEfCuCXdWw294GMYn9xXf9ABLUTidoVFXxQ2L
	 qBhAt0EsseLMnATo2Qchhc9cAPd7e293a4a8xmT16jruw5inSYgOS9PV4fW1J8hFAo
	 4aNAaJ81/ZGNA==
Date: Thu, 11 May 2023 10:02:19 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org, me@pmachata.org, jiri@resnulli.us,
	jmaloy@redhat.com, parav@nvidia.com, elic@nvidia.com,
	Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH iproute2] Add MAINTAINERS file
Message-ID: <20230511070219.GU38143@unreal>
References: <20230510210040.42325-1-stephen@networkplumber.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510210040.42325-1-stephen@networkplumber.org>

On Wed, May 10, 2023 at 02:00:40PM -0700, Stephen Hemminger wrote:
> Record the maintainers of subsections of iproute2.
> The subtree maintainers are based off of most recent current
> patches and maintainer of kernel portion of that subsystem.
> 
> Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  MAINTAINERS | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
>  create mode 100644 MAINTAINERS

Like Jiri said, this file lacks "rdma/" entry.

> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> new file mode 100644
> index 000000000000..fa720f686ba8
> --- /dev/null
> +++ b/MAINTAINERS
> @@ -0,0 +1,49 @@
> +Iproute2 Maintainers
> +====================
> +
> +The file provides a set of names that are are able to help
> +review patches and answer questions. This is in addition to
> +the netdev@vger.kernel.org mailing list used for all iproute2
> +and kernel networking.
> +
> +Descriptions of section entries:
> +
> +	M: Maintainer's Full Name <address@domain>
> +	T: Git tree location.
> +	F: Files and directories with wildcard patterns.
> +	   A trailing slash includes all files and subdirectory files.
> +	   A wildcard includes all files but not subdirectories.
> +	   One pattern per line. Multiple F: lines acceptable.
> +
> +Main Branch
> +M: Stephen Hemminger <stephen@networkplumber.org>
> +T: git://git.kernel.org/pub/scm/network/iproute2/iproute2.git
> +L: netdev@vger.kernel.org
> +
> +Next Tree
> +M: David Ahern <dsahern@gmail.com>
> +T: git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git
> +L: netdev@vger.kernel.org
> +
> +Ethernet Bridging - bridge
> +M: Roopa Prabhu <roopa@nvidia.com>
> +M: Nikolay Aleksandrov <razor@blackwall.org>
> +L: bridge@lists.linux-foundation.org (moderated for non-subscribers)
> +F: bridge/*
> +
> +Data Center Bridging - dcb
> +M: Petr Machata <me@pmachata.org>
> +F: dcb/*
> +
> +Device Link - devlink
> +M: Jiri Pirko <jiri@resnulli.us>
> +F: devlink/*
> +
> +Transparent Inter-Process Communication - Tipc

IMHO, it is better to be consistent: Tipc -> tipc

> +M: Jon Maloy <jmaloy@redhat.com>
> +F: tipc/*
> +
> +Virtual Datapath Accelration - Vdpa

Vdpa -> vdpa

> +M: Parav Pandit <parav@nvidia.com>
> +M: Eli Cohen <elic@nvidia.com>
> +F: vdpa/*
> -- 
> 2.39.2
> 
> 

