Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956A01E1AC8
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 07:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgEZFpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 01:45:54 -0400
Received: from mga18.intel.com ([134.134.136.126]:45351 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbgEZFpy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 01:45:54 -0400
IronPort-SDR: cYCDDN57SYWv3gyfhkPgFALO1bAQ1n50S0EEuww/sV5j2DMP69Qw3F17neFOipxamcHQpvJ0yn
 v+L6BmG3xc0w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2020 22:45:53 -0700
IronPort-SDR: VrZAgiJ3sCkCb6lsrASVA/z7T1Akr6WTiyRnpRtyLJz1jkmpGlnpYfXcfHJwoMgpPXPumxxKZ8
 7Gi3cm0LtUmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,436,1583222400"; 
   d="scan'208";a="301989735"
Received: from msimion-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.41.199])
  by orsmga008.jf.intel.com with ESMTP; 25 May 2020 22:45:51 -0700
Subject: Re: linux-next: manual merge of the net-next tree with the bpf tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20200526131243.0915e58c@canb.auug.org.au>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <56beee70-d2a7-e3d7-d37d-863c52d4e833@intel.com>
Date:   Tue, 26 May 2020 07:45:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200526131243.0915e58c@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-26 05:12, Stephen Rothwell wrote:
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

The fix looks good!

I'll keep this is mind, and try not to repeat similar conflicts for 
future patches.

Thanks for the fixup, and for the clarification!


Cheers,
Björn
