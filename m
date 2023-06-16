Return-Path: <netdev+bounces-11359-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B7D79732C5A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:43:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2A581C20F95
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:43:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EDCF16409;
	Fri, 16 Jun 2023 09:43:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8105174CB
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 09:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DEFC433C9;
	Fri, 16 Jun 2023 09:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686908590;
	bh=mDqf9UcBQG4wfwzaQjfPhMXh9FL+mDBknpAMOZt/rlc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TTBaozSstINS1Fiqtku/Rkwd70kHnvQru7vGJ3FrtI++594ueHYL+KAMQYQNB1+1l
	 WxfezVDDNe11KJrDngvUAirGN6Jt5boqO+Gu6zaQMJqQzPe4bbtXRZe3+8OAUTra53
	 jghGAKJ2V3BA01gr3PWFawIJM0aZJIZXlfBr3FB4=
Date: Fri, 16 Jun 2023 11:43:08 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Wang Ming <machel@vivo.com>
Cc: =linyunsheng@huawei.com, opensource.kernel@vivo.com,
	Sunil Goutham <sgoutham@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drivers:net:ethernet:Add missing fwnode_handle_put()
Message-ID: <2023061600-gong-pursuant-34d5@gregkh>
References: <20230616091549.1384-1-machel@vivo.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230616091549.1384-1-machel@vivo.com>

On Fri, Jun 16, 2023 at 05:15:01PM +0800, Wang Ming wrote:
> 本邮件及其附件内容可能含有机密和/或隐私信息，仅供指定个人或机构使用。若您非发件人指定收件人或其代理人，请勿使用、传播、复制或存储此邮件之任何内容或其附件。如您误收本邮件，请即以回复或电话方式通知发件人，并将原始邮件、附件及其所有复本删除。谢谢。
> The contents of this message and any attachments may contain confidential and/or privileged information and are intended exclusively for the addressee(s). If you are not the intended recipient of this message or their agent, please note that any use, dissemination, copying, or storage of this message or its attachments is not allowed. If you receive this message in error, please notify the sender by reply the message or phone and delete this message, any attachments and any copies immediately.
> Thank you

Now deleted.

