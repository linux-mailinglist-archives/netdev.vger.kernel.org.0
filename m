Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB89CECB0
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 21:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbfJGTVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 15:21:54 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:44970 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729133AbfJGTVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 15:21:53 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iHYZk-0007Vs-Ar; Mon, 07 Oct 2019 21:21:44 +0200
Message-ID: <c257bdfd1fc816367f5aad28953d7d100e75810d.camel@sipsolutions.net>
Subject: Re: Potential NULL pointer deference in iwlwifi: mvm
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Yizhuo Zhai <yzhai003@ucr.edu>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ayala Beker <ayala.beker@intel.com>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhiyun Qian <zhiyunq@cs.ucr.edu>,
        Chengyu Song <csong@cs.ucr.edu>
Date:   Mon, 07 Oct 2019 21:21:42 +0200
In-Reply-To: <CABvMjLRhqCAs-r3LA4nX_5tBj=hQeUfb4g5gHf8ghRdwWqKuPA@mail.gmail.com> (sfid-20191007_211937_883436_3262816D)
References: <CABvMjLRhqCAs-r3LA4nX_5tBj=hQeUfb4g5gHf8ghRdwWqKuPA@mail.gmail.com>
         (sfid-20191007_211937_883436_3262816D)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-10-07 at 12:19 -0700, Yizhuo Zhai wrote:
> Hi All:
> 
> drivers/net/wireless/intel/iwlwifi/mvm/scan.c:
> 
> Inside function iwl_mvm_power_ps_disabled_iterator(),
> iwl_mvm_vif_from_mac80211()
> could return NULL

No, it can not.

Whatever tool you've used to find this - you should fix it.

johannes

