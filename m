Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04FD64D1B42
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 16:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237601AbiCHPCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 10:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235737AbiCHPCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 10:02:50 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BACB4D9C9;
        Tue,  8 Mar 2022 07:01:54 -0800 (PST)
Date:   Tue, 8 Mar 2022 16:01:51 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646751713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5fedSGjHcH2Pyb/TyydAXfUcpZ6zhhEWbSLM4LLfaJs=;
        b=e0PFZjnsd8UhNp+w5LekBjKRzVA+cpxK8FjnddwfyFYkRChCq3rRnY9oUFEjpc5OZlf/y4
        15OIS7N1igTusZyZGYVSXCZW3qNZriR9jHcwSl3xJSwZzupFAIbIrf/mSSZqPRtLMkr7iu
        kHB0T2qFJp55fqsmfuGuSBjLWzIClw0m+s8NVotoUkNHXohVk0ULM2XSNzyQbPLHV4PZyZ
        q5zCR4kchb6QAbVwEvpIUEZ49DgoN8HZH9DrHJ0SPMD8SaoOpJPtez91wSyKsQOJh9pItX
        +j4NzBxo8nFJI8VuXxBqp/gOqe22eeHizRexczeDf6LG/enoPlchiFyC6n6TKQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646751713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5fedSGjHcH2Pyb/TyydAXfUcpZ6zhhEWbSLM4LLfaJs=;
        b=Xy2TuEnXPbSgNWdtiEWiDezGB5BFzz1zeIhu6o/0AIOrdkjqI671qCWDrf9DdBkCcjjIyq
        OUFSFzXQQTIYdeDg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arend van Spriel <aspriel@gmail.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        SHA-cyfmac-dev-list@infineon.com,
        Wright Feng <wright.feng@infineon.com>,
        brcm80211-dev-list.pdl@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next 6/8] wireless: brcmfmac: Use netif_rx().
Message-ID: <Yidv35TjGKHf8zNi@linutronix.de>
References: <20220305221252.3063812-1-bigeasy@linutronix.de>
 <20220305221252.3063812-7-bigeasy@linutronix.de>
 <c1ad3ee6-af16-77a1-e34d-91b2040dd8c9@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c1ad3ee6-af16-77a1-e34d-91b2040dd8c9@broadcom.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-08 15:59:50 [+0100], Arend van Spriel wrote:
> Looks good to me but that commit only seems to exist in net-next repo. So
> you want to take this patch through the net-next repo as well?

No need, DaveM took care of everything.

> Regards,
> Arend

Sebastian
