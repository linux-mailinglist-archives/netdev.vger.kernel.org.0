Return-Path: <netdev+bounces-8529-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18780724770
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:17:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8149280FA1
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E35A2DBAB;
	Tue,  6 Jun 2023 15:17:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBDE21068
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:17:48 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4F412D
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:17:46 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-569ca440bf0so27074227b3.3
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 08:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686064666; x=1688656666;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Waj5H85VW8ZKku//czny53S8ylfv++rK110jjAHNbM0=;
        b=gvPzw3bqF0EYtqkjkkX04sqSdf2ytbL33muNeRkgKMo9XiwY9e3eRwYm/vV3Z32SPJ
         cdjn7u3JfSuRq7DLIkJlSDBD30RzVQvglXsrVrI1ZFHRE6lRUegzP2UKakG4SW5SG55H
         Jzv/OBNp4youw7r9nDXPeA+gmPMOQVfsP2F3qa0K5l4R0BjtTZ05YyzFtdYjE/Zu29NG
         2dgQ3Uk4k9M1a8gpOaE66qt7k37UAO2+bU9OKM7Ozno+3EO9WBp+1K/w8Y6N8OWsQQ2y
         GU9DJnLQISOEConiQ99UXI9fIJzaL9l/IVsk/oRco+a2TsDsQKwAVF3ULP/4ll58TDG/
         tY8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686064666; x=1688656666;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Waj5H85VW8ZKku//czny53S8ylfv++rK110jjAHNbM0=;
        b=Vt/p0nRm5PZo/oDpXsqXhOpeXLZo1r3FP8XFfkXwvWiD6iZR5ibUI6yQu4kJjpncPP
         sFNdZqMx5tx4Iuu4eXI7TImXxmxviHbm+gTWjijrzqA3paP9rI1QBmtj1oAI0RE4b7Qt
         IA2+pfnCiuppRTbqX+k58KU6xCp9KEVdCZweNKUnGytjxwvNd+g+Ffj/ESNKL9+3ouWZ
         TjvegTtDnvS8mYZIuFXAYwrx/PUwnQDqQ5MvDuuL0SkKA2lS6HVCj147oL18oOT+c2Ec
         AG1b7YWOqZRp/ibxn/Gw+RyfXGv+IBjRP9vRYH4/1opapTIEmwQpuD0BQDX82WH2TOXB
         cmmA==
X-Gm-Message-State: AC+VfDzZcxqcHMoFZXFI49EuWQ8FBdUY5vNIKK8NsyV+uIHxFQhtL8qW
	VVryXL/0sxgcgamtXrPdxAMu1+Ef6Ac=
X-Google-Smtp-Source: ACHHUZ65oZfNvD5OIZcrGgn7+q21E2tWkqrD7GNNhnhhQCJnsHhIdV5NPz8Y7gQwekAfZAmdNRfiEG5QN/8=
X-Received: from sport.zrh.corp.google.com ([2a00:79e0:9d:4:aaaa:382a:f99c:6155])
 (user=gnoack job=sendgmr) by 2002:a05:6902:100c:b0:bb1:35e6:6c4 with SMTP id
 w12-20020a056902100c00b00bb135e606c4mr844423ybt.9.1686064666133; Tue, 06 Jun
 2023 08:17:46 -0700 (PDT)
Date: Tue, 6 Jun 2023 17:17:43 +0200
In-Reply-To: <20230515161339.631577-12-konstantin.meskhidze@huawei.com>
Message-Id: <ZH9OFyWZ1njI7VG9@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com> <20230515161339.631577-12-konstantin.meskhidze@huawei.com>
Subject: Re: [PATCH v11 11/12] samples/landlock: Add network demo
From: "=?iso-8859-1?Q?G=FCnther?= Noack" <gnoack@google.com>
To: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, 
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Konstantin!

Apologies if some of this was discussed before, in this case,
Micka=C3=ABl's review overrules my opinions from the sidelines ;)

On Tue, May 16, 2023 at 12:13:38AM +0800, Konstantin Meskhidze wrote:
> This commit adds network demo. It's possible to allow a sandboxer to
> bind/connect to a list of particular ports restricting network
> actions to the rest of ports.
>=20
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>


> diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
> index e2056c8b902c..b0250edb6ccb 100644
> --- a/samples/landlock/sandboxer.c
> +++ b/samples/landlock/sandboxer.c

...

> +static int populate_ruleset_net(const char *const env_var, const int rul=
eset_fd,
> +				const __u64 allowed_access)
> +{
> +	int num_ports, i, ret =3D 1;

I thought the convention was normally to set ret =3D 0 initially and to
override it in case of error, rather than the other way around?

> +	char *env_port_name;
> +	struct landlock_net_service_attr net_service =3D {
> +		.allowed_access =3D allowed_access,
> +		.port =3D 0,
> +	};
> +
> +	env_port_name =3D getenv(env_var);
> +	if (!env_port_name)
> +		return 0;
> +	env_port_name =3D strdup(env_port_name);
> +	unsetenv(env_var);
> +	num_ports =3D parse_port_num(env_port_name);
> +
> +	if (num_ports =3D=3D 1 && (strtok(env_port_name, ENV_PATH_TOKEN) =3D=3D=
 NULL)) {
> +		ret =3D 0;
> +		goto out_free_name;
> +	}

I don't understand why parse_port_num and strtok are necessary in this
program. The man-page for strsep(3) describes it as a replacement to
strtok(3) (in the HISTORY section), and it has a very short example
for how it is used.

Wouldn't it work like this as well?

while ((strport =3D strsep(&env_port_name, ":"))) {
  net_service.port =3D atoi(strport);
  /* etc */
}

> +
> +	for (i =3D 0; i < num_ports; i++) {
> +		net_service.port =3D atoi(strsep(&env_port_name, ENV_PATH_TOKEN));

Naming of ENV_PATH_TOKEN:
This usage is not related to paths, maybe rename the variable?
It's also technically not the token, but the delimiter.

> +		if (landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +				      &net_service, 0)) {
> +			fprintf(stderr,
> +				"Failed to update the ruleset with port \"%lld\": %s\n",
> +				net_service.port, strerror(errno));
> +			goto out_free_name;
> +		}
> +	}
> +	ret =3D 0;
> +
> +out_free_name:
> +	free(env_port_name);
> +	return ret;
> +}


>  		fprintf(stderr,
>  			"Launch a command in a restricted environment.\n\n");
> -		fprintf(stderr, "Environment variables containing paths, "
> -				"each separated by a colon:\n");
> +		fprintf(stderr,
> +			"Environment variables containing paths and ports "
> +			"each separated by a colon:\n");
>  		fprintf(stderr,
>  			"* %s: list of paths allowed to be used in a read-only way.\n",
>  			ENV_FS_RO_NAME);
>  		fprintf(stderr,
> -			"* %s: list of paths allowed to be used in a read-write way.\n",
> +			"* %s: list of paths allowed to be used in a read-write way.\n\n",
>  			ENV_FS_RW_NAME);
> +		fprintf(stderr,
> +			"Environment variables containing ports are optional "
> +			"and could be skipped.\n");

As it is, I believe the program does something different when I'm
setting these to the empty string (ENV_TCP_BIND_NAME=3D""), compared to
when I'm unsetting them?

I think the case where we want to forbid all handle-able networking is
a legit and very common use case - it could be clearer in the
documentation how this is done with the tool. (And maybe the interface
could be something more explicit than setting the environment variable
to empty?)


> +	/* Removes bind access attribute if not supported by a user. */
> +	env_port_name =3D getenv(ENV_TCP_BIND_NAME);
> +	if (!env_port_name) {
> +		ruleset_attr.handled_access_net &=3D
> +			~LANDLOCK_ACCESS_NET_BIND_TCP;
> +	}
> +	/* Removes connect access attribute if not supported by a user. */
> +	env_port_name =3D getenv(ENV_TCP_CONNECT_NAME);
> +	if (!env_port_name) {
> +		ruleset_attr.handled_access_net &=3D
> +			~LANDLOCK_ACCESS_NET_CONNECT_TCP;
> +	}

This is the code where the program does not restrict network usage,
if the corresponding environment variable is not set.

It's slightly inconsistent with what this tool does for filesystem
paths. - If you don't specify any file paths, it will still restrict
file operations there, independent of whether that env variable was
set or not.  (Apologies if it was discussed before.)

=E2=80=94G=C3=BCnther

--=20
Sent using Mutt =F0=9F=90=95 Woof Woof

