Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69701382AEF
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 13:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236712AbhEQL0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 07:26:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236707AbhEQL0N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 07:26:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8DE86100C;
        Mon, 17 May 2021 11:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621250697;
        bh=IqUZ0sNLzRXtoD/YFOpvkpCv7NFriIwqrV0nk+tQFjA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SjZiucxTGgskw3bZqxU8hkRIDqvLkRPDUPXGysGlCLAY4qMHHwLFDNWf7GzwMPeSy
         k6gBtne3rZl4OWw9EJiAKpC90ICt4wmL+dOW1/wtHGSzFBwlIEB7lPhufz0SGrH9U0
         8BeoyWN0zwaq92smlvSCsJzkysY0ZKum/rQEXJAZuksdPKz9UCm2b6rTTMrYAXAHuw
         m5K5R4IDiLhuXBms1/YwUa6BMqBAHs9uv2Ndu7DwgV1+6w7DgEDLXe2pUPRnLtE+Wd
         GExQHVUHQydYOYDz+zZFmQU4ywGdNTNfxU1WppJsq+V8siRV5m9U5SOv7k7mbiC129
         mEKSngo0SzESg==
Date:   Mon, 17 May 2021 13:24:46 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Theodore Ts'o <tytso@mit.edu>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Corentin Labbe <clabbe@baylibre.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Jean Delvare <jdelvare@suse.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mike Leach <mike.leach@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thorsten Leemhuis <linux@leemhuis.info>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        intel-wired-lan@lists.osuosl.org, kvm@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ext4@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-usb@vger.kernel.org, mjpeg-users@lists.sourceforge.net,
        netdev@vger.kernel.org, rcu@vger.kernel.org
Subject: Re: [PATCH v3 00/16] Replace some bad characters on documents
Message-ID: <20210517132446.7edba98f@coco.lan>
In-Reply-To: <30cd6dd9d1049d56b629c92a5f385b84c026b445.camel@infradead.org>
References: <cover.1621159997.git.mchehab+huawei@kernel.org>
        <30cd6dd9d1049d56b629c92a5f385b84c026b445.camel@infradead.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, 17 May 2021 11:48:04 +0100
David Woodhouse <dwmw2@infradead.org> escreveu:

> On Sun, 2021-05-16 at 12:18 +0200, Mauro Carvalho Chehab wrote:
> > The conversion tools used during DocBook/LaTeX/html/Markdown->ReST=20
> > conversion and some cut-and-pasted text contain some characters that
> > aren't easily reachable on standard keyboards and/or could cause=20
> > troubles when parsed by the documentation build system. =20
>=20
> Better.
>=20
> But you still don't say *why* it matters whether given characters are
> trivial to reach with standard keyboard layouts, or specify *what*
> 'troubles' the offending characters cause.

See the patches in the series. The reason for each particular case
is there on each patch, like on this one:

	[PATCH v3 13/16] docs: sound: kernel-api: writing-an-alsa-driver.rst: repl=
ace some characters

	The conversion tools used during DocBook/LaTeX/html/Markdown->ReST
	conversion and some cut-and-pasted text contain some characters that
	aren't easily reachable on standard keyboards and/or could cause
	troubles when parsed by the documentation build system.
	=20
	Replace the occurences of the following characters:
=09
		- U+00a0 ('=C2=A0'): NO-BREAK SPACE
		  as it can cause lines being truncated on PDF output

	Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>


Thanks,
Mauro
