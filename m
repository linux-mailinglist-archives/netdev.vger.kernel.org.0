Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875282F7A8D
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 13:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388219AbhAOMur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 07:50:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:25301 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387823AbhAOMup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 07:50:45 -0500
IronPort-SDR: 6G06CakxgiTh+QML2R+ZAZBbyYUCumaTQ9wVTy9EFHqMFrUr3QMSikcHfki2/1u8UJ+ddIjUff
 CIob1rVbc/+Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="175038398"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="175038398"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 04:50:04 -0800
IronPort-SDR: dpfUTDQvsp3I5TtXyYQrGXEQrA9qpLvEe95dX581oclfNQ7ngDPOXccSuKu8Nj2ycuNTds1KVI
 aA9ucku9Rl2w==
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="382652210"
Received: from crlyons-mobl2.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.51.162])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 04:49:58 -0800
Subject: Re: general protection fault in xsk_recvmsg
To:     syzbot <syzbot+b974d32294d1dffbea36@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        johannes.berg@intel.com, johannes@sipsolutions.net,
        john.fastabend@gmail.com, jonathan.lemon@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <000000000000ee881505b8e27cf2@google.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <e2f7ee95-1681-3ae5-861e-fa3d7ac12f5a@intel.com>
Date:   Fri, 15 Jan 2021 13:49:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <000000000000ee881505b8e27cf2@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: xsk: Validate socket state in xsk_recvmsg, prior touching 
socket members
