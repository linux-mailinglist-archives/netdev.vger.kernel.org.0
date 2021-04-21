Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359453665B4
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 08:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbhDUGw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 02:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235123AbhDUGwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 02:52:24 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5907BC06174A;
        Tue, 20 Apr 2021 23:51:51 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lZ6i9-00EdRP-KG; Wed, 21 Apr 2021 08:51:45 +0200
Message-ID: <494b1d770d7730b5a865b077cdd72ba6d17c7d38.camel@sipsolutions.net>
Subject: Re: [PATCH V2 01/16] net: iosm: entry point
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Leon Romanovsky <leon@kernel.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
Date:   Wed, 21 Apr 2021 08:51:44 +0200
In-Reply-To: <YH+71wFykp/fWcCe@unreal>
References: <20210420161310.16189-1-m.chetan.kumar@intel.com>
         <20210420161310.16189-2-m.chetan.kumar@intel.com> <YH+71wFykp/fWcCe@unreal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-04-21 at 08:44 +0300, Leon Romanovsky wrote:
> 
> > +#define DRV_AUTHOR "Intel Corporation <linuxwwan@intel.com>"
> 
> Driver author can't be a company. It needs to be a person.

Most of

	git grep MODULE_AUTHOR|grep Inc

disagrees.

johannes

