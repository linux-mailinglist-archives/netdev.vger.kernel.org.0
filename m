Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B96B346D91
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 23:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbhCWWtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 18:49:41 -0400
Received: from mga05.intel.com ([192.55.52.43]:1239 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234025AbhCWWte (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 18:49:34 -0400
IronPort-SDR: Wb2pkim3wGAwKEm3jMMaFYLmSb9kWl2z66Zn4ThArHxEAnb5aNiy+P4DhCfHhe/3DXhD9MCNAr
 ixIjVkuZ9d0g==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="275681388"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="275681388"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 15:49:19 -0700
IronPort-SDR: K5Q+Oq+JhbhXFNsH8pIwTOM2hFaA7hm3cLblQz5+UqXf+Pd7EqWd2Yf6KgQ0PHkpyEKRuM4fsp
 NsJP7CVvEQrg==
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="525020763"
Received: from ckane-desk.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.209.48.247])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 15:49:18 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, sasha.neftin@intel.com,
        anthony.l.nguyen@intel.com, linux-pci@vger.kernel.org,
        bhelgaas@google.com, netdev@vger.kernel.org, mlichvar@redhat.com,
        richardcochran@gmail.com
Subject: Re: [PATCH next-queue v3 1/3] Revert "PCI: Make pci_enable_ptm()
 private"
In-Reply-To: <20210323194046.GA598671@bjorn-Precision-5520>
References: <20210323194046.GA598671@bjorn-Precision-5520>
Date:   Tue, 23 Mar 2021 15:49:18 -0700
Message-ID: <874kh1jxjl.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bjorn Helgaas <helgaas@kernel.org> writes:

> On Mon, Mar 22, 2021 at 09:18:20AM -0700, Vinicius Costa Gomes wrote:
>> Make pci_enable_ptm() accessible from the drivers.
>> 
>> Even if PTM still works on the platform I am using without calling
>> this function, it might be possible that it's not always the case.
>
> I don't understand the value of this paragraph.  The rest of it makes
> good sense (although I think we might want to add a wrapper as I
> mentioned elsewhere).
>

Sure. Will remove this paragraph, and add the helper as you mentioned.
Thanks.


Cheers,
-- 
Vinicius
