Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5206AC20B
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 15:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjCFN7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 08:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCFN7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 08:59:46 -0500
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B802684D;
        Mon,  6 Mar 2023 05:59:43 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1678111180; bh=+O/tQvEEKg/Fmeucrj8YQ2UpdRcW6qnPWq0vPinoPQ4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ABe4eQunxTj/gMkIU0okCsnylD+iOO9YT+yVb2oxZXPQGC7UbP8TEiXtNC3urgL15
         N5c2GkFNaNk+Xl1uccqOEp4TbXH2oH/FsaaKcilSQTdG/nJdeEnD6hDqRbHNQSzHCA
         B07zzWB+ZUPDMDndR59HqwtjgpkbbZ+1oUmsvDZNqBPti6s44V8woF0Y/ksXUrVBCt
         eavzv4DkuaMFMtEP/hwu7aMVLqCqa29QHRoB0oZNcEicUdZuZUT24x8knqYbADCvlf
         rIFCOtPv8QAOuCvw7/kUELJeKsn/MoXvchwn1iBPVUaZ86t8oObuQgBudHLnKoOA/A
         Ldljoz4ki4Q8g==
To:     Bastian Germann <bage@debian.org>, Kalle Valo <kvalo@kernel.org>
Cc:     Bastian Germann <bage@debian.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] wifi: ath9k: Remove Qwest/Actiontec 802AIN ID
In-Reply-To: <20230306125041.2221-1-bage@debian.org>
References: <20230305210245.9831-1-bage@debian.org>
 <20230306125041.2221-1-bage@debian.org>
Date:   Mon, 06 Mar 2023 14:59:40 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87mt4qaskz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bastian Germann <bage@debian.org> writes:

> The USB device 1668:1200 is Qwest/Actiontec 802AIN which is also
> correctly claimed to be supported by carl9170.
>
> Supposedly, the successor 802AIN2 which has an ath9k compatible chip
> whose USB ID (unknown) could be inserted instead.
>
> Drop the ID from the wrong driver.
>
> Signed-off-by: Bastian Germann <bage@debian.org>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
