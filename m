Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FBD2605F4
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 22:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgIGUvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 16:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbgIGUvF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 16:51:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FBD2215A4;
        Mon,  7 Sep 2020 20:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599511864;
        bh=moHE2fS5SWr+Q90roWsS4gsQyYjLus/LW9s9udWd1Nk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LQ/2FOlmeD6SbiVafipbjXeesAhQ26/vuXrKYJkt9ywKt43vf+9LzkD9sOXZjJL1D
         4G2Jnepu5AFnxFKxshkkIeP1G36IwyrRKmKfMO5EMPY4kzW2v16WMn41QCe2ETLAcj
         Kkf/JBDthXbdIiHd8TktH6rVt0LkMSspBTITDTfE=
Date:   Mon, 7 Sep 2020 13:51:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>
Subject: Re: [PATCH net-next] netlink: add spaces around '&' in
 netlink_recvmsg()
Message-ID: <20200907135102.27e07aff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200907132144.3144704-1-yangyingliang@huawei.com>
References: <20200907132144.3144704-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Sep 2020 21:21:44 +0800 Yang Yingliang wrote:
> Spaces preferred around '&'.

This in itself is not a sufficient justification to touch code that
pre-dates the git era.

IMHO '&' without spaces around it is particularly hard to read, and 
the code is actively used, which makes the change worth considering.

But I'm not sure why you decided to fix recvmsg but not sendmsg.

Please provide a better commit message.

> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index d2d1448274f5..5a86bf4f80b1 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -1929,12 +1929,12 @@ static int netlink_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>  	struct scm_cookie scm;
>  	struct sock *sk = sock->sk;
>  	struct netlink_sock *nlk = nlk_sk(sk);
> -	int noblock = flags&MSG_DONTWAIT;
> +	int noblock = flags & MSG_DONTWAIT;
>  	size_t copied;
>  	struct sk_buff *skb, *data_skb;
>  	int err, ret;
>  
> -	if (flags&MSG_OOB)
> +	if (flags & MSG_OOB)
>  		return -EOPNOTSUPP;
>  
>  	copied = 0;

