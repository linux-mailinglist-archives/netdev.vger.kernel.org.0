Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D184280EA4
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 10:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387601AbgJBIUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 04:20:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbgJBIUN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 04:20:13 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B55420719;
        Fri,  2 Oct 2020 08:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601626812;
        bh=eCXSiU2FIhwyMUdAzE/HQoSwO9e7c1WQEH8tvyiMQns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=01oagkzbJzHnhjV2zf9J7vsHUTejgJ/cLcBOFBC4wrj7b06/ce6VUwjqoJKa3ScTy
         1CQlS3SP/MqGvCIhyFVjDz6/4pZfMM5aJgDUKGB7Wh3oxLHAhHq2Dl0/Dxlr9uPwJx
         aAO/Wp2r1hBVGU4D0kVg+mRrSDqAuWNAtXGDeZ0Q=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kOGIU-00GeG7-Q0; Fri, 02 Oct 2020 09:20:10 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, David Brazdil <dbrazdil@google.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dennis Zhou <dennis@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Tejun Heo <tj@kernel.org>,
        kernel-team@android.com, Christoph Lameter <cl@linux.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        kvm@vger.kernel.org, linux-i2c@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, linux-gpio@vger.kernel.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jeff Dike <jdike@addtoit.com>, Taehee Yoo <ap420073@gmail.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Richard Weinberger <richard@nod.at>,
        Andrew Jones <drjones@redhat.com>,
        Wolfram Sang <wsa@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-um@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Balbir Singh <sblbir@amazon.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Ulrich Hecht <uli+renesas@fpond.eu>
Subject: Re: [PATCH 0/6] Fix new html build warnings from next-20201001
Date:   Fri,  2 Oct 2020 09:19:59 +0100
Message-Id: <160162675379.1930042.15447480570555160964.b4-ty@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601616399.git.mchehab+huawei@kernel.org>
References: <cover.1601616399.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, dbrazdil@google.com, linux-doc@vger.kernel.org, mchehab+huawei@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, dennis@kernel.org, catalin.marinas@arm.com, will@kernel.org, tj@kernel.org, kernel-team@android.com, cl@linux.com, pbonzini@redhat.com, kuba@kernel.org, netdev@vger.kernel.org, geert+renesas@glider.be, kvm@vger.kernel.org, linux-i2c@vger.kernel.org, andrew@lunn.ch, linux-gpio@vger.kernel.org, anton.ivanov@cambridgegreys.com, davem@davemloft.net, bgolaszewski@baylibre.com, jdike@addtoit.com, ap420073@gmail.com, erosca@de.adit-jv.com, richard@nod.at, drjones@redhat.com, wsa@kernel.org, linus.walleij@linaro.org, tglx@linutronix.de, linux-um@lists.infradead.org, alexandru.elisei@arm.com, sblbir@amazon.com, corbet@lwn.net, mathieu.poirier@linaro.org, uli+renesas@fpond.eu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Oct 2020 07:49:44 +0200, Mauro Carvalho Chehab wrote:
> There are some new warnings when building the documentation from
> yesterday's linux next. This small series fix them.
> 
> - patch 1 documents two new kernel-doc parameters on a net core file.
>   I used the commit log in order to help documenting them;
> - patch 2 fixes some tags at UMLv2 howto;
> - patches 3 and 5 add some new documents at the corresponding
>   index file.
> - patch 4 changes kernel-doc script for it to recognize typedef enums.
> 
> [...]

Applied to next, thanks!

[2/6] KVM: arm64: Fix some documentation build warnings
      commit: 030bdf3698b7c3af190dd1fe714f0545f23441d0

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


