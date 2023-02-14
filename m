Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24736957BE
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 05:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbjBNELi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 23:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjBNELf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 23:11:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5032B17CE4;
        Mon, 13 Feb 2023 20:11:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E18656137F;
        Tue, 14 Feb 2023 04:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF508C433D2;
        Tue, 14 Feb 2023 04:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676347893;
        bh=llJZR7pK98/emAvHoO6xCRuI8lj7T3XJRXFwIvfYO9Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W0QU6Meho9pQJ8b8exCiXRy6k20TLCCCZOT3xwU1SC/WBE2Dy8+ZNJz0EG0w3FvAr
         d/p71BdHJBcsl+V14RK0zxshK4SNWDjPM7SnA2C5c7XfFWOe5hKeoWyd8Qzua+Ui9+
         1fGH1WVRkOZ1K5uPR9fXyUBI9D4zyU+goEdGC35VYv52KT+kYNCklVav6JpVGsJUXU
         c6Xj0nd9/yqVgkkVgODVfcj0SGBwPOosODiy9rMM4VMdQRHfQJbvQIhcOClxfkpOY3
         ACkguakfAMrFsgqo+ijiyNbCHl9bLMVbMovPnaIH7oooT9VUaciW/dX4zL57aTeP1o
         iE82zjFxCJWng==
Date:   Mon, 13 Feb 2023 20:11:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas =?UTF-8?B?V2Vpw59zY2h1aA==?= <linux@weissschuh.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 0/3] net: make kobj_type structures constant
Message-ID: <20230213201131.7ed238f9@kernel.org>
In-Reply-To: <20230211-kobj_type-net-v1-0-e3bdaa5d8a78@weissschuh.net>
References: <20230211-kobj_type-net-v1-0-e3bdaa5d8a78@weissschuh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Feb 2023 03:32:28 +0000 Thomas Wei=C3=9Fschuh wrote:
> Since commit ee6d3dd4ed48 ("driver core: make kobj_type constant.")
> the driver core allows the usage of const struct kobj_type.
>=20
> Take advantage of this to constify the structure definitions to prevent
> modification at runtime.

Could you resend just the first two with [PATCH net-next] in the
subject? Patch 3 needs to go to a different tree.
