Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA7F2FC332
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbhASWTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 17:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728210AbhASWSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 17:18:39 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F32C061757;
        Tue, 19 Jan 2021 14:17:59 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id r4so11339349pls.11;
        Tue, 19 Jan 2021 14:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=d4osgfp0iss0CDkLcixedPKYK/Iq16axn8OlnM1YIXw=;
        b=Fi3DCz0wjHH1sza6IeNDPn+5tWFLsjaq57pR33zEBI93JXib3KyP2JtTqaYgshQtxm
         3axyYUHEQNZGhnh9v/xdZOU0faz6TEujZpqroj+oxx3F2QI6VQ+sQ4GuN7FVWdPnxdzB
         coo9NnH6QRmgIBVfQV15kEfR3ytTctGvB75dCA23/PUh5dvRZBQH4tCYa8+mPOsk7D2l
         KofiCrp2JV4YyZP0cKhZFBb+LDhB0tZ6AfD0PYFwXOhpFyb7nk/Fy8vBDcmwkPWTO4hs
         ZTBhS3s0fS89qLaDbwttrF1i/QsxTzbXkBUM81t2Eb1kk7MdN7ogcwk0UlVWBgDsmM/o
         xTEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=d4osgfp0iss0CDkLcixedPKYK/Iq16axn8OlnM1YIXw=;
        b=sZFUmVWcTpHhQtrghm1stoWwXTGpPCi4tCi4VX2HxQMXRAKcQnoCENP0gXF51/xzj7
         gzngm1HRzkPlm4e/bSocYAb79BbTd7rQaq5h9Pz6M4xyaN8xvwuOlvhaLBqnl+3ZBm+4
         LUHrlHm8R+sv14WyquFP2wJh611DDoK+djEpaoB6TM+T8+ZWLg6ytJ1cphNlOI+Lyfig
         Qr2g58aZmMVykhlWtdEhUobS0Sc38+OrBacZy4fvbxSfrJ9oinZRDVJZ2ofnDUQ3VOKd
         CUnkIPJ/eMGK6ZTQKKref3LzbzwXFxGfncc31aN5oHTi2JQjhHJa7Feilx5baIZNZOqX
         8EvQ==
X-Gm-Message-State: AOAM530sV3p11WMtiikbKeLu0T8fqw8tPbw89s3yc8ZjWccDPcE65s+/
        6wkI6SG6XQeh+e+lYr06vQ==
X-Google-Smtp-Source: ABdhPJzGHLFkruSDhqYZSJHyD4kO5OcPNosh18JDWSYIPuLliftVoSOLaNMSt4XAWfc1ASkXI8ypwg==
X-Received: by 2002:a17:902:c3d2:b029:da:73c5:c589 with SMTP id j18-20020a170902c3d2b02900da73c5c589mr6711314plj.71.1611094678602;
        Tue, 19 Jan 2021 14:17:58 -0800 (PST)
Received: from ?IPv6:2600:1700:cda0:4340:501a:698e:f6c5:f47c? ([2600:1700:cda0:4340:501a:698e:f6c5:f47c])
        by smtp.gmail.com with ESMTPSA id t2sm84159pga.45.2021.01.19.14.17.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Jan 2021 14:17:57 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v2 net-next 1/1] Allow user to set metric on default route
 learned via Router Advertisement.
From:   praveen chaudhary <praveen5582@gmail.com>
In-Reply-To: <0f64942e-debd-81bd-b29c-7d2728a5bd4b@gmail.com>
Date:   Tue, 19 Jan 2021 14:17:49 -0800
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhenggen Xu <zxu@linkedin.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A2DE27CF-A988-4003-8A95-60CC101086DA@gmail.com>
References: <20210115080203.8889-1-pchaudhary@linkedin.com>
 <0f64942e-debd-81bd-b29c-7d2728a5bd4b@gmail.com>
To:     David Ahern <dsahern@gmail.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 16, 2021, at 9:13 AM, David Ahern <dsahern@gmail.com> wrote:
>=20
> On 1/15/21 1:02 AM, Praveen Chaudhary wrote:
>> For IPv4, default route is learned via DHCPv4 and user is allowed to =
change
>> metric using config etc/network/interfaces. But for IPv6, default =
route can
>> be learned via RA, for which, currently a fixed metric value 1024 is =
used.
>>=20
>> Ideally, user should be able to configure metric on default route for =
IPv6
>> similar to IPv4. This fix adds sysctl for the same.
>>=20
>> Signed-off-by: Praveen Chaudhary <pchaudhary@linkedin.com>
>> Signed-off-by: Zhenggen Xu <zxu@linkedin.com>
>>=20
>> Changes in v1.
>> ---
>=20
> your trying to be too fancy in the log messages; everything after this
> first '---' is dropped. Just Remove all of the '---' lines and '```' =
tags.
>=20

Removed all =E2=80=98=E2=80=94=E2=80=98 and =E2=80=98```=E2=80=99 in v3.

>> 1.) Correct the call to rt6_add_dflt_router.
>> ---
>>=20
>> Changes in v2.
>> [Refer: lkml.org/lkml/2021/1/14/1400]
>> ---
>> 1.) Replace accept_ra_defrtr_metric to ra_defrtr_metric.
>> 2.) Change Type to __u32 instead of __s32.
>> 3.) Change description in Documentation/networking/ip-sysctl.rst.
>> 4.) Use proc_douintvec instead of proc_dointvec.
>> 5.) Code style in ndisc_router_discovery().
>> 6.) Change Type to u32 instead of unsigned int.
>> ---
>>=20
>> Logs:
>> ----------------------------------------------------------------
>> For IPv4:
>> ----------------------------------------------------------------
>>=20
>> Config in etc/network/interfaces
>> ----------------------------------------------------------------
>> ```
>> auto eth0
>> iface eth0 inet dhcp
>>    metric 4261413864
>=20
> how does that work for IPv4? Is the metric passed to the dhclient and =
it
> inserts the route with the given metric or is a dhclient script used =
to
> replace the route after insert?
>=20
>=20

Yes, DHCP client picks config under =E2=80=9Ciface eth0 inet dhcp=E2=80=9D=
 line and if metric is configured, then it adds the metric for all added =
routes.


>> diff --git a/Documentation/networking/ip-sysctl.rst =
b/Documentation/networking/ip-sysctl.rst
>> index dd2b12a32b73..c4b8d4b8d213 100644
>> --- a/Documentation/networking/ip-sysctl.rst
>> +++ b/Documentation/networking/ip-sysctl.rst
>> @@ -1871,6 +1871,18 @@ accept_ra_defrtr - BOOLEAN
>> 		- enabled if accept_ra is enabled.
>> 		- disabled if accept_ra is disabled.
>>=20
>> +ra_defrtr_metric - INTEGER
>> +	Route metric for default route learned in Router Advertisement. =
This value
>> +	will be assigned as metric for the default route learned via =
IPv6 Router
>> +	Advertisement. Takes affect only if accept_ra_defrtr' is =
enabled.
>=20
> stray ' after accept_ra_defrtr
>=20

Removed.

>> +
>> +	Possible values are:
>> +		0:
>> +			default value will be used for route metric
>> +			i.e. IP6_RT_PRIO_USER 1024.
>> +		1 to 0xFFFFFFFF:
>> +			current value will be used for route metric.
>> +
>> accept_ra_from_local - BOOLEAN
>> 	Accept RA with source-address that is found on local machine
>> 	if the RA is otherwise proper and able to be accepted.
>=20
>=20
>=20
>> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
>> index eff2cacd5209..b13d3213e58f 100644
>> --- a/net/ipv6/addrconf.c
>> +++ b/net/ipv6/addrconf.c
>> @@ -205,6 +205,7 @@ static struct ipv6_devconf ipv6_devconf =
__read_mostly =3D {
>> 	.max_desync_factor	=3D MAX_DESYNC_FACTOR,
>> 	.max_addresses		=3D IPV6_MAX_ADDRESSES,
>> 	.accept_ra_defrtr	=3D 1,
>> +	.ra_defrtr_metric =3D 0,
>=20
> make the the '=3D' align column wise with the existing entries; seems =
like
> your new line is missing a tab

Fixed.

>=20
>> 	.accept_ra_from_local	=3D 0,
>> 	.accept_ra_min_hop_limit=3D 1,
>> 	.accept_ra_pinfo	=3D 1,
>> @@ -260,6 +261,7 @@ static struct ipv6_devconf ipv6_devconf_dflt =
__read_mostly =3D {
>> 	.max_desync_factor	=3D MAX_DESYNC_FACTOR,
>> 	.max_addresses		=3D IPV6_MAX_ADDRESSES,
>> 	.accept_ra_defrtr	=3D 1,
>> +	.ra_defrtr_metric =3D 0,
>=20
> same here

Fixed.

>=20
>> 	.accept_ra_from_local	=3D 0,
>> 	.accept_ra_min_hop_limit=3D 1,
>> 	.accept_ra_pinfo	=3D 1,
>> @@ -5475,6 +5477,7 @@ static inline void ipv6_store_devconf(struct =
ipv6_devconf *cnf,
>> 	array[DEVCONF_MAX_DESYNC_FACTOR] =3D cnf->max_desync_factor;
>> 	array[DEVCONF_MAX_ADDRESSES] =3D cnf->max_addresses;
>> 	array[DEVCONF_ACCEPT_RA_DEFRTR] =3D cnf->accept_ra_defrtr;
>> +	array[DEVCONF_RA_DEFRTR_METRIC] =3D cnf->ra_defrtr_metric;
>> 	array[DEVCONF_ACCEPT_RA_MIN_HOP_LIMIT] =3D =
cnf->accept_ra_min_hop_limit;
>> 	array[DEVCONF_ACCEPT_RA_PINFO] =3D cnf->accept_ra_pinfo;
>> #ifdef CONFIG_IPV6_ROUTER_PREF
>> @@ -6667,6 +6670,13 @@ static const struct ctl_table =
addrconf_sysctl[] =3D {
>> 		.mode		=3D 0644,
>> 		.proc_handler	=3D proc_dointvec,
>> 	},
>> +	{
>> +		.procname	=3D "ra_defrtr_metric",
>> +		.data		=3D &ipv6_devconf.ra_defrtr_metric,
>> +		.maxlen		=3D sizeof(u32),
>> +		.mode		=3D 0644,
>> +		.proc_handler	=3D proc_douintvec,
>> +	},
>> 	{
>> 		.procname	=3D "accept_ra_min_hop_limit",
>> 		.data		=3D =
&ipv6_devconf.accept_ra_min_hop_limit,
>> diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
>> index 76717478f173..2bffed49f5c0 100644
>> --- a/net/ipv6/ndisc.c
>> +++ b/net/ipv6/ndisc.c
>> @@ -1173,6 +1173,7 @@ static void ndisc_router_discovery(struct =
sk_buff *skb)
>> 	struct neighbour *neigh =3D NULL;
>> 	struct inet6_dev *in6_dev;
>> 	struct fib6_info *rt =3D NULL;
>> +	u32 defrtr_usr_metric;
>> 	struct net *net;
>> 	int lifetime;
>> 	struct ndisc_options ndopts;
>> @@ -1303,18 +1304,23 @@ static void ndisc_router_discovery(struct =
sk_buff *skb)
>> 			return;
>> 		}
>> 	}
>> -	if (rt && lifetime =3D=3D 0) {
>> +	/* Set default route metric if specified by user */
>> +	defrtr_usr_metric =3D in6_dev->cnf.accept_ra_defrtr_metric;
>=20
> this tells me you did not compile this version of the patch since the
> 'accept_' has been dropped. Always compile and test every patch before
> sending.

Yeah one patch was pushed bit early. Sorry about that. I will take care =
of this now onwards.

I have respined the Patch (v3) after addressing your review comments. =
Build is done in our pipeline.
Build logs: =
https://dev.azure.com/sonicswitch/build/_build/results?buildId=3D1669&view=
=3Dlogs&j=3D011e1ec8-6569-5e69-4f06-baf193d1351e

Thanks a lot again for spending time for this Review,
This feature will help SONiC OS [and others Linux flavors] for better =
IPv6 support, so thanks again.


Praveen=20
https://github.com/praveen-li


