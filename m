Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FD1260F58
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 12:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729200AbgIHKMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 06:12:37 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:44639 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726801AbgIHKMc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 06:12:32 -0400
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 4B020206462B7;
        Tue,  8 Sep 2020 12:12:30 +0200 (CEST)
Subject: Re: [Intel-wired-lan] [PATCH bpf-next 4/4] ixgbe, xsk: use
 XSK_NAPI_WEIGHT as NAPI poll budget
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kuba@kernel.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        intel-wired-lan@lists.osuosl.org, magnus.karlsson@intel.com
References: <20200907150217.30888-1-bjorn.topel@gmail.com>
 <20200907150217.30888-5-bjorn.topel@gmail.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <82901368-8e17-a63d-0e46-2434b5777c04@molgen.mpg.de>
Date:   Tue, 8 Sep 2020 12:12:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200907150217.30888-5-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Björn,


Am 07.09.20 um 17:02 schrieb Björn Töpel:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> Start using XSK_NAPI_WEIGHT as NAPI poll budget for the AF_XDP Rx
> zero-copy path.

Could you please add the description from the patch series cover letter 
to this commit too? To my knowledge, the message in the cover letter 
won’t be stored in the git repository.

> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> ---
>   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

[…]


Kind regards,

Paul
