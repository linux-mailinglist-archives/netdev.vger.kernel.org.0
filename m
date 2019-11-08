Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B075F51DB
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 18:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbfKHRAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 12:00:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46750 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726819AbfKHRAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 12:00:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573232429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n/6+UyZlF4TyeEnNIyN82rQsyWZEE8yQgrnfKdOn+Z8=;
        b=JD25KXevB1mBPcMxWO0FXeCGr/X9mugAC+ttmOgzxNGNhON71fBId4cGP/f+acLnwIJklJ
        iFfCPbhVoZXXTSNrEFc5uvhnm5FiuXePxSXuOjPDSi/ZQFx+m0V2XKg1Tal67p5RLyBZ6V
        YOmsOMbi+HhXd78KSsrcV1jLy8CL+1o=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-jRHI6aP_PmWMpWW7uS9Hgg-1; Fri, 08 Nov 2019 12:00:24 -0500
Received: by mail-wr1-f70.google.com with SMTP id q6so119608wrv.11
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 09:00:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bWk0xE7owDpet8m7u9r1HEdfidzmdlltjQwawzuH6fQ=;
        b=LDtds43mM4A6vZUdAn05qBurMBA9WSXH7FwEpm6cpSZ7iDl/MeSkjm9ll1RwTDuKOQ
         2pXDxzIVwhvpxBsX2YWJzSIPfv82VEwuE+z18GGB9QxIfp8N8A6bowoOolvdN4aB7LwO
         I5WyxetI4zhY7Jy8PrMOKt8TOdXAJ0DozAiMP3tWz8w45P/yvOWofWoqJaHou+SCo/OR
         GXycbVR3tIjy5o/U751T6QRgXX4lQiErHx2mHNdGuqBb/ZqbGlGyRs/2FshcLeKLm1Dh
         VCR1IkOkt5rDq4fRJ0qe033a26PeNyqypsryoAtDualZSXAsYNvYrrwLAaoNbY8IOX0i
         YLZA==
X-Gm-Message-State: APjAAAXfNndMFAsxsmILW3f4oJbOzp0FRyiOwpP4wyxSiPq7yThYim/S
        xWUqkkREj5J1Ie1sv0lpjl6TWRQTtPhpNQfbziW5QG2mip7VHzn12TxBqe8ESsrTMLMNQoZRsos
        J3Ho535zIG0GyHdm3
X-Received: by 2002:a1c:4c10:: with SMTP id z16mr8489364wmf.24.1573232422708;
        Fri, 08 Nov 2019 09:00:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqwtRm+cS/UhlN3BBBwJUlIrBT7kp0q1wiHT+zuIR9yZ67qhdzMpQsFsxBZaPwbtb0Q6dUObwA==
X-Received: by 2002:a1c:4c10:: with SMTP id z16mr8489347wmf.24.1573232422537;
        Fri, 08 Nov 2019 09:00:22 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id 11sm7717154wmb.34.2019.11.08.09.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 09:00:22 -0800 (PST)
Date:   Fri, 8 Nov 2019 18:00:20 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iproute2-next 5/5] ipnetns: remove blank lines printed by
 invarg() messages
Message-ID: <b5f703efe94f691bd52391aefdf2db63182752cb.1573231189.git.gnault@redhat.com>
References: <cover.1573231189.git.gnault@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1573231189.git.gnault@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: jRHI6aP_PmWMpWW7uS9Hgg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since invarg() automatically adds a '\n' character, having one in the
error message generates an extra blank line.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 ip/ipnetns.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index 4eb4a09a..b22e5d62 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -439,10 +439,10 @@ static int netns_list_id(int argc, char **argv)
 =09=09=09NEXT_ARG();
=20
 =09=09=09if (get_integer(&filter.target_nsid, *argv, 0))
-=09=09=09=09invarg("\"target-nsid\" value is invalid\n",
+=09=09=09=09invarg("\"target-nsid\" value is invalid",
 =09=09=09=09       *argv);
 =09=09=09else if (filter.target_nsid < 0)
-=09=09=09=09invarg("\"target-nsid\" value should be >=3D 0\n",
+=09=09=09=09invarg("\"target-nsid\" value should be >=3D 0",
 =09=09=09=09       argv[1]);
 =09=09} else if (strcmp(*argv, "nsid") =3D=3D 0) {
 =09=09=09if (nsid >=3D 0)
@@ -450,9 +450,9 @@ static int netns_list_id(int argc, char **argv)
 =09=09=09NEXT_ARG();
=20
 =09=09=09if (get_integer(&nsid, *argv, 0))
-=09=09=09=09invarg("\"nsid\" value is invalid\n", *argv);
+=09=09=09=09invarg("\"nsid\" value is invalid", *argv);
 =09=09=09else if (nsid < 0)
-=09=09=09=09invarg("\"nsid\" value should be >=3D 0\n",
+=09=09=09=09invarg("\"nsid\" value should be >=3D 0",
 =09=09=09=09       argv[1]);
 =09=09} else
 =09=09=09usage();
@@ -932,9 +932,9 @@ static int netns_set(int argc, char **argv)
 =09if (strcmp(argv[1], "auto") =3D=3D 0)
 =09=09nsid =3D -1;
 =09else if (get_integer(&nsid, argv[1], 0))
-=09=09invarg("Invalid \"netnsid\" value\n", argv[1]);
+=09=09invarg("Invalid \"netnsid\" value", argv[1]);
 =09else if (nsid < 0)
-=09=09invarg("\"netnsid\" value should be >=3D 0\n", argv[1]);
+=09=09invarg("\"netnsid\" value should be >=3D 0", argv[1]);
=20
 =09snprintf(netns_path, sizeof(netns_path), "%s/%s", NETNS_RUN_DIR, name);
 =09netns =3D open(netns_path, O_RDONLY | O_CLOEXEC);
--=20
2.21.0

