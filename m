Return-Path: <netdev+bounces-3945-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6348C709B75
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:39:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B3F8281922
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF44211181;
	Fri, 19 May 2023 15:38:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D216A5670
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 15:38:56 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B3F1A5;
	Fri, 19 May 2023 08:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=Content-Disposition:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:
	MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Content-Disposition:In-Reply-To:References;
	bh=omVuV1TDQWVA/C8v3UWExSrY1jklCeTmaHbrNW9ZbLg=; b=IgmJojbaIGWeZg6IwZRxGIH3tE
	vcvDuUVMDmbs5ANGFsnGM/MUi4tsBsANq1MOOx0NDRUln/vFv7NSv9egRkVW6JyYd3pPiOu0NYdfM
	jb5v9D+kCKZI/PkGx7wjEF6dHoU9dXCoj+LXK1b1c6JwzkR6lhqQ6KAN5eqMFSc/mMs4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q02Bp-00DLEd-4e; Fri, 19 May 2023 17:38:45 +0200
Date: Fri, 19 May 2023 17:38:45 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Lee Jones <lee@kernel.org>
Cc: Christian Marangi <ansuelsmth@gmail.com>, Pavel Machek <pavel@ucw.cz>,
	linux-leds@vger.kernel.org, David Miller <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	netdev <netdev@vger.kernel.org>
Subject: Stable branch for LEDs
Message-ID: <02004a73-2768-46f6-86ad-c6c631631abf@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Lee

Christian Marangi and I will be continuing the work of offloading LED
blinking to Ethernet MAC and PHY LED controllers. The next set of
patches is again cross subsystem, LEDs and netdev. It also requires
some patches you have in for-leds-next:

a286befc24e8 leds: trigger: netdev: Use mutex instead of spinlocks
509412749002 leds: trigger: netdev: Convert device attr to macro
0fd93ac85826 leds: trigger: netdev: Rename add namespace to netdev trigger enum modes
eb31ca4531a0 leds: trigger: netdev: Drop NETDEV_LED_MODE_LINKUP from mode
3fc498cf54b4 leds: trigger: netdev: Recheck NETDEV_LED_MODE_LINKUP on dev rename

I'm assuming the new series will get nerged via netdev, with your
Acked-by. Could you create a stable branch with these patches which
can be pulled into netdev?

Thanks
	Andrew

