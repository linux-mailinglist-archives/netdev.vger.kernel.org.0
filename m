Return-Path: <netdev+bounces-7992-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A595722622
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:42:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7B661C20AD8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 863D613AC5;
	Mon,  5 Jun 2023 12:42:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDB9525E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:42:17 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3520390;
	Mon,  5 Jun 2023 05:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=fCMkuadoPuug3gViSXGITaf9VX4lubrbW1ztUUEv5mk=; b=kAoATLP5//r2ffr+ruaTCADrg7
	g2ftUBM+X7ixCaJBJb79f7+XCWrZxr8zOijFwR/igTS5tVQjkuL34uL66jXzKtgfBKPOh8xVBZ9Kg
	zX+6IL+Fh9RBtK375se6njK+xuB0m46t8jTtY28w+YfHrk4jDePnWYcmFxddkH/46Y/c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q69Wy-00Etge-4T; Mon, 05 Jun 2023 14:41:52 +0200
Date: Mon, 5 Jun 2023 14:41:52 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: msmulski2@gmail.com
Cc: f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	linux@armlinux.org.uk, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, simon.horman@corigine.com,
	kabel@kernel.org, ioana.ciornei@nxp.com,
	Michal Smulski <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next v7 0/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Message-ID: <b38bd01c-dbaa-440d-93ae-b1b772f8e8e1@lunn.ch>
References: <20230605053954.4051-1-msmulski2@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605053954.4051-1-msmulski2@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,T_SCC_BODY_TEXT_LINE,
	T_SPF_HELO_TEMPERROR,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 10:39:53PM -0700, msmulski2@gmail.com wrote:
> From: Michal Smulski <michal.smulski@ooma.com>
> 
> Changelist:
> * do not enable USXGMII for 6361 chips
> * track state->an_complete with state->link 
> 
> *** BLURB HERE ***

Hi Michal

Please remember to remove the *** BLURB HERE ***. What often happens
is that a branch is created for a patchset, and then the branch is
merged and the content of patch 0/X is used as the merge commit
message. So this can end up in the git history.

For a single patch, you are not required to have a patch 0/X.

	 Andrew

