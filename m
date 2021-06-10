Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418FE3A212E
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhFJALj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:11:39 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:53785 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhFJALj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 20:11:39 -0400
Received: by mail-pj1-f44.google.com with SMTP id ei4so2568287pjb.3
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 17:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=faAxt3Q7aulHEh4rIMV/zqkjBp6avJdr39STmI0UbeE=;
        b=uFY6vw9AOxYUnjhzCbZWajIOeo6aAg5do0f0akIcr9N/2O5oED52XOlLAsgFUT+hWm
         KgLlKLfpG6PP5/cHxCVJ8X/QlDmZO1+XgPGG0YLMyZ+c2KO4JV2ke+eDsT+UL1zOJDAq
         bCtXCXsGdV8p7mZXw9oG1+9y+t9rCPExK8+BJFdgS51EhXQcqO41ouwz/Pfvk40k545f
         zR0/P/UbkrZpU+3EsYBZa4foB8NtHCAGql0sPs3xry6N8hiS4S6VWy2P1v2KTo/FOLA3
         l/ofE4IZNUzUxbHhfgWJ5EJEfJ9cq5PXlDH5SJdYqSschI2wtkLD5XvzmcL8PA8DsPcZ
         3kYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=faAxt3Q7aulHEh4rIMV/zqkjBp6avJdr39STmI0UbeE=;
        b=YUKcmG5thxpSKSmwFpI8G7Kh6KN3WBftqSw4mVSakXVShkMYkCdRxU8wplQbSNLu8x
         rOp+88/xwzsE8hDpAfLot+Me3jGYn/ffMESSVK/jXDhg0X+55HR5b9vr7ytq4Ks+dSbP
         pJxDOlXabxZtEU8zlJUNdM5GtZQpya33R0U77aPjZ7et6pPpFG6s+6kSIeaMsduWmtt8
         55bEh9V/LwOdS/ljzkksEwTBkKDDOVaQfgMhfvzUn+0CGCu+r7TnFFxeRE9KsbzdZFP8
         Cw5FAYpig4RIO34YiOLJf8DX+dLu8tHRxwMV3qwCUquWX3bTPO94Yo5JZJTuD6zSHCzu
         RNHg==
X-Gm-Message-State: AOAM530hHdPWBGITejRNKQVIc0z0i4mFpz/UOCVv0kCkK3IWBBUQLMbW
        7kgjYVxTXGwees518yRPh6Vzx7xThY4ZHzLV
X-Google-Smtp-Source: ABdhPJwNriG/Px8SjFDHf2wj7Pe+ZE8QUXnruOChwFwgXVYxqKC20ZSNFlt4SFal1tcEtqrpUP29eA==
X-Received: by 2002:a17:90a:2d8e:: with SMTP id p14mr280593pjd.131.1623283712134;
        Wed, 09 Jun 2021 17:08:32 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id 195sm560954pfz.24.2021.06.09.17.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 17:08:31 -0700 (PDT)
Date:   Wed, 9 Jun 2021 17:07:50 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= 
        <socketpair@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] ip link get dev if%u" now works
Message-ID: <20210609170743.7dd68f9a@hermes.local>
In-Reply-To: <CAEmTpZHK7OoWxpGXKc0_=yYhW0YxQVZUYU3_Gkpf2VeA9xBMXw@mail.gmail.com>
References: <CAEmTpZHK7OoWxpGXKc0_=yYhW0YxQVZUYU3_Gkpf2VeA9xBMXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> commit c71a164fb3abbce177cb2692e25ebc54e0156d5a (refs/remotes/origin/geti=
ndex)
> Author: =D0=9A=D0=BE=D1=80=D0=B5=D0=BD=D0=B1=D0=B5=D1=80=D0=B3 =E2=98=A2=
=EF=B8=8F  =D0=9C=D0=B0=D1=80=D0=BA <mark@ideco.ru>
> Date:   Thu May 13 15:43:14 2021 +0500
>=20
>     ip: "ip link get dev if%u" now works

Patch is missing Signed-off-by

>=20
> diff --git a/ip/ip_common.h b/ip/ip_common.h
> index 9a31e837..1eb40a1e 100644
> --- a/ip/ip_common.h
> +++ b/ip/ip_common.h
> @@ -89,7 +89,7 @@ int do_seg6(int argc, char **argv);
>  int do_ipnh(int argc, char **argv);
>  int do_mptcp(int argc, char **argv);
> =20
> -int iplink_get(char *name, __u32 filt_mask);
> +int iplink_get(unsigned ifindex, __u32 filt_mask);

WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
#94: FILE: ip/ip_common.h:92:
+int iplink_get(unsigned ifindex, __u32 filt_mask);

>  int iplink_ifla_xstats(int argc, char **argv);
> =20
>  int ip_link_list(req_filter_fn_t filter_fn, struct nlmsg_chain *linfo);
> diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> index 0bbcee2b..9be6ea4d 100644
> --- a/ip/ipaddress.c
> +++ b/ip/ipaddress.c
> @@ -10,6 +10,7 @@
>   *
>   */
> =20
> +#include <assert.h>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <unistd.h>
> @@ -2111,7 +2112,8 @@ static int ipaddr_list_flush_or_save(int argc, char=
 **argv, int action)
>  	 * the link device
>  	 */
>  	if (filter_dev && filter.group =3D=3D -1 && do_link =3D=3D 1) {
> -		if (iplink_get(filter_dev, RTEXT_FILTER_VF) < 0) {
> +		assert(filter.ifindex);

No assert() please do more complete error message and handling.

> +		if (iplink_get(filter.ifindex, RTEXT_FILTER_VF) < 0) {
>  			perror("Cannot send link get request");
>  			delete_json_obj();
>  			exit(1);
> diff --git a/ip/iplink.c b/ip/iplink.c
> index 27c9be44..43272c6b 100644
> --- a/ip/iplink.c
> +++ b/ip/iplink.c
> @@ -1101,21 +1101,17 @@ static int iplink_modify(int cmd, unsigned int fl=
ags, int argc, char **argv)
>  	return 0;
>  }
> =20
> -int iplink_get(char *name, __u32 filt_mask)
> +int iplink_get(unsigned ifindex, __u32 filt_mask)
>  {
>  	struct iplink_req req =3D {
>  		.n.nlmsg_len =3D NLMSG_LENGTH(sizeof(struct ifinfomsg)),
>  		.n.nlmsg_flags =3D NLM_F_REQUEST,
>  		.n.nlmsg_type =3D RTM_GETLINK,
>  		.i.ifi_family =3D preferred_family,
> +		.i.ifi_index =3D ifindex,
>  	};
>  	struct nlmsghdr *answer;
> =20
> -	if (name) {
> -		addattr_l(&req.n, sizeof(req),
> -			  !check_ifname(name) ? IFLA_IFNAME : IFLA_ALT_IFNAME,
> -			  name, strlen(name) + 1);
> -	}

The old code supported matching by alter name, it looks like with your
change it no longer does.

>  	addattr32(&req.n, sizeof(req), IFLA_EXT_MASK, filt_mask);
> =20
>  	if (rtnl_talk(&rth, &req.n, &answer) < 0)
