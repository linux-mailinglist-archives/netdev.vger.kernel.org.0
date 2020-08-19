Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C307924A724
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 21:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgHSTqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 15:46:24 -0400
Received: from mga03.intel.com ([134.134.136.65]:33767 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbgHSTqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 15:46:24 -0400
IronPort-SDR: 8rNr+aLLkh0SmiuPc280lDviplr/jRairhP07NFKpr1g/hP4o0bqIp/IRct499vfg6alVvZmKs
 NfCgkvGkv3BQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9718"; a="155159252"
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="155159252"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 12:46:23 -0700
IronPort-SDR: zyMb8aUirOYX+INy8BHXvHdMb0Hl5ayv99/RQ7Uf5swY9q79L8nVJH0O8GQLzIPatNWnkVr8mM
 GqbEi3gjvOMA==
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="472357806"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.106.143])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 12:46:23 -0700
Date:   Wed, 19 Aug 2020 12:46:21 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Cristobal Forno <cforno12@linux.ibm.com>
Cc:     <netdev@vger.kernel.org>, <drt@linux.vnet.ibm.com>
Subject: Re: [PATCH, net-next, v3] ibmvnic: store RX and TX subCRQ handle
 array in ibmvnic_adapter struct
Message-ID: <20200819124621.000045fc@intel.com>
In-Reply-To: <20200819181623.57821-1-cforno12@linux.ibm.com>
References: <20200819181623.57821-1-cforno12@linux.ibm.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cristobal Forno wrote:

> Currently the driver reads RX and TX subCRQ handle array directly from
> a DMA-mapped buffer address when it needs to make a H_SEND_SUBCRQ
> hcall. This patch stores that information in the ibmvnic_sub_crq_queue
> structure instead of reading from the buffer received at login. The
> overall goal of this patch is to parse relevant information from the
> login response buffer and store it in the driver's private data
> structures so that we don't need to read directly from the buffer and
> can then free up that memory.
> 
> Signed-off-by: Cristobal Forno <cforno12@linux.ibm.com>

LGTM, as long as this isn't a bug fix, net-next is fine for this.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
