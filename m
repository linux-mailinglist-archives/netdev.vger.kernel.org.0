Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5764B5A2CFA
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 18:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344846AbiHZQ6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 12:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344848AbiHZQ6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 12:58:06 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B73BD175;
        Fri, 26 Aug 2022 09:58:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6CC261F948;
        Fri, 26 Aug 2022 16:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661533081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HS6suzfimgcX49bwowySd7vxBltKHbEMB2e3PjKhmGc=;
        b=bBddGvKpe0UmGgiX8JfudWgFaahhSoOCRX6du44L21ceY7MHbTmViYLYoE+qg7oVuzwHP1
        HlsCzJVHQG4VZenGr9Oy4eIszlc5mhTuTAXGi5Owkrv89VKeU7g3GvzuGmW5MI3TPCrarA
        4UEaMwg/izOd061mpJpRyjI0S500beo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E66D213A7E;
        Fri, 26 Aug 2022 16:58:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id es2gNpj7CGPifQAAMHmgww
        (envelope-from <mkoutny@suse.com>); Fri, 26 Aug 2022 16:58:00 +0000
Date:   Fri, 26 Aug 2022 18:57:59 +0200
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
Message-ID: <20220826165759.GA30475@blackbody.suse.cz>
References: <20220824030031.1013441-1-haoluo@google.com>
 <20220824030031.1013441-2-haoluo@google.com>
 <20220825152455.GA29058@blackbody.suse.cz>
 <CA+khW7hdciswrjhY19uQu0rAurWXbfb4xuOYEZqXETu954=-sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <CA+khW7hdciswrjhY19uQu0rAurWXbfb4xuOYEZqXETu954=-sA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 25, 2022 at 11:56:11AM -0700, Hao Luo <haoluo@google.com> wrote:
> Michal, this patch series has merged. Do you need me to send your
> patch on your behalf, or you want to do it yourself?

I added some more fixups. Continuation at [1].

Thanks,
Michal

[1] https://lore.kernel.org/r/20220826165238.30915-1-mkoutny@suse.com/


--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYwj7kAAKCRAkDQmsBEOq
uTtEAP994SXoW7qIIWHKut58dTNgXsZ5qIYJ4bcHfCZDi2Vl0gD/U717nbJsE694
Hwve+ftlMVPjFoarSc3ohEgcwawK3gs=
=w1mO
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
