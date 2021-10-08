Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F6D426B9A
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 15:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240304AbhJHNZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 09:25:28 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55039 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234388AbhJHNZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 09:25:27 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 88F795C010A;
        Fri,  8 Oct 2021 09:23:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 08 Oct 2021 09:23:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=yS53zw6OQheXy+eKp
        sUW8k8fuTo94HweRyHaZLCldRk=; b=SXYnPNjDRoq/NNc4n2/Prk8O2WXS8pXHG
        dnpuE61mQ/kv8CLNxlmvmtlZGCCPrBpZtZd52rMp2G7VOVOk9b1LKnUgf5Svkl9o
        VsnZ+Q7gLAWSxDTtPuW5PPMKyNZ7W8unMCU+VysEqpIrCTKL//4UaFrbaPqBvLBT
        zpqhQLa0u/q5Wv30Pj5Bb3g0dMOcGE9GZUfNuA1hHbBiQqG8VbGK7t3+9RXm20FR
        FLTvxQb+7tYEeaTzdwsl/UzspEUvYfQsbf73bI2IeFFhCt47lNIpSFUDB+lvrymv
        ZIgLtysiyqX2D3ma3JTZD9O7Kz/Iu7jK+aBPDMKSFg8vUBcwY/9KQ==
X-ME-Sender: <xms:U0ZgYUVeY1TE7IJCOqpDXrO3Q8z6ztG1H389MJaEVhnqD_aMuZD5eQ>
    <xme:U0ZgYYk9kzqJg8oj86ohyhh7hvrGHirWoXZ1ZuSHHuARTvWwYj0qjojS7JEEEk7G7
    aM00LiT9nFJRGg>
X-ME-Received: <xmr:U0ZgYYahprkLXJulepHI_hFlQ5gL2A5iqL_k762pTV4Cy8f2-lM-uJNiSURy7cj8o9Vv3o-0xicNC1__0VGMEzeREnQ2qApE2ExH7N6A-GT2wA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddttddgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefkughoucfutghh
    ihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtthgvrh
    hnpeeihfetteegkefgjeetkedtvdetkefftdfhgeeuleeutdffieffvddvffekgfffueen
    ucffohhmrghinheplhhkmhhlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:U0ZgYTWWfCFKW_RKSE9BaU6hkk_rJZG3h2VTiiFiARNUjt56MW2PvQ>
    <xmx:U0ZgYelWH9zoS5k9e7_XWPvSe6QBVhk9E80iCNYgxq8zKq9yJmj1Kw>
    <xmx:U0ZgYYfzH4_0DIZYRj1wZIaYIaNNaGVNn1HTuCiKUAU7d_oK1fHdxQ>
    <xmx:U0ZgYfA5dGmlxo3l046iKS1rKTcplairfSkwhukqaEhVPupAyYW4Dg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Oct 2021 09:23:29 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH net-next] mlxsw: item: Annotate item helpers with '__maybe_unused'
Date:   Fri,  8 Oct 2021 16:23:15 +0300
Message-Id: <20211008132315.90211-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

mlxsw is using helpers to get / set fields in messages exchanged with
the device. It is possible that some fields are only set or only get.
This causes LLVM to emit warnings such as the following when building
with W=1 [1]:

drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c:2022:1: warning: unused function 'mlxsw_afa_sampler_mirror_agent_get'

The fact that some fields are only set or only get is very much
intentional and not indicative of functions that need to be removed.

Therefore, annotate the item helpers with '__maybe_unused' to suppress
these warnings.

[1] https://lkml.org/lkml/2021/9/29/685

Cc: Nathan Chancellor <nathan@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/item.h | 56 ++++++++++++----------
 1 file changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/item.h b/drivers/net/ethernet/mellanox/mlxsw/item.h
index e92cadc98128..ab70a873a01a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/item.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/item.h
@@ -270,11 +270,13 @@ static struct mlxsw_item __ITEM_NAME(_type, _cname, _iname) = {			\
 	.size = {.bits = _sizebits,},						\
 	.name = #_type "_" #_cname "_" #_iname,					\
 };										\
-static inline u8 mlxsw_##_type##_##_cname##_##_iname##_get(const char *buf)	\
+static inline u8 __maybe_unused							\
+mlxsw_##_type##_##_cname##_##_iname##_get(const char *buf)			\
 {										\
 	return __mlxsw_item_get8(buf, &__ITEM_NAME(_type, _cname, _iname), 0);	\
 }										\
-static inline void mlxsw_##_type##_##_cname##_##_iname##_set(char *buf, u8 val)\
+static inline void __maybe_unused						\
+mlxsw_##_type##_##_cname##_##_iname##_set(char *buf, u8 val)			\
 {										\
 	__mlxsw_item_set8(buf, &__ITEM_NAME(_type, _cname, _iname), 0, val);	\
 }
@@ -290,13 +292,13 @@ static struct mlxsw_item __ITEM_NAME(_type, _cname, _iname) = {			\
 	.size = {.bits = _sizebits,},						\
 	.name = #_type "_" #_cname "_" #_iname,					\
 };										\
-static inline u8								\
+static inline u8 __maybe_unused							\
 mlxsw_##_type##_##_cname##_##_iname##_get(const char *buf, unsigned short index)\
 {										\
 	return __mlxsw_item_get8(buf, &__ITEM_NAME(_type, _cname, _iname),	\
 				 index);					\
 }										\
-static inline void								\
+static inline void __maybe_unused						\
 mlxsw_##_type##_##_cname##_##_iname##_set(char *buf, unsigned short index,	\
 					  u8 val)				\
 {										\
@@ -311,11 +313,13 @@ static struct mlxsw_item __ITEM_NAME(_type, _cname, _iname) = {			\
 	.size = {.bits = _sizebits,},						\
 	.name = #_type "_" #_cname "_" #_iname,					\
 };										\
-static inline u16 mlxsw_##_type##_##_cname##_##_iname##_get(const char *buf)	\
+static inline u16 __maybe_unused						\
+mlxsw_##_type##_##_cname##_##_iname##_get(const char *buf)			\
 {										\
 	return __mlxsw_item_get16(buf, &__ITEM_NAME(_type, _cname, _iname), 0);	\
 }										\
-static inline void mlxsw_##_type##_##_cname##_##_iname##_set(char *buf, u16 val)\
+static inline void __maybe_unused						\
+mlxsw_##_type##_##_cname##_##_iname##_set(char *buf, u16 val)			\
 {										\
 	__mlxsw_item_set16(buf, &__ITEM_NAME(_type, _cname, _iname), 0, val);	\
 }
@@ -331,13 +335,13 @@ static struct mlxsw_item __ITEM_NAME(_type, _cname, _iname) = {			\
 	.size = {.bits = _sizebits,},						\
 	.name = #_type "_" #_cname "_" #_iname,					\
 };										\
-static inline u16								\
+static inline u16 __maybe_unused						\
 mlxsw_##_type##_##_cname##_##_iname##_get(const char *buf, unsigned short index)\
 {										\
 	return __mlxsw_item_get16(buf, &__ITEM_NAME(_type, _cname, _iname),	\
 				  index);					\
 }										\
-static inline void								\
+static inline void __maybe_unused						\
 mlxsw_##_type##_##_cname##_##_iname##_set(char *buf, unsigned short index,	\
 					  u16 val)				\
 {										\
@@ -352,11 +356,13 @@ static struct mlxsw_item __ITEM_NAME(_type, _cname, _iname) = {			\
 	.size = {.bits = _sizebits,},						\
 	.name = #_type "_" #_cname "_" #_iname,					\
 };										\
-static inline u32 mlxsw_##_type##_##_cname##_##_iname##_get(const char *buf)	\
+static inline u32 __maybe_unused						\
+mlxsw_##_type##_##_cname##_##_iname##_get(const char *buf)			\
 {										\
 	return __mlxsw_item_get32(buf, &__ITEM_NAME(_type, _cname, _iname), 0);	\
 }										\
-static inline void mlxsw_##_type##_##_cname##_##_iname##_set(char *buf, u32 val)\
+static inline void __maybe_unused						\
+mlxsw_##_type##_##_cname##_##_iname##_set(char *buf, u32 val)			\
 {										\
 	__mlxsw_item_set32(buf, &__ITEM_NAME(_type, _cname, _iname), 0, val);	\
 }
@@ -372,13 +378,13 @@ static struct mlxsw_item __ITEM_NAME(_type, _cname, _iname) = {			\
 	.size = {.bits = _sizebits,},						\
 	.name = #_type "_" #_cname "_" #_iname,					\
 };										\
-static inline u32								\
+static inline u32 __maybe_unused						\
 mlxsw_##_type##_##_cname##_##_iname##_get(const char *buf, unsigned short index)\
 {										\
 	return __mlxsw_item_get32(buf, &__ITEM_NAME(_type, _cname, _iname),	\
 				  index);					\
 }										\
-static inline void								\
+static inline void __maybe_unused						\
 mlxsw_##_type##_##_cname##_##_iname##_set(char *buf, unsigned short index,	\
 					  u32 val)				\
 {										\
@@ -393,11 +399,13 @@ static struct mlxsw_item __ITEM_NAME(_type, _cname, _iname) = {			\
 	.size = {.bits = _sizebits,},						\
 	.name = #_type "_" #_cname "_" #_iname,					\
 };										\
-static inline u64 mlxsw_##_type##_##_cname##_##_iname##_get(const char *buf)	\
+static inline u64 __maybe_unused						\
+mlxsw_##_type##_##_cname##_##_iname##_get(const char *buf)			\
 {										\
 	return __mlxsw_item_get64(buf, &__ITEM_NAME(_type, _cname, _iname), 0);	\
 }										\
-static inline void mlxsw_##_type##_##_cname##_##_iname##_set(char *buf, u64 val)\
+static inline void __maybe_unused						\
+mlxsw_##_type##_##_cname##_##_iname##_set(char *buf, u64 val)			\
 {										\
 	__mlxsw_item_set64(buf, &__ITEM_NAME(_type, _cname, _iname), 0,	val);	\
 }
@@ -413,13 +421,13 @@ static struct mlxsw_item __ITEM_NAME(_type, _cname, _iname) = {			\
 	.size = {.bits = _sizebits,},						\
 	.name = #_type "_" #_cname "_" #_iname,					\
 };										\
-static inline u64								\
+static inline u64 __maybe_unused						\
 mlxsw_##_type##_##_cname##_##_iname##_get(const char *buf, unsigned short index)\
 {										\
 	return __mlxsw_item_get64(buf, &__ITEM_NAME(_type, _cname, _iname),	\
 				  index);					\
 }										\
-static inline void								\
+static inline void __maybe_unused						\
 mlxsw_##_type##_##_cname##_##_iname##_set(char *buf, unsigned short index,	\
 					  u64 val)				\
 {										\
@@ -433,19 +441,19 @@ static struct mlxsw_item __ITEM_NAME(_type, _cname, _iname) = {			\
 	.size = {.bytes = _sizebytes,},						\
 	.name = #_type "_" #_cname "_" #_iname,					\
 };										\
-static inline void								\
+static inline void __maybe_unused						\
 mlxsw_##_type##_##_cname##_##_iname##_memcpy_from(const char *buf, char *dst)	\
 {										\
 	__mlxsw_item_memcpy_from(buf, dst,					\
 				 &__ITEM_NAME(_type, _cname, _iname), 0);	\
 }										\
-static inline void								\
+static inline void __maybe_unused						\
 mlxsw_##_type##_##_cname##_##_iname##_memcpy_to(char *buf, const char *src)	\
 {										\
 	__mlxsw_item_memcpy_to(buf, src,					\
 			       &__ITEM_NAME(_type, _cname, _iname), 0);		\
 }										\
-static inline char *								\
+static inline char * __maybe_unused						\
 mlxsw_##_type##_##_cname##_##_iname##_data(char *buf)				\
 {										\
 	return __mlxsw_item_data(buf, &__ITEM_NAME(_type, _cname, _iname), 0);	\
@@ -460,7 +468,7 @@ static struct mlxsw_item __ITEM_NAME(_type, _cname, _iname) = {			\
 	.size = {.bytes = _sizebytes,},						\
 	.name = #_type "_" #_cname "_" #_iname,					\
 };										\
-static inline void								\
+static inline void __maybe_unused						\
 mlxsw_##_type##_##_cname##_##_iname##_memcpy_from(const char *buf,		\
 						  unsigned short index,		\
 						  char *dst)			\
@@ -468,7 +476,7 @@ mlxsw_##_type##_##_cname##_##_iname##_memcpy_from(const char *buf,		\
 	__mlxsw_item_memcpy_from(buf, dst,					\
 				 &__ITEM_NAME(_type, _cname, _iname), index);	\
 }										\
-static inline void								\
+static inline void __maybe_unused						\
 mlxsw_##_type##_##_cname##_##_iname##_memcpy_to(char *buf,			\
 						unsigned short index,		\
 						const char *src)		\
@@ -476,7 +484,7 @@ mlxsw_##_type##_##_cname##_##_iname##_memcpy_to(char *buf,			\
 	__mlxsw_item_memcpy_to(buf, src,					\
 			       &__ITEM_NAME(_type, _cname, _iname), index);	\
 }										\
-static inline char *								\
+static inline char * __maybe_unused						\
 mlxsw_##_type##_##_cname##_##_iname##_data(char *buf, unsigned short index)	\
 {										\
 	return __mlxsw_item_data(buf,						\
@@ -491,14 +499,14 @@ static struct mlxsw_item __ITEM_NAME(_type, _cname, _iname) = {			\
 	.size = {.bytes = _sizebytes,},						\
 	.name = #_type "_" #_cname "_" #_iname,					\
 };										\
-static inline u8								\
+static inline u8 __maybe_unused							\
 mlxsw_##_type##_##_cname##_##_iname##_get(const char *buf, u16 index)		\
 {										\
 	return __mlxsw_item_bit_array_get(buf,					\
 					  &__ITEM_NAME(_type, _cname, _iname),	\
 					  index);				\
 }										\
-static inline void								\
+static inline void __maybe_unused						\
 mlxsw_##_type##_##_cname##_##_iname##_set(char *buf, u16 index, u8 val)		\
 {										\
 	return __mlxsw_item_bit_array_set(buf,					\
-- 
2.31.1

