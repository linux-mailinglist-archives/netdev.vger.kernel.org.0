Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0545793DC
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 09:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbiGSHKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 03:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbiGSHJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 03:09:59 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0803326E6;
        Tue, 19 Jul 2022 00:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=/yn6Pg6Bzg+ZpMdpNayFhtNUih4qa9d4cHz/tBIB/do=;
        t=1658214598; x=1659424198; b=tvD/poh/7pHBG34Q0a4bIsM8IdmoK1TqyItRnulcHrRpyc8
        NB8TlBYdO5Vqzh9fgg92MzIL6LzPN/nrPSTX9R+WVCn/lsCfm0a6Wd5pxlEsVeatfqFm2IP+gLh2k
        FjLB8zSzUyjBND0ZUkRTwbAxh51QChDdrVHQyjXn8L7c164Z7BdWDDymk4YdMHRWfoPtPHeecU2dp
        +QlasnPBplUT/X3zuvceDfgBAtSNqjm8S54d+C/OO9iDi3r3VlPn0HT2YtH6G1WtXUmyiotZ6PcuN
        jRd8pUozyf158IPqB87R6barsX0ELypNYJd/Qn1DT77AnhRI8xhiMx/3qvMRsIig==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oDhMQ-002T1l-1J;
        Tue, 19 Jul 2022 09:09:38 +0200
Message-ID: <a103d47bacd9c6e85d5c9bf969cd1bc69194eed6.camel@sipsolutions.net>
Subject: Re: [PATCH -next] wifi: mac80211: clean up one inconsistent
 indenting
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Yang Li <yang.lee@linux.alibaba.com>, davem@davemloft.net
Cc:     Larry.Finger@lwfinger.net, kvalo@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Date:   Tue, 19 Jul 2022 09:09:37 +0200
In-Reply-To: <20220719004423.85142-1-yang.lee@linux.alibaba.com>
References: <20220719004423.85142-1-yang.lee@linux.alibaba.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subject should be "wifi: b43legacy: ..." I think.

johannes
