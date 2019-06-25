Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E877C555D0
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730204AbfFYRY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:24:56 -0400
Received: from foss.arm.com ([217.140.110.172]:46070 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbfFYRY4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 13:24:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5CEC6C0A;
        Tue, 25 Jun 2019 10:24:55 -0700 (PDT)
Received: from e107155-lin (e107155-lin.cambridge.arm.com [10.1.196.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3AC343F718;
        Tue, 25 Jun 2019 10:24:49 -0700 (PDT)
Date:   Tue, 25 Jun 2019 18:24:42 +0100
From:   Sudeep Holla <sudeep.holla@arm.com>
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
        netdev@vger.kernel.org, nsekhar@ti.com, peterz@infradead.org,
        robert.jarzmik@free.fr, s.hauer@pengutronix.de,
        sebastian.hesselbarth@gmail.com, shawnguo@kernel.org,
        songliubraving@fb.com, swinslow@gmail.com, tglx@linutronix.de,
        tony@atomide.com, will@kernel.org, yhs@fb.com,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH V3 12/15] ARM: vexpress: cleanup cppcheck shifting error
Message-ID: <20190625172442.GA19852@e107155-lin>
References: <20190624135105.15579-1-tranmanphong@gmail.com>
 <20190625040356.27473-1-tranmanphong@gmail.com>
 <20190625040356.27473-13-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625040356.27473-13-tranmanphong@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 11:03:53AM +0700, Phong Tran wrote:
> There is error from cppcheck tool
> "Shifting signed 32-bit value by 31 bits is undefined behaviour errors"
> change to use BIT() marco for improvement.
>

What's your plan for merging this series ? I can take this for v5.4
If not,

Acked-by: Sudeep Holla <sudeep.holla@arm.com>

--
Regards,
Sudeep
