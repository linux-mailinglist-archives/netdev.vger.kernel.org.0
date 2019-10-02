Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64010C93A3
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfJBVtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:49:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43209 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726069AbfJBVtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 17:49:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570052959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6hrbSzRsq3ds3VXbb+ea03n+mD5K/aT75kBKzIeL8jA=;
        b=Vvysx/OSRZLZpTVgxIGUCQBOEfVyg0fZNSjPQSrk8cH+/31VqcJ9GaUCPnEz0vUrBfIPmt
        oPVEB8CnEGcJBIt5fkfjF+RQral3Wpva3GITUFR60ztZX3O7qFUp8M90Ha9YqQ8cZaHise
        au0m+1k1Ay129kk3c6SL20f1JeKS5sE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-kSMyp-HhNE6iqoMwrW0xCw-1; Wed, 02 Oct 2019 17:49:18 -0400
Received: by mail-wr1-f71.google.com with SMTP id q8so144921wrp.8
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 14:49:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l3Nxu/xtXSQjos9JiDu4uBaxvkGFvYrw3zPm6tflCvQ=;
        b=RLA2xw7VyCPKthkT/1nECNFij6DMcHCarOgRG6MrK2WVmGTZgPeKRfHyeHgoy5wT6f
         7NFBj42cGyyXo97lE4wqFAO1gMgG9qgHRvQNHMQXMVloiW8UU+70MoEm7KPAxFVs51ZZ
         FQGI6FQiuGveVHU700m8CVAI/4NGKgBip5ADFidL97lpW4F1DlGuGXX8aUXOg9rxeyxG
         1xbBUNJyDamOpOWLRRWQ8FWxGrA1go6q+mTaNPpijky9N1n8E3VYFtLvo42APLjhIUi3
         PCeqNViWg/392yA64HCRolWtf1mjNq90gg4vPuRjj2ul05IKatdGiqNuQuahpFLl+drL
         HZQQ==
X-Gm-Message-State: APjAAAUZlce1TD936ggijOCZnN5sQmd3aTLTA0CAr3Jf0vyRL91Tc5Ch
        YCvAr4Vk1eqUYae4hzcbQq3OK4eAU9msOXFaVpFyO4okR2pD8B4kHIkw34//5lnLueXwSm3Tt+p
        tKD/OhxHHg6emftkq
X-Received: by 2002:a5d:5381:: with SMTP id d1mr4344234wrv.315.1570052956908;
        Wed, 02 Oct 2019 14:49:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwcda7tsHRm1GWdgqm+B0tMOadsyXb2f93B2ypRL7Ehj9AtMyoWBctUTBe8ehgAUne8St50sw==
X-Received: by 2002:a5d:5381:: with SMTP id d1mr4344222wrv.315.1570052956685;
        Wed, 02 Oct 2019 14:49:16 -0700 (PDT)
Received: from raver.teknoraver.net (net-93-70-69-208.cust.vodafonedsl.it. [93.70.69.208])
        by smtp.gmail.com with ESMTPSA id q66sm965836wme.39.2019.10.02.14.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 14:49:16 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] mvpp2: remove misleading comment
Date:   Wed,  2 Oct 2019 23:49:04 +0200
Message-Id: <20191002214904.10887-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-MC-Unique: kSMyp-HhNE6iqoMwrW0xCw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recycling in mvpp2 has gone long time ago, but two comment still refers
to it. Remove those two misleading comments as they generate confusion.

Fixes: 7ef7e1d949cd ("net: mvpp2: drop useless fields in mvpp2_bm_pool and =
related code")
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/=
ethernet/marvell/mvpp2/mvpp2_main.c
index 111b3b8239e1..5fea65256b9d 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2863,7 +2863,7 @@ static void mvpp2_rx_csum(struct mvpp2_port *port, u3=
2 status,
 =09skb->ip_summed =3D CHECKSUM_NONE;
 }
=20
-/* Reuse skb if possible, or allocate a new skb and add it to BM pool */
+/* Allocate a new skb and add it to BM pool */
 static int mvpp2_rx_refill(struct mvpp2_port *port,
 =09=09=09   struct mvpp2_bm_pool *bm_pool, int pool)
 {
@@ -2871,7 +2871,6 @@ static int mvpp2_rx_refill(struct mvpp2_port *port,
 =09phys_addr_t phys_addr;
 =09void *buf;
=20
-=09/* No recycle or too many buffers are in use, so allocate a new skb */
 =09buf =3D mvpp2_buf_alloc(port, bm_pool, &dma_addr, &phys_addr,
 =09=09=09      GFP_ATOMIC);
 =09if (!buf)
--=20
2.21.0

