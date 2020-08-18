Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5515C248F23
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgHRT4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726632AbgHRT4n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 15:56:43 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 796842076E;
        Tue, 18 Aug 2020 19:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597780602;
        bh=neHbT+U3gwRWCIZyKJ4PN/GywWjBDOKx7ZICSN9l69Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=xQeFkOu9p8kJIUwn34yyUNd4VvuMg10RVUvQwEdYf4bVSAw2YLTMEVFz7dkVfMkcF
         aUONF2nUsUUtkj6JrGiV7NuO7QTOg9zEX5WlQznyPnhOKoGdG3+r3vEIQv3O5Jf3O5
         mdlchlUnS9HvFx/tkxA5+PaQ1hyXppwnEMqgntaE=
Message-ID: <d713ae02fc02ec4cf5edf1a6d0e9be49f00d5371.camel@kernel.org>
Subject: Re: [PATCH] libceph: Convert to use the preferred fallthrough macro
From:   Jeff Layton <jlayton@kernel.org>
To:     Miaohe Lin <linmiaohe@huawei.com>, idryomov@gmail.com,
        davem@davemloft.net, kuba@kernel.org, grandmaster@al2klimov.de
Cc:     ceph-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 18 Aug 2020 15:56:40 -0400
In-Reply-To: <20200818122637.21449-1-linmiaohe@huawei.com>
References: <20200818122637.21449-1-linmiaohe@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-08-18 at 08:26 -0400, Miaohe Lin wrote:
> Convert the uses of fallthrough comments to fallthrough macro.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  net/ceph/ceph_hash.c    | 20 ++++++++++----------
>  net/ceph/crush/mapper.c |  2 +-
>  net/ceph/messenger.c    |  4 ++--
>  net/ceph/mon_client.c   |  2 +-
>  net/ceph/osd_client.c   |  4 ++--
>  5 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/net/ceph/ceph_hash.c b/net/ceph/ceph_hash.c
> index 81e1e006c540..16a47c0eef37 100644
> --- a/net/ceph/ceph_hash.c
> +++ b/net/ceph/ceph_hash.c
> @@ -50,35 +50,35 @@ unsigned int ceph_str_hash_rjenkins(const char *str, unsigned int length)
>  	switch (len) {
>  	case 11:
>  		c = c + ((__u32)k[10] << 24);
> -		/* fall through */
> +		fallthrough;
>  	case 10:
>  		c = c + ((__u32)k[9] << 16);
> -		/* fall through */
> +		fallthrough;
>  	case 9:
>  		c = c + ((__u32)k[8] << 8);
>  		/* the first byte of c is reserved for the length */
> -		/* fall through */
> +		fallthrough;
>  	case 8:
>  		b = b + ((__u32)k[7] << 24);
> -		/* fall through */
> +		fallthrough;
>  	case 7:
>  		b = b + ((__u32)k[6] << 16);
> -		/* fall through */
> +		fallthrough;
>  	case 6:
>  		b = b + ((__u32)k[5] << 8);
> -		/* fall through */
> +		fallthrough;
>  	case 5:
>  		b = b + k[4];
> -		/* fall through */
> +		fallthrough;
>  	case 4:
>  		a = a + ((__u32)k[3] << 24);
> -		/* fall through */
> +		fallthrough;
>  	case 3:
>  		a = a + ((__u32)k[2] << 16);
> -		/* fall through */
> +		fallthrough;
>  	case 2:
>  		a = a + ((__u32)k[1] << 8);
> -		/* fall through */
> +		fallthrough;
>  	case 1:
>  		a = a + k[0];
>  		/* case 0: nothing left to add */
> diff --git a/net/ceph/crush/mapper.c b/net/ceph/crush/mapper.c
> index 07e5614eb3f1..7057f8db4f99 100644
> --- a/net/ceph/crush/mapper.c
> +++ b/net/ceph/crush/mapper.c
> @@ -987,7 +987,7 @@ int crush_do_rule(const struct crush_map *map,
>  		case CRUSH_RULE_CHOOSELEAF_FIRSTN:
>  		case CRUSH_RULE_CHOOSE_FIRSTN:
>  			firstn = 1;
> -			/* fall through */
> +			fallthrough;
>  		case CRUSH_RULE_CHOOSELEAF_INDEP:
>  		case CRUSH_RULE_CHOOSE_INDEP:
>  			if (wsize == 0)
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index 27d6ab11f9ee..bdfd66ba3843 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -412,7 +412,7 @@ static void ceph_sock_state_change(struct sock *sk)
>  	switch (sk->sk_state) {
>  	case TCP_CLOSE:
>  		dout("%s TCP_CLOSE\n", __func__);
> -		/* fall through */
> +		fallthrough;
>  	case TCP_CLOSE_WAIT:
>  		dout("%s TCP_CLOSE_WAIT\n", __func__);
>  		con_sock_state_closing(con);
> @@ -2751,7 +2751,7 @@ static int try_read(struct ceph_connection *con)
>  			switch (ret) {
>  			case -EBADMSG:
>  				con->error_msg = "bad crc/signature";
> -				/* fall through */
> +				fallthrough;
>  			case -EBADE:
>  				ret = -EIO;
>  				break;
> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> index 3d8c8015e976..d633a0aeaa55 100644
> --- a/net/ceph/mon_client.c
> +++ b/net/ceph/mon_client.c
> @@ -1307,7 +1307,7 @@ static struct ceph_msg *mon_alloc_msg(struct ceph_connection *con,
>  		 * request had a non-zero tid.  Work around this weirdness
>  		 * by allocating a new message.
>  		 */
> -		/* fall through */
> +		fallthrough;
>  	case CEPH_MSG_MON_MAP:
>  	case CEPH_MSG_MDS_MAP:
>  	case CEPH_MSG_OSD_MAP:
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index e4fbcad6e7d8..7901ab6c79fd 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -3854,7 +3854,7 @@ static void scan_requests(struct ceph_osd *osd,
>  			if (!force_resend && !force_resend_writes)
>  				break;
>  
> -			/* fall through */
> +			fallthrough;
>  		case CALC_TARGET_NEED_RESEND:
>  			cancel_linger_map_check(lreq);
>  			/*
> @@ -3891,7 +3891,7 @@ static void scan_requests(struct ceph_osd *osd,
>  			     !force_resend_writes))
>  				break;
>  
> -			/* fall through */
> +			fallthrough;
>  		case CALC_TARGET_NEED_RESEND:
>  			cancel_map_check(req);
>  			unlink_request(osd, req);


Looks sane. Merged into ceph-client/testing branch.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

