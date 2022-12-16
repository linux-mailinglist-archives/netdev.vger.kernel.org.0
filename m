Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C00564E971
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 11:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiLPK2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 05:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiLPK2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 05:28:35 -0500
Received: from email.studentenwerk.mhn.de (mailin.studentenwerk.mhn.de [141.84.225.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5D32A949;
        Fri, 16 Dec 2022 02:28:33 -0800 (PST)
Received: from mailhub.studentenwerk.mhn.de (mailhub.studentenwerk.mhn.de [127.0.0.1])
        by email.studentenwerk.mhn.de (Postfix) with ESMTPS id 4NYQL75rsLzRhTk;
        Fri, 16 Dec 2022 11:28:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de; s=stwm-20170627;
        t=1671186511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E+gRcYlkBgTay2aKzTpNSiy4Bv0vPYNnKAOHTra8+TA=;
        b=KeCzDtlUlzb9pVuW9+EWbOhJxPZLsfG1MAjx5r91bCPgq7EecIJpgyB2pCOZ8fomYF8N9S
        LtJonhpeAVm/y4oGw6QPyedR+kPd0RzxKllhXm3HsuyuoL6QiXvMpNB2xNV1uRPLucQ4NS
        xA/J9NpE5Tb5LNIs7O1GxAt1GjR85kLV2N7YxYyVVGhq0Wenpb2NE6S/24/gH9wzoMyX+p
        a91tGuel322VpHzTVWott7vqhZcjuSojGKf/PEPefE5cjiyWM9QXM8iVB5C5Jddi5jmY63
        J5PRLEBq/W+yEYaH9Bd/lMZauWtVlDQFm3IIMUJ5jM68h5BWtGO/v2uPX7sVCg==
MIME-Version: 1.0
Date:   Fri, 16 Dec 2022 11:28:54 +0100
From:   Wolfgang Walter <linux@stwm.de>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: kernel v6.1: NULL pointer dereference in ieee80211_deliver_skb
In-Reply-To: <5ef22539-7a99-0c12-a5b0-a5ea643fe635@nbd.name>
References: <1585238f2dee5e2daafe28ba0606b6a4@stwm.de>
 <5ef22539-7a99-0c12-a5b0-a5ea643fe635@nbd.name>
Message-ID: <2eb2bdca943c9acfdbadd6ae44a517dc@stwm.de>
X-Sender: linux@stwm.de
Organization: =?UTF-8?Q?Studentenwerk_M=C3=BCnchen?=
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-12-15 20:27, schrieb Felix Fietkau:
> On 15.12.22 18:31, Wolfgang Walter wrote:
>> Hello,
>> 
>> with kernel v6.1 I always get the following oops when running on a 
>> small
>> router:
> Please try this fix that I just posted:
> https://patchwork.kernel.org/project/linux-wireless/patch/20221215190503.79904-1-nbd@nbd.name/
> 
> - Felix

Thanks al lot, that fixed the problem.

Regards
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
