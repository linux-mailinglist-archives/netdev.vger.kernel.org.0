Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5946CE54D
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 16:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbfJGOcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 10:32:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46561 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727589AbfJGOcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 10:32:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570458765;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T2OuRtTehyGdu5tDLKoiUC7vGh/4x82BWj/yNHznFJY=;
        b=Wxs9BEt5H8fep2EkCH1PVt2MT7Da2Y1lA7jF+C/mg6GwAorsTZ+1DgAP2EYAltTpZBRq7A
        CG54ZH25NmnvYk1xp1fK/hF6ieR7gIBO55L4R1U2sQ3TIKyeBAGlmL/XO6/Znal0CVoQwV
        JddzNNsx3uYEFRc4mXRuM6C9x8aXYsQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-O9gK9qmDNYeRavgC0_Ep5A-1; Mon, 07 Oct 2019 10:32:44 -0400
Received: by mail-wm1-f70.google.com with SMTP id g67so3410749wmg.4
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 07:32:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=vtbJJLtvJi0JrxkCRUbtcK4mGFzAMFdOK2nSBpU6YfE=;
        b=DpE7PgMYHjs0SOnIuIYCpQtNmJgb0+VooFKYeK27Dx9Dq2DN13ruuZHaCDBdE+9kP2
         2BZDaGeOCrXhiVidnhgt7Oj5kyrtVUr8FcvVfR6DMhZf2CPfuTQMW3Wbctf++qo77Luo
         fcoPD/zY0teNitERioUcl6H/rSLU74EMoI/CyLHZFeibg1DNNCtNtNuj2d9P3WNXglDz
         GywdtitKwonm+ozbDF4KcanwNF16h9ZH53RvUSIbwaA8EfseLCxaNQ7OeP+Q4iDZFjKP
         NqRTVVjEvmK5/N0mqX7OB1EPu/sqZfjhhE9ARtWuleaOhjFu2XkdUxZpbC7OJrNorJD2
         VR9g==
X-Gm-Message-State: APjAAAVUGY2GztH69Zq6aDis6JHl7zfq8LffXfr5k7cQRyzUW2USG5I4
        zIVtw4u7w9AHFDbCfkEgXlXJaHmOEdV0bJ3dAZp0WOjELtslr9wqnh3ulQeO9jQEmrZRQX3ALwm
        9JUbmE1ZWfcUprOnv
X-Received: by 2002:a1c:4384:: with SMTP id q126mr22520344wma.153.1570458763139;
        Mon, 07 Oct 2019 07:32:43 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyvSTnKY/96vtBBgyavWwdMXQfduZTOCiqkw6pWLx3iNkByGdnpzq+EVVHeR0gVWB1HrYZGqA==
X-Received: by 2002:a1c:4384:: with SMTP id q126mr22520320wma.153.1570458762780;
        Mon, 07 Oct 2019 07:32:42 -0700 (PDT)
Received: from [10.43.2.48] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id r10sm15157444wml.46.2019.10.07.07.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 07:32:42 -0700 (PDT)
Message-ID: <caf06d0ee97fe234daa3a375a1912dc4bf536f58.camel@redhat.com>
Subject: Re: [PATCH iproute2] ipnetns: enable to dump nsid conversion table
From:   Petr Oros <poros@redhat.com>
Reply-To: poros@redhat.com
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Date:   Mon, 07 Oct 2019 16:32:41 +0200
In-Reply-To: <20191007134447.20077-1-nicolas.dichtel@6wind.com>
References: <20191007134447.20077-1-nicolas.dichtel@6wind.com>
Organization: Red Hat
User-Agent: Evolution 3.30.5
MIME-Version: 1.0
X-MC-Unique: O9gK9qmDNYeRavgC0_Ep5A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nicolas Dichtel p=C3=AD=C5=A1e v Po 07. 10. 2019 v 15:44 +0200:
> This patch enables to dump/get nsid from a netns into another netns.
>=20
> Example:
> $ ./test.sh
> + ip netns add foo
> + ip netns add bar
> + touch /var/run/netns/init_net
> + mount --bind /proc/1/ns/net /var/run/netns/init_net
> + ip netns set init_net 11
> + ip netns set foo 12
> + ip netns set bar 13
> + ip netns
> init_net (id: 11)
> bar (id: 13)
> foo (id: 12)
> + ip -n foo netns set init_net 21
> + ip -n foo netns set foo 22
> + ip -n foo netns set bar 23
> + ip -n foo netns
> init_net (id: 21)
> bar (id: 23)
> foo (id: 22)
> + ip -n bar netns set init_net 31
> + ip -n bar netns set foo 32
> + ip -n bar netns set bar 33
> + ip -n bar netns
> init_net (id: 31)
> bar (id: 33)
> foo (id: 32)
> + ip netns list-id target-nsid 12
> nsid 21 current-nsid 11 (iproute2 netns name: init_net)
> nsid 22 current-nsid 12 (iproute2 netns name: foo)
> nsid 23 current-nsid 13 (iproute2 netns name: bar)
> + ip -n foo netns list-id target-nsid 21
> nsid 11 current-nsid 21 (iproute2 netns name: init_net)
> nsid 12 current-nsid 22 (iproute2 netns name: foo)
> nsid 13 current-nsid 23 (iproute2 netns name: bar)
> + ip -n bar netns list-id target-nsid 33 nsid 32
> nsid 32 current-nsid 32 (iproute2 netns name: foo)
> + ip -n bar netns list-id target-nsid 31 nsid 32
> nsid 12 current-nsid 32 (iproute2 netns name: foo)
> + ip netns list-id nsid 13
> nsid 13 (iproute2 netns name: bar)
>=20
> CC: Petr Oros <poros@redhat.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  include/libnetlink.h |   5 +-
>  ip/ip_common.h       |   1 +
>  ip/ipnetns.c         | 115 +++++++++++++++++++++++++++++++++++++++++--
>  lib/libnetlink.c     |  15 ++++--
>  4 files changed, 126 insertions(+), 10 deletions(-)
>=20
> diff --git a/include/libnetlink.h b/include/libnetlink.h
> index 311cf3fc90f8..8ebdc6d3d03e 100644
> --- a/include/libnetlink.h
> +++ b/include/libnetlink.h
> @@ -71,8 +71,6 @@ int rtnl_mdbdump_req(struct rtnl_handle *rth, int famil=
y)
>  =09__attribute__((warn_unused_result));
>  int rtnl_netconfdump_req(struct rtnl_handle *rth, int family)
>  =09__attribute__((warn_unused_result));
> -int rtnl_nsiddump_req(struct rtnl_handle *rth, int family)
> -=09__attribute__((warn_unused_result));
> =20
>  int rtnl_linkdump_req(struct rtnl_handle *rth, int fam)
>  =09__attribute__((warn_unused_result));
> @@ -85,6 +83,9 @@ int rtnl_linkdump_req_filter_fn(struct rtnl_handle *rth=
, int fam,
>  int rtnl_fdb_linkdump_req_filter_fn(struct rtnl_handle *rth,
>  =09=09=09=09    req_filter_fn_t filter_fn)
>  =09__attribute__((warn_unused_result));
> +int rtnl_nsiddump_req_filter_fn(struct rtnl_handle *rth, int family,
> +=09=09=09=09req_filter_fn_t filter_fn)
> +=09__attribute__((warn_unused_result));
>  int rtnl_statsdump_req_filter(struct rtnl_handle *rth, int fam, __u32 fi=
lt_mask)
>  =09__attribute__((warn_unused_result));
>  int rtnl_dump_request(struct rtnl_handle *rth, int type, void *req,
> diff --git a/ip/ip_common.h b/ip/ip_common.h
> index cd916ec87c26..879287e3e506 100644
> --- a/ip/ip_common.h
> +++ b/ip/ip_common.h
> @@ -24,6 +24,7 @@ struct link_filter {
>  =09int master;
>  =09char *kind;
>  =09char *slave_kind;
> +=09int target_nsid;
>  };
> =20
>  int get_operstate(const char *name);
> diff --git a/ip/ipnetns.c b/ip/ipnetns.c
> index a883f210d7ba..20110ef0f58e 100644
> --- a/ip/ipnetns.c
> +++ b/ip/ipnetns.c
> @@ -36,7 +36,7 @@ static int usage(void)
>  =09=09"=09ip netns pids NAME\n"
>  =09=09"=09ip [-all] netns exec [NAME] cmd ...\n"
>  =09=09"=09ip netns monitor\n"
> -=09=09"=09ip netns list-id\n"
> +=09=09"=09ip netns list-id [target-nsid POSITIVE-INT] [nsid POSITIVE-INT=
]\n"
>  =09=09"NETNSID :=3D auto | POSITIVE-INT\n");
>  =09exit(-1);
>  }
> @@ -46,6 +46,7 @@ static struct rtnl_handle rtnsh =3D { .fd =3D -1 };
> =20
>  static int have_rtnl_getnsid =3D -1;
>  static int saved_netns =3D -1;
> +static struct link_filter filter;
> =20
>  static int ipnetns_accept_msg(struct rtnl_ctrl_data *ctrl,
>  =09=09=09      struct nlmsghdr *n, void *arg)
> @@ -294,7 +295,7 @@ int print_nsid(struct nlmsghdr *n, void *arg)
>  =09FILE *fp =3D (FILE *)arg;
>  =09struct nsid_cache *c;
>  =09char name[NAME_MAX];
> -=09int nsid;
> +=09int nsid, current;
> =20
>  =09if (n->nlmsg_type !=3D RTM_NEWNSID && n->nlmsg_type !=3D RTM_DELNSID)
>  =09=09return 0;
> @@ -317,9 +318,22 @@ int print_nsid(struct nlmsghdr *n, void *arg)
>  =09=09print_bool(PRINT_ANY, "deleted", "Deleted ", true);
> =20
>  =09nsid =3D rta_getattr_u32(tb[NETNSA_NSID]);
> -=09print_uint(PRINT_ANY, "nsid", "nsid %u ", nsid);
> +=09if (nsid < 0)
> +=09=09print_string(PRINT_ANY, "nsid", "nsid %s ", "not-assigned");
> +=09else
> +=09=09print_uint(PRINT_ANY, "nsid", "nsid %u ", nsid);
> +
> +=09if (tb[NETNSA_CURRENT_NSID]) {
> +=09=09current =3D rta_getattr_u32(tb[NETNSA_CURRENT_NSID]);
> +=09=09if (current < 0)
> +=09=09=09print_string(PRINT_ANY, "current-nsid",
> +=09=09=09=09     "current-nsid %s ", "not-assigned");
> +=09=09else
> +=09=09=09print_uint(PRINT_ANY, "current-nsid",
> +=09=09=09=09   "current-nsid %u ", current);
> +=09}
> =20
> -=09c =3D netns_map_get_by_nsid(nsid);
> +=09c =3D netns_map_get_by_nsid(tb[NETNSA_CURRENT_NSID] ? current : nsid)=
;
>  =09if (c !=3D NULL) {
>  =09=09print_string(PRINT_ANY, "name",
>  =09=09=09     "(iproute2 netns name: %s)", c->name);
> @@ -340,15 +354,106 @@ int print_nsid(struct nlmsghdr *n, void *arg)
>  =09return 0;
>  }
> =20
> +static int get_netnsid_from_netnsid(int nsid)
> +{
> +=09struct {
> +=09=09struct nlmsghdr n;
> +=09=09struct rtgenmsg g;
> +=09=09char            buf[1024];
> +=09} req =3D {
> +=09=09.n.nlmsg_len =3D NLMSG_LENGTH(NLMSG_ALIGN(sizeof(struct rtgenmsg))=
),
> +=09=09.n.nlmsg_flags =3D NLM_F_REQUEST,
> +=09=09.n.nlmsg_type =3D RTM_GETNSID,
> +=09=09.g.rtgen_family =3D AF_UNSPEC,
> +=09};
> +=09struct nlmsghdr *answer;
> +=09int err;
> +
> +=09netns_nsid_socket_init();
> +
> +=09err =3D addattr32(&req.n, sizeof(req), NETNSA_NSID, nsid);
> +=09if (err)
> +=09=09return err;
> +
> +=09if (filter.target_nsid >=3D 0) {
> +=09=09err =3D addattr32(&req.n, sizeof(req), NETNSA_TARGET_NSID,
> +=09=09=09=09filter.target_nsid);
> +=09=09if (err)
> +=09=09=09return err;
> +=09}
> +
> +=09if (rtnl_talk(&rtnsh, &req.n, &answer) < 0)
> +=09=09return -2;
> +
> +=09/* Validate message and parse attributes */
> +=09if (answer->nlmsg_type =3D=3D NLMSG_ERROR)
> +=09=09goto err_out;
> +
> +=09new_json_obj(json);
> +=09err =3D print_nsid(answer, stdout);
> +=09delete_json_obj();
> +err_out:
> +=09free(answer);
> +=09return err;
> +}
> +
> +static int netns_filter_req(struct nlmsghdr *nlh, int reqlen)
> +{
> +=09int err;
> +
> +=09if (filter.target_nsid >=3D 0) {
> +=09=09err =3D addattr32(nlh, reqlen, NETNSA_TARGET_NSID,
> +=09=09=09=09filter.target_nsid);
> +=09=09if (err)
> +=09=09=09return err;
> +=09}
> +
> +=09return 0;
> +}
> +
>  static int netns_list_id(int argc, char **argv)
>  {
> +=09int nsid =3D -1;
> +
>  =09if (!ipnetns_have_nsid()) {
>  =09=09fprintf(stderr,
>  =09=09=09"RTM_GETNSID is not supported by the kernel.\n");
>  =09=09return -ENOTSUP;
>  =09}
> =20
> -=09if (rtnl_nsiddump_req(&rth, AF_UNSPEC) < 0) {
> +=09filter.target_nsid =3D -1;
> +=09while (argc > 0) {
> +=09=09if (strcmp(*argv, "target-nsid") =3D=3D 0) {
> +=09=09=09if (filter.target_nsid >=3D 0)
> +=09=09=09=09duparg("target-nsid", *argv);
> +=09=09=09NEXT_ARG();
> +
> +=09=09=09if (get_integer(&filter.target_nsid, *argv, 0))
> +=09=09=09=09invarg("\"target-nsid\" value is invalid\n",
> +=09=09=09=09       *argv);
> +=09=09=09else if (filter.target_nsid < 0)
> +=09=09=09=09invarg("\"target-nsid\" value should be >=3D 0\n",
> +=09=09=09=09       argv[1]);
> +=09=09} else if (strcmp(*argv, "nsid") =3D=3D 0) {
> +=09=09=09if (nsid >=3D 0)
> +=09=09=09=09duparg("nsid", *argv);
> +=09=09=09NEXT_ARG();
> +
> +=09=09=09if (get_integer(&nsid, *argv, 0))
> +=09=09=09=09invarg("\"nsid\" value is invalid\n", *argv);
> +=09=09=09else if (nsid < 0)
> +=09=09=09=09invarg("\"nsid\" value should be >=3D 0\n",
> +=09=09=09=09       argv[1]);
> +=09=09} else
> +=09=09=09usage();
> +=09=09argc--; argv++;
> +=09}
> +
> +=09if (nsid >=3D 0)
> +=09=09return get_netnsid_from_netnsid(nsid);
> +
> +=09if (rtnl_nsiddump_req_filter_fn(&rth, AF_UNSPEC,
> +=09=09=09=09=09netns_filter_req) < 0) {
>  =09=09perror("Cannot send dump request");
>  =09=09exit(1);
>  =09}
> diff --git a/lib/libnetlink.c b/lib/libnetlink.c
> index 8c490f896326..6ce8b199f441 100644
> --- a/lib/libnetlink.c
> +++ b/lib/libnetlink.c
> @@ -438,12 +438,13 @@ int rtnl_netconfdump_req(struct rtnl_handle *rth, i=
nt family)
>  =09return send(rth->fd, &req, sizeof(req), 0);
>  }
> =20
> -int rtnl_nsiddump_req(struct rtnl_handle *rth, int family)
> +int rtnl_nsiddump_req_filter_fn(struct rtnl_handle *rth, int family,
> +=09=09=09=09req_filter_fn_t filter_fn)
>  {
>  =09struct {
>  =09=09struct nlmsghdr nlh;
>  =09=09struct rtgenmsg rtm;
> -=09=09char buf[0] __aligned(NLMSG_ALIGNTO);
> +=09=09char buf[1024];
>  =09} req =3D {
>  =09=09.nlh.nlmsg_len =3D NLMSG_LENGTH(NLMSG_ALIGN(sizeof(struct rtgenmsg=
))),
>  =09=09.nlh.nlmsg_type =3D RTM_GETNSID,
> @@ -451,8 +452,16 @@ int rtnl_nsiddump_req(struct rtnl_handle *rth, int f=
amily)
>  =09=09.nlh.nlmsg_seq =3D rth->dump =3D ++rth->seq,
>  =09=09.rtm.rtgen_family =3D family,
>  =09};
> +=09int err;
> =20
> -=09return send(rth->fd, &req, sizeof(req), 0);
> +=09if (!filter_fn)
> +=09=09return -EINVAL;
> +
> +=09err =3D filter_fn(&req.nlh, sizeof(req));
> +=09if (err)
> +=09=09return err;
> +
> +=09return send(rth->fd, &req, req.nlh.nlmsg_len, 0);
>  }
> =20
>  static int __rtnl_linkdump_req(struct rtnl_handle *rth, int family)

Works great. Thanks, Nicolas.

Tested-by: Petr Oros <poros@redhat.com>


