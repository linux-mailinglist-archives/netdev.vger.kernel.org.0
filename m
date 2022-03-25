Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C79F4E7C72
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbiCYWBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 18:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233664AbiCYWBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 18:01:05 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D53E131F45
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 14:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=3bgPddZ6KYwwWEMk+NadS7Papp+V/RHKcrqJ+paexrw=;
        t=1648245568; x=1649455168; b=BkMv8Di9HxSvOHPjG5Ykk519jsegno5si2d2CwzJowSBXRB
        rW/5LFQM/Au88kzOLpJ4+r27MQjlaSkXH4AinlpxTU/L+st6sLD7mTOCzkAJ536gQzJzHckc5Nekv
        JIn/eIu+iN2CWSoc0NNlp81KQBCvDn7QtE0wNVLxGqIpExrSb2bgEpPmAKBUu3mcdoIDDLyod7Jxv
        p8OJzQ+SaUYSJ7BWVXWVAsU96E87PPWATYPs6fO167Ah3fDLb9qhzwPSr31yI5xfkC4DbftNVeBkm
        M8wWqDcrJS+M5xPyoaLAvgF7ZO1lU1PjlnKm8vTv4LOHbC6wyDjlvW8KI1j4RvwA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nXrxu-000Whc-Cf;
        Fri, 25 Mar 2022 22:59:26 +0100
Message-ID: <05fc9b4d27dfc6ff9eb96062016e2ead5ea1d1c1.camel@sipsolutions.net>
Subject: Re: [PATCH] net: ensure net_todo_list is processed quickly
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Date:   Fri, 25 Mar 2022 22:59:25 +0100
In-Reply-To: <20220325145845.642c2082@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220325225055.37e89a72f814.Ic73d206e217db20fd22dcec14fe5442ca732804b@changeid>
         <20220325145845.642c2082@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-03-25 at 14:58 -0700, Jakub Kicinski wrote:
> On Fri, 25 Mar 2022 22:50:55 +0100 Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > In [1], Will raised a potential issue that the cfg80211 code,
> > which does (from a locking perspective)
> 
> LGTM, but I think we should defer this one a week and take it 
> to net-next when it re-opens, after the merge window.

Yeah that makes sense. Do you want me to resend it then?

johannes
