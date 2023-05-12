Return-Path: <netdev+bounces-2012-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7846A6FFF60
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 05:41:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 075F72819CD
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 03:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFFA1818;
	Fri, 12 May 2023 03:40:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971037E9
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 03:40:59 +0000 (UTC)
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5325B49F3;
	Thu, 11 May 2023 20:40:57 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id 028C65C06AF;
	Thu, 11 May 2023 23:40:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 11 May 2023 23:40:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to; s=fm3; t=1683862853; x=1683949253; bh=Yy+3AsZZ+G
	KOnBCvC9fqie6igaMxYbSY1+8CPpJ5LVY=; b=J6ELtN/wqDLH7PDAs7AREgiAoe
	pPqjHFHebRjfOe8qUPghWim8HGcU0/cshFKIwxwoHK9P2M+MDXf8gi5Ro95tki37
	xM5G3AcQqZvHoIXnsR2jRxsMknLPRMmyr76PLAgaM1exW/l178d6ZNLcpUUMPRK1
	7rpxXV7UDNCqtKzhnRhb+uPLzZmvibbEub9UuT5tLVnJgJp3Vyvr2Dm4JJ1Ojnwa
	edSi6V44uwWgP6aF9u/BWydL3GULIkG4l9XhMWXk6USORHdM6Yv3abBRyZAOdjVE
	6OVxJwHqrI1hBVCwsNp1r7of93ItGpBtmM28vYMX5IlRI7KPAjny4BY0AgtQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1683862853; x=1683949253; bh=Yy+3AsZZ+GKOn
	BCvC9fqie6igaMxYbSY1+8CPpJ5LVY=; b=eC+7F5QKmZlps8EJA96bDYoI/0ocC
	8JopEetJHmIXhzCH9/g4K4T8WAwEBWyIgSsVA4pOqVvCVGv1m/ywf31WKaFkgo9e
	zAqQfigfIUObfRwdHHy/nbUp7s22xhQrKvXeA1XHZAJCkh0LuzX+c8oQdSJ/wrV1
	JVkQjEVOUjtRP+RyWq11YVQayiEmxEaiBpKMQzt68D+4jZXLR++EDNsKRx4Csnez
	tkA726qTBpLoY+J5MP6DtUCdKBhudc/TwSBc3luyt4JrJhLYTUDCYrdFx20Fl5Z1
	lCfmWe+i1ZBGj1Y5PIpzRhLaevYpk7gXzY/HMXJokY2lEYeKthTxZjvuA==
X-ME-Sender: <xms:RbVdZAQ9ugPYFL37ZsR_vXl23ENDE_1Y7krN9ipL9zGh_kICrO9gig>
    <xme:RbVdZNyuw-gTcrTZDWEOQrP5ADcmKkQ7x6Wo3QTwQAoCU_k3loS6vMceV8WiasQqR
    W5aGlIqjd1kKJBlezo>
X-ME-Received: <xmr:RbVdZN1zm9yXSS41WQBcFYhnVGvkdQuB0pgqOgmfHxmK9Xm_vqPW788w3SQWPxdvh_bJuUGW>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeegledgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdluddtmdenucfjughrpefhvf
    evufffkffoggfgsedtkeertdertddtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhi
    shhhkhhinhcuoehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrg
    htthgvrhhnpeekjeehjedukeffuefgveefgeeutdduudetvdduhefftdevhedujeekjeeu
    jeeludenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepvhhlrgguihhmihhrsehnihhkihhshhhk
    ihhnrdhpfi
X-ME-Proxy: <xmx:RbVdZEBP6FLW7UriEvwAQWfDUC1oXuf8Hdti-CJb181PC4Nbax1NMQ>
    <xmx:RbVdZJgCYc96-1Q_NhVSUkTn18XMLSIMa5U4PLny4v-d9mv6HrQ1Cg>
    <xmx:RbVdZApHqSnu547uA3KJ0e1N__l6mPZxBiczB-KHEa4tJO0VaSKm4Q>
    <xmx:RbVdZMSSRpviKZ_CC52Cp_hgJLvYP-k9D5S3S9EpfsiC2FzkCrVVjw>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 11 May 2023 23:40:48 -0400 (EDT)
From: Vladimir Nikishkin <vladimir@nikishkin.pw>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com,
	gnault@redhat.com,
	razor@blackwall.org,
	idosch@nvidia.com,
	liuhangbin@gmail.com,
	eyal.birger@gmail.com,
	jtoppins@redhat.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	Vladimir Nikishkin <vladimir@nikishkin.pw>
Subject: [PATCH net-next v9 1/2] net: vxlan: Add nolocalbypass option to vxlan.
Date: Fri, 12 May 2023 11:40:33 +0800
Message-Id: <20230512034034.16778-1-vladimir@nikishkin.pw>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

If a packet needs to be encapsulated towards a local destination IP, the
packet will undergo a "local bypass" and be injected into the Rx path as
if it was received by the target VXLAN device without undergoing
encapsulation. If such a device does not exist, the packet will be
dropped.

There are scenarios where we do not want to perform such a bypass, but
instead want the packet to be encapsulated and locally received by a
user space program for post-processing.

To that end, add a new VXLAN device attribute that controls whether a
"local bypass" is performed or not. Default to performing a bypass to
maintain existing behavior.

Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
v8=>v9
1. Update commit message to mention "local bypass".
2. Update "summary phrase" to include net:  as suggested by
https://patchwork.kernel.org/project/netdevbpf/patch/20230510200247.1534793-1-u.kleine-koenig@pengutronix.de/
3. Add reviewer's reviewed-by.

 drivers/net/vxlan/vxlan_core.c | 21 +++++++++++++++++++--
 include/net/vxlan.h            |  4 +++-
 include/uapi/linux/if_link.h   |  1 +
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 561fe1b314f5..78744549c1b3 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2352,7 +2352,8 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 #endif
 	/* Bypass encapsulation if the destination is local */
 	if (rt_flags & RTCF_LOCAL &&
-	    !(rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))) {
+	    !(rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST)) &&
+	    vxlan->cfg.flags & VXLAN_F_LOCALBYPASS) {
 		struct vxlan_dev *dst_vxlan;
 
 		dst_release(dst);
@@ -3172,6 +3173,7 @@ static void vxlan_raw_setup(struct net_device *dev)
 }
 
 static const struct nla_policy vxlan_policy[IFLA_VXLAN_MAX + 1] = {
+	[IFLA_VXLAN_UNSPEC]     = { .strict_start_type = IFLA_VXLAN_LOCALBYPASS },
 	[IFLA_VXLAN_ID]		= { .type = NLA_U32 },
 	[IFLA_VXLAN_GROUP]	= { .len = sizeof_field(struct iphdr, daddr) },
 	[IFLA_VXLAN_GROUP6]	= { .len = sizeof(struct in6_addr) },
@@ -3202,6 +3204,7 @@ static const struct nla_policy vxlan_policy[IFLA_VXLAN_MAX + 1] = {
 	[IFLA_VXLAN_TTL_INHERIT]	= { .type = NLA_FLAG },
 	[IFLA_VXLAN_DF]		= { .type = NLA_U8 },
 	[IFLA_VXLAN_VNIFILTER]	= { .type = NLA_U8 },
+	[IFLA_VXLAN_LOCALBYPASS]	= NLA_POLICY_MAX(NLA_U8, 1),
 };
 
 static int vxlan_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -4011,6 +4014,17 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
 			conf->flags |= VXLAN_F_UDP_ZERO_CSUM_TX;
 	}
 
+	if (data[IFLA_VXLAN_LOCALBYPASS]) {
+		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_LOCALBYPASS,
+				    VXLAN_F_LOCALBYPASS, changelink,
+				    true, extack);
+		if (err)
+			return err;
+	} else if (!changelink) {
+		/* default to local bypass on a new device */
+		conf->flags |= VXLAN_F_LOCALBYPASS;
+	}
+
 	if (data[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {
 		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_UDP_ZERO_CSUM6_TX,
 				    VXLAN_F_UDP_ZERO_CSUM6_TX, changelink,
@@ -4232,6 +4246,7 @@ static size_t vxlan_get_size(const struct net_device *dev)
 		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_UDP_ZERO_CSUM6_RX */
 		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_REMCSUM_TX */
 		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_REMCSUM_RX */
+		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_LOCALBYPASS */
 		0;
 }
 
@@ -4308,7 +4323,9 @@ static int vxlan_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	    nla_put_u8(skb, IFLA_VXLAN_REMCSUM_TX,
 		       !!(vxlan->cfg.flags & VXLAN_F_REMCSUM_TX)) ||
 	    nla_put_u8(skb, IFLA_VXLAN_REMCSUM_RX,
-		       !!(vxlan->cfg.flags & VXLAN_F_REMCSUM_RX)))
+		       !!(vxlan->cfg.flags & VXLAN_F_REMCSUM_RX)) ||
+	    nla_put_u8(skb, IFLA_VXLAN_LOCALBYPASS,
+		       !!(vxlan->cfg.flags & VXLAN_F_LOCALBYPASS)))
 		goto nla_put_failure;
 
 	if (nla_put(skb, IFLA_VXLAN_PORT_RANGE, sizeof(ports), &ports))
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 20bd7d893e10..0be91ca78d3a 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -328,6 +328,7 @@ struct vxlan_dev {
 #define VXLAN_F_TTL_INHERIT		0x10000
 #define VXLAN_F_VNIFILTER               0x20000
 #define VXLAN_F_MDB			0x40000
+#define VXLAN_F_LOCALBYPASS		0x80000
 
 /* Flags that are used in the receive path. These flags must match in
  * order for a socket to be shareable
@@ -348,7 +349,8 @@ struct vxlan_dev {
 					 VXLAN_F_UDP_ZERO_CSUM6_TX |	\
 					 VXLAN_F_UDP_ZERO_CSUM6_RX |	\
 					 VXLAN_F_COLLECT_METADATA  |	\
-					 VXLAN_F_VNIFILTER)
+					 VXLAN_F_VNIFILTER         |    \
+					 VXLAN_F_LOCALBYPASS)
 
 struct net_device *vxlan_dev_create(struct net *net, const char *name,
 				    u8 name_assign_type, struct vxlan_config *conf);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 4ac1000b0ef2..0f6a0fe09bdb 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -828,6 +828,7 @@ enum {
 	IFLA_VXLAN_TTL_INHERIT,
 	IFLA_VXLAN_DF,
 	IFLA_VXLAN_VNIFILTER, /* only applicable with COLLECT_METADATA mode */
+	IFLA_VXLAN_LOCALBYPASS,
 	__IFLA_VXLAN_MAX
 };
 #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
-- 
2.35.8

--
Fastmail.


