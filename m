Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD1C3DF688
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730293AbfJUUKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:10:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53971 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726672AbfJUUKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:10:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571688629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tIRfkARawuYx5E17weGS9sdJ1VOiUwg/d8BMqTS+xF4=;
        b=iuWukpnhAp5fVoiPpV1ZhizQuaprjNdTX0ggFKuwzBko00BXMW67Q01WxdvcoiCWndl6L+
        uVjqRtq9QRJGNyPm3XzeDlmRQ+sHpk6TrVga1qTErhVKtJRji1Ww3rFQIfUQ6AhE8TOqjP
        FuuMLOJxPBN1msbcS4lc7EOfz4xo5aU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-6Buyy3G_MOCrG4jyuVyEoA-1; Mon, 21 Oct 2019 16:10:27 -0400
Received: by mail-wm1-f72.google.com with SMTP id i23so29707wmb.3
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 13:10:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SMEGf4c6Ma+Bze2+ZiGp43bjN8huF03EIdt6wvA9wXw=;
        b=EzoMQPMGhZ9vQ1ZeM8NFbReM1xyIVUaPeNailtbhXQyMsVrT6/iYc+e7tZiOc8gS9l
         BA6qEar7py4eQKowS9gConjZhU8dhSJUiDjP875jpW0XkQ59M19kvJCX3PX69knUjpL6
         afw5fArSTlJLIXHtzM6UqDoyGCRaNvLC15EPidN/VJ7S6fbwmeKrkyE36VvQWlDWIdxE
         p0a9WlHgUrqVLEono/nBuVi9jhFvRlpjk7OP594qfnQILKYepLHE3njc1KnyS+xUk3vj
         IL0eJAE054OdhGtsHV4jlLdsZMxX4BcUENOcpOrdgt0DtJB0ZYks39kOCkKw1gL6RRrl
         mnIw==
X-Gm-Message-State: APjAAAXvAWd+YskcW4rl+aY2VqpCGesKM7ZEoXUuuSmE9p+45dYGTXSj
        id8/0oCbSNV4JU+Bbm1ZdGaykgx9Gs8weVM1qQYqmdLlZ341KH8IhDfYzxdaib514WT24ch+DOD
        UQHEF0GzD7UX1t4qQ
X-Received: by 2002:a1c:c912:: with SMTP id f18mr8901558wmb.168.1571688626069;
        Mon, 21 Oct 2019 13:10:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx15FjYZFXXvyV63hNCvlR9L6mdwPxb6AMjC6rMphOyiOSYm40k8lVTtPDL8hhtsd7I1xplIA==
X-Received: by 2002:a1c:c912:: with SMTP id f18mr8901544wmb.168.1571688625838;
        Mon, 21 Oct 2019 13:10:25 -0700 (PDT)
Received: from turbo.teknoraver.net (net-109-115-41-234.cust.vodafonedsl.it. [109.115.41.234])
        by smtp.gmail.com with ESMTPSA id l18sm20701933wrn.48.2019.10.21.13.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 13:10:25 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller " <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/4] flow_dissector: add meaningful comments
Date:   Mon, 21 Oct 2019 22:09:45 +0200
Message-Id: <20191021200948.23775-2-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021200948.23775-1-mcroce@redhat.com>
References: <20191021200948.23775-1-mcroce@redhat.com>
MIME-Version: 1.0
X-MC-Unique: 6Buyy3G_MOCrG4jyuVyEoA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documents two piece of code which can't be understood at a glance.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 include/net/flow_dissector.h | 1 +
 net/core/flow_dissector.c    | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 90bd210be060..7747af3cc500 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -282,6 +282,7 @@ struct flow_keys {
 =09struct flow_dissector_key_vlan cvlan;
 =09struct flow_dissector_key_keyid keyid;
 =09struct flow_dissector_key_ports ports;
+=09/* 'addrs' must be the last member */
 =09struct flow_dissector_key_addrs addrs;
 };
=20
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 7c09d87d3269..affde70dad47 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1374,6 +1374,9 @@ static inline size_t flow_keys_hash_length(const stru=
ct flow_keys *flow)
 {
 =09size_t diff =3D FLOW_KEYS_HASH_OFFSET + sizeof(flow->addrs);
 =09BUILD_BUG_ON((sizeof(*flow) - FLOW_KEYS_HASH_OFFSET) % sizeof(u32));
+=09/* flow.addrs MUST be the last member in struct flow_keys because
+=09 * different L3 protocols have different address length
+=09 */
 =09BUILD_BUG_ON(offsetof(typeof(*flow), addrs) !=3D
 =09=09     sizeof(*flow) - sizeof(flow->addrs));
=20
@@ -1421,6 +1424,9 @@ __be32 flow_get_u32_dst(const struct flow_keys *flow)
 }
 EXPORT_SYMBOL(flow_get_u32_dst);
=20
+/* Sort the source and destination IP (and the ports if the IP are the sam=
e),
+ * to have consistent hash within the two directions
+ */
 static inline void __flow_hash_consistentify(struct flow_keys *keys)
 {
 =09int addr_diff, i;
--=20
2.21.0

