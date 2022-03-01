Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63614C8F6E
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 16:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbiCAPt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 10:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233830AbiCAPt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 10:49:28 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA6B252B1D
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 07:48:46 -0800 (PST)
Received: from [192.168.1.214] (dynamic-089-012-174-087.89.12.pool.telefonica.de [89.12.174.87])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9678120B7178;
        Tue,  1 Mar 2022 07:48:45 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9678120B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1646149726;
        bh=SaC0aRqtMlc7spY1Zi3FEHO1evOLJ7yuSFycKLfJ5tw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=eSG6fK58QGCmPWvEOlzaJE92MmYHB7tHdbjJb0Q6kZ0OgaqPLA5ZrXTs1MtsepOWz
         W+CaJuhXkHrKRp6MhLFOZBsqnaDhSkFPJqDYL5ELjs2B27XtrfOJkfdmbS3Krj6t87
         H2pSYkQz1OhwedzU54EWhK6BzM3aqj7uik3BKXbg=
Subject: Re: [PATCH 1/2] Revert "xfrm: interface with if_id 0 should return
 error"
To:     Paul Chaignon <paul@cilium.io>, Eyal Birger <eyal.birger@gmail.com>
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
References: <20220301131512.1303-1-kailueke@linux.microsoft.com>
 <CAHsH6Gtzaf2vhSv5sPpBBhBww9dy8_E7c0utoqMBORas2R+_zg@mail.gmail.com>
 <d5e58052-86df-7ffa-02a0-fc4db5a7bbdf@linux.microsoft.com>
 <CAHsH6GsxaSgGkF9gkBKCcO9feSrsXsuNBdKRM_R8=Suih9oxSw@mail.gmail.com>
 <20220301150930.GA56710@Mem>
From:   =?UTF-8?B?S2FpIEzDvGtl?= <kailueke@linux.microsoft.com>
Message-ID: <dcc83e93-4a28-896c-b3d3-8d675bb705eb@linux.microsoft.com>
Date:   Tue, 1 Mar 2022 16:48:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20220301150930.GA56710@Mem>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I agree with Eyal here.  As far as Cilium is concerned, this is not
> causing any regression.  Only the second commit, 68ac0f3810e7 ("xfrm:
> state and policy should fail if XFRMA_IF_ID 0") causes issues in a
> previously-working setup in Cilium.  We don't use xfrm interfaces.
>
I see this as a very generic question of changing userspace behavior or
not, regardless if we know how many users are affected, and from what I
know there are similar cases in the kernel where the response was that
breaking userspace is a no go - even if the intention was to be helpful
by having early errors.

Greets,
Kai


