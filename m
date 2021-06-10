Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9663A2120
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhFJAGH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Jun 2021 20:06:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:14314 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229557AbhFJAGG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 20:06:06 -0400
IronPort-SDR: LnhG6hbqD/N/h01EwutFNsNcGZZZqMsjAB/Abbms124eUVrWc8uG18b+0plp7lxWFdC+gEOBWU
 i03Ha1M4krKw==
X-IronPort-AV: E=McAfee;i="6200,9189,10010"; a="269049778"
X-IronPort-AV: E=Sophos;i="5.83,262,1616482800"; 
   d="scan'208";a="269049778"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 17:04:11 -0700
IronPort-SDR: 4MnFHB+M+vjtoiMy13HteGof5hFGFs5FhkQtRFaWT8DG7SvgqidkUIAFAPs7b9eR1TNZy9DFRs
 PB0vo/OgQdgg==
X-IronPort-AV: E=Sophos;i="5.83,262,1616482800"; 
   d="scan'208";a="552848525"
Received: from kotikala-mobl1.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.209.25.177])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 17:04:10 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>, linux-pci@vger.kernel.org,
        richardcochran@gmail.com, hch@infradead.org,
        netdev@vger.kernel.org, bhelgaas@google.com,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [Intel-wired-lan] [PATCH next-queue v5 3/4] igc: Enable PCIe PTM
In-Reply-To: <20210609232034.GA2681266@bjorn-Precision-5520>
References: <20210609232034.GA2681266@bjorn-Precision-5520>
Date:   Wed, 09 Jun 2021 17:04:09 -0700
Message-ID: <87eedavb46.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bjorn Helgaas <helgaas@kernel.org> writes:

> On Wed, Jun 09, 2021 at 04:07:20PM -0700, Vinicius Costa Gomes wrote:
>> Hi Paul,
>> 
>> >> 
>> >>> Regarding my comment, I did not mean returning an error but the log
>> >>> *level* of the message. So, `dmesg --level err` would show that message.
>> >>> But if there are PCI controllers not supporting that, it’s not an error,
>> >>> but a warning at most. So, I’d use:
>> >>>
>> >>> 	dev_warn(&pdev->dev, "PTM not supported by PCI bus/controller
>> >>> (pci_enable_ptm() failed)\n");
>> >> 
>> >> I will use you suggestion for the message, but I think that warn is a
>> >> bit too much, info or notice seem to be better.
>> >
>> > I do not know, if modern PCI(e)(?) controllers normally support PTM or 
>> > not. If recent controllers should support it, then a warning would be 
>> > warranted, otherwise a notice.
>> 
>> From the Intel side, it seems that it's been supported for a few years.
>> So, fair enough, let's go with a warn.
>
> I'm not sure about this.  I think "warning" messages interrupt distro
> graphical boot scenarios and cause user complaints.  In this case,
> there is nothing broken and the user can do nothing about it; it's
> merely a piece of missing optional functionality.  So I think "info"
> is a more appropriate level.

Good point. "info" it is, then. 


Cheers,
-- 
Vinicius
