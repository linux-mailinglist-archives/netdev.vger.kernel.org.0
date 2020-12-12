Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B5B2D874F
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 16:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439278AbgLLPdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 10:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439273AbgLLPdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 10:33:09 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C40C0617A6
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 07:31:56 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id n26so16486631eju.6
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 07:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=iHyYxUrb0BRO8DXNBu/BXjBebWrkB+LbsHZA9LoJK48=;
        b=D6XEAHIug8iYe4lRCjNGZjjOvk6MePTQ6RoQULtDXRBNZwajTKxmMfRFwnMzYKUxK4
         ulPOwf2Nr81qLhJnmfr7ypCWG9aMiqInGCfSFHyD34nBOuod/PImZy2qPxbicQoBJwVc
         wzMdSFw2XBVbT/KCg0q9wVKdrOCGAHnqhz/+jY9lX4YAOepbAhdffp+LE1N5Br4s4DmM
         ixAhWH3uhySEbvee+l014XvZ8BalNN00JdepBDsYhS9KroIopYcvJb4b5z3zQbJIL4bE
         J/ffnsSXt0YLfDcqaHpMFrIk/XqwPnXa00uvYwSx2BokXWOuolLAJHUL0rsF9WIX5EsC
         esyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=iHyYxUrb0BRO8DXNBu/BXjBebWrkB+LbsHZA9LoJK48=;
        b=N8wEX68PuTsjQTKf7hcpQ6L43c2cqlA3Ug87A3iLIHi9mfQqwwZCrm9+FgXmSwXitN
         RUHGipMvQGDlURKXQ/DyUTGczx2kP3WmRUUL/EyxBY2wJHZ01e3vd+ZXt11iPDXpkVv7
         YViVSn8ZbP7DPVG/qM20jEyObCnJzj3K78yKWtbOEonZHHVQMzY6abhn7BnVV2I03X3M
         QY5tRxa1eG/Y/I2qiD5boGBo8K/9s0aIW1fy1Iaw/2eR8C3Qy9An7rTQTLdbEqcrRdOV
         imnxnJMfHY0lm3KL2/T83CETSzV0jUVFuxPKjM3YGMn8a6JJ3UcflxUstOL1Y6MCXi6H
         8jLw==
X-Gm-Message-State: AOAM530OFS7F3i/IvXh9ISxyneuF2vHckxw/JxNXB900QKMd29Ccd1jX
        48zRBoPZkQeFm7UCBsdkugeLbHQEOJ4jZa31BYrnDdjqrRy3bJ5d
X-Google-Smtp-Source: ABdhPJxRCNCXTCUEJyeSKL2oE5mX1UC3MXQoKs6odAnB/5GGCKNF7/QGajbtUQ5I5ZEDYmjgteL1Vh770O4reEEjZHw=
X-Received: by 2002:a17:906:4994:: with SMTP id p20mr15440540eju.391.1607787114894;
 Sat, 12 Dec 2020 07:31:54 -0800 (PST)
MIME-Version: 1.0
From:   Victor Stewart <v@nametag.social>
Date:   Sat, 12 Dec 2020 15:31:44 +0000
Message-ID: <CAM1kxwguzWCReTdiGG6wV8L9MPi51QmOCbHiKS6cHNTrJD=E1Q@mail.gmail.com>
Subject: [PATCH 3/3] add PROTO_CMSG_DATA_ONLY to inet6_dgram_ops
To:     io-uring <io-uring@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Stefan Metzmacher <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add PROTO_CMSG_DATA_ONLY to inet6_dgram_ops

Signed-off by: Victor Stewart <v@nametag.social>
---
net/ipv6/af_inet6.c | 1 +
1 file changed, 1 insertion(+)

diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index e648fbebb167..560f45009d06 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -695,6 +695,7 @@ const struct proto_ops inet6_stream_ops = {

 const struct proto_ops inet6_dgram_ops = {
        .family            = PF_INET6,
+       .flags             = PROTO_CMSG_DATA_ONLY,
        .owner             = THIS_MODULE,
        .release           = inet6_release,
        .bind              = inet6_bind,
