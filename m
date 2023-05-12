Return-Path: <netdev+bounces-1986-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABD006FFE13
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 02:41:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD6241C210E3
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 00:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B15707EC;
	Fri, 12 May 2023 00:41:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179917EB;
	Fri, 12 May 2023 00:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0866C4339B;
	Fri, 12 May 2023 00:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683852068;
	bh=buIg82FsdUAF2Q1U/hR23a0od1zuZD5R5znK2wDNEQE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FR9CtCjJXhscTX6v+8eud1o8h8AsAJ6CvD1UDO3Ny+kWOY9I3O9HZWktWAa4grjkn
	 Iu2OcNzq7LNVuMd1AEPkfLMajCndiwQ0+Q8bE8R5idpeMifggxQOIvWzGpsdeaHzGj
	 uw0q9ORsxXvVUbTAZZ6Zkk7ahY/q3m1DG8KrGl+7L1TgsrC5o2UvMok/vvtuOes5ws
	 ijPJslKVstS6L8cNoZhC16eMm9dtwSEAZeqPBdQugC5x4SfsrLQ6ndDNRYe+NLfagJ
	 KRWdc4iu8NbhhqNFDyNXwnglJWhTXm65486914Yp/k8CS14VXp6ZGdMxz5nxJO8z4U
	 K5CWoACLAPKTw==
Date: Thu, 11 May 2023 17:41:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux DRI Development <dri-devel@lists.freedesktop.org>, Linux Kernel
 Mailing List <linux-kernel@vger.kernel.org>, Linux Networking
 <netdev@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Linux Staging Drivers <linux-staging@lists.linux.dev>, Linux Watchdog
 Devices <linux-watchdog@vger.kernel.org>, Linux Kernel Actions
 <linux-actions@lists.infradead.org>, Diederik de Haas
 <didi.debian@cknow.org>, Kate Stewart <kstewart@linuxfoundation.org>, David
 Airlie <airlied@redhat.com>, Karsten Keil <isdn@linux-pingi.de>, Jay
 Vosburgh <j.vosburgh@gmail.com>, Andy Gospodarek <andy@greyhouse.net>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Sam Creasey
 <sammy@sammy.net>, Dominik Brodowski <linux@dominikbrodowski.net>, Daniel
 Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>, Robert
 Jarzmik <robert.jarzmik@free.fr>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Wim Van Sebroeck <wim@linux-watchdog.org>,
 Guenter Roeck <linux@roeck-us.net>, Jan Kara <jack@suse.com>, Andreas
 =?UTF-8?B?RsOkcmJlcg==?= <afaerber@suse.de>, Manivannan Sadhasivam
 <mani@kernel.org>, Tom Rix <trix@redhat.com>, Simon Horman
 <simon.horman@corigine.com>, Yang Yingliang <yangyingliang@huawei.com>,
 "Steven Rostedt (Google)" <rostedt@goodmis.org>, Pavel Machek
 <pavel@ucw.cz>, Minghao Chi <chi.minghao@zte.com.cn>, Kalle Valo
 <kvalo@kernel.org>, Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?=
 <u.kleine-koenig@pengutronix.de>, Viresh Kumar <viresh.kumar@linaro.org>,
 Arnd Bergmann <arnd@arndb.de>, Deepak R Varma <drv@mailo.com>, Davidlohr
 Bueso <dave@stgolabs.net>, Thomas Gleixner <tglx@linutronix.de>, Jacob
 Keller <jacob.e.keller@intel.com>, Gaosheng Cui <cuigaosheng1@huawei.com>,
 Dan Carpenter <error27@gmail.com>, Archana <craechal@gmail.com>
Subject: Re: [PATCH 00/10] Treewide GPL SPDX conversion (love letter to
 Didi)
Message-ID: <20230511174105.63b7a6ae@kernel.org>
In-Reply-To: <20230511133406.78155-1-bagasdotme@gmail.com>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 May 2023 20:33:56 +0700 Bagas Sanjaya wrote:
> I trigger this patch series because of Didi's GPL full name fixes
> attempt [1], for which all of them had been NAKed. In many cases, the
> appropriate correction is to use SPDX license identifier instead.
> 
> Often, when replacing license notice boilerplates with their equivalent
> SPDX identifier, the notice doesn't mention explicit GPL version. Greg
> [2] replied this question by falling back to GPL 1.0 (more precisely
> GPL 1.0+ in order to be compatible with GPL 2.0 used by Linux kernel),
> although there are exceptions (mostly resolved by inferring from
> older patches covering similar situation).

Should you be CCing linux-spdx@ on this?

