Return-Path: <netdev+bounces-11475-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 451CF7333DC
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 16:44:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76A691C20FBE
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 14:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1735D50C;
	Fri, 16 Jun 2023 14:44:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D4A79E5
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 14:44:52 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544492D73;
	Fri, 16 Jun 2023 07:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=lrmY5DOLGXtA1k0B/72pEMtj8OGLUiDM+PjIMPdL11w=; b=ILuZyqjhcrRfkR9E/LRyChDSUF
	SICNiYWjepUZWOFCAp2zgaLizRgwStMiR/ZclNzIYDDCZ2NVnm8rDWRgdoGcv9Zkmb3GTIlW9nYQg
	JWL+KcHTzpAFi0LDdgAUSayJlceo/UrTw2bw3MIhZn4fwDM6lexJRsXf/NjOqpSJL/ZU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAAgt-00GjGY-Vr; Fri, 16 Jun 2023 16:44:43 +0200
Date: Fri, 16 Jun 2023 16:44:43 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Michael Walle <mwalle@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Rob Herring <robh@kernel.org>
Subject: Re: [PATCH net-next] dt-bindings: net: phy: gpy2xx: more precise
 description
Message-ID: <248899a6-ae04-4e57-baba-e77e79f5a4f8@lunn.ch>
References: <20230616-feature-maxlinear-dt-better-irq-desc-v1-1-57a8936543bf@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616-feature-maxlinear-dt-better-irq-desc-v1-1-57a8936543bf@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 12:45:57PM +0200, Michael Walle wrote:
> Mention that the interrupt line is just asserted for a random period of
> time, not the entire time.
> 
> Suggested-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Michael Walle <mwalle@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

