Return-Path: <netdev+bounces-1616-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AF7C6FE8CC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:37:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5FF628160C
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 00:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9497039C;
	Thu, 11 May 2023 00:37:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86190365
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 00:37:47 +0000 (UTC)
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.217])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 712AD1FEB
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 17:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=9+wrX
	e/AzWRjKarCMp1sC6NLHOq5i6TJSCuRDAJttVk=; b=Q3Lm3rVhaTeVPo844nTx0
	nX/9AtDqS49bqMsvaPuXOq6Ia9JT1EViM7PxZo2JeRGNx1SNfnDDdPWi17dQKLCH
	4bXfAXXN8iWCEMfzRY3PA12yIi8KRpAwzVQt9JsBQpbCNUv0hJ1lcfiDsinwGw4n
	NtwxfqEpitvmtnqRHbNf8Q=
Received: from localhost.localdomain (unknown [113.200.76.118])
	by zwqz-smtp-mta-g1-4 (Coremail) with SMTP id _____wBXZPXMOFxkqfUVBA--.59052S2;
	Thu, 11 May 2023 08:37:32 +0800 (CST)
From: zhaoshuang <izhaoshuang@163.com>
To: pawel.chmielewski@intel.com
Cc: netdev@vger.kernel.org
Subject: Re: [PATCH] ipruote2: optimize code and fix some mem-leak risk
Date: Thu, 11 May 2023 08:37:25 +0800
Message-Id: <20230511003726.32443-1-izhaoshuang@163.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230510133616.7717-1-izhaoshuang@163.com>
References: <20230510133616.7717-1-izhaoshuang@163.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXZPXMOFxkqfUVBA--.59052S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4RAZ2TDUUUU
X-Originating-IP: [113.200.76.118]
X-CM-SenderInfo: 5l2kt0pvkxt0rj6rljoofrz/xtbBEQ1suFaENxMd-QAAse
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

@pawel.chmielewski
A signoff has been deleted. Pls review again


