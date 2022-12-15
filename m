Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C06A64E1BF
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 20:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiLOT15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 14:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLOT14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 14:27:56 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4D82314B;
        Thu, 15 Dec 2022 11:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rRpRYLEWJeMFjtMtsSMVO3ntF+irtyv0bv6wXyoGCWQ=; b=eQ+9CauxjZ7sPCq8vcHRlgF2ze
        evLAfLmyNP+KYJRZxh4v7pmDPRe2kyQxqERmQpFiK0qel0OMMlvS/ud6LHpclbxJTESSlwbqlHmVE
        3hAbo4NbEO0phsJDADhOx8AlyeLGjk+fJrQtY6KKfAHpY3KlkA6iNitte3WkVCxpLex0=;
Received: from p200300daa7420a02090f62f75c4aa0ce.dip0.t-ipconnect.de ([2003:da:a742:a02:90f:62f7:5c4a:a0ce] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1p5ttZ-0099EI-Ll; Thu, 15 Dec 2022 20:27:53 +0100
Message-ID: <5ef22539-7a99-0c12-a5b0-a5ea643fe635@nbd.name>
Date:   Thu, 15 Dec 2022 20:27:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: kernel v6.1: NULL pointer dereference in ieee80211_deliver_skb
To:     Wolfgang Walter <linux@stwm.de>, linux-wireless@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <1585238f2dee5e2daafe28ba0606b6a4@stwm.de>
Content-Language: en-US
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <1585238f2dee5e2daafe28ba0606b6a4@stwm.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.12.22 18:31, Wolfgang Walter wrote:
> Hello,
> 
> with kernel v6.1 I always get the following oops when running on a small
> router:
Please try this fix that I just posted:
https://patchwork.kernel.org/project/linux-wireless/patch/20221215190503.79904-1-nbd@nbd.name/

- Felix
