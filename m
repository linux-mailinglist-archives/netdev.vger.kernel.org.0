Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 279A311830E
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 10:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbfLJJIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 04:08:53 -0500
Received: from a27-56.smtp-out.us-west-2.amazonses.com ([54.240.27.56]:42598
        "EHLO a27-56.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727045AbfLJJIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 04:08:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575968931;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=fAhQaC8sJcNzBFJdml56yo1VHwYdbrT0AxCr3FdKVP4=;
        b=LTit0VSro6eezsKkd0yJKAHbAOkpzct9tIrvYYlVv1N6WRAyoYDThKowOKJzz7HO
        hjL8WTgi/xlb8QyfTgHfOR7hREUpm/oBHLWTyHL8SLvr+FjqMQtNF3aLe5vOudyT5d3
        h3EZ3UILArkJx718/mt0ELU2sy1K1wW81TcRCKFw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575968931;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=fAhQaC8sJcNzBFJdml56yo1VHwYdbrT0AxCr3FdKVP4=;
        b=C+hIXG6h6/8VT5IVFRqUtt3+PFxgMKxcx9EYGu/+BnY0BB+tGanu5PG2D2SS8PwK
        ehMQl2a1YLVWgr0wX70NCHTtx6vVSPagrY98uwvHWDtMd1pP/T9NFcDMn9qri579xe0
        o090mWODoSoFOczptEnwRQklWottJ84B6PYjikZs=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 423C7C4479C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Soeren Moch <smoch@web.de>
Cc:     Wright Feng <wright.feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] brcmfmac: reset two D11 cores if chip has two D11 cores
References: <20191209223822.27236-1-smoch@web.de>
Date:   Tue, 10 Dec 2019 09:08:51 +0000
In-Reply-To: <20191209223822.27236-1-smoch@web.de> (Soeren Moch's message of
        "Mon, 9 Dec 2019 23:38:15 +0100")
Message-ID: <0101016eef117ea9-8b775155-a37b-4174-99b7-c9d320c94b64-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.12.10-54.240.27.56
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Soeren Moch <smoch@web.de> writes:

> From: Wright Feng <wright.feng@cypress.com>
>
> There are two D11 cores in RSDB chips like 4359. We have to reset two
> D11 cores simutaneously before firmware download, or the firmware may
> not be initialized correctly and cause "fw initialized failed" error.
>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>

Soeren's s-o-b missing at least in patches 1, 6 and 7. Please read:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#signed-off-by_missing

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
