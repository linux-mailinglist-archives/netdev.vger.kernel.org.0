Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE50C9240
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 21:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbfJBTYy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Oct 2019 15:24:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:60996 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726076AbfJBTYy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 15:24:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6EB2FAD09;
        Wed,  2 Oct 2019 19:24:51 +0000 (UTC)
Date:   Wed, 2 Oct 2019 21:08:31 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Paul Burton <paul.burton@mips.com>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rtc@vger.kernel.org" <linux-rtc@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH v6 1/4] nvmem: core: add nvmem_device_find
Message-Id: <20191002210831.f7fa10ad7f055801df26669d@suse.de>
In-Reply-To: <20191002183327.grhkxlbyu65vvhr4@pburton-laptop>
References: <20190923114636.6748-1-tbogendoerfer@suse.de>
        <20190923114636.6748-2-tbogendoerfer@suse.de>
        <ce44c762-f9a6-b4ef-fa8a-19ee4a6d391f@linaro.org>
        <20191002183327.grhkxlbyu65vvhr4@pburton-laptop>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Oct 2019 18:33:28 +0000
Paul Burton <paul.burton@mips.com> wrote:

> Hello,
> 
> On Tue, Oct 01, 2019 at 11:11:58AM +0100, Srinivas Kandagatla wrote:
> > On 23/09/2019 12:46, Thomas Bogendoerfer wrote:
> > > nvmem_device_find provides a way to search for nvmem devices with
> > > the help of a match function simlair to bus_find_device.
> > > 
> > > Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> > > ---
> > 
> > Thanks for the patch,
> > This patch looks good for me.
> > 
> > Do you know which tree is going to pick this series up?
> > 
> > I can either apply this patch to nvmem tree
> > 
> > or here is my Ack for this patch to take it via other trees.
> > 
> > Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> > Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> 
> Thanks - if you don't mind I'll take this through mips-next along with
> the following patch that depends on it.
> 
> Thomas: I see patch 3 has an issue reported by the kbuild test robot,

yes, that's because kbuild robot tries to build it 32bit. I'm going to make
it depend on 64bit all possible ioc3 platforms only support 64bit kernels.

>         and still needs acks from the MFD & network maintainers. Can I
> 	presume it's safe to apply patches 1 & 2 without 3 & 4 in the
> 	meantime?

yes, thank you.

Thomas.

-- 
SUSE Software Solutions Germany GmbH
HRB 247165 (AG München)
Geschäftsführer: Felix Imendörffer
