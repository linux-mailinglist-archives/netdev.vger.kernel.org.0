Return-Path: <netdev+bounces-3214-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C09C5705FFC
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:27:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82A82281458
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 06:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F8635688;
	Wed, 17 May 2023 06:27:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F75440A
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 06:27:22 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5ED40E7;
	Tue, 16 May 2023 23:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=n96OXagPNbbIGhllOsTU6Nvko8
	sdV81MymooKBut9cKTfx1gLSQWWCaa6jlrT8eH7yrPPupyjAtYapcazQoVvjyKHLUcvXIWV1w2pxT
	xeW9TqL0mOeNPmcq4lTfcCBC4FNudSRMCVVdr0D0Vz1BBYzce557s6zuwzzW7Gz5uyahP20AW1bLp
	FHE82edsFY215RxbDuhspvBGHS4zp0tJEE41IJ+02oT32S2ekD5S7VDcDnOu+5hFZnCamjfz+q0HS
	sNAVxy+iEYmLV5Yr3KUo0RHzprS0X1vpGjMyvLoHk7e5miodpjhcctEzpbNZDBlwsri0pk/R+FlEX
	wq1XDmrg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pzAd2-008S1R-0i;
	Wed, 17 May 2023 06:27:16 +0000
Date: Tue, 16 May 2023 23:27:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, arnd@arndb.de, christophe.leroy@csgroup.eu,
	hch@infradead.org, agordeev@linux.ibm.com,
	wangkefeng.wang@huawei.com, schnelle@linux.ibm.com,
	David.Laight@aculab.com, shorne@gmail.com, willy@infradead.org,
	deller@gmx.de, loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v5 RESEND 01/17] asm-generic/iomap.h: remove
 ARCH_HAS_IOREMAP_xx macros
Message-ID: <ZGRzxAza23HNPeCU@infradead.org>
References: <20230515090848.833045-1-bhe@redhat.com>
 <20230515090848.833045-2-bhe@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515090848.833045-2-bhe@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

