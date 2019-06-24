Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 712DF5104F
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730723AbfFXP3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:29:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46678 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfFXP3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:29:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=oAjztfS6a11nHbhHo7uC7mDxqHgIvw/jJlFzaOoft6c=; b=ChS7ei37kxum+rWJw+kFlBTPO
        C/scV2A8FYJo+q7aUFx1PkEmzzt4b5EVV6M1jdpQvr0Gx1lO5RSYlbIId/xZJ25JZx0WNvctgqNzO
        rAUAboJM7X/Gu3T9M4213MrJRQ7Q/mQ7kswh7gpnMJQh/fxuH2dMJbUPXd3UZUsdk8yWXjFSqLxks
        20EGrtd6HZnSY8b2S3g+12cmGcfsy0QRYFRXsxS2cf+9CzDBGrqe7U3RJUNo92vPmuQ+UtysgfdZB
        OIBKgc7xSf41vYlypspPOuf7je/fafDmAxpYAMEVwHpSvsnctIKIuJET9jDFXJoMNBfVMo73uzyy5
        0pMuLoOBA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hfQsj-0000ti-6T; Mon, 24 Jun 2019 15:27:47 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C2D8720A585BA; Mon, 24 Jun 2019 17:27:43 +0200 (CEST)
Date:   Mon, 24 Jun 2019 17:27:43 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Phong Tran <tranmanphong@gmail.com>
Cc:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        alexander.sverdlin@gmail.com, allison@lohutok.net, andrew@lunn.ch,
        ast@kernel.org, bgolaszewski@baylibre.com, bpf@vger.kernel.org,
        daniel@iogearbox.net, daniel@zonque.org, dmg@turingmachine.org,
        festevam@gmail.com, gerg@uclinux.org, gregkh@linuxfoundation.org,
        gregory.clement@bootlin.com, haojian.zhuang@gmail.com,
        hsweeten@visionengravers.com, illusionist.neo@gmail.com,
        info@metux.net, jason@lakedaemon.net, jolsa@redhat.com,
        kafai@fb.com, kernel@pengutronix.de, kgene@kernel.org,
        krzk@kernel.org, kstewart@linuxfoundation.org,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@armlinux.org.uk,
        liviu.dudau@arm.com, lkundrak@v3.sk, lorenzo.pieralisi@arm.com,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, nsekhar@ti.com, robert.jarzmik@free.fr,
        s.hauer@pengutronix.de, sebastian.hesselbarth@gmail.com,
        shawnguo@kernel.org, songliubraving@fb.com, sudeep.holla@arm.com,
        swinslow@gmail.com, tglx@linutronix.de, tony@atomide.com,
        will@kernel.org, yhs@fb.com
Subject: Re: [PATCH V2 00/15] cleanup cppcheck signed shifting errors
Message-ID: <20190624152743.GG3436@hirez.programming.kicks-ass.net>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624135105.15579-1-tranmanphong@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 08:50:50PM +0700, Phong Tran wrote:
> There are errors with cppcheck 
> 
> "Shifting signed 32-bit value by 31 bits is undefined behaviour errors"

As I've already told you; your checker is bad. That is not in face
undefined behaviour in the kernel.

That's not to say you shouldn't clean up the code, but don't give broken
checkout output as a reason.
