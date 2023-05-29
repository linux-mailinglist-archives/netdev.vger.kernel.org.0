Return-Path: <netdev+bounces-6155-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6EBD714EC1
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 19:07:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3ADC9280ECE
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:07:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5980FAD5E;
	Mon, 29 May 2023 17:07:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9B18C1E
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 17:07:49 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D57DBE;
	Mon, 29 May 2023 10:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=ctAn0AM1Vo5Aq8eCIhGC4WHg91BjrPdeqG9a05gQ9v4=; b=tk43u7gI1eHeQ16EAYoaZmTk70
	GAsIPIOCiKZFDwokn88VKJslyoyuNaZRZ+efWs/zqHnAE6+5BPVFpfcU52Yo/0IIHOPdxi9spogjr
	7SwEN1SxrWEF8HcwAuftKT1+aGJk/ECacrLHJBXjdrstJvqWQTEXcRYCV4zFNgra2HO4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q3gLI-00EFbZ-E3; Mon, 29 May 2023 19:07:36 +0200
Date: Mon, 29 May 2023 19:07:36 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-leds@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v4 03/13] Documentation: leds: leds-class:
 Document new Hardware driven LEDs APIs
Message-ID: <dc8c8a5b-8922-4c0e-95d8-7914ea6272d3@lunn.ch>
References: <20230529163243.9555-1-ansuelsmth@gmail.com>
 <20230529163243.9555-4-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529163243.9555-4-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 06:32:33PM +0200, Christian Marangi wrote:
> Document new Hardware driven LEDs APIs.
> 
> Some LEDs can be programmed to be driven by hardware. This is not
> limited to blink but also to turn off or on autonomously.
> To support this feature, a LED needs to implement various additional
> ops and needs to declare specific support for the supported triggers.
> 
> Add documentation for each required value and API to make hw control
> possible and implementable by both LEDs and triggers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

