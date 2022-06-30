Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4EF561A55
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 14:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbiF3MaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 08:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234300AbiF3MaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 08:30:19 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6F32E6A6;
        Thu, 30 Jun 2022 05:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656592218; x=1688128218;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5icDXcV1A8avrdnVbjP97VdY1x9/zsRtsP/+vwKsYT0=;
  b=Om7HIrgVwZq1fM1eXG3nUYPDYNrc34/yuAovizRKh7RLYS+Mg42ipAlu
   5klV84VQ0QqE7QNauPt4I+/cX2aW0yRZJMdXdcREEYVbff1sM7ltsPeUP
   AeTMfT+Gb1p0nL6ySVUgkN/XHJrV7RILzYDG5VaCrz40Wpf/af420MKLv
   NSAaOi2XVB7Aw/mgFD1ZHZBUuuXmDenCBTDSgjulut4S89K0LVzONgBAq
   Q9C0pk0/bt4mVhXzh24yxapEykqVg62OhkAxthUGFPlxEe6BM3fMmVgGg
   3BUu9Z0DptLcD9Y8DsqqjtBoKBRtrsPFp3lzvPddv56cbhb23PBPbY2KO
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="262132323"
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="262132323"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 05:30:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="595670194"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jun 2022 05:30:15 -0700
Date:   Thu, 30 Jun 2022 14:30:15 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, andrii@kernel.org, hawk@kernel.org,
        toke@redhat.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] selftests, bpf: remove AF_XDP samples
Message-ID: <Yr2XV5855QM9JWv4@boxer>
References: <20220630093717.8664-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630093717.8664-1-magnus.karlsson@gmail.com>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 11:37:17AM +0200, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Remove the AF_XDP samples from samples/bpf as they are dependent on
> the AF_XDP support in libbpf. This support has now been removed in the
> 1.0 release, so these samples cannot be compiled anymore. Please start
> to use libxdp instead. It is backwards compatible with the AF_XDP
> support that was offered in libbpf. New samples can be found in the
> various xdp-project repositories connected to libxdp and by googling.

R.I.P.

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
