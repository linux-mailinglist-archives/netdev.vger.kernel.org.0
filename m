Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78566543F3D
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 00:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236635AbiFHWhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 18:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234574AbiFHWhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 18:37:33 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5525A23F887;
        Wed,  8 Jun 2022 15:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1654727830;
        bh=6UcI+eHcxXsjfyDUhrglMMSQWDVdg3SyxvdHwQBpES0=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=VL2nl8Zk1TeimCboWYa0kHvwhrF264awD8AUAUKR3r/sHr/4LA2yU7X1ZiUesn6BB
         BuGvni/P8v2Ialm3RzhMM+yicfA4z4wLkC1TWv5xaGYbbdPfFQdJlayn8g7uUcZBea
         iRwloFN01MPpfyy3iBGA2iP2bBy8jtosrjjxM2YU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from zweiundvierzig.fritz.box ([217.239.16.253]) by mail.gmx.net
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MRmfo-1oAfAy0BoY-00TDFV; Thu, 09 Jun 2022 00:37:10 +0200
From:   Jonas Lindner <jolindner@gmx.de>
To:     paul@paul-moore.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org
Cc:     trivial@kernel.org, Jonas Lindner <jolindner@gmx.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
        selinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] selinux: fix typos in comments
Date:   Thu,  9 Jun 2022 00:36:16 +0200
Message-Id: <20220608223619.2287162-1-jolindner@gmx.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:E+DvfH46gyv8+k9caVZG/w/zdElgiIB/JC/XVRJZakZ/NLVeFjv
 G+ha2gL0vRrLCftm/OC1EvjzNCWqa7IAwgQgkE8sdNTN5nqY7k7edaOsYdMybtawxiMNCpz
 qcRUTypUBq6Kx2P7iPg5j0fy7Xd6ZGm0TPEcBQje9cWg5QBppeAojuJbQy2F24XtJPn0XHi
 BUYUVFUbLpt8POUyiUDjQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:mqIas/Cr+H8=:7a1wAZKwOkfYZYBqT31v63
 NveO4N/ZKZcq4RtTdBQ5uJDsQEq6s6SM0Z29D2k9vcjB5BljfOmTW94/LzkbFoRXgxC2nnSZs
 UJdhTGqrsgjGItXB6AWokO0ED0YpqrUSGpyReKbPjSSe5DbiOOwVQQsskgnRIKQnRn1ZTX4NE
 j9387e8zMk8Y2ExOiLNnwI6CI2zpXgJB15qkLlY/+oMYd5BLdHhvsvNHL62V/SdZmhiAahZit
 hx2HQXJTkryJtLGMQqYMle2doR9nyApX2klNVp0SICHYB/YYKBGDCyYdbdrhZuaqTOcmuAiFH
 gy/yQrGjs1Wh3NewD+a8xoWomlTw5NlYhGmneVsBufnVdaeZo6JVoPMnxR8XzdkyUKRHgSwwd
 g84t9FFapl2M22enE6isL/gUhTtG/Ry3LRylGEsNzQrP1NHJ5ieae36UVVEd+dhJxU4nc03Yc
 7frq8Z/VXJtCrZJBPhah5MQqAm+crR3MJzK8Yz/7KSdvm3pUalwgmkWh515muL9PDpH68j1hO
 Zy6/yqunqlS3qviWFJrGF67Bft+9A/6j+xOLpw2e3z5PIWXKPYw5azgDF3pIPldae4dWcPuql
 tgZjwAmkO/vopuS6z//l480iuWFDZeqVH0vJu7ihedznnOq0o9T2olP6U4vX2+CK+7opGEPLA
 3g6mc9u/4Fc0daoKEe5feLTCLMjaL/pULSawHbbwhWNqQCULloEdmxYJeTQshdgtk4ZCSHubO
 ug2E8XdJhFGwLy5kBz78nY3VejeLS7HrGv4EUHjWnhxgmq9yrB/aakeuSy6Y6ycH/T54ZHwfb
 QDlQYgmSEntQcm1/6gXHo5DD2aIDeNHrSzyBQT1kmdA3uQdU1Emqcwr/t3NDEvYDESqUGgiY1
 y7wug+71EQs4BRtUapsEma/YczUpZN6iOvvumpeb1HK/cXNSnfPA19iWw5Qpsqqi2lZvFJc38
 xEGPGMcX5EMLlfD8fTeWs5McfPj6xsE1gNa4beoOTo0mIoRUkW4yST8Nx62a44nPvo54TR1wV
 voEBkVHft8tof2LLoZvaiFRosyVIQDaorhYlvfCQIHZBDLUIRUUXVKriYZWrC988rvPYs6aek
 sL+TiBh+uqxxa9dQp6QK8xVkb1jqSDGETOavGsfsppwPS7viI8hpFULQw==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

selinux: fix typos in comments
Signed-off-by: Jonas Lindner <jolindner@gmx.de>
=2D--
 security/selinux/hooks.c         | 4 ++--
 security/selinux/include/audit.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index beceb89f68d9..d3f18d4a03c0 100644
=2D-- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -640,7 +640,7 @@ static int selinux_set_mnt_opts(struct super_block *sb=
,
 	 * we need to skip the double mount verification.
 	 *
 	 * This does open a hole in which we will not notice if the first
-	 * mount using this sb set explict options and a second mount using
+	 * mount using this sb set explicit options and a second mount using
 	 * this sb does not set any security options.  (The first options
 	 * will be used for both mounts)
 	 */
@@ -6795,7 +6795,7 @@ static u32 bpf_map_fmode_to_av(fmode_t fmode)
 }

 /* This function will check the file pass through unix socket or binder t=
o see
- * if it is a bpf related object. And apply correspinding checks on the b=
pf
+ * if it is a bpf related object. And apply corresponding checks on the b=
pf
  * object based on the type. The bpf maps and programs, not like other fi=
les and
  * socket, are using a shared anonymous inode inside the kernel as their =
inode.
  * So checking that inode cannot identify if the process have privilege t=
o
diff --git a/security/selinux/include/audit.h b/security/selinux/include/a=
udit.h
index 1cba83d17f41..406bceb90c6c 100644
=2D-- a/security/selinux/include/audit.h
+++ b/security/selinux/include/audit.h
@@ -18,7 +18,7 @@
 /**
  *	selinux_audit_rule_init - alloc/init an selinux audit rule structure.
  *	@field: the field this rule refers to
- *	@op: the operater the rule uses
+ *	@op: the operator the rule uses
  *	@rulestr: the text "target" of the rule
  *	@rule: pointer to the new rule structure returned via this
  *
=2D-
2.34.1

