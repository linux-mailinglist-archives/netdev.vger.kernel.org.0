Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB8715AE97A
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 15:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbiIFN0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 09:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbiIFN0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 09:26:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD33074B82
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 06:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662470801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cG+EMJYQC9dpJwtmnpabIGTtF9jjQR1GUpVCWiATrrQ=;
        b=UfzM0b77jXZLuuWQfcjkRELCCEy1+psLLv1G2btwuJ2QQe82zSOHU7FbiQsBL/yGWLURHf
        jsyj4E3MOSJaF/nUrZOarK0KwnqZeCdIhMc2Y03RdQeod81IFnI6bJYPrDVYj0phgqfWKz
        uHnOuTVU0v+/1zvEoBFdk0Xu2yukI5A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-kAuUCntzO02DdqDuwRNM8A-1; Tue, 06 Sep 2022 09:26:37 -0400
X-MC-Unique: kAuUCntzO02DdqDuwRNM8A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 907501C006AA;
        Tue,  6 Sep 2022 13:26:35 +0000 (UTC)
Received: from localhost (unknown [10.39.193.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0EAEC2026D4C;
        Tue,  6 Sep 2022 13:26:34 +0000 (UTC)
Date:   Tue, 6 Sep 2022 09:26:33 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@gmail.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH 0/6] virtio/vsock: introduce dgrams, sk_buff, and qdisc
Message-ID: <YxdKiUzlfpHs3h3q@fedora>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ffA3zeJuYjNdcnmP"
Content-Disposition: inline
In-Reply-To: <cover.1660362668.git.bobby.eshleman@bytedance.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ffA3zeJuYjNdcnmP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Bobby,
If you are attending Linux Foundation conferences in Dublin, Ireland
next week (Linux Plumbers Conference, Open Source Summit Europe, KVM
Forum, ContainerCon Europe, CloudOpen Europe, etc) then you could meet
Stefano Garzarella and others to discuss this patch series.

Using netdev and sk_buff is a big change to vsock. Discussing your
requirements and the future direction of vsock in person could help.

If you won't be in Dublin, don't worry. You can schedule a video call if
you feel it would be helpful to discuss these topics.

Stefan

--ffA3zeJuYjNdcnmP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmMXSogACgkQnKSrs4Gr
c8iC8wf/WGQyOwxcifRrsvIy43xkZiginzOzlIJEAkBPO1lbTUzCLMkjeiaOgOkO
7VOexEKxi3S67NVq1vUyAzKPB6HFERheGtQOQtkhrmKDKfhVH14zU6t/bHSVeoAe
UfM2UaaO4nF/XRVuO6g6sKsVAqVFWQxpdBjVrsg4B4v8k/1q7W/tiAy//WJHCZc9
6dJCJ+qoPxICjfqc0bw56xbERbh0TG+xneBkGVjp7nLLq/NG/tV7LoIb7xs3EXxq
wB/WYW+bZBtO378tl7SxMksYKv1DFPuYjU52vuUw2X0bz6jgoFn3/rB5ndoHg/o0
D8YtdthVM/GJqXQtJAhIIqbPdUV7Dg==
=DJmj
-----END PGP SIGNATURE-----

--ffA3zeJuYjNdcnmP--

