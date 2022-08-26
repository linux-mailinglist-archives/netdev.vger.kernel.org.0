Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4B15A2D29
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 19:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344852AbiHZRPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 13:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344911AbiHZRPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 13:15:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475F7459A3;
        Fri, 26 Aug 2022 10:15:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A3B6821BC9;
        Fri, 26 Aug 2022 17:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661534131; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ujnem+82jghAPynX8D89kMmJ0aBREjhSFJXo32+xYis=;
        b=D+mtfhJ2z4xrDBSNcnA4TFx+/P44V+D+ZE5amHfKim/P5TlSVXi301DlnwO+/YhaB2ZXcs
        1Y0vqyxwh/ULCExOilHOj8dTxoVzWOcxNxTqMpnHlDg3Sub36rAXeHC4bPkKDu/0U5QlFi
        Z/vzm0/agm7LOHVNfvT7HVOPhhzrNiU=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 357E013A7E;
        Fri, 26 Aug 2022 17:15:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qdA1DLP/CGMaBQAAMHmgww
        (envelope-from <mkoutny@suse.com>); Fri, 26 Aug 2022 17:15:31 +0000
Date:   Fri, 26 Aug 2022 19:15:29 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Hao Luo <haoluo@google.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH bpf-next v9 1/5] bpf: Introduce cgroup iter
Message-ID: <20220826171529.GB30475@blackbody.suse.cz>
References: <20220824030031.1013441-1-haoluo@google.com>
 <20220824030031.1013441-2-haoluo@google.com>
 <20220825152455.GA29058@blackbody.suse.cz>
 <CA+khW7hKk8yMvsQCQjnEoR3=G9=77F2TgAEDa+uSVedoOE=NsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uZ3hkaAS1mZxFaxD"
Content-Disposition: inline
In-Reply-To: <CA+khW7hKk8yMvsQCQjnEoR3=G9=77F2TgAEDa+uSVedoOE=NsA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 25, 2022 at 10:58:26AM -0700, Hao Luo <haoluo@google.com> wrote:
> Permission is a valid point about FD. There was discussion in an
> earlier version of this patch series [0].

(I'm sorry, I didn't follow all the version discussions closely.)

I think the permissions are a non-issue when unprivileged BPF is
disabled. If it's allowed, I think it'd be better solved generally
within the BPF iterator framework. (Maybe it's already present, I didn't
check.)

(OT:
> The good thing about ID is that it can be passed across processes=20

FDs can be passed too (parent-child trivially, others via SCM_RIGHTS
message).

> and it's meaningful to appear in logs. It's more user-friendly.

I'd say cgroup path wins both in meaning and user friendliness.
(Or maybe you meant different class of users.)
)

> So we decided to support both.

I accept cgroup ids are an establish{ing,ed} way to refer to cgroups
=66rom userspace. Hence my fixups for the BPF cgroup iter (another thread)
for better namespacing consisntency.

Thanks,
Michal

--uZ3hkaAS1mZxFaxD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYwj/rgAKCRAkDQmsBEOq
uRDtAP95KSUf5eIbnMtX+q0mP/oOLO5HxrPBR3LcuKDvtCX16gEA1qMMMrMNNSRI
PnRFq9cTUofRflCF69bLsiCRXGQYSQk=
=zlex
-----END PGP SIGNATURE-----

--uZ3hkaAS1mZxFaxD--
