Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82AFCF532A
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 19:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbfKHSDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:03:22 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41147 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfKHSDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 13:03:22 -0500
Received: by mail-pl1-f193.google.com with SMTP id d29so4418990plj.8;
        Fri, 08 Nov 2019 10:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Cf/MzkLmYD+yZFPvoSKA3+NfS3oVHMt1KomSDwacCxw=;
        b=Qbod+qYZa+0KIsIAfPgI2qF7uAcwF5AnZcYgOJd46QeIumaZUA0tr3lTHQ2kru8g6T
         N4jsZ2eTZr6DnyD1WS9iDLi1cqjf0oU8nmmVGRd1Dewc117UTjS/1n1a8ZrjGR4t1FNj
         Dke9HWpwVoq13FUVvmcvaTBIcyFTMPyX6iy4TZKfRUc2nXCXhqGAetbQoXgkxkOzD15z
         9GuEokDd3qJ6TtbH5Eofixpgwd9n22WQy4m56vhOTagn5E+aBoyeGiD4NYU64I75XXgy
         omSQDHPX3P8bsGPsym3Z3/kricv4GfPbMdHsod+bS1xtrGuGA7EoJghqHymTOgbxcjxz
         T7MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Cf/MzkLmYD+yZFPvoSKA3+NfS3oVHMt1KomSDwacCxw=;
        b=cKtPNUfMhmrfBtxb46fuCbd8q4uA0RJsDhHamCrRyVKKSTT6b4cIUmFYmM/cq9+ub3
         n/VWwmzoLmTVvz5TD8EYi7eLoxPos0JmAeMTVyk0cVe8m5ku81ybnU18JWkmRt3JztyV
         t7YTZNFuWsGlYBDQyObtJSBl7U1N4YJPTaMjoIh7SZN3QhOdv9bxRbluLq/XEQTVFOqL
         E8ab2FAfUpBKiLCd9/19kw7RUhQ9ZnXQ81bqUisBOYyAK+PL55rMVbZlhzwKfowAt7vk
         E9dmfgGMn2zfOnt+REdb0R8e3/qrOFbM86eN/g0YrY8yB9b3XYpvVdQ5+0H26Ohlmqa5
         xQUA==
X-Gm-Message-State: APjAAAWxmw4+Wl4oFIBVntXkus2BQIcrqyf9MgqP21Ig9I9KNKjhoHlb
        e4gtMVdVPxywjlPGpUl1TCuYA/R3XQs=
X-Google-Smtp-Source: APXvYqwtrcmn0ooctEksvsu8/NHBMlCnPo4tGJpYjPkaD6kmCYD27yJyV/IOMO7eVifevpVehXC07w==
X-Received: by 2002:a17:902:6f01:: with SMTP id w1mr12354984plk.35.1573236201119;
        Fri, 08 Nov 2019 10:03:21 -0800 (PST)
Received: from gmail.com ([66.170.99.95])
        by smtp.gmail.com with ESMTPSA id w69sm781803pfc.164.2019.11.08.10.03.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 10:03:20 -0800 (PST)
Date:   Fri, 8 Nov 2019 10:03:14 -0800
From:   William Tu <u9012063@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/5] libbpf: support XDP_SHARED_UMEM with
 external XDP program
Message-ID: <20191108180314.GA30004@gmail.com>
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
 <1573148860-30254-2-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573148860-30254-2-git-send-email-magnus.karlsson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Magnus,

Thanks for the patch.

On Thu, Nov 07, 2019 at 06:47:36PM +0100, Magnus Karlsson wrote:
> Add support in libbpf to create multiple sockets that share a single
> umem. Note that an external XDP program need to be supplied that
> routes the incoming traffic to the desired sockets. So you need to
> supply the libbpf_flag XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD and load
> your own XDP program.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/lib/bpf/xsk.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 86c1b61..8ebd810 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -586,15 +586,21 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
>  	if (!umem || !xsk_ptr || !rx || !tx)
>  		return -EFAULT;
>  
> -	if (umem->refcount) {
> -		pr_warn("Error: shared umems not supported by libbpf.\n");
> -		return -EBUSY;
> -	}
> -
>  	xsk = calloc(1, sizeof(*xsk));
>  	if (!xsk)
>  		return -ENOMEM;
>  
> +	err = xsk_set_xdp_socket_config(&xsk->config, usr_config);
> +	if (err)
> +		goto out_xsk_alloc;
> +
> +	if (umem->refcount &&
> +	    !(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
> +		pr_warn("Error: shared umems not supported by libbpf supplied XDP program.\n");

Why can't we use the existing default one in libbpf?
If users don't want to redistribute packet to different queue,
then they can still use the libbpf default one.

William
> +		err = -EBUSY;
> +		goto out_xsk_alloc;
> +	}
> +
>  	if (umem->refcount++ > 0) {
>  		xsk->fd = socket(AF_XDP, SOCK_RAW, 0);
>  		if (xsk->fd < 0) {
> @@ -616,10 +622,6 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
>  	memcpy(xsk->ifname, ifname, IFNAMSIZ - 1);
>  	xsk->ifname[IFNAMSIZ - 1] = '\0';
>  
> -	err = xsk_set_xdp_socket_config(&xsk->config, usr_config);
> -	if (err)
> -		goto out_socket;
> -
>  	if (rx) {
>  		err = setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
>  				 &xsk->config.rx_size,
> @@ -687,7 +689,12 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
>  	sxdp.sxdp_family = PF_XDP;
>  	sxdp.sxdp_ifindex = xsk->ifindex;
>  	sxdp.sxdp_queue_id = xsk->queue_id;
> -	sxdp.sxdp_flags = xsk->config.bind_flags;
> +	if (umem->refcount > 1) {
> +		sxdp.sxdp_flags = XDP_SHARED_UMEM;
> +		sxdp.sxdp_shared_umem_fd = umem->fd;
> +	} else {
> +		sxdp.sxdp_flags = xsk->config.bind_flags;
> +	}
>  
>  	err = bind(xsk->fd, (struct sockaddr *)&sxdp, sizeof(sxdp));
>  	if (err) {
> -- 
> 2.7.4
> 
