Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71BD13215CF
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 13:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhBVMJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 07:09:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:25241 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230099AbhBVMJY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 07:09:24 -0500
IronPort-SDR: ET5Jc9My+rCKr2lb7wLa7KUl6VmAWgHnaY0qqfQUFb3vekR6dhV4vtV8E3/NMF5ycH43ecHUPF
 4fPbJSsiEnMA==
X-IronPort-AV: E=McAfee;i="6000,8403,9902"; a="184530528"
X-IronPort-AV: E=Sophos;i="5.81,197,1610438400"; 
   d="scan'208";a="184530528"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 04:08:42 -0800
IronPort-SDR: T3SdDulAUIcrV38Y+LvEAPxnMsphwFEguk9iMUEFGJac0oZflj5pxUwaKvLeM76J2SjSG2mQuN
 uydO1HWS7dTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,197,1610438400"; 
   d="scan'208";a="432050189"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga002.fm.intel.com with ESMTP; 22 Feb 2021 04:08:40 -0800
Date:   Mon, 22 Feb 2021 12:58:03 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Subject: Re: [PATCH bpf-next 1/4] selftest/bpf: make xsk tests less verbose
Message-ID: <20210222115803.GC29106@ranger.igk.intel.com>
References: <20210217160214.7869-1-ciara.loftus@intel.com>
 <20210217160214.7869-2-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210217160214.7869-2-ciara.loftus@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 04:02:11PM +0000, Ciara Loftus wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Make the xsk tests less verbose by only printing the
> essentials. Currently, it is hard to see if the tests passed or not
> due to all the printouts. Move the extra printouts to a verbose
> option, if further debugging is needed when a problem arises.
> 
> To run the xsk tests with verbose output:
> ./test_xsk.sh -v
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
