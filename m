Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0643633A46D
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 12:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbhCNLMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 07:12:13 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:34571 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbhCNLLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 07:11:44 -0400
Date:   Sun, 14 Mar 2021 11:11:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615720303; bh=X3TuYcTaZPUU1Xz+TlNF44PidtjG5KU7YmET3XhmCM4=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=LQIkSHYL/JKjtC1hVLDGKzdivEcZL/6ARhm2BmF6IMg0R3s/R3fueTyKmQhMmx/OI
         KLhtMmoWrWn0wyUYO2u4aC4RvB0iF2UIrpnpw0iS7HpqWViseGLJCFDUBA/yTiSxXB
         A2RPRYRD/n6JKP6CD5cblTmg4qzie2Myax4DvEsFeipLPe+WM2IuTtVM0pSOo/AwmJ
         GkG0Dj3CYb3dC1gmqtlj6Wpi2Pn9DyHo66EGmPizv2DAb3xZrdSRpnZsiCO/bOI0Yo
         KppelL9b8cYHYsjA/6XuIiWc5dH2+K5Fo9ssF3HT5Uso3R9HQ8VD4tAzj353pat4Gf
         pv0IOnFO5cNiw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Wang Qing <wangqing@vivo.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Guillaume Nault <gnault@redhat.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v3 net-next 4/6] linux/etherdevice.h: misc trailing whitespace cleanup
Message-ID: <20210314111027.7657-5-alobakin@pm.me>
In-Reply-To: <20210314111027.7657-1-alobakin@pm.me>
References: <20210314111027.7657-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Caught by the text editor. Fix it separately from the actual changes.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/linux/etherdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 2e5debc0373c..bcb2f81baafb 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -11,7 +11,7 @@
  * Authors:=09Ross Biro
  *=09=09Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
  *
- *=09=09Relocated to include/linux where it belongs by Alan Cox
+ *=09=09Relocated to include/linux where it belongs by Alan Cox
  *=09=09=09=09=09=09=09<gw4pts@gw4pts.ampr.org>
  */
 #ifndef _LINUX_ETHERDEVICE_H
--
2.30.2


