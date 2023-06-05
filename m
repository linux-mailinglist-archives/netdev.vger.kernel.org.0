Return-Path: <netdev+bounces-8013-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C0017226B7
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:00:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0452C1C20B72
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB1F31950F;
	Mon,  5 Jun 2023 13:00:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5E56D3F
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:00:28 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB2CA1
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=r6B59z6NWgSnbAr/h5mlLldeNsVGJvI7wVALTw4XeOs=; b=juwqP0xNrAcURhtxtWAJru6Zw5
	TZtzTZxf9Mylk5W8Ok1XjQOg4RaAkMARWWgK9Pead3MbAPrS265ZjCA3gWiWti+/y70b6R9zbxwsR
	xcnMIW32D+QYUC+/I8I87zr95AXzDg4A1fFaam/I0Fq2w6lC2tEBldtTX36GR08rB+k0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q69ou-00Etpc-CN; Mon, 05 Jun 2023 15:00:24 +0200
Date: Mon, 5 Jun 2023 15:00:24 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Mengyuan Lou <mengyuanlou@net-swift.com>
Cc: netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [RFC,PATCH net-next 1/3] net: ngbe: add Wake on Lan support
Message-ID: <372be8c0-f83f-4641-ad6d-f126a01e02d4@lunn.ch>
References: <20230605095527.57898-1-mengyuanlou@net-swift.com>
 <6DD3D5EDF01AE3F5+20230605095527.57898-2-mengyuanlou@net-swift.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6DD3D5EDF01AE3F5+20230605095527.57898-2-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 05:52:50PM +0800, Mengyuan Lou wrote:
> Implement ethtool_ops get_wol.
> Implement Wake-on-LAN support.
> 
> Magic packets are checked by fw, for now just support
> WAKE_MAGIC and do not supoort to set_wol.

So are you saying WOL cannot be disabled? A magic packet will always
wake the system?

Can you disable WoL by not calling device_set_wakeup_enable()? Can the
interrupt be masked to disable WoL?

Is this specific to ngbe? Does txgbe have different firmware and
different WoL support?

	  Andrew

