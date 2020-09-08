Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39AB2261097
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 13:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbgIHLVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 07:21:52 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:44287 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729858AbgIHLUT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 07:20:19 -0400
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 1EB82206462B7;
        Tue,  8 Sep 2020 13:20:16 +0200 (CEST)
Subject: Re: [Intel-wired-lan] [PATCH bpf-next 4/4] ixgbe, xsk: use
 XSK_NAPI_WEIGHT as NAPI poll budget
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kuba@kernel.org, intel-wired-lan@lists.osuosl.org,
        magnus.karlsson@intel.com
References: <20200907150217.30888-1-bjorn.topel@gmail.com>
 <20200907150217.30888-5-bjorn.topel@gmail.com>
 <82901368-8e17-a63d-0e46-2434b5777c04@molgen.mpg.de>
 <0fb03a39-d098-8fc9-ba70-e919ef8e091e@intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <0b927a07-6fbb-0e5b-e791-9558c9ea8e63@molgen.mpg.de>
Date:   Tue, 8 Sep 2020 13:20:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <0fb03a39-d098-8fc9-ba70-e919ef8e091e@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Björn,


Am 08.09.20 um 13:12 schrieb Björn Töpel:
> On 2020-09-08 12:12, Paul Menzel wrote:

>> Am 07.09.20 um 17:02 schrieb Björn Töpel:
>>> From: Björn Töpel <bjorn.topel@intel.com>
>>>
>>> Start using XSK_NAPI_WEIGHT as NAPI poll budget for the AF_XDP Rx
>>> zero-copy path.
>>
>> Could you please add the description from the patch series cover 
>> letter to this commit too? To my knowledge, the message in the cover 
>> letter won’t be stored in the git repository.
> 
> Paul, thanks for the input! The netdev/bpf trees always include the 
> cover letter in the merge commit.

Yes, for pull/merge requests. But you posted them to the list, so I’d 
assume they will be applied with `git am` and not merged, or am I 
missing something. Could you please point me to a merge commit where the 
patches were posted to the list?


Kind regards,

Paul
