Return-Path: <netdev+bounces-1527-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 793D66FE1DD
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 17:49:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D8361C20B2D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 15:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 631F3168AF;
	Wed, 10 May 2023 15:49:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593A4154AF
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 15:49:12 +0000 (UTC)
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.198])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 514209004
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=LAKjo
	/6XVVYpyHnKy/+iQLnF/w/ZTXPLy9M0w7TdH4g=; b=WPNJPrAbIrn6RYjzVSsw5
	1iKgAJEFNxvBUNFarsxeWkbakR9Hir2S0a9unUTxoV73y+ijTmtX2Y7nMFGnDzSb
	lXjHBDkw/awoTr/gAuF4UEPOl02QUt0tg1XzTgGrpsSy6IP+ni6mC3L2CUkACtNr
	MUioRRH1aaNN6FfNVCPrjE=
Received: from localhost.localdomain (unknown [113.200.76.118])
	by zwqz-smtp-mta-g5-4 (Coremail) with SMTP id _____wCnt0vGvFtkI9ryBQ--.8640S2;
	Wed, 10 May 2023 23:48:22 +0800 (CST)
From: zhaoshuang <izhaoshuang@163.com>
To: pawel.chmielewski@intel.com
Cc: netdev@vger.kernel.org
Subject: Re: [PATCH] ipruote2: optimize code and fix some mem-leak risk
Date: Wed, 10 May 2023 23:47:46 +0800
Message-Id: <20230510154747.26835-1-izhaoshuang@163.com>
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
X-CM-TRANSID:_____wCnt0vGvFtkI9ryBQ--.8640S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4RAZ2TDUUUU
X-Originating-IP: [113.200.76.118]
X-CM-SenderInfo: 5l2kt0pvkxt0rj6rljoofrz/1tbiSghruGI0Ydg6ngAAsa
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

@pawel.chmielewski
Thanks for your review

The commit message has been modified. But I don't know how to modify mail subject
If the mail subject shall be corrected, could U help to do it? Thanks


