Return-Path: <netdev+bounces-6819-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 73B05718514
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:36:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDC0A2813CA
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:36:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10F3614272;
	Wed, 31 May 2023 14:36:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0152CC8E6
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:35:59 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA7F95;
	Wed, 31 May 2023 07:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=alvQB06G2abYDgIKNOmnv/gb3Ob0yZ2ECtTyulkpYs8=; b=rm5bQWLLPPPgcQ/f1U545OaUox
	IivbR+swBZL81qJJQV1asp5bq0ormUfDhuDZEg2ykNqw8XOOlgWWgxpmN0mRfgEwaUPUmC/yLCzfr
	N7b3H7j1/dE67BrMOQ0ZqUtis9UomAVJHfladyXQpERIjMOi7Zit0iewuNZL+3LU1WjM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q4MvX-00ET54-Oc; Wed, 31 May 2023 16:35:51 +0200
Date: Wed, 31 May 2023 16:35:51 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Atsushi Nemoto <atsushi.nemoto@sord.co.jp>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
	Michael Hennerich <michael.hennerich@analog.com>,
	Alexandru Tachici <alexandru.tachici@analog.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v2 1/2] dt-bindings: net: adin: document a phy
 link status inversion property
Message-ID: <7d2c7842-2295-4f42-a18a-12f641042972@lunn.ch>
References: <e7a699fb-f7aa-3a3e-625f-7a2c512da5f9@sord.co.jp>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7a699fb-f7aa-3a3e-625f-7a2c512da5f9@sord.co.jp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 10:57:55PM +0900, Atsushi Nemoto wrote:
> The ADIN1200/ADIN1300 supports inverting the link status output signal
> on the LINK_ST pin.

Please could you add an explanation to the commit message why you
would want to do this?  Is this because there is an LED connected to
it, but its polarity is inverted?

    Andrew

