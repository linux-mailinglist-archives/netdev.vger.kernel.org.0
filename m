Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2B1C11E4
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 20:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbfI1S6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 14:58:16 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33108 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728576AbfI1S6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 14:58:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iEHus-0002U3-8A; Sat, 28 Sep 2019 20:58:02 +0200
Message-ID: <cf8d8627e3716172bb8c034ba7e55472eb78518d.camel@sipsolutions.net>
Subject: Re: [PATCH net v4 12/12] virt_wifi: fix refcnt leak in module exit
 routine
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        jakub.kicinski@netronome.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
Date:   Sat, 28 Sep 2019 20:57:58 +0200
In-Reply-To: <20190928164843.31800-13-ap420073@gmail.com> (sfid-20190928_185052_013812_882A8484)
References: <20190928164843.31800-1-ap420073@gmail.com>
         <20190928164843.31800-13-ap420073@gmail.com>
         (sfid-20190928_185052_013812_882A8484)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2019-09-28 at 16:48 +0000, Taehee Yoo wrote:
> virt_wifi_newlink() calls netdev_upper_dev_link() and it internally
> holds reference count of lower interface.
[...]
> This patch adds notifier routine to delete upper interface before deleting
> lower interface.

Good catch, thanks!

For now I'll assume this will go in through net together with the whole
series (once ready), shout if you want something else.

johannes

