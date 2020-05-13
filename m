Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516AE1D0E28
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 11:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388525AbgEMJ6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 05:58:19 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36271 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387860AbgEMJ6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 05:58:17 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B93B55C013B;
        Wed, 13 May 2020 05:58:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 13 May 2020 05:58:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=OaeA8w
        vL6EZuvopKe7Yu4eCZ8ipuCPQar2EUyF/PnCs=; b=Ue8hMjdpY6PxotlfsfJlDM
        /mNvmgxiUFVwZP8yn5XK5GrsZNQDjCTIVxsx97SRsv35nK6f8+sv862CUf2Vwf4P
        XHwdhpq3fqEGty1DCEaL78YyvUS0D7rNd4tfiqxcIy7aBAZq7JQftm9JR60OGoew
        bwNdwU0m+0y+VPCQuOHO5aWcsuIYL3QvEPa413obOD5bxhzZQidlqf5R6SInMPby
        3sMtlPpLtXb6L0uBB9o52mL2JxLqniEiZvR8sSBDjXvmwdYB1yNSRcMerRgdbjUz
        0nvdBVoYJUdjJToFRK746idTqtVTiMqpCIu91mB4pDLIKtAyUBNpmLE93kjZeReQ
        ==
X-ME-Sender: <xms:tsS7XmLEOprM7S_ZEzAH1gCxHmRgIAVlxANDMORjNMNUaJoNm9IOqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrleeggddvvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeejledrudejiedrvdegrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:tsS7XuLFw8WvkbMoOhU8khdBbug055W_z3m5tlJLUY_mvk2hqy2Fvw>
    <xmx:tsS7Xmul3Hck40Tw4z4ICSra1MAgB0z11Qtngf3KAA3nvQFfvgpI8A>
    <xmx:tsS7Xrb8F9N2jKyGBnlThIF0Srcvx4U5HmdXo1lq8aDiPBJBeB0EzA>
    <xmx:t8S7XuDk8gMOxoQ1hcf_aFCbuVs-nLd4MPY9WEbFVsIzUft7I8XgeQ>
Received: from localhost (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8339E30662F8;
        Wed, 13 May 2020 05:58:14 -0400 (EDT)
Date:   Wed, 13 May 2020 12:58:11 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net/scm: cleanup scm_detach_fds
Message-ID: <20200513095811.GA598161@splinter>
References: <20200511115913.1420836-1-hch@lst.de>
 <20200511115913.1420836-3-hch@lst.de>
 <20200513092918.GA596863@splinter>
 <20200513094908.GA31756@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513094908.GA31756@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 11:49:08AM +0200, Christoph Hellwig wrote:
> On Wed, May 13, 2020 at 12:29:18PM +0300, Ido Schimmel wrote:
> > On Mon, May 11, 2020 at 01:59:12PM +0200, Christoph Hellwig wrote:
> > > Factor out two helpes to keep the code tidy.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Christoph,
> > 
> > After installing net-next (fb9f2e92864f) on a Fedora 32 machine I cannot
> > ssh to it. Bisected it to this commit [1].
> > 
> > When trying to connect I see these error messages in journal:
> > 
> > sshd[1029]: error: mm_receive_fd: no message header
> > sshd[1029]: fatal: mm_pty_allocate: receive fds failed
> > sshd[1029]: fatal: mm_request_receive_expect: buffer error: incomplete message
> > sshd[1018]: fatal: mm_request_receive: read: Connection reset by peer
> > 
> > Please let me know if more info is required. I can easily test a patch
> > if you need me to try something.
> 
> To start we can try reverting just this commit, which requires a
> little manual work.  Patch below:

Thanks for the quick reply. With the below patch ssh is working again.

> 
> ---
> From fe4f53219b42aeded3c1464dbe2bbc9365f6a853 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Wed, 13 May 2020 11:48:33 +0200
> Subject: Revert "net/scm: cleanup scm_detach_fds"
> 
> This reverts commit 2618d530dd8b7ac0fdcb83f4c95b88f7b0d37ce6.
> ---
>  net/core/scm.c | 94 +++++++++++++++++++++++---------------------------
>  1 file changed, 43 insertions(+), 51 deletions(-)
> 
> diff --git a/net/core/scm.c b/net/core/scm.c
> index a75cd637a71ff..2d9aa5682bed2 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -280,53 +280,18 @@ void put_cmsg_scm_timestamping(struct msghdr *msg, struct scm_timestamping_inter
>  }
>  EXPORT_SYMBOL(put_cmsg_scm_timestamping);
>  
> -static int __scm_install_fd(struct file *file, int __user *ufd, int o_flags)
> -{
> -	struct socket *sock;
> -	int new_fd;
> -	int error;
> -
> -	error = security_file_receive(file);
> -	if (error)
> -		return error;
> -
> -	new_fd = get_unused_fd_flags(o_flags);
> -	if (new_fd < 0)
> -		return new_fd;
> -
> -	error = put_user(new_fd, ufd);
> -	if (error) {
> -		put_unused_fd(new_fd);
> -		return error;
> -	}
> -
> -	/* Bump the usage count and install the file. */
> -	sock = sock_from_file(file, &error);
> -	if (sock) {
> -		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
> -		sock_update_classid(&sock->sk->sk_cgrp_data);
> -	}
> -	fd_install(new_fd, get_file(file));
> -	return error;
> -}
> -
> -static int scm_max_fds(struct msghdr *msg)
> -{
> -	if (msg->msg_controllen <= sizeof(struct cmsghdr))
> -		return 0;
> -	return (msg->msg_controllen - sizeof(struct cmsghdr)) / sizeof(int);
> -}
> -
>  void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>  {
>  	struct cmsghdr __user *cm
>  		= (__force struct cmsghdr __user*)msg->msg_control;
> -	int o_flags = (msg->msg_flags & MSG_CMSG_CLOEXEC) ? O_CLOEXEC : 0;
> -	int fdmax = min_t(int, scm_max_fds(msg), scm->fp->count);
> -	int __user *cmsg_data = CMSG_USER_DATA(cm);
> +
> +	int fdmax = 0;
> +	int fdnum = scm->fp->count;
> +	struct file **fp = scm->fp->fp;
> +	int __user *cmfptr;
>  	int err = 0, i;
>  
> -	if (msg->msg_flags & MSG_CMSG_COMPAT) {
> +	if (MSG_CMSG_COMPAT & msg->msg_flags) {
>  		scm_detach_fds_compat(msg, scm);
>  		return;
>  	}
> @@ -335,35 +300,62 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>  	if (WARN_ON_ONCE(!msg->msg_control_is_user))
>  		return;
>  
> -	for (i = 0; i < fdmax; i++) {
> -		err = __scm_install_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
> +	if (msg->msg_controllen > sizeof(struct cmsghdr))
> +		fdmax = ((msg->msg_controllen - sizeof(struct cmsghdr))
> +			 / sizeof(int));
> +
> +	if (fdnum < fdmax)
> +		fdmax = fdnum;
> +
> +	for (i=0, cmfptr =(int __user *)CMSG_USER_DATA(cm); i<fdmax;
> +	     i++, cmfptr++)
> +	{
> +		struct socket *sock;
> +		int new_fd;
> +		err = security_file_receive(fp[i]);
>  		if (err)
>  			break;
> +		err = get_unused_fd_flags(MSG_CMSG_CLOEXEC & msg->msg_flags
> +					  ? O_CLOEXEC : 0);
> +		if (err < 0)
> +			break;
> +		new_fd = err;
> +		err = put_user(new_fd, cmfptr);
> +		if (err) {
> +			put_unused_fd(new_fd);
> +			break;
> +		}
> +		/* Bump the usage count and install the file. */
> +		sock = sock_from_file(fp[i], &err);
> +		if (sock) {
> +			sock_update_netprioidx(&sock->sk->sk_cgrp_data);
> +			sock_update_classid(&sock->sk->sk_cgrp_data);
> +		}
> +		fd_install(new_fd, get_file(fp[i]));
>  	}
>  
> -	if (i > 0)  {
> -		int cmlen = CMSG_LEN(i * sizeof(int));
> -
> +	if (i > 0)
> +	{
> +		int cmlen = CMSG_LEN(i*sizeof(int));
>  		err = put_user(SOL_SOCKET, &cm->cmsg_level);
>  		if (!err)
>  			err = put_user(SCM_RIGHTS, &cm->cmsg_type);
>  		if (!err)
>  			err = put_user(cmlen, &cm->cmsg_len);
>  		if (!err) {
> -			cmlen = CMSG_SPACE(i * sizeof(int));
> +			cmlen = CMSG_SPACE(i*sizeof(int));
>  			if (msg->msg_controllen < cmlen)
>  				cmlen = msg->msg_controllen;
>  			msg->msg_control += cmlen;
>  			msg->msg_controllen -= cmlen;
>  		}
>  	}
> -
> -	if (i < scm->fp->count || (scm->fp->count && fdmax <= 0))
> +	if (i < fdnum || (fdnum && fdmax <= 0))
>  		msg->msg_flags |= MSG_CTRUNC;
>  
>  	/*
> -	 * All of the files that fit in the message have had their usage counts
> -	 * incremented, so we just free the list.
> +	 * All of the files that fit in the message have had their
> +	 * usage counts incremented, so we just free the list.
>  	 */
>  	__scm_destroy(scm);
>  }
> -- 
> 2.26.2
> 
