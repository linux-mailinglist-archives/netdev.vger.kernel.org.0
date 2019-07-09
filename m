Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6029F634A4
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 12:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfGIK7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 06:59:01 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54462 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726411AbfGIK7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 06:59:01 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hknpk-0000pM-7d; Tue, 09 Jul 2019 13:58:53 +0300
Message-ID: <e6a6d6e6d9d94c317778e534b0fe048b7d0612ef.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Hariprasad Kelam <hariprasad.kelam@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 09 Jul 2019 13:58:50 +0300
In-Reply-To: <20190526113815.GA6328@hari-Inspiron-1545>
References: <20190526113815.GA6328@hari-Inspiron-1545>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        TVD_RCVD_IP autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH] iwlwifi: fix warning iwl-trans.h is included more than
 once
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2019-05-26 at 17:08 +0530, Hariprasad Kelam wrote:
> remove duplication include of iwl-trans.h
> 
> issue identified by includecheck
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
> ---

Thanks! I have applied this (with small modifications to the commit
message) in our internal tree and it will reach the mainline following
our normal upstreaming process.

--
Cheers,
Luca.

