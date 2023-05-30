Return-Path: <netdev+bounces-6388-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 29A84716129
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:11:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD5C22810FF
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F324D1EA85;
	Tue, 30 May 2023 13:11:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F061DDD7
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:11:22 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CE1A1;
	Tue, 30 May 2023 06:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=Drw7ZiISMTlYwQlP2tc86Tkb8Zg9w9S5oUOCgiy4lMs=; b=SNyvoJ/8K1jd1+68bWFWoiPyt6
	WA8Z4aAcHRZn1q6yHDubjJ6w5cT3MPAWm12VIgwjWSkLOm9m6WSWshmfQfASU1HfrWo/qxvqROax5
	n2ZRpuVwuQR54K2eK2tz29YXGUtwyfdUdXwvgqfhiqpihwKaQ+1181rHqFHMl0YsL3pg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q3z85-00EKRE-69; Tue, 30 May 2023 15:11:13 +0200
Date: Tue, 30 May 2023 15:11:13 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Lu Hongfei <luhongfei@vivo.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"open list:ETHERNET PHY LIBRARY" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	opensource.kernel@vivo.com
Subject: Re: [PATCH] net: Replace the ternary conditional operator with min()
Message-ID: <851564e1-1e23-4950-8aab-50c7693b4b8d@lunn.ch>
References: <20230530084531.7354-1-luhongfei@vivo.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530084531.7354-1-luhongfei@vivo.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 04:45:30PM +0800, Lu Hongfei wrote:
> It would be better to replace the traditional ternary conditional
> operator with min()

Hi Lu

Adding to the comments from Russell and Heiner, if i remember
correctly, the exact same change has been rejected before, for the
same reasons.  When submitting a patch, please do a search first and
see if somebody else has already received a reject.

Did you use a static analyser to find this? Please submit a patch to
the static analyser to stop it reporting code like this. That will
save wasting peoples time having to develop such bad patches, and
reviewers having to reject them.

	Andrew

