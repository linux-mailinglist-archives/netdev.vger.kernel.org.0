Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC01F51D4
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 18:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730065AbfKHRAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 12:00:20 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58716 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbfKHRAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 12:00:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573232419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h+gZe2wFZESvKJBl48rpO/IUOUeFRtFHturfF7yqPaM=;
        b=XpBywPGtgZVvMnLcu4o1YfoSrrxwQJLyts2+aAQKzlV5eC8INDAsWzefK4neHh2MaB2uBA
        dfBQ5qg5wiUW60nMDtEh0Y2c57KUvCGfwOBgNdK4M4rlwE0CuHy7sLfdNNti6nphiGINGq
        kbM56UPOHqd2B9LCIeI5XKv2yDbanRo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-lkOvEcYwMVKY94xLAzqp2A-1; Fri, 08 Nov 2019 12:00:17 -0500
Received: by mail-wr1-f72.google.com with SMTP id m17so3561556wrn.23
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 09:00:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F9W1Ub+TmPGvMGDsz2Naj2JeXaFxe1Kf/G5aPghYuKc=;
        b=tahHGflda86acP9OIuFgFXDnvXbteLRtz6diK0UArxBb0R3JQ81LbO9VyB0Xkf8Tvn
         yua+0v0aWxHEvje4ZVdPjK2swJzdjUn19PVtNF7S12WPmiQRDiqQ32D1dRalgcl1QCEP
         y0949OF2SGqKDBXoMQGNiwDmJXyA9hisDbS/Mgca3nh8bq+VM4QhSmtS7bInJgqJ7fl8
         8YUXuGgK48aeZLU0Cvuc7wGgiiPW+ljJ0kEDwCZ1aEj18fupdJX5j5C+0TtxP4V6x0cm
         vvd/5BjrEETJBYOzvEUTsnGH7gOx4rMwT+MCBbOr+JB9Jv8yBI3jIaf+lsu/7qootPb/
         kk3g==
X-Gm-Message-State: APjAAAVHJIDxWD38xgQP51AMm9K4rM9UnA2f/vpnlU9mLvfaXS1Vr9Qy
        nnWdHYpDOdNLQL4/5dU1bWI5ovt1VjhMYIlAuOYD6Tv1N+l1VJulbKvJ0AUfWOs0mpXq4tcGQF3
        ukGRepdOdC8vAyB4e
X-Received: by 2002:a05:600c:22c3:: with SMTP id 3mr8801425wmg.139.1573232416392;
        Fri, 08 Nov 2019 09:00:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqz3ZTqYNZLM0l8gp5AnzlTXsrCE/Kw/gftTH/qukJtWr9RDPNDF0CvS0zjYGeVafz3ZqruauQ==
X-Received: by 2002:a05:600c:22c3:: with SMTP id 3mr8801410wmg.139.1573232416230;
        Fri, 08 Nov 2019 09:00:16 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id j10sm985506wrx.30.2019.11.08.09.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 09:00:15 -0800 (PST)
Date:   Fri, 8 Nov 2019 18:00:14 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iproute2-next 2/5] ipnetns: fix misleading comment about 'ip
 monitor nsid'
Message-ID: <c20c62df6c7c66e9cffd4d493752fcd8876fc92f.1573231189.git.gnault@redhat.com>
References: <cover.1573231189.git.gnault@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1573231189.git.gnault@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: lkOvEcYwMVKY94xLAzqp2A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'ip monitor nsid' doesn't call print_nsid().

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 ip/ipnetns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index 0a7912df..b02e0a8a 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -340,7 +340,7 @@ int print_nsid(struct nlmsghdr *n, void *arg)
 =09=09netns_map_del(c);
 =09}
=20
-=09/* During 'ip monitor nsid', no chance to have new nsid in cache. */
+=09/* nsid might not be in cache */
 =09if (c =3D=3D NULL && n->nlmsg_type =3D=3D RTM_NEWNSID)
 =09=09if (netns_get_name(nsid, name) =3D=3D 0) {
 =09=09=09print_string(PRINT_ANY, "name",
--=20
2.21.0

