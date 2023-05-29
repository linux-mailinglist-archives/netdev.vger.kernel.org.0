Return-Path: <netdev+bounces-6138-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A99B714E33
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:23:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6227E280E7E
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86555A949;
	Mon, 29 May 2023 16:23:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0F9947D
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 16:23:02 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FEFE8;
	Mon, 29 May 2023 09:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=n4QXLGAfRkLH8bC9a2mTFIwRoAkIoJF6zXz6tT7k76A=; b=T/3hS/8qkG2fAAL7LAX8/auZp8
	d8jXB5EuF0GzluT7bxRwuBjNiOkIMSyNLyn78Fjl2nniVlYHvVjmCapLDz8WD6/cvjAy3aEHJIoFY
	7DfBIKxQ1yw6NSSoGFwPbOsQxclH2TaiZ0oLImnV7w+le4FPAGB4oXgGFuEHoRgNg6R0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q3fdn-00EFMM-H5; Mon, 29 May 2023 18:22:39 +0200
Date: Mon, 29 May 2023 18:22:39 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
	geert+renesas@glider.be, magnus.damm@gmail.com,
	netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] net: renesas: rswitch: Improve performance
 of TX
Message-ID: <a181cce3-c553-4635-a039-021be50f2a51@lunn.ch>
References: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 05:08:35PM +0900, Yoshihiro Shimoda wrote:
> This patch series is based on next-20230525.

Hi Yoshihiro

Patches for networking should be based on the HEAD of net-next/main.

	Andrew

